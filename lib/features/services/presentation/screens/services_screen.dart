import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/sawa_app_bar.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/theme/animation_extensions.dart';
import '../widgets/service_card.dart';
import '../widgets/pricing_calculator.dart';
import '../widgets/process_timeline.dart';
import '../widgets/package_comparison.dart';
import '../widgets/quote_builder.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatController;
  String _activeSection = 'overview';
  int _selectedQuantity = 100;
  String _selectedService = 'screen-print';
  double _estimatedPrice = 24.50;

  final Map<String, Map<String, dynamic>> _services = {
    'screen-print': {
      'name': 'Screen Printing',
      'description': 'Vibrant, durable prints perfect for bulk orders',
      'icon': '🎨',
      'basePrice': 18.50,
      'features': ['Up to 6 colors', 'Durable plastisol inks', 'Perfect for bulk orders', 'Cost-effective'],
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?q=80&w=2340&auto=format&fit=crop',
    },
    'dtg': {
      'name': 'Direct-to-Garment',
      'description': 'High-resolution, photo-quality prints for complex designs',
      'icon': '🖨️',
      'basePrice': 28.75,
      'features': ['Full-color prints', 'Photo quality', 'No minimum order', 'Eco-friendly inks'],
      'image': 'https://images.unsplash.com/photo-1618517351616-38fb9c5210c6?q=80&w=2787&auto=format&fit=crop',
    },
    'embroidery': {
      'name': 'Embroidery',
      'description': 'Premium textured finish that adds perceived value',
      'icon': '🧵',
      'basePrice': 32.95,
      'features': ['Premium finish', 'Highly durable', 'Professional look', 'Multiple thread types'],
      'image': 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=2340&auto=format&fit=crop',
    },
    'patches': {
      'name': 'Patches & Labels',
      'description': 'Custom woven patches and labels for brand identity',
      'icon': '🏷️',
      'basePrice': 15.25,
      'features': ['Woven or PVC', 'Custom shapes', 'Heat-sealed or sewn', 'Minimum 50 pieces'],
      'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?q=80&w=1972&auto=format&fit=crop',
    },
  };

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _updatePrice() {
    final service = _services[_selectedService]!;
    double basePrice = service['basePrice'];
    
    // Volume discounts
    double discount = 1.0;
    if (_selectedQuantity >= 500) discount = 0.85;
    else if (_selectedQuantity >= 250) discount = 0.90;
    else if (_selectedQuantity >= 100) discount = 0.95;

    setState(() {
      _estimatedPrice = basePrice * discount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Scaffold(
      appBar: const SawaAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Interactive Elements
            _buildHeroSection(context, isMobile),

            // Services Overview
            _buildServicesOverview(context, isMobile),

            // Interactive Pricing Calculator
            _buildPricingSection(context, isMobile),

            // Process Timeline
            _buildProcessSection(context, isMobile),

            // Package Comparison
            _buildPackagesSection(context, isMobile),

            // Custom Quote Builder
            _buildQuoteSection(context, isMobile),

            // FAQ Section
            _buildFAQSection(context, isMobile),

            // CTA Section
            _buildCTASection(context, isMobile),

            SizedBox(height: design.Spacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      height: isMobile ? 500 : 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a1a),
            const Color(0xFF2d2d2d),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background pattern
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FloatingPatternPainter(_floatController.value),
                );
              },
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: _heroController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _heroController.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - _heroController.value)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.Spacing.md,
                                vertical: design.Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(design.Borders.lg),
                              ),
                              child: Text(
                                '🎯 Complete Custom Apparel Solutions',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: design.Spacing.xl),

                            // Main heading
                            SizedBox(
                              width: isMobile ? double.infinity : screenWidth * 0.6,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Professional Services\n',
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        height: 1.1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Made Simple',
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: design.Spacing.xl),

                            // Subtitle
                            SizedBox(
                              width: isMobile ? double.infinity : screenWidth * 0.5,
                              child: Text(
                                'From concept to delivery, we handle every aspect of your custom apparel project with precision and care.',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: design.Spacing.xxl),

                            // Interactive service indicators
                            Wrap(
                              spacing: design.Spacing.lg,
                              runSpacing: design.Spacing.md,
                              children: _services.entries.map((entry) {
                                return _buildServiceIndicator(
                                  entry.value['icon'],
                                  entry.value['name'],
                                  entry.key == _selectedService,
                                  () => setState(() => _selectedService = entry.key),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIndicator(String emoji, String name, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: design.Spacing.lg,
          vertical: design.Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(design.Borders.lg),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 20)),
            SizedBox(width: design.Spacing.sm),
            Text(
              name,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesOverview(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          // Section header
          AnimatedReveal(
            child: Text(
              'Our Services',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          // Service cards grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: design.Spacing.xl,
              mainAxisSpacing: design.Spacing.xl,
              childAspectRatio: isMobile ? 1.2 : 1.4,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final entry = _services.entries.elementAt(index);
              return AnimatedReveal(
                delay: Duration(milliseconds: 100 * index),
                child: ServiceCard(
                  service: entry.value,
                  serviceKey: entry.key,
                  isSelected: entry.key == _selectedService,
                  onTap: () {
                    setState(() => _selectedService = entry.key);
                    _updatePrice();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, bool isMobile) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          AnimatedReveal(
            child: Text(
              'Interactive Pricing',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          PricingCalculator(
            selectedService: _selectedService,
            selectedQuantity: _selectedQuantity,
            estimatedPrice: _estimatedPrice,
            services: _services,
            onServiceChanged: (service) {
              setState(() => _selectedService = service);
              _updatePrice();
            },
            onQuantityChanged: (quantity) {
              setState(() => _selectedQuantity = quantity);
              _updatePrice();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProcessSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          AnimatedReveal(
            child: Text(
              'Our Process',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          ProcessTimeline(isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildPackagesSection(BuildContext context, bool isMobile) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          AnimatedReveal(
            child: Text(
              'Service Packages',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          PackageComparison(isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildQuoteSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          AnimatedReveal(
            child: Text(
              'Get Custom Quote',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          QuoteBuilder(isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, bool isMobile) {
    final faqs = [
      {
        'question': 'What\'s the minimum order quantity?',
        'answer': 'Our minimum order quantity is 50 pieces for most services, though some specialty services may have different requirements.',
      },
      {
        'question': 'How long does production take?',
        'answer': 'Standard production time is 7-10 business days after artwork approval. Rush orders can be completed in 3-5 business days for an additional fee.',
      },
      {
        'question': 'Do you provide design services?',
        'answer': 'Yes! Our design team can help create or refine your artwork. Design consultations are included with orders over 250 pieces.',
      },
      {
        'question': 'What file formats do you accept?',
        'answer': 'We accept AI, EPS, PDF, PNG, and JPEG files. Vector formats are preferred for screen printing and embroidery.',
      },
    ];

    return Container(
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Column(
        children: [
          AnimatedReveal(
            child: Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: design.Spacing.xl),

          ...faqs.map((faq) => AnimatedReveal(
            child: Container(
              margin: EdgeInsets.only(bottom: design.Spacing.lg),
              child: ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(design.Spacing.lg),
                    child: Text(
                      faq['answer']!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.xl : design.Spacing.xxxl,
      ),
      child: Container(
        padding: EdgeInsets.all(design.Spacing.xxl),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(design.Borders.xl),
        ),
        child: Column(
          children: [
            Text(
              'Ready to Start Your Project?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: design.Spacing.lg),
            Text(
              'Get a custom quote or speak with our team about your specific needs.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: design.Spacing.xl),

            isMobile
                ? Column(
                    children: [
                      _buildCTAButton('Get Custom Quote', true, () {}),
                      SizedBox(height: design.Spacing.md),
                      _buildCTAButton('Start Designing', false, () {
                        context.go(AppRoutes.productShowcase);
                      }),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCTAButton('Get Custom Quote', true, () {}),
                      SizedBox(width: design.Spacing.lg),
                      _buildCTAButton('Start Designing', false, () {
                        context.go(AppRoutes.productShowcase);
                      }),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(String text, bool isPrimary, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        foregroundColor: isPrimary ? Colors.black : Colors.white,
        side: isPrimary ? null : const BorderSide(color: Colors.white),
        padding: EdgeInsets.symmetric(
          horizontal: design.Spacing.xl,
          vertical: design.Spacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.Borders.md),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

// Custom painter for floating pattern background
class _FloatingPatternPainter extends CustomPainter {
  final double animation;

  _FloatingPatternPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (size.width / 20) * i + (math.sin(animation * 2 * math.pi + i) * 30);
      final y = (size.height / 10) * (i % 10) + (math.cos(animation * 2 * math.pi + i) * 20);
      canvas.drawCircle(Offset(x, y), 2 + math.sin(animation * math.pi + i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingPatternPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}