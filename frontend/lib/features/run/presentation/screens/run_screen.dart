import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../../core/models/location_model.dart';
import '../../../../core/services/socket_service.dart';
import '../widgets/run_completion_modal_new.dart';

@RoutePage()
class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  StreamSubscription<Position>? _locationSubscription;
  bool _isInitialized = false;
  String? _mapError;
  List<LatLng> _routeCoordinates = [];
  bool _isRunning = false;
  bool _isFollowingUser = true;
  double _distance = 0;
  DateTime? _startTime;
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mapError = e.toString();
        });
      }
    }
  }

  void _handleLocationUpdate(Position position) {
    if (!mounted) return;

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

      setState(() {});
    }
  }

  Future<void> _setupLocationStream() async {
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
        _handleLocationUpdate,
        onError: (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location error: $e'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      );
    } catch (e) {
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

  void _toggleRun() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startRun();
      } else {
        _endRun();
      }
    });
  }

  void _startRun() {
    _startTime = DateTime.now();
    _setupLocationStream();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _startTime != null) {
        setState(() {
          _duration = DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  void _endRun() {
    _locationSubscription?.cancel();
    _timer?.cancel();
    
    if (_startTime != null) {
      final duration = DateTime.now().difference(_startTime!);
      final averagePace = _distance > 0 
          ? duration.inMinutes / (_distance / 1000) 
          : 0.0;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RunCompletionModal(
          distance: _distance,
          duration: duration,
          averagePace: averagePace,
        ),
      );
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        _mapController.zoom,
      );
      setState(() {
        _isFollowingUser = true;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
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
                    builder: (context) => Stack(
                      children: [
                        Center(
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
                        ),
                        if (_isRunning)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
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
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run'),
      ),
      body: _buildBody(),
    );
  }
}
