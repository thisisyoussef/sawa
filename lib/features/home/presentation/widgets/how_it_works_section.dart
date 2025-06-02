import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/theme/animation_extensions.dart';
import 'dart:math' as math;
import 'dart:async';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({Key? key}) : super(key: key);

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with SingleTickerProviderStateMixin {
  int _activeStep = 1;
  late AnimationController _floatController;
  Timer? _autoStepTimer;
  bool _userInteracting = false;

  // Detailed info for each step
  final List<Map<String, dynamic>> _stepsInfo = [
    {
      'title': 'Design',
      'description': 'Create the perfect look for your brand or team.',
      'longDescription':
          'Use our simple online studio or work with our team to create your perfect custom apparel. We\'ll guide you through every step, from logo placement to color selection, ensuring your design perfectly captures your unique identity.',
      'image':
          'https://images.unsplash.com/photo-1618517351616-38fb9c5210c6?q=80&w=2787&auto=format&fit=crop',
      'icon': Icons.design_services,
    },
    {
      'title': 'Sample',
      'description': 'Try before you commit to full production.',
      'longDescription':
          'Order samples to test the quality, fit, and feel before placing your full order. Our sample program lets you verify every detail, so you can be confident in your final product before committing to production.',
      'image':
          'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?q=80&w=2671&auto=format&fit=crop',
      'icon': Icons.inventory,
    },
    {
      'title': 'Production',
      'description':
          'Our experts handle the printing, embroidery, and finishing touches.',
      'longDescription':
          'Sit back while our experienced team brings your vision to life. We use high-quality materials and premium printing techniques to create custom apparel that you\'ll be proud to wear or sell, with careful attention to every detail.',
      'image':
          'https://images.unsplash.com/photo-1523381294911-8d3cead13475?q=80&w=2670&auto=format&fit=crop',
      'icon': Icons.construction,
    },
    {
      'title': 'Delivery',
      'description':
          'Fast, reliable shipping—so you\'re ready for your next event or launch.',
      'longDescription':
          'Your order arrives neatly packaged and ready to distribute. Track delivery in real-time through our portal and receive notifications when your apparel is on its way. Most orders arrive within 7-10 business days.',
      'image':
          'https://images.unsplash.com/photo-1606293459339-117215380bdf?q=80&w=2670&auto=format&fit=crop',
      'icon': Icons.local_shipping,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Setup floating animation for the shirt
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Start auto-cycling through steps
    _startAutoStepping();
  }

  void _startAutoStepping() {
    _autoStepTimer?.cancel();
    _autoStepTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_userInteracting && mounted) {
        setState(() {
          _activeStep = _activeStep < 4 ? _activeStep + 1 : 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _autoStepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          AnimatedReveal(
            type: RevealType.fade,
            direction: RevealDirection.fromLeft,
            child: Text(
              'How It Works',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
            ),
          ),

          // Main heading
          AnimatedReveal(
            delay: const Duration(milliseconds: 100),
            type: RevealType.fade,
            direction: RevealDirection.fromLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: design.Spacing.md),
              child: Text(
                'Getting Custom Apparel',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      height: 1.1,
                    ),
              ),
            ),
          ),

          AnimatedReveal(
            delay: const Duration(milliseconds: 200),
            type: RevealType.fade,
            direction: RevealDirection.fromLeft,
            child: Text(
              'for Your Community is Easy',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    height: 1.1,
                  ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          // CTA link
          AnimatedReveal(
            delay: const Duration(milliseconds: 300),
            type: RevealType.fade,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.go(AppRoutes.products);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(design.Borders.md),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Your Community Order',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      SizedBox(width: design.Spacing.xs),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: design.Spacing.xxl),

          // Process steps
          AnimatedReveal(
            delay: const Duration(milliseconds: 400),
            type: RevealType.fade,
            child: MouseRegion(
              onEnter: (_) => _userInteracting = true,
              onExit: (_) => _userInteracting = false,
              child: !isMobile
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 4; i++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeStep = i + 1),
                              child: MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _activeStep = i + 1),
                                child: _buildInteractiveStep(
                                  context,
                                  number: '${i + 1}',
                                  title: _stepsInfo[i]['title'],
                                  description: _stepsInfo[i]['description'],
                                  isActive: _activeStep == i + 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < 4; i++)
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _activeStep = i + 1),
                                child: _buildInteractiveStep(
                                  context,
                                  number: '${i + 1}',
                                  title: _stepsInfo[i]['title'],
                                  description: _stepsInfo[i]['description'],
                                  isActive: _activeStep == i + 1,
                                ),
                              ),
                              if (i < 3) SizedBox(height: design.Spacing.xl),
                            ],
                          ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: design.Spacing.xxl),

          // Selected step details
          AnimatedReveal(
            delay: const Duration(milliseconds: 500),
            type: RevealType.scale,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(design.Spacing.xl),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(design.Borders.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step detail header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          _stepsInfo[_activeStep - 1]['icon'],
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: design.Spacing.md),
                      Text(
                        _stepsInfo[_activeStep - 1]['title'],
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),

                  SizedBox(height: design.Spacing.xl),

                  // Step detail content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: AnimationCurves.fabric,
                    switchOutCurve: AnimationCurves.fabric,
                    child: Container(
                      key: ValueKey<int>(_activeStep),
                      child: !isMobile
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step image
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        design.Borders.md),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: AnimatedBuilder(
                                        animation: _floatController,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              0,
                                              math.sin(_floatController.value *
                                                      math.pi *
                                                      2) *
                                                  5,
                                            ),
                                            child: child,
                                          );
                                        },
                                        child: Image.network(
                                          _stepsInfo[_activeStep - 1]['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade300,
                                              child: Center(
                                                child: Icon(
                                                  _stepsInfo[_activeStep - 1]
                                                      ['icon'],
                                                  color: Colors.white,
                                                  size: 48,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: design.Spacing.xl),

                                // Step detailed information
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _stepsInfo[_activeStep - 1]
                                            ['longDescription'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              height: 1.7,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.8),
                                            ),
                                      ),
                                      SizedBox(height: design.Spacing.xl),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Mobile view - image first
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(design.Borders.md),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      _stepsInfo[_activeStep - 1]['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade300,
                                          child: Center(
                                            child: Icon(
                                              _stepsInfo[_activeStep - 1]
                                                  ['icon'],
                                              color: Colors.white,
                                              size: 48,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: design.Spacing.lg),

                                // Mobile view - description
                                Text(
                                  _stepsInfo[_activeStep - 1]
                                      ['longDescription'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        height: 1.7,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStep(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
    required bool isActive,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: AnimationCurves.fabric,
      padding: EdgeInsets.all(design.Spacing.md),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(design.Borders.md),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number and title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                ),
              ),
              SizedBox(width: design.Spacing.md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),

          // Divider
          Container(
            width: isMobile ? double.infinity : screenWidth * 0.15,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: design.Spacing.md),
            color: isActive
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.grey.shade300,
          ),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.Spacing.xl,
            vertical: design.Spacing.md,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(design.Borders.md),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
