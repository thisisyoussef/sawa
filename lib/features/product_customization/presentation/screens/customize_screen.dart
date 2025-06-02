import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
// Uncomment these after adding the packages to pubspec.yaml
// import 'package:lottie/lottie.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:glassmorphism/glassmorphism.dart'; // Uncomment if you add glassmorphism package

class CustomizeScreen extends StatefulWidget {
  final String? productId;
  const CustomizeScreen({Key? key, this.productId}) : super(key: key);

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen>
    with SingleTickerProviderStateMixin {
  String selectedView = 'Front';
  String selectedColor = 'Bright White';
  String? dyeType = 'Standard Garment Dye';
  int quantity = 50;
  double unitCost = 38.5;
  bool customLabel = false;
  bool isUploading = false;
  String? artworkImage;
  double artworkScale = 1.0;
  Offset artworkPosition = Offset.zero;
  bool showTooltip = false;
  String activeSection = 'Color';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> swatches = [
    {'name': 'Bright White', 'color': Colors.white},
    {'name': 'True Black', 'color': Colors.black},
    {'name': 'Indian Almond', 'color': const Color(0xFF8B8578)},
    {'name': 'Buffalo Chip', 'color': const Color(0xFF7B5E57)},
    {'name': 'Silver Bullet', 'color': const Color(0xFFB0B7C3)},
    {'name': 'Amparo Blue', 'color': const Color(0xFF4969B1)},
    {'name': 'Ecru', 'color': const Color(0xFFF5E9DA)},
    {'name': 'Oat Milk', 'color': const Color(0xFFF3E5C2)},
    {'name': 'Coca Mocha', 'color': const Color(0xFF7B4B3A)},
    {'name': 'Glacier Lake', 'color': const Color(0xFFB6D6E1)},
    {'name': 'Deep Periwinkle', 'color': const Color(0xFF6C7BAE)},
    {'name': 'Blue Ribbon', 'color': const Color(0xFF1A237E)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Background pattern or gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF8F9FA),
                      const Color(0xFFF0F1F2),
                    ],
                  ),
                ),
              ),
            ),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopBar(),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.only(
                top: 60,
                bottom: isMobile ? 0 : 24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Canvas - Takes 60% on desktop, full width on mobile
                  Expanded(
                    flex: 6,
                    child: _ProductCanvas(
                      selectedView: selectedView,
                      selectedColor: swatches.firstWhere(
                          (s) => s['name'] == selectedColor)['color'],
                      artworkImage: artworkImage,
                      artworkPosition: artworkPosition,
                      artworkScale: artworkScale,
                      onArtworkPositionChanged: (offset) {
                        setState(() => artworkPosition = offset);
                      },
                      onArtworkScaleChanged: (scale) {
                        setState(() => artworkScale = scale);
                      },
                      customLabel: customLabel,
                      onViewChanged: (v) => setState(() => selectedView = v),
                      showTooltip: showTooltip,
                    ),
                  ),

                  // Right Panel - Only visible on desktop
                  if (!isMobile)
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _CustomizationPanel(
                          activeSection: activeSection,
                          onSectionChanged: (section) {
                            setState(() => activeSection = section);
                          },
                          dyeType: dyeType!,
                          onDyeTypeChanged: (v) {
                            if (v != null) setState(() => dyeType = v);
                          },
                          swatches: swatches,
                          selectedColor: selectedColor,
                          onColorSelected: (String? c) {
                            if (c != null) setState(() => selectedColor = c);
                          },
                          isUploading: isUploading,
                          onUploadArtwork: _handleUploadArtwork,
                          artworkImage: artworkImage,
                          onRemoveArtwork: () =>
                              setState(() => artworkImage = null),
                          customLabel: customLabel,
                          onToggleLabel: (v) => setState(() => customLabel = v),
                          quantity: quantity,
                          onQuantityChanged: (q) {
                            if (q != null) setState(() => quantity = q);
                          },
                          unitCost: unitCost,
                          onConfirm: _handleConfirm,
                          onToggleTooltip: (show) {
                            setState(() => showTooltip = show);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Mobile: Bottom Navigation and Expandable Panel
            if (isMobile)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _MobileControlPanel(
                  activeSection: activeSection,
                  onSectionChanged: (section) {
                    setState(() => activeSection = section);
                  },
                  dyeType: dyeType!,
                  onDyeTypeChanged: (v) {
                    if (v != null) setState(() => dyeType = v);
                  },
                  swatches: swatches,
                  selectedColor: selectedColor,
                  onColorSelected: (String? c) {
                    if (c != null) setState(() => selectedColor = c);
                  },
                  isUploading: isUploading,
                  onUploadArtwork: _handleUploadArtwork,
                  artworkImage: artworkImage,
                  onRemoveArtwork: () => setState(() => artworkImage = null),
                  customLabel: customLabel,
                  onToggleLabel: (v) => setState(() => customLabel = v),
                  quantity: quantity,
                  onQuantityChanged: (q) {
                    if (q != null) setState(() => quantity = q);
                  },
                  unitCost: unitCost,
                  onConfirm: _handleConfirm,
                  onToggleTooltip: (show) {
                    setState(() => showTooltip = show);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleUploadArtwork() async {
    setState(() => isUploading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate upload
    setState(() {
      isUploading = false;
      artworkImage =
          'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png';
    });
  }

  void _handleConfirm() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Design Saved!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your custom hoodie is ready for review.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Edit Design'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue'),
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

// --- Top Bar ---
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Product Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.create_outlined,
                  size: 16,
                  color: Colors.black.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  'Customizing: Classic Hoodie',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Share and Help
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
                tooltip: 'Share this design',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {},
                tooltip: 'Get help',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Product Canvas ---
class _ProductCanvas extends StatelessWidget {
  final String selectedView;
  final Color selectedColor;
  final String? artworkImage;
  final bool customLabel;
  final ValueChanged<String> onViewChanged;
  final Offset artworkPosition;
  final double artworkScale;
  final ValueChanged<Offset> onArtworkPositionChanged;
  final ValueChanged<double> onArtworkScaleChanged;
  final bool showTooltip;

  const _ProductCanvas({
    required this.selectedView,
    required this.selectedColor,
    required this.artworkImage,
    required this.customLabel,
    required this.onViewChanged,
    required this.artworkPosition,
    required this.artworkScale,
    required this.onArtworkPositionChanged,
    required this.onArtworkScaleChanged,
    required this.showTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Product Image with Interactive Preview
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Slightly offset shadows for 3D effect
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuint,
                  right: selectedView == 'Front' ? 20 : 40,
                  left: selectedView == 'Back' ? 20 : 40,
                  top: 100,
                  child: Opacity(
                    opacity: 0.08,
                    child: Image.network(
                      'https://i.imgur.com/Qp5mavE.png', // Placeholder shadow using same front image with opacity
                      width: 400,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Main product view with animated transitions
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildProductView(selectedView),
                ),

                // Artwork overlay with interactive positioning
                if (artworkImage != null)
                  Positioned(
                    left: 50.0 + artworkPosition.dx,
                    top: 120.0 + artworkPosition.dy,
                    child: GestureDetector(
                      onScaleUpdate: (details) {
                        // Scale gesture already includes translation (pan)
                        // Update position using focal point delta
                        onArtworkPositionChanged(
                            artworkPosition + details.focalPointDelta);

                        // Update scale factor if it changed
                        if (details.scale != 1.0) {
                          final newScale =
                              (artworkScale * details.scale).clamp(0.5, 2.0);
                          onArtworkScaleChanged(newScale);
                        }
                      },
                      child: Transform.scale(
                        scale: artworkScale,
                        child: Container(
                          decoration: BoxDecoration(
                            border: showTooltip
                                ? Border.all(
                                    color: Colors.blue.withOpacity(0.8),
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  )
                                : null,
                          ),
                          child: Image.network(
                            artworkImage!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Interactive tool tip
                if (showTooltip)
                  Positioned(
                    top: 80,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '✨ Interactive Design Tips',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Drag artwork to position\n• Pinch to resize\n• Rotate for different views',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // View Switcher with 3D carousel effect
          Container(
            margin: const EdgeInsets.all(16),
            child: _View3DSwitcher(
              selected: selectedView,
              onChanged: onViewChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductView(String view) {
    // Return different product views based on selection
    switch (view) {
      case 'Front':
        return Hero(
          tag: 'product-preview-front',
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              selectedColor,
              BlendMode.modulate,
            ),
            child: Image.network(
              'https://i.imgur.com/Qp5mavE.png', // Placeholder hoodie front view
              key: const ValueKey('front-view'),
              width: 400,
              fit: BoxFit.contain,
            ),
          ),
        );
      case 'Back':
        return Hero(
          tag: 'product-preview-back',
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              selectedColor,
              BlendMode.modulate,
            ),
            child: Image.network(
              'https://i.imgur.com/VXeNKxb.png', // Placeholder hoodie back view
              key: const ValueKey('back-view'),
              width: 400,
              fit: BoxFit.contain,
            ),
          ),
        );
      case 'Neck':
        return Hero(
          tag: 'product-preview-neck',
          child: Stack(
            alignment: Alignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selectedColor,
                  BlendMode.modulate,
                ),
                child: Image.network(
                  'https://i.imgur.com/kcC1rJI.png', // Placeholder hoodie neck view
                  key: const ValueKey('neck-view'),
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
              if (customLabel)
                Positioned(
                  top: 150,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'YOUR BRAND',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}

// 3D View Switcher with advanced UI
class _View3DSwitcher extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _View3DSwitcher({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final views = ['Front', 'Neck', 'Back'];
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: views.map((view) {
          final isSelected = view == selected;
          return GestureDetector(
            onTap: () => onChanged(view),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForView(view),
                    size: 16,
                    color: isSelected
                        ? Colors.black
                        : Colors.black.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    view,
                    style: GoogleFonts.inter(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.black
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForView(String view) {
    switch (view) {
      case 'Front':
        return Icons.accessibility_new;
      case 'Back':
        return Icons.flip_to_back;
      case 'Neck':
        return Icons.label;
      default:
        return Icons.view_in_ar;
    }
  }
}

// --- Customization Panel (Desktop) ---
class _CustomizationPanel extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChanged;
  final String dyeType;
  final ValueChanged<String?> onDyeTypeChanged;
  final List<Map<String, dynamic>> swatches;
  final String selectedColor;
  final ValueChanged<String?> onColorSelected;
  final bool isUploading;
  final VoidCallback onUploadArtwork;
  final String? artworkImage;
  final VoidCallback onRemoveArtwork;
  final bool customLabel;
  final ValueChanged<bool> onToggleLabel;
  final int quantity;
  final ValueChanged<int?> onQuantityChanged;
  final double unitCost;
  final VoidCallback onConfirm;
  final ValueChanged<bool> onToggleTooltip;

  const _CustomizationPanel({
    required this.activeSection,
    required this.onSectionChanged,
    required this.dyeType,
    required this.onDyeTypeChanged,
    required this.swatches,
    required this.selectedColor,
    required this.onColorSelected,
    required this.isUploading,
    required this.onUploadArtwork,
    required this.artworkImage,
    required this.onRemoveArtwork,
    required this.customLabel,
    required this.onToggleLabel,
    required this.quantity,
    required this.onQuantityChanged,
    required this.unitCost,
    required this.onConfirm,
    required this.onToggleTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _DesignSectionTabs(
                  activeSection: activeSection,
                  onSectionChanged: onSectionChanged,
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildActiveSection(),
                ),
              ),

              // Bottom actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '€${(unitCost * quantity).toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => onToggleTooltip(true),
                          onExit: (_) => onToggleTooltip(false),
                          child: Text(
                            'Need help with design?',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildActiveSection() {
    switch (activeSection) {
      case 'Color':
        return _ColorSection(
          dyeType: dyeType,
          onDyeTypeChanged: onDyeTypeChanged,
          swatches: swatches,
          selectedColor: selectedColor,
          onColorSelected: onColorSelected,
        );
      case 'Artwork':
        return _ArtworkSection(
          isUploading: isUploading,
          onUploadArtwork: onUploadArtwork,
          artworkImage: artworkImage,
          onRemoveArtwork: onRemoveArtwork,
        );
      case 'Label':
        return _LabelSection(
          customLabel: customLabel,
          onToggleLabel: onToggleLabel,
        );
      case 'Order':
        return _OrderSection(
          quantity: quantity,
          onQuantityChanged: onQuantityChanged,
          unitCost: unitCost,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// Design section tabs with modern design
class _DesignSectionTabs extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChanged;

  const _DesignSectionTabs({
    required this.activeSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'id': 'Color', 'icon': Icons.palette_outlined},
      {'id': 'Artwork', 'icon': Icons.image_outlined},
      {'id': 'Label', 'icon': Icons.label_outline},
      {'id': 'Order', 'icon': Icons.shopping_bag_outlined},
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: sections.map((section) {
          final isActive = section['id'] == activeSection;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSectionChanged(section['id'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                margin: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      section['icon'] as IconData,
                      size: 20,
                      color: isActive
                          ? Colors.black
                          : Colors.black.withOpacity(0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section['id'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? Colors.black
                            : Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Color section with selection and swatches
class _ColorSection extends StatelessWidget {
  final String dyeType;
  final ValueChanged<String?> onDyeTypeChanged;
  final List<Map<String, dynamic>> swatches;
  final String selectedColor;
  final ValueChanged<String?> onColorSelected;

  const _ColorSection({
    required this.dyeType,
    required this.onDyeTypeChanged,
    required this.swatches,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Garment Color',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: dyeType,
          decoration: InputDecoration(
            labelText: 'Dye Type',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: [
            'Standard Garment Dye',
            'Premium Pigment Dye',
          ]
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: onDyeTypeChanged,
        ),
        const SizedBox(height: 24),
        Text(
          'Available Colors',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: swatches.map((swatch) {
            final isSelected = swatch['name'] == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(swatch['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: swatch['color'],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            selectedColor,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Artwork section with upload controls
class _ArtworkSection extends StatelessWidget {
  final bool isUploading;
  final VoidCallback onUploadArtwork;
  final String? artworkImage;
  final VoidCallback onRemoveArtwork;

  const _ArtworkSection({
    required this.isUploading,
    required this.onUploadArtwork,
    required this.artworkImage,
    required this.onRemoveArtwork,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Artwork',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Upload your design to customize the garment',
          style: GoogleFonts.inter(
            color: Colors.black.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        if (isUploading)
          Center(
            child: Column(
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Uploading artwork...',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else if (artworkImage == null)
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: 0,
                          strokeWidth: 2,
                          backgroundColor: Color(0xFFE0E0E0),
                          color: Colors.transparent,
                        ),
                      ),
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 32,
                        color: Color(0xFF555555),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Drag & drop your artwork here',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Support PNG, JPG, SVG files (max 5MB)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onUploadArtwork,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Browse Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            artworkImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: onRemoveArtwork,
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Artwork',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Drag on the product to position\n• Pinch on the product to resize',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onUploadArtwork,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload New Artwork'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// Label section for custom neck label
class _LabelSection extends StatelessWidget {
  final bool customLabel;
  final ValueChanged<bool> onToggleLabel;

  const _LabelSection({
    required this.customLabel,
    required this.onToggleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Labels',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand Label',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      customLabel
                          ? 'Your brand label will be sewn on the neck'
                          : 'No custom label',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: customLabel,
                onChanged: onToggleLabel,
                activeColor: Colors.black,
              ),
            ],
          ),
        ),
        if (customLabel) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Label Preview',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'YOUR BRAND',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Note: Custom labels add €1.50 per unit',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Order section with quantity selection and cost summary
class _OrderSection extends StatelessWidget {
  final int quantity;
  final ValueChanged<int?> onQuantityChanged;
  final double unitCost;

  const _OrderSection({
    required this.quantity,
    required this.onQuantityChanged,
    required this.unitCost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Quantity',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: quantity,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [50, 100, 250, 500, 1000]
                          .map((q) => DropdownMenuItem(
                                value: q,
                                child: Text('$q'),
                              ))
                          .toList(),
                      onChanged: onQuantityChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unit cost',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '€${unitCost.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '€${(unitCost * quantity).toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated delivery',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2-3 weeks',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Final pricing will be confirmed after design review',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Mobile Control Panel ---
class _MobileControlPanel extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChanged;
  final String dyeType;
  final ValueChanged<String?> onDyeTypeChanged;
  final List<Map<String, dynamic>> swatches;
  final String selectedColor;
  final ValueChanged<String?> onColorSelected;
  final bool isUploading;
  final VoidCallback onUploadArtwork;
  final String? artworkImage;
  final VoidCallback onRemoveArtwork;
  final bool customLabel;
  final ValueChanged<bool> onToggleLabel;
  final int quantity;
  final ValueChanged<int?> onQuantityChanged;
  final double unitCost;
  final VoidCallback onConfirm;
  final ValueChanged<bool> onToggleTooltip;

  const _MobileControlPanel({
    required this.activeSection,
    required this.onSectionChanged,
    required this.dyeType,
    required this.onDyeTypeChanged,
    required this.swatches,
    required this.selectedColor,
    required this.onColorSelected,
    required this.isUploading,
    required this.onUploadArtwork,
    required this.artworkImage,
    required this.onRemoveArtwork,
    required this.customLabel,
    required this.onToggleLabel,
    required this.quantity,
    required this.onQuantityChanged,
    required this.unitCost,
    required this.onConfirm,
    required this.onToggleTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bottom Navigation tabs
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MobileTabItem(
                label: 'Color',
                icon: Icons.palette_outlined,
                isActive: activeSection == 'Color',
                onTap: () => onSectionChanged('Color'),
              ),
              _MobileTabItem(
                label: 'Artwork',
                icon: Icons.image_outlined,
                isActive: activeSection == 'Artwork',
                onTap: () => onSectionChanged('Artwork'),
              ),
              _MobileTabItem(
                label: 'Label',
                icon: Icons.label_outline,
                isActive: activeSection == 'Label',
                onTap: () => onSectionChanged('Label'),
              ),
              _MobileTabItem(
                label: 'Order',
                icon: Icons.shopping_bag_outlined,
                isActive: activeSection == 'Order',
                onTap: () => onSectionChanged('Order'),
              ),
            ],
          ),
        ),

        // Expandable Panel
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: activeSection != '' ? 340 : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              height: 340,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  // Panel content
                  Expanded(
                    child: _buildPanelContent(),
                  ),

                  // Bottom actions
                  ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      activeSection == 'Order'
                          ? 'Continue to Checkout'
                          : 'Apply Changes',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanelContent() {
    switch (activeSection) {
      case 'Color':
        return _ColorSection(
          dyeType: dyeType,
          onDyeTypeChanged: onDyeTypeChanged,
          swatches: swatches,
          selectedColor: selectedColor,
          onColorSelected: onColorSelected,
        );
      case 'Artwork':
        return _ArtworkSection(
          isUploading: isUploading,
          onUploadArtwork: onUploadArtwork,
          artworkImage: artworkImage,
          onRemoveArtwork: onRemoveArtwork,
        );
      case 'Label':
        return _LabelSection(
          customLabel: customLabel,
          onToggleLabel: onToggleLabel,
        );
      case 'Order':
        return _OrderSection(
          quantity: quantity,
          onQuantityChanged: onQuantityChanged,
          unitCost: unitCost,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// Mobile tab item
class _MobileTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileTabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.black : Colors.black.withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isActive ? Colors.black : Colors.black.withOpacity(0.5),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
