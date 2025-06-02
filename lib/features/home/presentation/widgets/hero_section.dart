import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < Breakpoints.mobile;

    return Container(
      height: isMobile ? 600 : 700,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/hero_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xBF000000), // Semi-transparent black overlay
            BlendMode.darken,
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? Spacing.xl : Spacing.xxxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(Borders.lg),
                          ),
                          child: Text(
                            '✨ Premium Quality • Ethical Manufacturing',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Spacing.lg),

                    // Headline
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SizedBox(
                          width:
                              isMobile ? double.infinity : screenWidth * 0.55,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sawa Threads',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        height: 1.1,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                TextSpan(
                                  text: '\nQuality Custom Apparel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.2,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Spacing.xl),

                    // Subheading
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SizedBox(
                          width: isMobile ? double.infinity : screenWidth * 0.5,
                          child: Text(
                            'For teams, clubs, businesses, and brands of all sizes. Affordable, high-quality, and uniquely yours.',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Spacing.xxl),

                    // Call to action buttons with a slight delay in their animation
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.5), end: Offset.zero)
                            .animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve:
                                const Interval(0.3, 1.0, curve: Curves.easeOut),
                          ),
                        ),
                        child: isMobile
                            // Mobile layout - stacked buttons
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPrimaryButton(context),
                                  SizedBox(height: Spacing.lg),
                                  _buildSecondaryButton(context),
                                ],
                              )
                            // Desktop layout - side by side buttons
                            : Row(
                                children: [
                                  _buildPrimaryButton(context),
                                  SizedBox(width: Spacing.xl),
                                  _buildSecondaryButton(context),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // Animated diagonal across the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                  ),
                  child: ClipPath(
                    clipper: DiagonalClipper(),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go(AppRoutes.productShowcase),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xl,
          vertical: Spacing.md,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Borders.md),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Start Designing',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: Spacing.sm),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.white, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xl,
          vertical: Spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Borders.md),
        ),
      ),
      onPressed: () => context.go(AppRoutes.products),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Get Free Samples',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: Spacing.sm),
          Icon(Icons.local_shipping_outlined, size: 16, color: Colors.white),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.7, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
