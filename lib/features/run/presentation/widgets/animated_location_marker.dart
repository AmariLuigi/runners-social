import 'package:flutter/material.dart';

class AnimatedLocationMarker extends StatefulWidget {
  final Widget child;
  final Widget? label;
  final Color color;
  final bool showWaves;

  const AnimatedLocationMarker({
    Key? key,
    required this.child,
    this.label,
    this.color = Colors.blue,
    this.showWaves = true,
  }) : super(key: key);

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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -12)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -12, end: 0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6),
      ),
    );

    _waveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuad,
    );

    if (widget.showWaves) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.reset();
    _controller.repeat();
  }

  @override
  void didUpdateWidget(AnimatedLocationMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showWaves != oldWidget.showWaves) {
      if (widget.showWaves) {
        _startAnimation();
      } else {
        _controller.stop();
      }
    }
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
                  scale: 1 + (_waveAnimation.value * 0.8),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.15 * _waveAnimation.value),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1 + (_waveAnimation.value * 0.5),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.25 * _waveAnimation.value),
                    ),
                  ),
                ),
              ],
              Transform.translate(
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
            ],
          ),
        );
      },
    );
  }
}
