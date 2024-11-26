import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:runners_social/core/services/socket_service.dart';
import 'package:runners_social/features/run/data/models/location_model.dart';
import 'package:runners_social/features/run/data/models/participant.dart';
import 'package:runners_social/features/run/presentation/widgets/run_completion_modal.dart';

class ActiveRunScreen extends ConsumerStatefulWidget {
  final String runId;

  const ActiveRunScreen({
    Key? key,
    required this.runId,
  }) : super(key: key);

  @override
  ConsumerState<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends ConsumerState<ActiveRunScreen> {
  late final SocketService _socketService;
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _locationSubscription;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _routeCoordinates = [];
  Timer? _timer;
  Duration _duration = Duration.zero;
  double _distance = 0;
  String? _mapError;
  bool _disposed = false;
  bool _isRunning = false;
  DateTime? _startTime;
  final List<Function> _socketListeners = [];
  Map<String, Participant> _participants = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _socketService = GetIt.I<SocketService>();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    try {
      await _socketService.ensureConnected();
      
      if (!mounted) return;
      
      setState(() {
        _isInitialized = true;
      });

      _setupSocketListeners();
      await _socketService.joinRun(widget.runId);
      await _startLocationTracking();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing: $e')),
      );
    }
  }

  void _setupSocketListeners() {
    if (!_socketService.isConnected) return;

    void addListener(String event, Function(dynamic) callback) {
      _socketService.socket.on(event, callback);
      _socketListeners.add(() {
        _socketService.socket.off(event, callback);
      });
    }

    addListener('runStarted', (data) {
      if (!mounted || _disposed) return;
      setState(() {
        _isRunning = true;
        _startTime = DateTime.now();
      });
    });

    addListener('runEnded', (data) {
      if (!mounted || _disposed) return;
      setState(() {
        _isRunning = false;
      });
      _handleRunEnd();
    });

    addListener('participantJoined', (data) {
      if (data is! Map<String, dynamic>) return;
      if (data['participant'] != null) {
        final participant = Participant.fromJson(data['participant'] as Map<String, dynamic>);
        setState(() {
          _participants[participant.id] = participant;
          _updateParticipantMarker(participant);
        });
      }
    });

    addListener('participantLeft', (data) {
      if (data is! Map<String, dynamic>) return;
      final participantId = data['participantId'];
      if (participantId != null) {
        setState(() {
          _participants.remove(participantId);
          _markers.removeWhere((marker) => marker.markerId.value == participantId);
        });
      }
    });

    addListener('locationUpdate', (data) {
      if (data is Map<String, dynamic>) {
        _handleParticipantLocationUpdate(data);
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    for (final removeListener in _socketListeners) {
      removeListener();
    }
    _locationSubscription?.cancel();
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(_handleLocationUpdate);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting location tracking: ${e.toString()}')),
        );
      }
    }
  }

  void _handleLocationUpdate(Position position) {
    if (!mounted || !_isRunning) return;

    final location = LocationModel(
      coordinates: [position.longitude, position.latitude],
      altitude: position.altitude,
      speed: position.speed,
      timestamp: DateTime.now(),
    );

    _socketService.emitLocationUpdate(
      runId: widget.runId,
      location: location,
    );

    setState(() {
      _routeCoordinates.add(
        LatLng(position.latitude, position.longitude),
      );
      _updateRouteAndStats();
    });
  }

  void _updateRouteAndStats() {
    if (_routeCoordinates.isEmpty) return;

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _routeCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_routeCoordinates.last),
        );
      }
    });
  }

  double _calculateTotalDistance() {
    double totalDistance = 0;
    for (int i = 0; i < _routeCoordinates.length - 1; i++) {
      totalDistance += _calculateDistance(
        _routeCoordinates[i],
        _routeCoordinates[i + 1],
      );
    }
    return totalDistance;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const int earthRadius = 6371000; // Earth's radius in meters
    
    final lat1 = start.latitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final dLat = (end.latitude - start.latitude) * pi / 180;
    final dLon = (end.longitude - start.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  void _handleRunEnd() async {
    if (!mounted) return;
    
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _timer?.cancel();
    
    if (_startTime != null) {
      final distance = _calculateTotalDistance();
      final duration = DateTime.now().difference(_startTime!);
      final averagePace = duration.inMinutes / (distance / 1000);

      await _socketService.endRun(widget.runId);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RunCompletionModal(
          distance: distance,
          duration: duration,
          averagePace: averagePace,
        ),
      );

      context.router.pop();
    }
  }

  void _handleParticipantLocationUpdate(Map<String, dynamic> data) {
    if (!mounted) return;
    final participantId = data['participantId'];
    final location = data['location'];
    
    if (participantId != null && location != null && _participants.containsKey(participantId)) {
      final participant = _participants[participantId]!;
      setState(() {
        _participants[participantId] = Participant(
          id: participant.id,
          name: participant.name,
          latitude: (location['coordinates'] as List<dynamic>)[1] as double,
          longitude: (location['coordinates'] as List<dynamic>)[0] as double,
        );
        _updateParticipantMarker(_participants[participantId]!);
      });
    }
  }

  void _updateParticipantMarker(Participant participant) {
    final markerId = MarkerId(participant.id);
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == markerId);
      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(participant.latitude, participant.longitude),
          infoWindow: InfoWindow(title: participant.name),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _toggleRun() async {
    if (!_socketService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Socket not connected')),
      );
      return;
    }

    try {
      if (_isRunning) {
        await _socketService.endRun(widget.runId);
      } else {
        await _socketService.startRun(widget.runId);
        setState(() {
          _startTime = DateTime.now();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (mounted && _isRunning) {
              setState(() {
                _duration = DateTime.now().difference(_startTime!);
              });
            }
          });
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Active Run'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Run'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Distance: ${(_distance / 1000).toStringAsFixed(2)} km',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Time: ${_formatDuration(_duration)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _toggleRun,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: _isRunning ? Colors.red : Colors.green,
                  ),
                  child: Text(_isRunning ? 'End Run' : 'Start Run'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
