import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../data/sample_partners.dart';
import '../../../../models/partner.dart';
import 'partner_logo.dart';

class BrandsCarousel extends StatefulWidget {
  const BrandsCarousel({Key? key}) : super(key: key);

  @override
  State<BrandsCarousel> createState() => _BrandsCarouselState();
}

class _BrandsCarouselState extends State<BrandsCarousel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;

  // Use sample partners from data file
  final List<Partner> partners = kSamplePartners;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: false);

    // Wait for layout to complete before setting up scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Allow time for the scroll view to render completely
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _scrollController.hasClients) {
          setState(() {
            _isScrollable = _scrollController.position.maxScrollExtent > 0;
          });
        }
      });
    });

    _controller.addListener(() {
      // Create endless scrolling effect only if the content is scrollable
      if (!mounted) return;

      if (_isScrollable &&
          _scrollController.hasClients &&
          _scrollController.positions.isNotEmpty &&
          _scrollController.position.hasContentDimensions) {
        try {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final currentScroll = maxScroll * _controller.value;
          _scrollController.jumpTo(currentScroll);
        } catch (e) {
          // Handle any potential errors silently
          debugPrint('Scroll error: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of brand logos from our partners
    // Add duplicates to make the loop less noticeable
    final brandLogos = [
      ...partners.map((partner) => _buildBrandLogo(context, partner)),
      ...partners.map((partner) => _buildBrandLogo(context, partner)),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xl,
        horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: design.Spacing.lg),
            child: Text(
              'Trusted by',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          SizedBox(
            height: 80,
            // Using ListView with controller for the animation
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable manual scrolling
              children: [
                Row(
                  children: brandLogos.map((logo) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: design.Spacing.xl),
                      child: logo,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo(BuildContext context, Partner partner) {
    return Tooltip(
      message: partner.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: partner.websiteUrl != null
              ? () {
                  // In a real app, you would use url_launcher to open the website
                  debugPrint('Navigate to: ${partner.websiteUrl}');
                }
              : null,
          // Use our new PartnerLogo widget which handles fallbacks
          child: PartnerLogo(partner: partner, height: 50, width: 120),
        ),
      ),
    );
  }
}
