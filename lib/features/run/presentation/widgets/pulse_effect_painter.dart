import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PulseEffectPainter extends CustomPainter {
  final LatLng position;
  final double pulseValue;
  final GoogleMapController? mapController;
  Offset? _lastKnownScreenPosition;

  PulseEffectPainter({
    required this.position,
    required this.pulseValue,
    this.mapController,
  }) {
    _updateScreenPosition();
  }

  void _updateScreenPosition() {
    if (mapController == null) return;
    
    mapController!.getScreenCoordinate(position).then((screenCoordinate) {
      _lastKnownScreenPosition = Offset(
        screenCoordinate.x.toDouble(),
        screenCoordinate.y.toDouble(),
      );
    }).catchError((e) {
      debugPrint('Error getting screen coordinate: $e');
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_lastKnownScreenPosition == null) return;

    // Outer glow
    final Paint glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(_lastKnownScreenPosition!, 50 * (1 + pulseValue), glowPaint);

    // Outer pulse
    final outerPaint = Paint()
      ..color = Colors.blue.withOpacity(0.4 * (1 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(_lastKnownScreenPosition!, 40 * (1 + pulseValue), outerPaint);

    // Middle pulse
    final middlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.6 * (1 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(_lastKnownScreenPosition!, 30 * (1 + pulseValue * 0.7), middlePaint);

    // Inner circle
    final innerPaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(_lastKnownScreenPosition!, 20, innerPaint);
  }

  @override
  bool shouldRepaint(PulseEffectPainter oldDelegate) {
    if (oldDelegate.position != position) {
      _updateScreenPosition();
    }
    return oldDelegate.pulseValue != pulseValue ||
           oldDelegate.position != position;
  }
}
