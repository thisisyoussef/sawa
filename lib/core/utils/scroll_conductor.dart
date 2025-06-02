import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the scroll conductor
final scrollConductorProvider =
    ChangeNotifierProvider((ref) => ScrollConductor());

/// Class to orchestrate scroll-based animations across the entire app
class ScrollConductor extends ChangeNotifier {
  // The primary scroll controller for the main page
  final ScrollController controller = ScrollController();

  // Tracks the current scroll direction
  ScrollDirection _scrollDirection = ScrollDirection.idle;

  // Tracks the current scroll position
  double _scrollPosition = 0.0;

  // Tracks if user has scrolled down from the top
  bool _hasScrolledDown = false;

  // Tracks scroll velocity for momentum-based effects
  double _scrollVelocity = 0.0;

  // Section visibility thresholds (0.0-1.0)
  final Map<String, double> _sectionVisibility = {};

  // Last update timestamp for velocity calculation
  DateTime _lastUpdate = DateTime.now();

  ScrollConductor() {
    controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    controller.removeListener(_handleScroll);
    controller.dispose();
    super.dispose();
  }

  // Current scroll position
  double get scrollPosition => _scrollPosition;

  // Current scroll direction
  ScrollDirection get scrollDirection => _scrollDirection;

  // Whether user has scrolled down from top
  bool get hasScrolledDown => _hasScrolledDown;

  // Current scroll velocity (positive = down, negative = up)
  double get scrollVelocity => _scrollVelocity;

  // Get visibility percentage for a specific section
  double getSectionVisibility(String sectionKey) {
    return _sectionVisibility[sectionKey] ?? 0.0;
  }

  // Set visibility for a specific section
  void setSectionVisibility(String sectionKey, double visibility) {
    _sectionVisibility[sectionKey] = visibility.clamp(0.0, 1.0);
    notifyListeners();
  }

  // Handle scroll events
  void _handleScroll() {
    // Calculate scroll velocity
    final now = DateTime.now();
    final dt = now.difference(_lastUpdate).inMilliseconds / 1000;
    if (dt > 0) {
      final oldPosition = _scrollPosition;
      _scrollPosition = controller.offset;
      _scrollVelocity = (_scrollPosition - oldPosition) / dt;
      _lastUpdate = now;
    }

    // Determine scroll direction
    if (_scrollVelocity > 0.5) {
      _scrollDirection = ScrollDirection.forward;
    } else if (_scrollVelocity < -0.5) {
      _scrollDirection = ScrollDirection.reverse;
    } else {
      _scrollDirection = ScrollDirection.idle;
    }

    // Track if user has scrolled down from top
    if (_scrollPosition > 10 && !_hasScrolledDown) {
      _hasScrolledDown = true;
    } else if (_scrollPosition <= 10 && _hasScrolledDown) {
      _hasScrolledDown = false;
    }

    notifyListeners();
  }

  // Smoothly scroll to a specific position
  Future<void> smoothScrollTo(double position,
      {Duration duration = const Duration(milliseconds: 800)}) async {
    await controller.animateTo(
      position,
      duration: duration,
      curve: Curves.easeOutCubic,
    );
  }

  // Get progress value normalized between two scroll positions
  double getProgressBetween(double start, double end) {
    if (end <= start) return 0.0;
    return ((_scrollPosition - start) / (end - start)).clamp(0.0, 1.0);
  }

  // Get parallax offset based on scroll position
  double getParallaxOffset(double start, double end, double magnitude) {
    final progress = getProgressBetween(start, end);
    return progress * magnitude;
  }
}
