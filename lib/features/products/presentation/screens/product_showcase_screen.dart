import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/sawa_app_bar.dart';
import '../../../../data/sample_products.dart';
import '../../../../models/product.dart';

class ProductShowcaseScreen extends StatefulWidget {
  const ProductShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<ProductShowcaseScreen> createState() => _ProductShowcaseScreenState();
}

class _ProductShowcaseScreenState extends State<ProductShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;
    final isTablet = screenWidth < design.Breakpoints.tablet && !isMobile;

    // Determine number of grid columns based on screen size
    final crossAxisCount = isMobile
        ? 1
        : isTablet
            ? 2
            : 3;

    return Scaffold(
      appBar: const SawaAppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      isMobile ? design.Spacing.xl : design.Spacing.xxxl,
                  vertical: design.Spacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose from a',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      'best-selling basic',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(height: design.Spacing.lg),
                    Text(
                      'Select a product to start your custom design journey',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),

              // Products grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isMobile ? design.Spacing.lg : design.Spacing.xxl,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: design.Spacing.xl,
                      mainAxisSpacing: design.Spacing.xl,
                    ),
                    itemCount: kSampleProducts.length,
                    itemBuilder: (context, index) {
                      final product = kSampleProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _controller.reverse();
        });
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(design.Borders.md),
                boxShadow:
                    _isHovered ? design.Shadows.medium : design.Shadows.subtle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with overlay buttons on hover
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Product image
                        Hero(
                          tag: 'product-${widget.product.id}',
                          child: Image.asset(
                            widget.product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey[400],
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Darkening overlay on hover
                        AnimatedOpacity(
                          opacity: _isHovered ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),

                        // Action buttons on hover
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(design.Spacing.md),
                            child: Column(
                              children: [
                                // See Product Details button
                                Opacity(
                                  opacity: _opacityAnimation.value,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.go(AppRoutes.productDetail
                                          .replaceFirst(
                                              ':id', widget.product.id));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      minimumSize: const Size.fromHeight(44),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            design.Borders.sm),
                                      ),
                                    ),
                                    child: const Text('See Product Details'),
                                  ),
                                ),
                                SizedBox(height: design.Spacing.sm),
                                // Customize button
                                Opacity(
                                  opacity: _opacityAnimation.value,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.go(
                                          '${AppRoutes.customize}?productId=${widget.product.id}');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.white),
                                      minimumSize: const Size.fromHeight(44),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            design.Borders.sm),
                                      ),
                                    ),
                                    child: const Text('Customize'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product info
                  Padding(
                    padding: const EdgeInsets.all(design.Spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'from €${widget.product.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
