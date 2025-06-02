import 'package:flutter/material.dart';

/// Animation durations used throughout the app
class AnimationDurations {
  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 400);
  static const slow = Duration(milliseconds: 600);
  static const extraSlow = Duration(milliseconds: 1200);
}

/// Animation curves used throughout the app
class AnimationCurves {
  // Natural, fabric-like movement
  static const fabric = Curves.easeOutBack;

  // Gentle, floating motion
  static const float = Curves.easeInOutCubic;

  // Quick response for micro-interactions
  static const snap = Curves.easeOutExpo;

  // Smoothly decelerate to rest
  static const settle = Curves.easeOutCirc;

  // For more dramatic entrances
  static const emphasis = Cubic(0.2, 0.8, 0.2, 1.0);
}

/// Extension methods for widgets to easily add animated transitions
extension AnimatedWidgetExtensions on Widget {
  /// Wraps widget with a fade transition
  Widget fadeIn({
    Key? key,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOut,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: this,
    );
  }

  /// Wraps widget with a slide transition from bottom
  Widget slideUp({
    Key? key,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
    double offset = 50.0,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween<double>(begin: offset, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: this,
    );
  }

  /// Wraps widget with a scale transition
  Widget scaleIn({
    Key? key,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutBack,
    double from = 0.95,
    Alignment alignment = Alignment.center,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween<double>(begin: from, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: alignment,
          child: child,
        );
      },
      child: this,
    );
  }

  /// Combines fade and slide up for a smooth entrance
  Widget fadeSlideUp({
    Key? key,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = AnimationCurves.fabric,
    double offset = 50.0,
  }) {
    return this
        .fadeIn(
          key: key,
          duration: duration,
          curve: curve,
        )
        .slideUp(
          duration: duration,
          curve: curve,
          offset: offset,
        );
  }
}

/// Custom scroll physics that simulate fabric resistance
class FabricScrollPhysics extends ScrollPhysics {
  const FabricScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  FabricScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FabricScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80, // Higher mass creates more momentum
        stiffness: 100, // Lower stiffness for softer deceleration
        damping: 15, // Higher damping for organic feel
      );
}
