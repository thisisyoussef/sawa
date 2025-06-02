import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/sawa_app_bar.dart';
import '../../../../data/sample_products.dart';
import '../../../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find the product by ID
    final product = kSampleProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => kSampleProducts.first, // Fallback if not found
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;
    final isTablet = screenWidth < design.Breakpoints.tablet && !isMobile;

    return Scaffold(
      appBar: const SawaAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content area with split view on desktop
            if (isMobile || isTablet)
              // Mobile/tablet layout - stacked
              _buildMobileLayout(context, product)
            else
              // Desktop layout - side by side
              _buildDesktopLayout(context, product),

            // Related products section
            _buildRelatedProducts(context, product),

            // Bottom spacing
            SizedBox(height: design.Spacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image hero
        Hero(
          tag: 'product-${product.id}',
          child: Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Image.asset(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                );
              },
            ),
          ),
        ),

        // Product information
        Padding(
          padding: EdgeInsets.all(design.Spacing.xl),
          child: _buildProductInfo(context, product),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Product product) {
    return Padding(
      padding: EdgeInsets.all(design.Spacing.xxl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image - 50% width
          Expanded(
            flex: 1,
            child: Hero(
              tag: 'product-${product.id}',
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(design.Borders.md),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(design.Borders.md),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: design.Spacing.xxl),

          // Product info - 50% width
          Expanded(
            flex: 1,
            child: _buildProductInfo(context, product),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          product.name,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: design.Spacing.md),

        // Price with badge
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.Spacing.md,
                vertical: design.Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(design.Borders.sm),
              ),
              child: Text(
                '€${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(width: design.Spacing.md),

            // Minimum order info
            Text(
              'Minimum order: 50 units',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        SizedBox(height: design.Spacing.lg),

        // Divider
        Divider(color: Colors.grey[300]),
        SizedBox(height: design.Spacing.md),

        // Product metadata in a grid
        Wrap(
          spacing: design.Spacing.xl,
          runSpacing: design.Spacing.md,
          children: [
            if (product.material != null)
              _buildSpecItem(
                context,
                title: 'Material',
                value: product.material!,
                icon: Icons.style,
              ),
            if (product.weight != null)
              _buildSpecItem(
                context,
                title: 'Weight',
                value: product.weight!,
                icon: Icons.scale,
              ),
            _buildSpecItem(
              context,
              title: 'Production Time',
              value: '2-3 weeks',
              icon: Icons.schedule,
            ),
            _buildSpecItem(
              context,
              title: 'MOQ',
              value: '50 units',
              icon: Icons.inventory_2,
            ),
          ],
        ),

        SizedBox(height: design.Spacing.lg),
        Divider(color: Colors.grey[300]),
        SizedBox(height: design.Spacing.lg),

        // Description heading
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: design.Spacing.md),

        // Description
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Colors.grey[800],
              ),
        ),
        SizedBox(height: design.Spacing.lg),

        // Additional information
        Text(
          'Our ${product.name.toLowerCase()} are produced using sustainable manufacturing processes and premium materials. Perfect for businesses, teams, organizations, or events looking for high-quality custom apparel.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Colors.grey[800],
              ),
        ),
        SizedBox(height: design.Spacing.xl),

        // Customization options
        Container(
          padding: EdgeInsets.all(design.Spacing.lg),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(design.Borders.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customization Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: design.Spacing.md),

              // Customization bullets
              _buildBulletPoint(context, 'Screen printing (up to 6 colors)'),
              _buildBulletPoint(context, 'Embroidery (up to 12 colors)'),
              _buildBulletPoint(context, 'DTG printing for complex designs'),
              _buildBulletPoint(context, 'Custom labels and packaging'),
              _buildBulletPoint(context, 'Multiple color options available'),
            ],
          ),
        ),
        SizedBox(height: design.Spacing.xl),

        // Tags
        if (product.tags.isNotEmpty) ...[
          Text(
            'Tags',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: design.Spacing.sm),
          Wrap(
            spacing: design.Spacing.sm,
            runSpacing: design.Spacing.sm,
            children: product.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(design.Borders.sm),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: design.Spacing.xl),
        ],

        // Call to action buttons
        Row(
          children: [
            // Customize button
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .go('${AppRoutes.customize}?productId=${product.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Customize Now',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: design.Spacing.md),

            // Request samples button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sample request form would open here'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                minimumSize: Size(48, 56),
              ),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[700],
        ),
        SizedBox(width: design.Spacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.Spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: design.Spacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context, Product currentProduct) {
    // Get products excluding the current one
    final relatedProducts = kSampleProducts
        .where((p) => p.id != currentProduct.id)
        .take(3) // Limit to 3 related products
        .toList();

    if (relatedProducts.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Padding(
      padding: EdgeInsets.all(
        isMobile ? design.Spacing.xl : design.Spacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          Text(
            'You May Also Like',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: design.Spacing.xl),

          // Related products grid/row
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: design.Spacing.lg,
              mainAxisSpacing: design.Spacing.lg,
            ),
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return _buildRelatedProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.productDetail.replaceFirst(':id', product.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(design.Borders.md),
                boxShadow: design.Shadows.subtle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: design.Spacing.md),

          // Product info
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'from €${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }
}
