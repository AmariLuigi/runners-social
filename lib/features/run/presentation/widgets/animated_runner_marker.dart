import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnimatedRunnerMarker extends StatefulWidget {
  final LatLng position;
  final double rotation;
  final double size;

  const AnimatedRunnerMarker({
    Key? key,
    required this.position,
    required this.rotation,
    this.size = 50,
  }) : super(key: key);

  @override
  State<AnimatedRunnerMarker> createState() => _AnimatedRunnerMarkerState();
}

class _AnimatedRunnerMarkerState extends State<AnimatedRunnerMarker> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
    debugPrint('AnimatedRunnerMarker initialized');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building AnimatedRunnerMarker with rotation: ${widget.rotation}');
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.3),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Transform.rotate(
        angle: widget.rotation * (3.14159265359 / 180),
        child: Stack(
          children: [
            Image.network(
              'https://media1.giphy.com/media/3o7ZetM6YgOMvFZq5q/giphy.gif',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading running.gif: $error');
                debugPrint('Stack trace: $stackTrace');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            // Add a semi-transparent blue overlay
            Container(
              width: widget.size,
              height: widget.size,
              color: Colors.blue.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
