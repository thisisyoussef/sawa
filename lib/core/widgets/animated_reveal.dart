import 'package:flutter/material.dart';
import '../constants/design_system.dart' as design;

enum RevealType {
  fade,
  scale,
}

enum RevealDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}

/// A widget that animates its child into view when it appears on screen
class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final RevealType type;
  final RevealDirection direction;
  final Duration duration;
  final Curve curve;

  const AnimatedReveal({
    Key? key,
    required this.child,
    this.delay,
    this.type = RevealType.fade,
    this.direction = RevealDirection.fromBottom,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutQuart,
  }) : super(key: key);

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        // Check if widget is still mounted before starting animation
        if (!_isDisposed && mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary to isolate animations and improve performance
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Make sure child is not null before using it
          if (child == null) {
            return const SizedBox();
          }

          switch (widget.type) {
            case RevealType.scale:
              return _buildScaleAnimation(child);
            case RevealType.fade:
            default:
              return _buildFadeAnimation(child);
          }
        },
        child: widget.child,
      ),
    );
  }

  Widget _buildFadeAnimation(Widget child) {
    // Ensure opacity is within valid range (0.0 to 1.0)
    final opacity = _animation.value.clamp(0.0, 1.0);

    // Calculate transform offset based on direction
    final Offset offset = _getOffsetForDirection(widget.direction);

    // Only apply transform if needed (when direction is specified)
    final bool needsTransform = widget.direction != RevealDirection.fromBottom;

    // Use opacity for the fade effect
    return Opacity(
      opacity: opacity,
      child: needsTransform
          ? Transform.translate(
              offset: Offset(
                offset.dx * (1 - _animation.value),
                offset.dy * (1 - _animation.value),
              ),
              child: child,
            )
          : child,
    );
  }

  Widget _buildScaleAnimation(Widget child) {
    // Scale from 0.8 to 1.0
    final scale = 0.8 + (0.2 * _animation.value);

    // Ensure opacity is within valid range
    final opacity = _animation.value.clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
  }

  Offset _getOffsetForDirection(RevealDirection direction) {
    switch (direction) {
      case RevealDirection.fromTop:
        return const Offset(0, -30);
      case RevealDirection.fromBottom:
        return const Offset(0, 30);
      case RevealDirection.fromLeft:
        return const Offset(-30, 0);
      case RevealDirection.fromRight:
        return const Offset(30, 0);
      default:
        return const Offset(0, 30);
    }
  }
}

/// Custom painter for wave reveal animation
class WaveRevealPainter extends CustomPainter {
  final double progress;
  final RevealDirection direction;

  WaveRevealPainter({required this.progress, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white;

    if (progress <= 0.0) return;
    if (progress >= 1.0) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Horizontal wave parameters
    final waveHeight = height * 0.1;
    final horizontalOffset = width * progress;

    // Vertical wave parameters
    final waveWidth = width * 0.1;
    final verticalOffset = height * progress;

    switch (direction) {
      case RevealDirection.fromLeft:
        path.moveTo(0, 0);
        path.lineTo(horizontalOffset - waveWidth, 0);
        path.quadraticBezierTo(
            horizontalOffset, height / 2, horizontalOffset - waveWidth, height);
        path.lineTo(0, height);
        path.close();
        break;

      case RevealDirection.fromRight:
        path.moveTo(width, 0);
        path.lineTo(width - horizontalOffset + waveWidth, 0);
        path.quadraticBezierTo(width - horizontalOffset, height / 2,
            width - horizontalOffset + waveWidth, height);
        path.lineTo(width, height);
        path.close();
        break;

      case RevealDirection.fromTop:
        path.moveTo(0, 0);
        path.lineTo(0, verticalOffset - waveHeight);
        path.quadraticBezierTo(
            width / 2, verticalOffset, width, verticalOffset - waveHeight);
        path.lineTo(width, 0);
        path.close();
        break;

      case RevealDirection.fromBottom:
        path.moveTo(0, height);
        path.lineTo(0, height - verticalOffset + waveHeight);
        path.quadraticBezierTo(width / 2, height - verticalOffset, width,
            height - verticalOffset + waveHeight);
        path.lineTo(width, height);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveRevealPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
