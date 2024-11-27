import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:runners_social/core/services/socket_service.dart';
import 'package:runners_social/features/run/data/models/location_model.dart';
import 'package:runners_social/features/run/data/models/participant.dart';
import 'package:runners_social/features/run/presentation/widgets/run_completion_modal_new.dart';
import 'package:runners_social/features/run/presentation/widgets/animated_location_marker.dart';

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
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _locationSubscription;
  final List<LatLng> _routeCoordinates = [];
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
  Position? _currentPosition;
  bool _isFollowingUser = true;

  @override
  void initState() {
    super.initState();
    _socketService = GetIt.I<SocketService>();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      debugPrint('Starting initialization...');
      await _requestLocationPermission();
      debugPrint('Location permission granted');

      // Get initial position
      final initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint('Got initial position: ${initialPosition.latitude}, ${initialPosition.longitude}');

      setState(() {
        _currentPosition = initialPosition;
      });

      await _socketService.ensureConnected();
      debugPrint('Socket connected');
      
      await _socketService.joinRun(widget.runId);
      debugPrint('Joined run: ${widget.runId}');

      await _setupLocationStream();
      debugPrint('Location stream setup complete');
      
      _setupSocketListeners();
      debugPrint('Socket listeners setup complete');
      
      setState(() {
        _isInitialized = true;
      });
      debugPrint('Initialization complete');
    } catch (e) {
      debugPrint('Error during initialization: $e');
      setState(() {
        _mapError = 'Failed to initialize map: $e';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    debugPrint('Checking location services...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable location services.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      throw Exception('Location services are disabled');
    }
    debugPrint('Location services are enabled');

    debugPrint('Checking location permission...');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('Requesting location permission...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. Please enable location permission.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied. Please enable in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      throw Exception('Location permissions are permanently denied');
    }

    debugPrint('Location permission granted: $permission');
  }

  Future<void> _setupLocationStream() async {
    debugPrint('Setting up location stream...');
    _locationSubscription?.cancel();

    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: const Duration(seconds: 5),
      );

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (position) {
          debugPrint('New position received: ${position.latitude}, ${position.longitude}');
          if (mounted) {
            _handleLocationUpdate(position);
          }
        },
        onError: (e) {
          debugPrint('Error in location stream: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location error: $e'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        cancelOnError: false,
      );

      debugPrint('Location stream setup successful');
    } catch (e) {
      debugPrint('Error setting up location stream: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting up location tracking: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      rethrow;
    }
  }

  void _handleLocationUpdate(Position position) {
    debugPrint('Handling location update: ${position.latitude}, ${position.longitude}');
    if (!mounted || _disposed) return;

    setState(() {
      _currentPosition = position;
    });

    if (_isRunning) {
      final newCoordinate = LatLng(position.latitude, position.longitude);
      _routeCoordinates.add(newCoordinate);
      
      if (_routeCoordinates.length > 1) {
        final lastCoordinate = _routeCoordinates[_routeCoordinates.length - 2];
        final distance = Geolocator.distanceBetween(
          lastCoordinate.latitude,
          lastCoordinate.longitude,
          newCoordinate.latitude,
          newCoordinate.longitude,
        );
        _distance += distance;
      }

      if (_isFollowingUser) {
        _mapController.move(newCoordinate, _mapController.zoom);
      }

      setState(() {}); // Update polylines

      _socketService.emitLocationUpdate(
        runId: widget.runId,
        location: LocationModel(
          coordinates: [position.longitude, position.latitude],
          altitude: position.altitude,
          speed: position.speed,
          timestamp: DateTime.now(),
        ),
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
        });
      }
    });

    addListener('participantLeft', (data) {
      if (data is! Map<String, dynamic>) return;
      final participantId = data['participantId'];
      if (participantId != null) {
        setState(() {
          _participants.remove(participantId);
        });
      }
    });

    addListener('locationUpdate', (data) {
      if (data is Map<String, dynamic>) {
        _handleParticipantLocationUpdate(data);
      }
    });
  }

  void _handleRunEnd() async {
    if (!mounted) return;
    
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _timer?.cancel();
    
    if (_startTime != null) {
      final distance = _calculateTotalDistance();
      final duration = DateTime.now().difference(_startTime!);
      final averagePace = distance > 0 
          ? duration.inMinutes / (distance / 1000) 
          : 0.0;

      await _socketService.endRun(widget.runId);

      if (!mounted) return;

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
      });
    }
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

  void _centerOnUser() {
    if (_currentPosition != null) {
      _isFollowingUser = true;
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        _mapController.zoom,
      );
    }
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
        await _handleRunEnd(); // Add this line to show the completion modal
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

  Future<bool> _onWillPop() async {
    if (_isRunning) {
      _showExitConfirmationDialog();
      return false;
    }
    return true;
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exit Run'),
        content: const Text('Are you sure you want to exit the run?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _stopRun();
              if (mounted) {
                Navigator.of(context).pop(); // Close dialog
                context.router.pop(); // Exit screen
              }
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<void> _stopRun() async {
    _timer?.cancel();
    _locationSubscription?.cancel();
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      await _socketService.endRun(widget.runId);
      await _handleRunEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Run'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _onWillPop().then((canPop) {
              if (canPop) Navigator.of(context).pop();
            }),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
                color: _isFollowingUser ? Colors.blue : Colors.grey,
              ),
              onPressed: _centerOnUser,
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_mapError != null) {
      return Center(child: Text(_mapError!));
    }

    if (!_isInitialized || _currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final primaryColor = Theme.of(context).primaryColor;
    
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                _isFollowingUser = false;
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.runners_social.app',
            ),
            PolylineLayer(
              polylines: [
                if (_routeCoordinates.isNotEmpty)
                  Polyline(
                    points: _routeCoordinates,
                    color: primaryColor,
                    strokeWidth: 4,
                  ),
              ],
            ),
            MarkerLayer(
              markers: [
                if (_currentPosition != null)
                  Marker(
                    point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    width: 60,
                    height: 80,
                    builder: (context) => AnimatedLocationMarker(
                      color: primaryColor,
                      showWaves: _isRunning,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      label: _isRunning ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Running',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) : null,
                    ),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 100,
          child: FloatingActionButton(
            onPressed: _centerOnUser,
            child: Icon(
              _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _disposed = true;
    for (final removeListener in _socketListeners) {
      removeListener();
    }
    _locationSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
