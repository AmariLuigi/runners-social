import 'package:flutter/material.dart';

class AnimatedLocationMarker extends StatefulWidget {
  final Widget child;
  final Widget? label;
  final bool showWaves;
  final Color color;

  const AnimatedLocationMarker({
    super.key,
    required this.child,
    this.label,
    this.showWaves = true,
    required this.color,
  });

  @override
  State<AnimatedLocationMarker> createState() => _AnimatedLocationMarkerState();
}

class _AnimatedLocationMarkerState extends State<AnimatedLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -10)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1),
      ),
    );

    _waveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.showWaves) ...[
                Transform.scale(
                  scale: 1 + (_waveAnimation.value * 0.5),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.1),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1 + (_waveAnimation.value * 0.35),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.2),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1 + (_waveAnimation.value * 0.2),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
              Positioned(
                top: 10,
                child: Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.child,
                      if (widget.label != null) ...[
                        const SizedBox(height: 4),
                        widget.label!,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
