import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../../domain/entities/run.dart';
import '../../../../core/services/api_service.dart';

final routeMapControllerProvider = StateProvider<GoogleMapController?>((ref) => null);

class RouteMap extends ConsumerStatefulWidget {
  final List<RoutePoint> routePoints;
  final Function(List<RoutePoint>)? onRouteChanged;
  final bool isEditable;

  const RouteMap({
    Key? key,
    required this.routePoints,
    this.onRouteChanged,
    this.isEditable = true,
  }) : super(key: key);

  @override
  ConsumerState<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends ConsumerState<RouteMap> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _center;
  bool _isLoading = true;
  final String _googleApiKey = 'AIzaSyAm-4YgsBuOB-AsmyiPiA396ibXivObO3E';

  @override
  void initState() {
    super.initState();
    _loadInitialPosition();
  }

  Future<void> _loadInitialPosition() async {
    setState(() => _isLoading = true);
    try {
      // Request permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        // Default to a fallback location if permission denied
        _center = const LatLng(45.4642, 9.1900); // Milan, Italy
      } else {
        final position = await Geolocator.getCurrentPosition();
        _center = LatLng(position.latitude, position.longitude);
      }

      // If we have route points, center on those instead
      if (widget.routePoints.isNotEmpty) {
        final firstPoint = widget.routePoints.first;
        _center = LatLng(firstPoint.latitude, firstPoint.longitude);
        
        // Add markers and polylines for existing route
        _markers.clear();
        _polylines.clear();
        
        for (int i = 0; i < widget.routePoints.length; i++) {
          final point = widget.routePoints[i];
          final isStart = i == 0;
          final isEnd = i == widget.routePoints.length - 1;
          
          _markers.add(
            Marker(
              markerId: MarkerId('point_$i'),
              position: LatLng(point.latitude, point.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isStart ? BitmapDescriptor.hueGreen :
                isEnd ? BitmapDescriptor.hueRed :
                BitmapDescriptor.hueBlue,
              ),
            ),
          );

          // Add polyline between consecutive points
          if (i < widget.routePoints.length - 1) {
            final nextPoint = widget.routePoints[i + 1];
            await _addRouteBetweenPoints(
              LatLng(point.latitude, point.longitude),
              LatLng(nextPoint.latitude, nextPoint.longitude),
            );
          }
        }
      }
    } catch (e) {
      print('Error loading initial position: $e');
      // Fallback to a default location
      _center = const LatLng(45.4642, 9.1900); // Milan, Italy
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addRouteBetweenPoints(LatLng start, LatLng end) async {
    try {
      print('Requesting route between:');
      print('Start: ${start.latitude}, ${start.longitude}');
      print('End: ${end.latitude}, ${end.longitude}');

      final apiService = ApiService();
      final response = await apiService.get(
        '/api/maps/directions',
        queryParameters: {
          'origin': '${start.latitude},${start.longitude}',
          'destination': '${end.latitude},${end.longitude}',
          'mode': 'walking',
          'alternatives': 'false',
          'optimize': 'true'
        },
      );

      final data = response.data;
      if (data == null || data['routes'] == null || data['routes'].isEmpty) {
        print('No routes found in response');
        return;
      }

      final route = data['routes'][0];
      final List<LatLng> routePoints = [];

      // Add all points from the route steps
      if (route['legs'] != null && route['legs'].isNotEmpty) {
        final leg = route['legs'][0];
        for (final step in leg['steps']) {
          if (step['start_location'] != null) {
            routePoints.add(LatLng(
              step['start_location']['lat'].toDouble(),
              step['start_location']['lng'].toDouble()
            ));
          }
          if (step['end_location'] != null) {
            routePoints.add(LatLng(
              step['end_location']['lat'].toDouble(),
              step['end_location']['lng'].toDouble()
            ));
          }
        }
      }

      setState(() {
        // Add the new polyline
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route_${_polylines.length}'),
            points: routePoints,
            color: Colors.blue,
            width: 4,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        );
      });
    } catch (e, stackTrace) {
      print('Error fetching route: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _updateMarkerIcons() {
    final markersList = _markers.toList();
    if (markersList.isEmpty) return;

    // Create a new set of markers with updated icons
    final updatedMarkers = <Marker>{};
    
    for (int i = 0; i < markersList.length; i++) {
      final marker = markersList[i];
      final isStart = i == 0;
      final isEnd = i == markersList.length - 1;
      
      updatedMarkers.add(
        Marker(
          markerId: marker.markerId,
          position: marker.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isStart ? BitmapDescriptor.hueGreen :
            isEnd ? BitmapDescriptor.hueRed :
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }

    _markers.clear();
    _markers.addAll(updatedMarkers);
  }

  Future<void> _addMarker(LatLng position) async {
    if (!widget.isEditable) return;

    setState(() {
      // Add the new marker
      _markers.add(
        Marker(
          markerId: MarkerId('point_${_markers.length}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      // Update all marker icons
      _updateMarkerIcons();
    });

    // If we have at least 2 markers, draw route between the last two points
    if (_markers.length >= 2) {
      final lastIndex = _markers.length - 1;
      final start = _markers.elementAt(lastIndex - 1).position;
      final end = _markers.elementAt(lastIndex).position;
      await _addRouteBetweenPoints(start, end);
    }

    // Update route points for the form
    final updatedPoints = _markers.map((marker) => RoutePoint(
      latitude: marker.position.latitude,
      longitude: marker.position.longitude,
      order: _markers.toList().indexOf(marker),
    )).toList();

    widget.onRouteChanged?.call(updatedPoints);
  }

  void _updateMarkerPosition(int index, LatLng newPosition) {
    final updatedPoints = List<RoutePoint>.from(widget.routePoints);
    updatedPoints[index] = RoutePoint(
      latitude: newPosition.latitude,
      longitude: newPosition.longitude,
      order: index,
    );
    widget.onRouteChanged?.call(updatedPoints);
  }

  double calculateDistance() {
    double totalDistance = 0;
    for (var i = 0; i < widget.routePoints.length - 1; i++) {
      final start = widget.routePoints[i];
      final end = widget.routePoints[i + 1];
      totalDistance += Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );
    }
    return totalDistance;
  }

  void _clearRoute() {
    setState(() {
      _markers.clear();
      _polylines.clear();
    });
    widget.onRouteChanged?.call([]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _center == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: !widget.isEditable,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center!,
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              ref.read(routeMapControllerProvider.notifier).state = controller;
            },
            onTap: widget.isEditable ? _addMarker : null,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            mapType: MapType.normal,
          ),
        ),
        if (widget.isEditable && widget.routePoints.isNotEmpty)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _clearRoute,
              child: const Icon(Icons.undo),
              tooltip: 'Clear route',
            ),
          ),
      ],
    );
  }
}
