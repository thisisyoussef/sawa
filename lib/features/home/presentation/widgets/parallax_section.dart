import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;

class ParallaxSection extends StatefulWidget {
  const ParallaxSection({Key? key}) : super(key: key);

  @override
  State<ParallaxSection> createState() => _ParallaxSectionState();
}

class _ParallaxSectionState extends State<ParallaxSection> {
  double _opacity = 1.0;
  double _scale = 1.0;

  // Handle scroll notification from the parent
  bool handleScrollNotification(ScrollNotification notification) {
    // Get the position of this widget within the scrollable area
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) {
      return false;
    }

    final RenderBox renderBox = renderObject as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // Calculate how far this widget has been scrolled past the top of the screen
    final scrollOffset = -position.dy;

    // Start fade out when widget is at top of screen
    final opacity = 1.0 - (scrollOffset / 400).clamp(0.0, 1.0);

    // Scale image as scrolling occurs (from 1.0 to 1.3)
    final scale = 1.0 + (scrollOffset / 1000).clamp(0.0, 0.3);

    if (opacity != _opacity || scale != _scale) {
      setState(() {
        _opacity = opacity;
        _scale = scale;
      });
    }

    // Continue to let the notification bubble up
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return NotificationListener<ScrollNotification>(
      onNotification: handleScrollNotification,
      child: SizedBox(
        height: 800,
        child: Stack(
          children: [
            // Image that scales on scroll
            Positioned.fill(
              child: AnimatedScale(
                scale: _scale,
                duration: design.Durations.short,
                child: Image.asset(
                  'assets/images/clothing_factory.jpg',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),

            // Content overlay with fade effect
            AnimatedOpacity(
              opacity: _opacity,
              duration: design.Durations.short,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      isMobile ? design.Spacing.xl : design.Spacing.xxxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clothing made from scratch',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                    ),
                    SizedBox(height: design.Spacing.md),
                    SizedBox(
                      width: isMobile ? double.infinity : screenWidth * 0.5,
                      child: Text(
                        'Every stitch, every fabric, every detail matters to us. Scroll to see our process.',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                    SizedBox(height: design.Spacing.xl),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom stats section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(design.Spacing.xl),
                margin: EdgeInsets.all(
                    isMobile ? design.Spacing.lg : design.Spacing.xxxl),
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our craftsmanship',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                    ),
                    SizedBox(height: design.Spacing.md),
                    Text(
                      'We combine traditional techniques with modern technology to create garments that stand the test of time.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    SizedBox(height: design.Spacing.lg),
                    Row(
                      children: [
                        _buildStatistic(
                            context, '500+', 'Garments produced monthly'),
                        SizedBox(width: design.Spacing.xxl),
                        _buildStatistic(
                            context, '98%', 'On-time delivery rate'),
                        SizedBox(width: design.Spacing.xxl),
                        _buildStatistic(context, '100%', 'Quality checked'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(BuildContext context, String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: design.Spacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
      ],
    );
  }
}
