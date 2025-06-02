import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/theme/animation_extensions.dart';
import '../../../../core/constants/app_routes.dart';

class FeaturesBenefitsSection extends StatefulWidget {
  const FeaturesBenefitsSection({Key? key}) : super(key: key);

  @override
  State<FeaturesBenefitsSection> createState() => _FeaturesBenefitsState();
}

class _FeaturesBenefitsState extends State<FeaturesBenefitsSection>
    with SingleTickerProviderStateMixin {
  int _activeFeatureIndex = 0;
  late AnimationController _imageTransitionController;
  bool _isImageLoading = false;

  // Pre-loaded images to avoid loading delays
  List<Image?> _preloadedImages = [];
  List<bool> _imagesLoaded = [];

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Affordable Quality',
      'description':
          'Get premium custom apparel at competitive prices. We keep costs down without compromising on quality, so you get the best value for your budget.',
      'image':
          'https://images.unsplash.com/photo-1529697216570-d0e57a6b2a45?q=80&w=2340&auto=format&fit=crop',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Low Minimums',
      'description':
          'Order just what you need—no huge minimums, no waste. Perfect for small businesses, teams, and projects that need quality custom apparel without ordering excess inventory.',
      'image':
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=2340&auto=format&fit=crop',
      'icon': Icons.verified,
    },
    {
      'title': 'Fully Customizable',
      'description':
          'Choose your colors, add your logo, and make it truly yours. Our customization options let you create apparel that perfectly represents your unique identity and brand.',
      'image':
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?q=80&w=1972&auto=format&fit=crop',
      'icon': Icons.palette,
    },
    {
      'title': 'High Quality Materials',
      'description':
          'Durable, comfortable, and made to last. We use premium materials that stand up to repeated washing and wearing, ensuring your custom apparel maintains its quality over time.',
      'image':
          'https://images.unsplash.com/photo-1545458074-7f59b2b8d15e?q=80&w=2340&auto=format&fit=crop',
      'icon': Icons.star,
    },
  ];

  @override
  void initState() {
    super.initState();
    _imageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize _imagesLoaded list with false values
    _imagesLoaded = List.generate(_features.length, (_) => false);

    // Initialize _preloadedImages with null values
    _preloadedImages = List.generate(_features.length, (_) => null);

    // Preload images to avoid loading spinner issues
    _preloadImages();
  }

  void _preloadImages() {
    for (var i = 0; i < _features.length; i++) {
      final feature = _features[i];

      if (feature['image'] == null) {
        _imagesLoaded[i] = true; // Mark as "loaded" to avoid waiting
        continue;
      }

      try {
        final image = Image.network(
          feature['image'],
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null) {
              // Image has been loaded successfully
              _imagesLoaded[i] = true;
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            // Mark as "loaded" on error to avoid waiting
            _imagesLoaded[i] = true;
            return _buildErrorPlaceholder(feature);
          },
        );

        _preloadedImages[i] = image;

        // Trigger image load
        precacheImage(image.image, context).then((_) {
          if (mounted) {
            setState(() {
              _imagesLoaded[i] = true;
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _imagesLoaded[i] = true; // Mark as loaded even on error
            });
          }
        });
      } catch (e) {
        // Handle any exceptions during image creation
        _imagesLoaded[i] = true;
      }
    }
  }

  @override
  void dispose() {
    _imageTransitionController.dispose();
    super.dispose();
  }

  void _setActiveFeature(int index) {
    if (index < 0 || index >= _features.length || _activeFeatureIndex == index)
      return;

    setState(() {
      _isImageLoading = !_imagesLoaded[index];
      _activeFeatureIndex = index;
    });

    _imageTransitionController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main heading
          Container(
            width: isMobile ? double.infinity : screenWidth * 0.6,
            margin: EdgeInsets.only(bottom: design.Spacing.xl),
            child: AnimatedReveal(
              type: RevealType.fade,
              direction: RevealDirection.fromBottom,
              child: Text(
                'Everything You Need—All in One Place',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      height: 1.1,
                    ),
              ),
            ),
          ),

          // Features and image container - using SizedBox with fixed height instead of ConstrainedBox
          SizedBox(
            height: 600, // Fixed height to ensure it fits
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Feature list - scrollable for mobile
                      Expanded(
                        child: _buildFeaturesList(context),
                      ),
                      SizedBox(height: design.Spacing.xl),
                      // Image - reduced height for mobile
                      SizedBox(
                        height: 300,
                        child: _buildFeatureImage(context),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Feature list
                      Expanded(
                        flex: 1,
                        child: _buildFeaturesList(context),
                      ),
                      SizedBox(width: design.Spacing.xl),
                      // Feature image
                      Expanded(
                        flex: 1,
                        child: _buildFeatureImage(context),
                      ),
                    ],
                  ),
          ),

          // CTA link
          SizedBox(height: design.Spacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 500),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.go(AppRoutes.productShowcase);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.Spacing.lg,
                    vertical: design.Spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(design.Borders.md),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Designing Now',
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
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_features.length, (index) {
          final isActive = _activeFeatureIndex == index;
          return AnimatedReveal(
            delay: Duration(milliseconds: 100 * index),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _setActiveFeature(index),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: AnimationCurves.fabric,
                      margin: EdgeInsets.only(bottom: design.Spacing.md),
                      padding: EdgeInsets.symmetric(
                        horizontal: design.Spacing.lg,
                        vertical: design.Spacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(design.Borders.md),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _features[index]['icon'] as IconData? ??
                                Icons.image,
                            color: isActive ? Colors.white : Colors.black,
                            size: 20,
                          ),
                          SizedBox(width: design.Spacing.md),
                          Expanded(
                            child: Text(
                              _features[index]['title'] as String? ?? 'Feature',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isActive ? Colors.white : Colors.black,
                                  ),
                            ),
                          ),
                          Icon(
                            isActive
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: isActive
                                ? Colors.white
                                : Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Description with animated height
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: AnimationCurves.fabric,
                  height: isActive ? null : 0,
                  margin: EdgeInsets.only(
                    left: design.Spacing.xl,
                    bottom: isActive ? design.Spacing.lg : 0,
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isActive ? 1.0 : 0.0,
                    child: isActive
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: design.Spacing.lg,
                              top: design.Spacing.sm,
                              bottom: design.Spacing.md,
                            ),
                            child: Text(
                              _features[index]['description'] as String? ??
                                  'No description available',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.8),
                                    height: 1.5,
                                  ),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeatureImage(BuildContext context) {
    if (_activeFeatureIndex < 0 || _activeFeatureIndex >= _features.length) {
      return Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(design.Borders.lg),
        ),
        child: Center(
          child: Text('No feature selected'),
        ),
      );
    }

    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(design.Borders.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.Borders.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Display the preloaded image directly
            Opacity(
              opacity: _isImageLoading ? 0.3 : 1.0,
              child: (_activeFeatureIndex < _preloadedImages.length &&
                      _preloadedImages[_activeFeatureIndex] != null)
                  ? _preloadedImages[_activeFeatureIndex]!
                  : _buildErrorPlaceholder(_features[_activeFeatureIndex]),
            ),

            // Overlay with feature title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(design.Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Feature badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.Spacing.md,
                        vertical: design.Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(design.Borders.sm),
                      ),
                      child: Text(
                        _features[_activeFeatureIndex]['title'] as String? ??
                            'Feature',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading indicator
            if (_isImageLoading)
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(Map<String, dynamic> feature) {
    final icon = feature['icon'] as IconData? ?? Icons.error_outline;

    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
