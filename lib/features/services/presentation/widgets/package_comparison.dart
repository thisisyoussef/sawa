import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';

class PackageComparison extends StatefulWidget {
  final bool isMobile;

  const PackageComparison({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<PackageComparison> createState() => _PackageComparisonState();
}

class _PackageComparisonState extends State<PackageComparison> {
  int _selectedPackage = 1; // Default to Standard package

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'Basic',
      'subtitle': 'Perfect for small teams',
      'price': '€18.50',
      'originalPrice': null,
      'popular': false,
      'description': 'Essential custom apparel services for smaller orders',
      'features': [
        'Screen printing (up to 2 colors)',
        'Standard fabric options',
        'Basic packaging',
        '10-14 day turnaround',
        'Email support',
        'Minimum 50 pieces',
      ],
      'limitations': [
        'Limited color options',
        'No rush orders',
        'Standard shipping only',
      ],
      'color': const Color(0xFF6B7280),
      'buttonText': 'Get Quote',
    },
    {
      'name': 'Standard',
      'subtitle': 'Most popular choice',
      'price': '€24.95',
      'originalPrice': '€28.95',
      'popular': true,
      'description': 'Complete custom apparel solution with premium features',
      'features': [
        'Screen printing (up to 6 colors)',
        'DTG printing available',
        'Premium fabric selection',
        'Custom packaging options',
        '7-10 day turnaround',
        'Priority support',
        'Free design consultation',
        'Sample approval process',
        'Minimum 50 pieces',
      ],
      'limitations': [],
      'color': const Color(0xFF3B82F6),
      'buttonText': 'Start Project',
    },
    {
      'name': 'Premium',
      'subtitle': 'For high-volume orders',
      'price': '€19.95',
      'originalPrice': '€32.95',
      'popular': false,
      'description': 'Enterprise-level service with maximum customization',
      'features': [
        'All printing methods available',
        'Embroidery & patches included',
        'Premium & eco-friendly fabrics',
        'Branded packaging design',
        '5-7 day turnaround',
        'Dedicated account manager',
        'Unlimited design revisions',
        'On-site consultation available',
        'Volume discounts up to 30%',
        'Rush order options',
        'Minimum 250 pieces',
      ],
      'limitations': [],
      'color': const Color(0xFF10B981),
      'buttonText': 'Contact Sales',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Package toggle (for mobile)
        if (widget.isMobile) _buildMobilePackageSelector(),

        SizedBox(height: design.Spacing.xl),

        // Package cards
        widget.isMobile
            ? _buildMobilePackageView()
            : _buildDesktopPackageGrid(),
      ],
    );
  }

  Widget _buildMobilePackageSelector() {
    return Container(
      padding: EdgeInsets.all(design.Spacing.xs),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(design.Borders.md),
      ),
      child: Row(
        children: List.generate(_packages.length, (index) {
          final isSelected = index == _selectedPackage;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPackage = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  vertical: design.Spacing.sm,
                  horizontal: design.Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(design.Borders.sm),
                  boxShadow: isSelected ? design.Shadows.subtle : null,
                ),
                child: Text(
                  _packages[index]['name'],
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.black : Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMobilePackageView() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _buildPackageCard(_selectedPackage, true),
    );
  }

  Widget _buildDesktopPackageGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_packages.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: design.Spacing.md),
            child: AnimatedReveal(
              delay: Duration(milliseconds: 100 * index),
              child: _buildPackageCard(index, false),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPackageCard(int index, bool isMobile) {
    final package = _packages[index];
    final isPopular = package['popular'] as bool;
    final packageColor = package['color'] as Color;

    return Container(
      key: ValueKey(index),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(design.Borders.xl),
        border: Border.all(
          color: isPopular ? packageColor : Colors.grey[300]!,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular ? [
          BoxShadow(
            color: packageColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ] : design.Shadows.subtle,
      ),
      child: Stack(
        children: [
          // Popular badge
          if (isPopular)
            Positioned(
              top: -1,
              left: design.Spacing.xl,
              right: design.Spacing.xl,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.Spacing.md,
                  vertical: design.Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: packageColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(design.Borders.sm),
                  ),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Card content
          Padding(
            padding: EdgeInsets.all(design.Spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (isPopular) SizedBox(height: design.Spacing.lg),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package['name'],
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: packageColor,
                            ),
                          ),
                          Text(
                            package['subtitle'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            if (package['originalPrice'] != null) ...[
                              Text(
                                package['originalPrice'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: design.Spacing.xs),
                            ],
                            Text(
                              package['price'],
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: packageColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'per piece',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: design.Spacing.md),

                // Description
                Text(
                  package['description'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                SizedBox(height: design.Spacing.xl),

                // Features
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What\'s included:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: design.Spacing.md),

                    ...package['features'].map<Widget>((feature) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: design.Spacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: packageColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: design.Spacing.md),
                            Expanded(
                              child: Text(
                                feature,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // Limitations (if any)
                    if (package['limitations'].isNotEmpty) ...[
                      SizedBox(height: design.Spacing.lg),
                      Text(
                        'Limitations:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: design.Spacing.md),

                      ...package['limitations'].map<Widget>((limitation) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: design.Spacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: design.Spacing.md),
                              Expanded(
                                child: Text(
                                  limitation,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),

                SizedBox(height: design.Spacing.xl),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPackageDetails(package);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? packageColor : Colors.white,
                      foregroundColor: isPopular ? Colors.white : packageColor,
                      side: isPopular ? null : BorderSide(color: packageColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(design.Borders.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      package['buttonText'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Additional info for premium
                if (index == 2) ...[
                  SizedBox(height: design.Spacing.md),
                  Container(
                    padding: EdgeInsets.all(design.Spacing.md),
                    decoration: BoxDecoration(
                      color: packageColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(design.Borders.sm),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: packageColor,
                          size: 16,
                        ),
                        SizedBox(width: design.Spacing.sm),
                        Expanded(
                          child: Text(
                            'Speak with our enterprise team',
                            style: TextStyle(
                              color: packageColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPackageDetails(Map<String, dynamic> package) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.Borders.xl),
        ),
        child: Container(
          padding: EdgeInsets.all(design.Spacing.xl),
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${package['name']} Package',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Ready to get started?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),

              SizedBox(height: design.Spacing.xl),

              // Content
              Text(
                'We\'ll connect you with our team to discuss your project requirements and provide a detailed quote.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: design.Spacing.xl),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Maybe Later'),
                    ),
                  ),
                  SizedBox(width: design.Spacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigate to contact form or start quote process
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: package['color'],
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Get Quote'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}