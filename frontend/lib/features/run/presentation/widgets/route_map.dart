import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/run.dart';

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
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _updateMapPoints();
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _center = const LatLng(0, 0);
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routePoints != widget.routePoints) {
      _updateMapPoints();
    }
  }

  Future<List<LatLng>> _getRoutePoints(LatLng origin, LatLng destination) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=walking'
        '&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          return points;
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
    
    // Fallback to straight line if route fetching fails
    return [origin, destination];
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _updateMapPoints() async {
    if (widget.routePoints.isEmpty) {
      setState(() {
        _center = const LatLng(0, 0);
        _markers = {};
        _polylines = {};
      });
      return;
    }

    final points = widget.routePoints.map((point) => 
      LatLng(point.latitude, point.longitude)).toList();

    _center = points.first;
    
    // Create markers with custom icons for start and end
    _markers = widget.routePoints.asMap().entries.map((entry) {
      final i = entry.key;
      final point = entry.value;
      final latLng = LatLng(point.latitude, point.longitude);
      
      final isStart = i == 0;
      final isEnd = i == widget.routePoints.length - 1;

      return Marker(
        markerId: MarkerId('point_$i'),
        position: latLng,
        draggable: widget.isEditable,
        onDragEnd: widget.isEditable 
          ? (newPosition) => _updateMarkerPosition(i, newPosition)
          : null,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isStart ? BitmapDescriptor.hueGreen :
          isEnd ? BitmapDescriptor.hueRed :
          BitmapDescriptor.hueAzure
        ),
        infoWindow: InfoWindow(
          title: isStart ? 'Start' :
                 isEnd ? 'End' :
                 'Waypoint ${i + 1}',
          snippet: 'Drag to adjust',
        ),
      );
    }).toSet();

    // Create route between points
    if (points.length > 1) {
      List<LatLng> routePoints = [];
      
      // Get route between each consecutive pair of points
      for (int i = 0; i < points.length - 1; i++) {
        final start = points[i];
        final end = points[i + 1];
        final segmentPoints = await _getRoutePoints(start, end);
        routePoints.addAll(segmentPoints);
      }

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: Colors.blue,
            width: 5,
            patterns: [
              PatternItem.dash(20.0),
              PatternItem.gap(10.0),
            ],
          ),
        };
      });
    } else {
      setState(() {
        _polylines = {};
      });
    }
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

  void _addMarker(LatLng position) {
    if (!widget.isEditable) return;

    final updatedPoints = List<RoutePoint>.from(widget.routePoints);
    updatedPoints.add(RoutePoint(
      latitude: position.latitude,
      longitude: position.longitude,
      order: updatedPoints.length,
    ));
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
        if (!widget.isEditable)
          Container(
            color: Colors.grey.withOpacity(0.5),
          ),
        if (widget.isEditable && widget.routePoints.isNotEmpty)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                final updatedPoints = List<RoutePoint>.from(widget.routePoints);
                updatedPoints.removeLast();
                widget.onRouteChanged?.call(updatedPoints);
              },
              child: const Icon(Icons.undo),
              tooltip: 'Undo last point',
            ),
          ),
      ],
    );
  }
}
