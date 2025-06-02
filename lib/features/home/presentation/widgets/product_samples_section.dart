import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/theme/animation_extensions.dart';
import 'dart:math' as math;
import 'dart:async';

class ProductSamplesSection extends StatefulWidget {
  const ProductSamplesSection({Key? key}) : super(key: key);

  @override
  State<ProductSamplesSection> createState() => _ProductSamplesSectionState();
}

class _ProductSamplesSectionState extends State<ProductSamplesSection>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  int _currentPage = 0;
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final AnimationController _autoScrollController;
  Timer? _autoScrollTimer;

  // Store MediaQuery values to prevent accessing during disposal
  double _screenWidth = 0;
  bool _isMobile = false;

  // Hover state
  int? _hoveredProductIndex;

  // Track if user is manually scrolling
  bool _isUserScrolling = false;

  // Product data - 9 total products
  final List<Map<String, String>> _products = [
    {
      'name': 'Tote Bags',
      'price': '13.85€',
      'image':
          'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?q=80&w=1974&auto=format&fit=crop',
      'description':
          'Versatile tote bags that make great promotional items or merchandise.',
      'material': '100% Organic Cotton',
      'weight': '280 g/m²',
    },
    {
      'name': 'Hoodies',
      'price': '28.60€',
      'image':
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?q=80&w=1972&auto=format&fit=crop',
      'description':
          'Premium quality hoodies with multiple customization options.',
      'material': '85% Cotton, 15% Polyester',
      'weight': '500 g/m²',
    },
    {
      'name': 'T-Shirts',
      'price': '9.95€',
      'image':
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?q=80&w=1664&auto=format&fit=crop',
      'description': 'Classic fit t-shirts made from soft, durable fabric.',
      'material': '100% Combed Cotton',
      'weight': '200 g/m²',
    },
    {
      'name': 'Sweatshirts',
      'price': '24.95€',
      'image':
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=2340&auto=format&fit=crop',
      'description': 'Comfortable sweatshirts perfect for any season.',
      'material': '80% Cotton, 20% Polyester',
      'weight': '330 g/m²',
    },
    {
      'name': 'Caps',
      'price': '14.50€',
      'image':
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=2036&auto=format&fit=crop',
      'description':
          'Stylish caps with embroidery options for your logo or design.',
      'material': 'Twill Cotton',
      'weight': '180 g/m²',
    },
    {
      'name': 'Canvas Totes',
      'price': '18.95€',
      'image':
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=1935&auto=format&fit=crop',
      'description':
          'Heavy-duty canvas totes that are both practical and stylish.',
      'material': 'Canvas Cotton',
      'weight': '380 g/m²',
    },
    {
      'name': 'Premium Hoodies',
      'price': '32.95€',
      'image':
          'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?q=80&w=1974&auto=format&fit=crop',
      'description': 'High-end zip hoodies made from premium materials.',
      'material': '70% Cotton, 30% Polyester',
      'weight': '400 g/m²',
    },
    {
      'name': 'Beanies',
      'price': '11.95€',
      'image':
          'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?q=80&w=1887&auto=format&fit=crop',
      'description':
          'Cozy beanies that can be customized with your unique design.',
      'material': 'Acrylic Wool Blend',
      'weight': '120 g/m²',
    },
    {
      'name': 'Long Sleeves',
      'price': '16.95€',
      'image':
          'https://images.unsplash.com/photo-1618517351616-38fb9c5210c6?q=80&w=2787&auto=format&fit=crop',
      'description': 'Comfortable long sleeve t-shirts for cooler weather.',
      'material': '100% Ring-Spun Cotton',
      'weight': '220 g/m²',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _autoScrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Listen to scroll changes
    _scrollController.addListener(_handleScroll);

    // Setup auto-scroll
    _setupAutoScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store MediaQuery values safely
    _screenWidth = MediaQuery.of(context).size.width;
    _isMobile = _screenWidth < design.Breakpoints.mobile;
  }

  void _setupAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUserScrolling && mounted) {
        _goToNextPage();
      }
    });
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      // Calculate current page based on scroll position
      final productCardWidth =
          400.0 + design.Spacing.xl * 2; // Card width + margin

      if (productCardWidth > 0) {
        final newPage = (_scrollController.offset / productCardWidth).round();
        if (newPage != _currentPage &&
            newPage >= 0 &&
            newPage < _products.length) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    }
  }

  void _goToNextPage() {
    if (_currentPage < _products.length - 1) {
      _scrollToPage(_currentPage + 1);
    } else {
      _scrollToPage(0); // Loop back to beginning
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _scrollToPage(_currentPage - 1);
    } else {
      _scrollToPage(_products.length - 1); // Loop to end
    }
  }

  void _scrollToPage(int page) {
    if (_scrollController.hasClients) {
      // Use stored values instead of direct MediaQuery access
      if (_isMobile) {
        setState(() => _currentPage = page);
      } else {
        final productCardWidth =
            400.0 + design.Spacing.xl * 2; // Card width + margin
        final targetOffset = page * productCardWidth;

        _fadeController.forward(from: 0.0);

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: AnimationCurves.fabric,
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _autoScrollController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update the stored values whenever the widget is built
    _screenWidth = MediaQuery.of(context).size.width;
    _isMobile = _screenWidth < design.Breakpoints.mobile;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: design.Spacing.xxxl,
        bottom: design.Spacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title and heading
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile ? design.Spacing.lg : design.Spacing.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Small section title
                AnimatedReveal(
                  type: RevealType.fade,
                  direction: RevealDirection.fromBottom,
                  child: Text(
                    'See What\'s Possible',
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
                Container(
                  margin: EdgeInsets.only(
                    top: design.Spacing.md,
                    bottom: design.Spacing.xl,
                  ),
                  child: AnimatedReveal(
                    delay: const Duration(milliseconds: 100),
                    type: RevealType.fade,
                    direction: RevealDirection.fromBottom,
                    child: Text(
                      'Custom Apparel Options',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                                height: 1.1,
                              ),
                    ),
                  ),
                ),

                // Subtitle
                AnimatedReveal(
                  delay: const Duration(milliseconds: 200),
                  type: RevealType.fade,
                  direction: RevealDirection.fromBottom,
                  child: Text(
                    'Quality products for your brand, team, or personal project.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                  ),
                ),

                // Description
                SizedBox(height: design.Spacing.md),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 200),
                  type: RevealType.fade,
                  direction: RevealDirection.fromBottom,
                  child: Container(
                    width: _isMobile ? double.infinity : _screenWidth * 0.5,
                    child: Text(
                      'Materialize your brand vision with the highest quality customizable blanks in the industry. Order a sample before you buy and test it for yourself!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: design.Spacing.xl),

          // Carousel status indicator
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile ? design.Spacing.lg : design.Spacing.xxxl,
            ),
            child: AnimatedReveal(
              delay: const Duration(milliseconds: 250),
              type: RevealType.fade,
              child: Row(
                children: [
                  ...List.generate(_products.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: design.Spacing.md),

          // Buttons row with navigation arrows
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile ? design.Spacing.lg : design.Spacing.xxxl,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CTA buttons
                AnimatedReveal(
                  delay: const Duration(milliseconds: 300),
                  direction: RevealDirection.fromLeft,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.productShowcase),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: design.Spacing.xl,
                            vertical: design.Spacing.md,
                          ),
                        ),
                        child: const Text('Start Designing'),
                      ),
                      SizedBox(width: design.Spacing.lg),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Text('Request Samples'),
                        label: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation arrows
                AnimatedReveal(
                  delay: const Duration(milliseconds: 300),
                  direction: RevealDirection.fromRight,
                  child: Row(
                    children: [
                      _buildNavButton(
                        icon: Icons.arrow_back,
                        onPressed: () => _goToPreviousPage(),
                      ),
                      SizedBox(width: design.Spacing.md),
                      _buildNavButton(
                        icon: Icons.arrow_forward,
                        onPressed: () => _goToNextPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: design.Spacing.xxl),

          // Product cards grid or carousel
          AnimatedReveal(
            delay: const Duration(milliseconds: 400),
            type: RevealType.fade,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _isMobile ? design.Spacing.lg : design.Spacing.xxxl,
              ),
              child: Container(
                height: 500,
                child: MouseRegion(
                  onEnter: (_) => _isUserScrolling = true,
                  onExit: (_) => _isUserScrolling = false,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        _isUserScrolling = true;
                      } else if (notification is ScrollEndNotification) {
                        _isUserScrolling = false;
                      }
                      return true;
                    },
                    child: _buildProductGrid(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    // Use stored values instead of direct MediaQuery access
    if (_isMobile) {
      // For mobile, show the current product in the carousel
      return PageView.builder(
        controller: PageController(initialPage: _currentPage),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(
            context,
            _products[index],
            index,
          );
        },
      );
    } else {
      // For desktop, use horizontal scrolling for products
      return AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - (_fadeController.value * 0.3),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 400,
                  margin: EdgeInsets.only(
                    right: index != _products.length - 1
                        ? design.Spacing.xl * 2
                        : 0,
                  ),
                  child: _buildProductCard(
                    context,
                    _products[index],
                    index,
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, String> product,
    int productIndex,
  ) {
    final isActive = _currentPage == productIndex;
    final isHovered = _hoveredProductIndex == productIndex;

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 500),
      curve: AnimationCurves.fabric,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredProductIndex = productIndex),
        onExit: (_) => setState(() => _hoveredProductIndex = null),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name and price header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['name']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    'from ${product['price']!}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              SizedBox(height: design.Spacing.md),

              // Product card with image and details
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main card
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: AnimationCurves.fabric,
                      transform: Matrix4.identity()
                        ..translate(isHovered ? 0.0 : 0.0,
                            isHovered ? -10.0 : 0.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(design.Borders.lg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(isHovered ? 0.15 : 0.08),
                            blurRadius: isHovered ? 30 : 15,
                            offset: Offset(0, isHovered ? 15 : 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(design.Borders.lg),
                        child: Stack(
                          children: [
                            // Product image with parallax
                            Positioned.fill(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                curve: AnimationCurves.fabric,
                                transform: Matrix4.identity()
                                  ..translate(
                                    0.0,
                                    isHovered ? -15.0 : 0.0,
                                    0.0,
                                  )
                                  ..scale(isHovered ? 1.05 : 1.0),
                                child: Hero(
                                  tag: 'product_${product['name']}',
                                  child: Image.network(
                                    product['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.grey.shade400,
                                            size: 48,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Gradient overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 220,
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
                              ),
                            ),

                            // Product details overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.all(design.Spacing.lg),
                                transform: Matrix4.identity()
                                  ..translate(
                                    0.0,
                                    isHovered ? -8.0 : 0.0,
                                    0.0,
                                  ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product specs
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: design.Spacing.md,
                                            vertical: design.Spacing.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(
                                                design.Borders.sm),
                                          ),
                                          child: Text(
                                            product['material']!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: design.Spacing.md),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: design.Spacing.md,
                                            vertical: design.Spacing.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(
                                                design.Borders.sm),
                                          ),
                                          child: Text(
                                            product['weight']!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: design.Spacing.lg),

                                    // Product description
                                    Text(
                                      product['description']!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),

                                    SizedBox(height: design.Spacing.xl),

                                    // "Order Sample" button that appears on hover
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: isHovered ? 1.0 : 0.0,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: AnimationCurves.fabric,
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0, (1.0 - value) * 20),
                                          child: Opacity(
                                            opacity: value,
                                            child: Container(
                                              width: double.infinity,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        design.Borders.md),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Order Sample',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // "New" badge for some products
                    if (productIndex == 3 || productIndex == 7)
                      Positioned(
                        top: -10,
                        right: 20,
                        child: AnimatedScale(
                          scale: isHovered ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.Spacing.md,
                              vertical: design.Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.circular(design.Borders.md),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
