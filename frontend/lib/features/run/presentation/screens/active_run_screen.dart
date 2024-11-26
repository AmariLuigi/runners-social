import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:runners_social/core/services/socket_service.dart';
import 'package:runners_social/core/services/user_service.dart';
import 'package:runners_social/features/run/data/models/run_session.dart';
import 'package:runners_social/features/run/presentation/widgets/run_completion_modal.dart';
import '../providers/run_provider.dart';

class ActiveRunScreen extends ConsumerStatefulWidget {
  final String runId;

  const ActiveRunScreen({
    super.key,
    required this.runId,
  });

  @override
  ConsumerState<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends ConsumerState<ActiveRunScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  final Set<Polyline> _polylines = {};
  final SocketService _socketService = SocketService();
  final UserService _userService = GetIt.I<UserService>();
  StreamSubscription<Position>? _locationSubscription;
  List<LatLng> _routePoints = [];
  bool _isRunning = false;
  Timer? _timer;
  Duration _duration = Duration.zero;
  double _distance = 0;
  double _currentPace = 0;
  RunSession? _currentRun;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadRun();
    _setupSocketListeners();
  }

  Future<void> _loadRun() async {
    try {
      final run = await ref.read(runRepositoryProvider).getRun(widget.runId);
      setState(() {
        _currentRun = run;
      });
      _setupMap(run);
      _setupLocationTracking();
      _socketService.joinRun(widget.runId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load run: $e')),
        );
      }
    }
  }

  Future<void> _setupSocketListeners() async {
    await _socketService.connect();

    _socketService.onRunStarted((data) {
      setState(() {
        _isRunning = true;
        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            setState(() {
              _duration += const Duration(seconds: 1);
            });
          },
        );
      });
    });

    _socketService.onLocationUpdated((data) {
      if (!mounted) return;
      final participantId = data['participantId'];
      final location = data['location'];
      final position = LatLng(location['latitude'], location['longitude']);
      
      setState(() {
        // Update participant marker
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'participant_$participantId',
        );
        if (_currentRun != null) {
          final participant = _currentRun!.participants
              .firstWhere((p) => p.id == participantId);
          _updateParticipantMarkers();
        }
      });
    });

    _socketService.onRunEnded((data) {
      if (!mounted) return;
      _endRun();
    });

    _socketService.onParticipantJoined((data) {
      if (!mounted) return;
      final participant = Participant.fromJson(data['participant']);
      setState(() {
        _currentRun?.participants.add(participant);
        _updateParticipantMarkers();
      });
    });

    _socketService.onParticipantLeft((data) {
      if (!mounted) return;
      final participantId = data['participantId'];
      setState(() {
        _currentRun?.participants
            .removeWhere((p) => p.id == participantId);
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'participant_$participantId',
        );
      });
    });
  }

  void _setupMap(RunSession run) {
    if (run.checkpoints.isEmpty) return;

    // Add checkpoint markers and circles
    for (final checkpoint in run.checkpoints) {
      final position = LatLng(
        checkpoint.location.latitude,
        checkpoint.location.longitude,
      );

      _markers.add(
        Marker(
          markerId: MarkerId('checkpoint_${checkpoint.id}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(
            title: checkpoint.name,
            snippet: checkpoint.description,
          ),
        ),
      );

      _circles.add(
        Circle(
          circleId: CircleId('checkpoint_${checkpoint.id}_radius'),
          center: position,
          radius: checkpoint.radius,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    }

    setState(() {});
  }

  void _updateParticipantMarkers() {
    if (_currentRun == null) return;

    for (final participant in _currentRun!.participants) {
      final markerId = MarkerId('participant_${participant.user.id}');
      final participantMetrics = _currentRun!.metrics.firstWhere(
        (m) => m.userId == participant.user.id,
        orElse: () => RunMetrics(
          userId: participant.user.id,
          distance: 0,
        ),
      );

      if (participantMetrics.location != null) {
        _markers.add(
          Marker(
            markerId: markerId,
            position: LatLng(
              participantMetrics.location!.latitude,
              participantMetrics.location!.longitude,
            ),
            infoWindow: InfoWindow(
              title: participant.user.username,
              snippet: 'Distance: ${(participantMetrics.distance / 1000).toStringAsFixed(2)}km',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              participant.role == 'host' ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    }
  }

  Future<void> _setupLocationTracking() async {
    if (!await _checkLocationPermission()) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      _locationSubscription = Geolocator.getPositionStream().listen((position) {
        final latLng = LatLng(position.latitude, position.longitude);
        
        if (_mapController != null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(latLng),
          );
        }

        _handleLocationUpdate(position);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void _handleLocationUpdate(Position position) {
    if (_currentRun == null) return;
    
    _socketService.updateLocation(
      widget.runId,
      {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      _currentRun!.isActive,
      _userService.currentUserId ?? '',
    );
    
    // Update local state
    setState(() {
      _currentPosition = position;
      if (_isRunning) {
        _updateRouteAndStats(position);
      }
    });
  }

  void _startRun() {
    _socketService.startRun(widget.runId);
  }

  void _endRun() {
    if (_currentRun == null) return;
    
    // Calculate final stats
    final stats = {
      'distance': _distance,
      'averagePace': _calculateAveragePace(),
      'totalTime': _duration.inSeconds,
    };
    
    _socketService.endRun(
      widget.runId,
      _userService.currentUserId ?? '',
      stats,
    );
    
    // Show completion modal
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RunCompletionModal(
          distance: _distance / 1000, // Convert meters to kilometers
          duration: _duration,
          averagePace: _calculateAveragePace(),
        ),
      ).then((_) {
        // Navigate back after modal is closed
        context.router.pop();
      });
    }
  }

  double _calculateAveragePace() {
    if (_distance == 0) return 0;
    // Convert distance to kilometers and calculate minutes per kilometer
    return (_duration.inMinutes / (_distance / 1000));
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371e3; // Earth's radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return r * c; // Distance in meters
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _updateRouteAndStats(Position position) {
    // Update route points
    _routePoints.add(LatLng(position.latitude, position.longitude));

    // Update distance
    if (_routePoints.length > 1) {
      final distance = _calculateDistance(
        _routePoints[_routePoints.length - 2].latitude,
        _routePoints[_routePoints.length - 2].longitude,
        position.latitude,
        position.longitude,
      );
      _distance += distance;
    }

    // Update pace
    if (_duration.inSeconds > 0) {
      _currentPace = _distance / _duration.inSeconds * 60;
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentRun == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentRun!.title),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentRun!.checkpoints.isNotEmpty
                  ? LatLng(
                      _currentRun!.checkpoints.first.location.latitude,
                      _currentRun!.checkpoints.first.location.longitude,
                    )
                  : const LatLng(0, 0),
              zoom: 15,
            ),
            markers: _markers,
            circles: _circles,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      _formatDuration(_duration),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Distance',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${(_distance / 1000).toStringAsFixed(2)} km',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Pace',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${_currentPace.toStringAsFixed(2)} min/km',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isRunning ? _endRun : _startRun,
        icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
        label: Text(_isRunning ? 'End Run' : 'Start Run'),
      ),
    );
  }
}
