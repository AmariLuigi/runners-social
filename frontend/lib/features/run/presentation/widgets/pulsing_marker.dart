import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PulsingMarkerOverlay extends StatefulWidget {
  final LatLng position;
  final double rotation;
  final GoogleMapController mapController;

  const PulsingMarkerOverlay({
    Key? key,
    required this.position,
    required this.rotation,
    required this.mapController,
  }) : super(key: key);

  @override
  State<PulsingMarkerOverlay> createState() => _PulsingMarkerOverlayState();
}

class _PulsingMarkerOverlayState extends State<PulsingMarkerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset _screenPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat();
    _updatePosition();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updatePosition() async {
    if (!mounted) return;
    try {
      final screenCoordinate = await widget.mapController.getScreenCoordinate(widget.position);
      if (mounted) {
        setState(() {
          _screenPosition = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
        });
      }
    } catch (e) {
      debugPrint('Error updating marker position: $e');
    }
  }

  @override
  void didUpdateWidget(PulsingMarkerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _updatePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _screenPosition.dx - 30,
      top: _screenPosition.dy - 30,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: widget.rotation * (pi / 180),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulsing circle
                Transform.scale(
                  scale: 1.0 + (_animation.value * 0.3),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.3 * (1 - _animation.value)),
                    ),
                  ),
                ),
                // Middle pulsing circle
                Transform.scale(
                  scale: 1.0 + (_animation.value * 0.2),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.4 * (1 - _animation.value)),
                    ),
                  ),
                ),
                // Core marker
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade600,
                      ],
                      stops: const [0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
