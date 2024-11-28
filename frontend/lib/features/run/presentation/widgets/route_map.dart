import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/run.dart';

final routeMapControllerProvider = StateProvider<GoogleMapController?>((ref) => null);

class RouteMap extends StatefulWidget {
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
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _center;
  bool _isLoading = true;

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

  void _updateMapPoints() {
    if (widget.routePoints.isEmpty) {
      _center = const LatLng(0, 0);
      _markers = {};
      _polylines = {};
      return;
    }

    final points = widget.routePoints.map((point) => 
      LatLng(point.latitude, point.longitude)).toList();

    _center = points.first;
    
    // Create markers
    _markers = widget.routePoints.asMap().entries.map((entry) {
      final i = entry.key;
      final point = entry.value;
      final latLng = LatLng(point.latitude, point.longitude);

      return Marker(
        markerId: MarkerId('point_$i'),
        position: latLng,
        draggable: widget.isEditable,
        onDragEnd: widget.isEditable 
          ? (newPosition) => _updateMarkerPosition(i, newPosition)
          : null,
      );
    }).toSet();

    // Create polyline
    if (points.length > 1) {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 3,
        ),
      };
    } else {
      _polylines = {};
    }

    setState(() {});
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
              // ref.read(routeMapControllerProvider.notifier).state = controller;
            },
            onTap: widget.isEditable ? _addMarker : null,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
          ),
        ),
        if (!widget.isEditable)
          Container(
            color: Colors.grey.withOpacity(0.5),
          ),
      ],
    );
  }
}
