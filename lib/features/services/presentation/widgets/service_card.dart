import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/theme/animation_extensions.dart';

class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  final String serviceKey;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.serviceKey,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(design.Borders.lg),
                  border: Border.all(
                    color: widget.isSelected 
                        ? Colors.black 
                        : Colors.grey.withOpacity(0.2),
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05 + (_elevationAnimation.value * 0.1)),
                      blurRadius: 10 + (_elevationAnimation.value * 20),
                      offset: Offset(0, 5 + (_elevationAnimation.value * 10)),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service image with overlay
                    Expanded(
                      flex: 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          Image.network(
                            widget.service['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    widget.service['icon'],
                                    style: TextStyle(fontSize: 48),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Gradient overlay
                          Container(
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

                          // Service icon and price
                          Positioned(
                            top: design.Spacing.lg,
                            left: design.Spacing.lg,
                            child: Container(
                              padding: EdgeInsets.all(design.Spacing.sm),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: design.Shadows.subtle,
                              ),
                              child: Text(
                                widget.service['icon'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),

                          // Price badge
                          Positioned(
                            top: design.Spacing.lg,
                            right: design.Spacing.lg,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.Spacing.md,
                                vertical: design.Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(design.Borders.lg),
                              ),
                              child: Text(
                                'from €${widget.service['basePrice'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),

                          // Selected indicator
                          if (widget.isSelected)
                            Positioned(
                              bottom: design.Spacing.lg,
                              right: design.Spacing.lg,
                              child: Container(
                                padding: EdgeInsets.all(design.Spacing.xs),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Service details
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(design.Spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Service name
                            Text(
                              widget.service['name'],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: widget.isSelected ? Colors.black : null,
                              ),
                            ),
                            SizedBox(height: design.Spacing.xs),

                            // Description
                            Text(
                              widget.service['description'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: design.Spacing.md),

                            // Features list
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.service['features']
                                    .take(3)
                                    .map<Widget>((feature) => Padding(
                                          padding: EdgeInsets.only(bottom: design.Spacing.xs),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 4,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: widget.isSelected 
                                                      ? Colors.black 
                                                      : Colors.grey[400],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: design.Spacing.sm),
                                              Expanded(
                                                child: Text(
                                                  feature,
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),

                            // Select button or selected indicator
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              height: 36,
                              decoration: BoxDecoration(
                                color: widget.isSelected 
                                    ? Colors.black 
                                    : (_isHovered ? Colors.grey[100] : Colors.transparent),
                                borderRadius: BorderRadius.circular(design.Borders.sm),
                                border: widget.isSelected 
                                    ? null 
                                    : Border.all(color: Colors.grey[300]!),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.isSelected ? 'Selected' : 'Select Service',
                                style: TextStyle(
                                  color: widget.isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}