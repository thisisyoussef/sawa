import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class ProductImageViewer extends StatefulWidget {
  final String productType;
  final Color productColor;
  final String? artworkUrl;
  final Offset artworkPosition;
  final double artworkScale;
  final double artworkRotation;
  final String viewAngle;
  final bool showGrid;
  final Function(Offset)? onArtworkPositionChanged;
  final Function(double)? onArtworkScaleChanged;
  final Function(double)? onArtworkRotationChanged;
  
  const ProductImageViewer({
    Key? key,
    required this.productType,
    required this.productColor,
    this.artworkUrl,
    this.artworkPosition = Offset.zero,
    this.artworkScale = 1.0,
    this.artworkRotation = 0.0,
    this.viewAngle = 'front',
    this.showGrid = false,
    this.onArtworkPositionChanged,
    this.onArtworkScaleChanged,
    this.onArtworkRotationChanged,
  }) : super(key: key);
  
  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  
  TransformationController _transformationController = TransformationController();
  
  // Gesture states
  bool _isDraggingArtwork = false;
  Offset _lastFocalPoint = Offset.zero;
  double _lastScale = 1.0;
  double _lastRotation = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
    
    // Start subtle animation
    _bounceController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.showGrid) {
      return _buildGridView();
    } else {
      return _buildSingleView();
    }
  }
  
  Widget _buildSingleView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background effects
        _buildBackgroundEffects(),
        
        // Main product view
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: _buildProductView(),
            );
          },
        ),
        
        // Controls overlay
        _buildControlsOverlay(),
      ],
    );
  }
  
  Widget _buildGridView() {
    final views = ['front', 'back', 'left_sleeve', 'right_sleeve'];
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: views.length,
      itemBuilder: (context, index) {
        final view = views[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.productColor.withOpacity(0.8),
                      BlendMode.modulate,
                    ),
                    child: _getProductImage(view),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  view.replaceAll('_', ' ').toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _BackgroundPatternPainter(
          color: widget.productColor.withOpacity(0.05),
        ),
      ),
    );
  }
  
  Widget _buildProductView() {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow effect
            Transform.translate(
              offset: const Offset(0, 20),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // Product image
            InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(40),
              minScale: 0.5,
              maxScale: 3.0,
              child: Hero(
                tag: 'product-${widget.viewAngle}',
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.productColor.withOpacity(0.8),
                    BlendMode.modulate,
                  ),
                  child: _getProductImage(widget.viewAngle),
                ),
              ),
            ),
            
            // Artwork overlay
            if (widget.artworkUrl != null)
              Positioned(
                left: 150 + widget.artworkPosition.dx,
                top: 150 + widget.artworkPosition.dy,
                child: _buildArtworkOverlay(),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildArtworkOverlay() {
    return GestureDetector(
      onPanStart: (_) => setState(() => _isDraggingArtwork = true),
      onPanUpdate: (details) {
        widget.onArtworkPositionChanged?.call(
          widget.artworkPosition + details.delta,
        );
      },
      onPanEnd: (_) => setState(() => _isDraggingArtwork = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDraggingArtwork
                ? Colors.blue
                : Colors.blue.withOpacity(0.3),
            width: _isDraggingArtwork ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isDraggingArtwork
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Transform.scale(
          scale: widget.artworkScale,
          child: Transform.rotate(
            angle: widget.artworkRotation * math.pi / 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.artworkUrl!,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildControlsOverlay() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Column(
        children: [
          // 3D rotation toggle
          _ControlButton(
            icon: Icons.threed_rotation,
            onPressed: () {
              if (_rotationController.isAnimating) {
                _rotationController.stop();
              } else {
                _rotationController.repeat();
              }
              setState(() {});
            },
            isActive: _rotationController.isAnimating,
            tooltip: '3D Rotation',
          ),
          
          const SizedBox(height: 12),
          
          // Reset view
          _ControlButton(
            icon: Icons.center_focus_strong,
            onPressed: () {
              _transformationController.value = Matrix4.identity();
              widget.onArtworkPositionChanged?.call(Offset.zero);
              widget.onArtworkScaleChanged?.call(1.0);
              widget.onArtworkRotationChanged?.call(0.0);
            },
            tooltip: 'Reset View',
          ),
          
          const SizedBox(height: 12),
          
          // Screenshot
          _ControlButton(
            icon: Icons.camera_alt_outlined,
            onPressed: _takeScreenshot,
            tooltip: 'Take Screenshot',
          ),
        ],
      ),
    );
  }
  
  Widget _getProductImage(String view) {
    // Map product images based on type and view
    final imageMap = {
      'hoodie': {
        'front': 'https://i.imgur.com/Qp5mavE.png',
        'back': 'https://i.imgur.com/VXeNKxb.png',
        'left_sleeve': 'https://i.imgur.com/kcC1rJI.png',
        'right_sleeve': 'https://i.imgur.com/kcC1rJI.png',
      },
      't-shirt': {
        'front': 'https://i.imgur.com/tshirt-front.png',
        'back': 'https://i.imgur.com/tshirt-back.png',
        'left_sleeve': 'https://i.imgur.com/tshirt-sleeve.png',
        'right_sleeve': 'https://i.imgur.com/tshirt-sleeve.png',
      },
    };
    
    final productImages = imageMap[widget.productType] ?? imageMap['hoodie']!;
    final imageUrl = productImages[view] ?? productImages['front']!;
    
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 64,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
  
  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _lastScale = widget.artworkScale;
    _lastRotation = widget.artworkRotation;
  }
  
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (widget.artworkUrl == null) return;
    
    // Handle rotation
    if (details.scale != 1.0) {
      final newScale = (_lastScale * details.scale).clamp(0.5, 2.0);
      widget.onArtworkScaleChanged?.call(newScale);
    }
    
    // Handle rotation with two fingers
    if (details.rotation != 0.0) {
      final newRotation = _lastRotation + details.rotation * 180 / math.pi;
      widget.onArtworkRotationChanged?.call(newRotation);
    }
  }
  
  void _handleScaleEnd(ScaleEndDetails details) {
    // Optional: Add momentum or snap-to-grid behavior
  }
  
  void _takeScreenshot() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Screenshot saved to gallery'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final String tooltip;
  
  const _ControlButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    required this.tooltip,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive ? Colors.black : Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 24,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  final Color color;
  
  _BackgroundPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    const dotRadius = 2.0;
    const spacing = 30.0;
    
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}