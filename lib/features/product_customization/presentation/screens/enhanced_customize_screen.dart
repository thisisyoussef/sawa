import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/product_customization.dart';
import '../../../../services/customization_service.dart';

// Provider for customization service
final customizationServiceProvider = ChangeNotifierProvider<CustomizationService>((ref) {
  final service = CustomizationService();
  service.loadFromLocalStorage();
  return service;
});

class EnhancedCustomizeScreen extends ConsumerStatefulWidget {
  final String productId;
  final String productName;
  
  const EnhancedCustomizeScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  ConsumerState<EnhancedCustomizeScreen> createState() => _EnhancedCustomizeScreenState();
}

class _EnhancedCustomizeScreenState extends ConsumerState<EnhancedCustomizeScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pageAnimationController;
  late AnimationController _fabAnimationController;
  late AnimationController _pulseAnimationController;
  
  // UI State
  String activeTab = 'design';
  bool showGridView = false;
  bool showPriceBreakdown = false;
  bool isProcessing = false;
  
  // Product views
  final productViews = ['front', 'back', 'left_sleeve', 'right_sleeve'];
  String currentView = 'front';
  
  // Gesture controls for artwork
  TransformationController transformationController = TransformationController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    // Start animations
    _pageAnimationController.forward();
    
    // Initialize customization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customizationServiceProvider).createNewCustomization(widget.productId);
    });
  }
  
  @override
  void dispose() {
    _pageAnimationController.dispose();
    _fabAnimationController.dispose();
    _pulseAnimationController.dispose();
    transformationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final customizationService = ref.watch(customizationServiceProvider);
    final customization = customizationService.currentCustomization;
    
    if (customization == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF8F9FA),
                  const Color(0xFFE9ECEF).withOpacity(0.5),
                ],
              ),
            ),
          ),
          
          // Main content
          Column(
            children: [
              // Enhanced top bar
              _buildTopBar(context, customization),
              
              // Content area
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 1200;
                    final isTablet = constraints.maxWidth > 768;
                    
                    if (isDesktop) {
                      return _buildDesktopLayout(customization);
                    } else if (isTablet) {
                      return _buildTabletLayout(customization);
                    } else {
                      return _buildMobileLayout(customization);
                    }
                  },
                ),
              ),
            ],
          ),
          
          // Floating action buttons
          _buildFloatingActions(context, customization),
        ],
      ),
    );
  }
  
  Widget _buildTopBar(BuildContext context, ProductCustomization customization) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Product info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customizing',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      widget.productName,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Row(
                children: [
                  // Save draft
                  TextButton.icon(
                    onPressed: _saveDraft,
                    icon: const Icon(Icons.save_outlined, size: 20),
                    label: const Text('Save Draft'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Preview button
                  FilledButton.icon(
                    onPressed: () => _showPreview(context, customization),
                    icon: const Icon(Icons.visibility_outlined, size: 20),
                    label: const Text('Preview'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
  
  Widget _buildDesktopLayout(ProductCustomization customization) {
    return Row(
      children: [
        // Left panel - Product preview
        Expanded(
          flex: 6,
          child: _buildProductPreview(customization),
        ),
        
        // Right panel - Customization options
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: _buildCustomizationPanel(customization),
        ),
      ],
    );
  }
  
  Widget _buildTabletLayout(ProductCustomization customization) {
    return Column(
      children: [
        // Product preview
        Expanded(
          flex: 5,
          child: _buildProductPreview(customization),
        ),
        
        // Customization panel
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: _buildCustomizationPanel(customization),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(ProductCustomization customization) {
    return Stack(
      children: [
        // Product preview
        _buildProductPreview(customization),
        
        // Bottom sheet style panel
        DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: _buildCustomizationPanel(customization),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildProductPreview(ProductCustomization customization) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // View selector
          _buildViewSelector(),
          
          const SizedBox(height: 24),
          
          // 3D-like product view
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Product image with color filter
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: Container(
                    key: ValueKey(currentView),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: customization.color.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: InteractiveViewer(
                        transformationController: transformationController,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            customization.color.withOpacity(0.8),
                            BlendMode.modulate,
                          ),
                          child: _getProductImage(currentView),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Artwork overlay
                if (customization.artworkUrl != null)
                  Positioned(
                    left: 100 + customization.artworkPosition.dx,
                    top: 100 + customization.artworkPosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final service = ref.read(customizationServiceProvider);
                        service.updateCurrentCustomization(
                          customization.copyWith(
                            artworkPosition: customization.artworkPosition + details.delta,
                          ),
                        );
                      },
                      child: Transform.scale(
                        scale: customization.artworkScale,
                        child: Transform.rotate(
                          angle: customization.artworkRotation * math.pi / 180,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Image.network(
                              customization.artworkUrl!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Zoom controls
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          final matrix = transformationController.value.clone();
                          matrix.scale(1.2);
                          transformationController.value = matrix;
                        },
                        icon: const Icon(Icons.zoom_in),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {
                          final matrix = transformationController.value.clone();
                          matrix.scale(0.8);
                          transformationController.value = matrix;
                        },
                        icon: const Icon(Icons.zoom_out),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {
                          transformationController.value = Matrix4.identity();
                        },
                        icon: const Icon(Icons.restore),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Grid view toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Single View',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: !showGridView ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: showGridView,
                onChanged: (value) => setState(() => showGridView = value),
                activeColor: Colors.black,
              ),
              const SizedBox(width: 12),
              Text(
                'All Views',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: showGridView ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildViewSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: productViews.map((view) {
          final isSelected = currentView == view;
          return GestureDetector(
            onTap: () => setState(() => currentView = view),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconForView(view),
                    size: 18,
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    view.replaceAll('_', ' ').toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.black : Colors.grey.shade600,
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
  
  Widget _buildCustomizationPanel(ProductCustomization customization) {
    return Column(
      children: [
        // Tabs
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildTab('design', Icons.palette_outlined, 'Design'),
              _buildTab('artwork', Icons.image_outlined, 'Artwork'),
              _buildTab('label', Icons.label_outline, 'Label'),
              _buildTab('summary', Icons.receipt_outlined, 'Summary'),
            ],
          ),
        ),
        
        // Tab content
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildTabContent(customization),
          ),
        ),
        
        // Bottom actions
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            children: [
              // Price display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '€${customization.totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => setState(() => showPriceBreakdown = !showPriceBreakdown),
                    child: Text(
                      showPriceBreakdown ? 'Hide Details' : 'View Details',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ),
                ],
              ),
              
              // Price breakdown
              if (showPriceBreakdown) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: ref.read(customizationServiceProvider).getPriceBreakdown().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Text(
                              '€${entry.value.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: entry.value < 0 ? FontWeight.w600 : FontWeight.w400,
                                color: entry.value < 0 ? Colors.green : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: isProcessing ? null : () => _proceedToCheckout(context),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTab(String id, IconData icon, String label) {
    final isActive = activeTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabContent(ProductCustomization customization) {
    switch (activeTab) {
      case 'design':
        return _DesignTab(
          key: const ValueKey('design'),
          customization: customization,
          onUpdate: (updated) {
            ref.read(customizationServiceProvider).updateCurrentCustomization(updated);
          },
        );
      case 'artwork':
        return _ArtworkTab(
          key: const ValueKey('artwork'),
          customization: customization,
          onUpdate: (updated) {
            ref.read(customizationServiceProvider).updateCurrentCustomization(updated);
          },
        );
      case 'label':
        return _LabelTab(
          key: const ValueKey('label'),
          customization: customization,
          onUpdate: (updated) {
            ref.read(customizationServiceProvider).updateCurrentCustomization(updated);
          },
        );
      case 'summary':
        return _SummaryTab(
          key: const ValueKey('summary'),
          customization: customization,
          priceBreakdown: ref.read(customizationServiceProvider).getPriceBreakdown(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildFloatingActions(BuildContext context, ProductCustomization customization) {
    return Positioned(
      bottom: 80,
      right: 20,
      child: Column(
        children: [
          // Help button
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _fabAnimationController,
              curve: Curves.elasticOut,
            ),
            child: FloatingActionButton.small(
              heroTag: 'help',
              onPressed: () => _showHelp(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.help_outline),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Share button
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _fabAnimationController,
              curve: Curves.elasticOut,
            ),
            child: FloatingActionButton.small(
              heroTag: 'share',
              onPressed: () => _shareDesign(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.share_outlined),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods
  Widget _getProductImage(String view) {
    // Replace with actual product images
    switch (view) {
      case 'front':
        return Image.network(
          'https://i.imgur.com/Qp5mavE.png',
          fit: BoxFit.contain,
        );
      case 'back':
        return Image.network(
          'https://i.imgur.com/VXeNKxb.png',
          fit: BoxFit.contain,
        );
      case 'left_sleeve':
      case 'right_sleeve':
        return Image.network(
          'https://i.imgur.com/kcC1rJI.png',
          fit: BoxFit.contain,
        );
      default:
        return const SizedBox.shrink();
    }
  }
  
  IconData _getIconForView(String view) {
    switch (view) {
      case 'front':
        return Icons.accessibility_new;
      case 'back':
        return Icons.flip_to_back;
      case 'left_sleeve':
        return Icons.chevron_left;
      case 'right_sleeve':
        return Icons.chevron_right;
      default:
        return Icons.view_in_ar;
    }
  }
  
  void _saveDraft() async {
    setState(() => isProcessing = true);
    
    try {
      await ref.read(customizationServiceProvider).saveCustomization();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Design saved successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving design: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }
  
  void _showPreview(BuildContext context, ProductCustomization customization) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _PreviewScreen(customization: customization),
      ),
    );
  }
  
  void _proceedToCheckout(BuildContext context) async {
    final validationError = ref.read(customizationServiceProvider).validateCustomization();
    
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    
    setState(() => isProcessing = true);
    
    try {
      await ref.read(customizationServiceProvider).saveCustomization();
      
      if (mounted) {
        // Navigate to cart or checkout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to cart successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to cart
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }
  
  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Customization Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Use the view selector to see different angles'),
              SizedBox(height: 8),
              Text('• Drag artwork to position it on the product'),
              SizedBox(height: 8),
              Text('• Pinch to zoom in/out on the product view'),
              SizedBox(height: 8),
              Text('• Switch between tabs to customize different aspects'),
              SizedBox(height: 8),
              Text('• Save your draft to continue later'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
  
  void _shareDesign(BuildContext context) {
    final json = ref.read(customizationServiceProvider).exportCustomization();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Share Design'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share your custom design with others'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.link, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'sawa.design/share/abc123',
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'sawa.design/share/abc123'));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Link copied to clipboard'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }
}

// Design Tab
class _DesignTab extends StatelessWidget {
  final ProductCustomization customization;
  final Function(ProductCustomization) onUpdate;
  
  const _DesignTab({
    Key? key,
    required this.customization,
    required this.onUpdate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dye type selector
          Text(
            'Dye Type',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...DyeType.options.map((dye) {
            final isSelected = customization.dyeType == dye.name;
            return GestureDetector(
              onTap: () => onUpdate(customization.copyWith(dyeType: dye.name)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dye.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dye.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (dye.priceModifier > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white24 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+€${dye.priceModifier.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 32),
          
          // Color selector
          Text(
            'Color',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ProductColor.defaultColors.length,
            itemBuilder: (context, index) {
              final color = ProductColor.defaultColors[index];
              final isSelected = customization.colorName == color.name;
              
              return GestureDetector(
                onTap: () => onUpdate(
                  customization.copyWith(
                    color: color.color,
                    colorName: color.name,
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: color.color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Selected color info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: customization.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customization.colorName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ProductColor.defaultColors
                            .firstWhere((c) => c.name == customization.colorName)
                            .hexCode,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Quantity selector
          Text(
            'Quantity',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: customization.quantity > 1
                    ? () => onUpdate(customization.copyWith(quantity: customization.quantity - 1))
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customization.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: customization.quantity < 10000
                    ? () => onUpdate(customization.copyWith(quantity: customization.quantity + 1))
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '€${customization.unitPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'per unit',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Volume discount indicator
          if (customization.quantity >= 50) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.discount_outlined,
                    size: 20,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    customization.quantity >= 100
                        ? '10% volume discount applied!'
                        : '5% volume discount applied!',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Artwork Tab
class _ArtworkTab extends StatefulWidget {
  final ProductCustomization customization;
  final Function(ProductCustomization) onUpdate;
  
  const _ArtworkTab({
    Key? key,
    required this.customization,
    required this.onUpdate,
  }) : super(key: key);
  
  @override
  State<_ArtworkTab> createState() => _ArtworkTabState();
}

class _ArtworkTabState extends State<_ArtworkTab> {
  bool isUploading = false;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Artwork',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          if (widget.customization.artworkUrl == null)
            // Upload area
            GestureDetector(
              onTap: _uploadArtwork,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: isUploading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Click or drag to upload',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'PNG, JPG, SVG up to 10MB',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            )
          else
            // Artwork preview
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.customization.artworkUrl!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () {
                            widget.onUpdate(
                              widget.customization.copyWith(artworkUrl: null),
                            );
                          },
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Artwork controls
                Text(
                  'Artwork Settings',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Placement area
                Text(
                  'Placement Area',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: PlacementArea.values.map((area) {
                    final isSelected = widget.customization.placementArea == area;
                    return ChoiceChip(
                      label: Text(area.name.replaceAll('_', ' ').toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          widget.onUpdate(
                            widget.customization.copyWith(placementArea: area),
                          );
                        }
                      },
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 20),
                
                // Scale slider
                Text(
                  'Size',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.photo_size_select_small, size: 20),
                    Expanded(
                      child: Slider(
                        value: widget.customization.artworkScale,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: '${(widget.customization.artworkScale * 100).round()}%',
                        onChanged: (value) {
                          widget.onUpdate(
                            widget.customization.copyWith(artworkScale: value),
                          );
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    const Icon(Icons.photo_size_select_large, size: 20),
                  ],
                ),
                
                // Rotation slider
                Text(
                  'Rotation',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.rotate_left, size: 20),
                    Expanded(
                      child: Slider(
                        value: widget.customization.artworkRotation,
                        min: -180,
                        max: 180,
                        divisions: 36,
                        label: '${widget.customization.artworkRotation.round()}°',
                        onChanged: (value) {
                          widget.onUpdate(
                            widget.customization.copyWith(artworkRotation: value),
                          );
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    const Icon(Icons.rotate_right, size: 20),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Reset button
                OutlinedButton.icon(
                  onPressed: () {
                    widget.onUpdate(
                      widget.customization.copyWith(
                        artworkPosition: Offset.zero,
                        artworkScale: 1.0,
                        artworkRotation: 0.0,
                      ),
                    );
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset Position'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 20),
          
          // Guidelines
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Artwork Guidelines',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Use high-resolution images (300 DPI)\n'
                  '• Transparent backgrounds work best\n'
                  '• Keep important elements away from edges\n'
                  '• Vector files (SVG) provide best quality',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.blue.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _uploadArtwork() async {
    setState(() => isUploading = true);
    
    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));
    
    widget.onUpdate(
      widget.customization.copyWith(
        artworkUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png',
      ),
    );
    
    setState(() => isUploading = false);
  }
}

// Label Tab
class _LabelTab extends StatelessWidget {
  final ProductCustomization customization;
  final Function(ProductCustomization) onUpdate;
  
  const _LabelTab({
    Key? key,
    required this.customization,
    required this.onUpdate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Label',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Toggle custom label
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SwitchListTile(
              title: Text(
                'Add Custom Neck Label',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                customization.customLabel
                    ? 'Your brand label will be sewn inside the neck'
                    : 'Standard manufacturer label',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              value: customization.customLabel,
              onChanged: (value) => onUpdate(
                customization.copyWith(customLabel: value),
              ),
              activeColor: Colors.black,
            ),
          ),
          
          if (customization.customLabel) ...[
            const SizedBox(height: 24),
            
            // Label text input
            Text(
              'Label Text',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: customization.labelText ?? '',
              onChanged: (value) => onUpdate(
                customization.copyWith(labelText: value),
              ),
              maxLength: 30,
              decoration: InputDecoration(
                hintText: 'Enter your brand name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: GoogleFonts.inter(fontSize: 16),
            ),
            
            const SizedBox(height: 24),
            
            // Label preview
            Text(
              'Label Preview',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
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
                    (customization.labelText?.isNotEmpty ?? false)
                        ? customization.labelText!.toUpperCase()
                        : 'YOUR BRAND',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Label info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Custom labels add a professional touch to your products. '
                      'They are printed on premium woven material and sewn securely inside the neck area.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.amber.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Other label options
          Text(
            'Additional Options',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.local_laundry_service),
                  title: const Text('Care Instructions'),
                  subtitle: const Text('Standard wash care symbols'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified),
                  title: const Text('Size Label'),
                  subtitle: const Text('Size tag on inner seam'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: const Text('QR Code Label'),
                  subtitle: const Text('Link to your website (Coming Soon)'),
                  trailing: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Summary Tab
class _SummaryTab extends StatelessWidget {
  final ProductCustomization customization;
  final Map<String, double> priceBreakdown;
  
  const _SummaryTab({
    Key? key,
    required this.customization,
    required this.priceBreakdown,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          
          // Product summary card
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
              children: [
                // Product preview
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: customization.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 40,
                          color: customization.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Custom Hoodie',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${customization.colorName} • ${customization.dyeType}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (customization.artworkUrl != null)
                            Text(
                              'With custom artwork',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                
                // Details
                _buildDetailRow('Quantity', customization.quantity.toString()),
                const SizedBox(height: 12),
                _buildDetailRow('Placement', customization.placementArea.name.replaceAll('_', ' ').toUpperCase()),
                const SizedBox(height: 12),
                _buildDetailRow('Custom Label', customization.customLabel ? 'Yes' : 'No'),
                if (customization.customLabel && customization.labelText != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Label Text', customization.labelText!),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Price breakdown
          Text(
            'Price Breakdown',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ...priceBreakdown.entries.where((e) => e.value != 0).map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        Text(
                          '€${entry.value.abs().toStringAsFixed(2)}${entry.value < 0 ? '-' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: entry.value < 0 ? FontWeight.w600 : FontWeight.w400,
                            color: entry.value < 0 ? Colors.green : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unit Price',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '€${customization.unitPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total (${customization.quantity} units)',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '€${customization.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Production info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 24,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Production Time',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '7-10 business days after approval',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Preview Screen
class _PreviewScreen extends StatelessWidget {
  final ProductCustomization customization;
  
  const _PreviewScreen({
    Key? key,
    required this.customization,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Preview'),
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              customization.color.withOpacity(0.8),
              BlendMode.modulate,
            ),
            child: Image.network(
              'https://i.imgur.com/Qp5mavE.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}