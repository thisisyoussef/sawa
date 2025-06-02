import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/theme/animation_extensions.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class FooterSection extends StatefulWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _emailInput = '';
  bool _isFormSubmitted = false;
  bool _isHoveringSubmit = false;
  bool _isFormValid = false;

  final Map<String, List<Map<String, dynamic>>> _footerLinks = {
    'Products': [
      {'title': 'T-Shirts', 'route': '/products/t-shirts'},
      {'title': 'Hoodies', 'route': '/products/hoodies'},
      {'title': 'Caps', 'route': '/products/caps'},
      {'title': 'Tote Bags', 'route': '/products/tote-bags'},
    ],
    'Services': [
      {'title': 'Team Orders', 'route': '/services/teams'},
      {'title': 'Business Orders', 'route': '/services/business'},
      {'title': 'Custom Design', 'route': '/services/design'},
      {'title': 'Volume Discounts', 'route': '/services/discounts'},
    ],
    'Company': [
      {'title': 'About Us', 'route': '/about'},
      {'title': 'Customer Stories', 'route': '/customer-stories'},
      {'title': 'Sustainability', 'route': '/sustainability'},
      {'title': 'Contact', 'route': '/contact'},
    ],
  };

  final List<Map<String, dynamic>> _socialLinks = [
    {
      'platform': 'Instagram',
      'icon': Icons.camera_alt_outlined,
      'url': 'instagram.com/sawathreads'
    },
    {
      'platform': 'Twitter',
      'icon': Icons.flutter_dash,
      'url': 'twitter.com/sawathreads'
    },
    {
      'platform': 'Facebook',
      'icon': Icons.facebook,
      'url': 'facebook.com/sawathreads'
    },
    {
      'platform': 'TikTok',
      'icon': Icons.music_note,
      'url': 'tiktok.com/@sawathreads'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isFormValid = emailRegex.hasMatch(_emailInput);
    });
  }

  void _handleSubmit() {
    if (_isFormValid) {
      setState(() {
        _isFormSubmitted = true;
      });
      // In a real app, this would send the email to your backend
      print('Subscribing email: $_emailInput');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;
    final isTablet = screenWidth < design.Breakpoints.tablet && !isMobile;

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Main footer content
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: design.Spacing.xxl,
              horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and tagline section
                _buildLogoSection(context, isMobile),

                SizedBox(height: design.Spacing.xxl),

                // Footer links and newsletter
                isMobile
                    ? _buildMobileFooterContent(context)
                    : _buildDesktopFooterContent(context, isTablet),

                SizedBox(height: design.Spacing.xxl),

                // Social links
                _buildSocialLinks(context, isMobile),
              ],
            ),
          ),

          // Footer bottom bar with copyright
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: design.Spacing.md,
              horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: isMobile
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© ${DateTime.now().year} Sawa Threads. All rights reserved.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                if (!isMobile)
                  Row(
                    children: [
                      _buildFooterTextLink('Privacy Policy', () {}),
                      SizedBox(width: design.Spacing.md),
                      _buildFooterTextLink('Terms of Service', () {}),
                      SizedBox(width: design.Spacing.md),
                      _buildFooterTextLink('Cookie Policy', () {}),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Logo placeholder (replace with actual logo)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(width: design.Spacing.md),
            Text(
              'Sawa Threads',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        SizedBox(height: design.Spacing.md),
        Container(
          width: isMobile ? double.infinity : 400,
          child: Text(
            'Quality custom apparel for businesses, teams, and individuals. Affordable, high-quality, and uniquely yours.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopFooterContent(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Footer links columns
        ...isTablet
            ? _buildTabletFooterColumns()
            : _footerLinks.entries.map(
                (entry) => _buildFooterLinksColumn(entry.key, entry.value),
              ),

        // Spacer
        const Spacer(),

        // Newsletter signup
        _buildNewsletterSignup(context),
      ],
    );
  }

  List<Widget> _buildTabletFooterColumns() {
    // For tablet, we'll combine the links to save space
    final columns = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumnHeader('Products'),
          ..._footerLinks['Products']!.map(
            (link) => _buildFooterLink(link['title'], () => {}),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumnHeader('Services'),
          ..._footerLinks['Services']!.take(2).map(
                (link) => _buildFooterLink(link['title'], () => {}),
              ),
          ..._footerLinks['Company']!.take(2).map(
                (link) => _buildFooterLink(link['title'], () => {}),
              ),
        ],
      ),
    ];

    return columns;
  }

  Widget _buildMobileFooterContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accordion-style footer links
        ...['Products', 'Services', 'Company'].map(
          (section) => _buildMobileAccordion(section, _footerLinks[section]!),
        ),

        SizedBox(height: design.Spacing.xl),

        // Newsletter signup
        _buildNewsletterSignup(context),
      ],
    );
  }

  Widget _buildMobileAccordion(String title, List<Map<String, dynamic>> links) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: links
            .map(
              (link) => Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: design.Spacing.md,
                  bottom: design.Spacing.sm,
                ),
                child: _buildFooterLink(link['title'], () => {}),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFooterLinksColumn(
      String title, List<Map<String, dynamic>> links) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: design.Spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumnHeader(title),
          SizedBox(height: design.Spacing.md),
          ...links.map(
            (link) => Padding(
              padding: EdgeInsets.only(bottom: design.Spacing.md),
              child: _buildFooterLink(link['title'], () => {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterTextLink(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsletterSignup(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isMobile ? double.infinity : 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay Connected',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: design.Spacing.sm),
          Text(
            'Sign up for updates, product news, and special offers for your next order.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          SizedBox(height: design.Spacing.lg),

          // Newsletter form
          _isFormSubmitted
              ? _buildSuccessMessage()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(design.Borders.md),
                      ),
                      child: Row(
                        children: [
                          // Email input
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _emailInput = value;
                                });
                                _validateEmail();
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: design.Spacing.md,
                                ),
                              ),
                            ),
                          ),

                          // Submit button
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _isHoveringSubmit = true),
                            onExit: (_) =>
                                setState(() => _isHoveringSubmit = false),
                            cursor: _isFormValid
                                ? SystemMouseCursors.click
                                : SystemMouseCursors.basic,
                            child: GestureDetector(
                              onTap: _isFormValid ? _handleSubmit : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _isFormValid
                                      ? (_isHoveringSubmit
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.9))
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.circular(design.Borders.md),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: _isFormValid
                                        ? Colors.black
                                        : Colors.white.withOpacity(0.5),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_emailInput.isNotEmpty && !_isFormValid)
                      Padding(
                        padding: EdgeInsets.only(
                            top: design.Spacing.sm, left: design.Spacing.sm),
                        child: Text(
                          'Please enter a valid email address',
                          style: TextStyle(
                            color: Colors.red.shade300,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: EdgeInsets.all(design.Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(design.Borders.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.greenAccent,
            size: 24,
          ),
          SizedBox(width: design.Spacing.md),
          Expanded(
            child: Text(
              'Thank you for joining our community! Watch your inbox for updates and offers.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.white.withOpacity(0.1),
          margin: EdgeInsets.only(bottom: design.Spacing.lg),
        ),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: _socialLinks
              .map(
                (social) => Padding(
                  padding: EdgeInsets.only(right: design.Spacing.md),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            social['icon'],
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
