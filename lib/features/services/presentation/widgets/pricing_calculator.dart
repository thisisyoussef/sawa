import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';

class PricingCalculator extends StatefulWidget {
  final String selectedService;
  final int selectedQuantity;
  final double estimatedPrice;
  final Map<String, Map<String, dynamic>> services;
  final Function(String) onServiceChanged;
  final Function(int) onQuantityChanged;

  const PricingCalculator({
    Key? key,
    required this.selectedService,
    required this.selectedQuantity,
    required this.estimatedPrice,
    required this.services,
    required this.onServiceChanged,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<PricingCalculator> createState() => _PricingCalculatorState();
}

class _PricingCalculatorState extends State<PricingCalculator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  final List<int> _quantityOptions = [50, 100, 250, 500, 1000, 2500];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _triggerPulse() {
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  double _getDiscountRate() {
    if (widget.selectedQuantity >= 1000) return 0.20;
    if (widget.selectedQuantity >= 500) return 0.15;
    if (widget.selectedQuantity >= 250) return 0.10;
    if (widget.selectedQuantity >= 100) return 0.05;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.all(design.Spacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(design.Borders.xl),
          boxShadow: design.Shadows.medium,
        ),
        child: Column(
          children: [
            // Service selector
            _buildServiceSelector(isMobile),
            SizedBox(height: design.Spacing.xl),

            // Quantity slider
            _buildQuantitySelector(isMobile),
            SizedBox(height: design.Spacing.xl),

            // Price breakdown
            _buildPriceBreakdown(isMobile),
            SizedBox(height: design.Spacing.xl),

            // Volume discount info
            _buildVolumeDiscountInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelector(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Service Type',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: design.Spacing.md),

        isMobile
            ? _buildMobileServiceSelector()
            : _buildDesktopServiceSelector(),
      ],
    );
  }

  Widget _buildMobileServiceSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: design.Spacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(design.Borders.md),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.selectedService,
          isExpanded: true,
          onChanged: (String? value) {
            if (value != null) {
              widget.onServiceChanged(value);
              _triggerPulse();
            }
          },
          items: widget.services.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Text(entry.value['icon'], style: TextStyle(fontSize: 20)),
                  SizedBox(width: design.Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value['name'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'from €${entry.value['basePrice'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDesktopServiceSelector() {
    return Wrap(
      spacing: design.Spacing.md,
      runSpacing: design.Spacing.md,
      children: widget.services.entries.map((entry) {
        final isSelected = entry.key == widget.selectedService;
        return GestureDetector(
          onTap: () {
            widget.onServiceChanged(entry.key);
            _triggerPulse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(design.Spacing.lg),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey[50],
              borderRadius: BorderRadius.circular(design.Borders.md),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  entry.value['icon'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: design.Spacing.sm),
                Text(
                  entry.value['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'from €${entry.value['basePrice'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantitySelector(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.Spacing.md,
                vertical: design.Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(design.Borders.lg),
              ),
              child: Text(
                '${widget.selectedQuantity} pieces',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: design.Spacing.lg),

        // Quantity slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.black,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: widget.selectedQuantity.toDouble(),
            min: 50,
            max: 2500,
            divisions: _quantityOptions.length - 1,
            onChanged: (value) {
              // Find the closest quantity option
              final closest = _quantityOptions.reduce((a, b) => 
                (value - a).abs() < (value - b).abs() ? a : b);
              widget.onQuantityChanged(closest);
              _triggerPulse();
            },
          ),
        ),

        // Quantity quick selectors
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _quantityOptions.map((qty) {
            final isSelected = qty == widget.selectedQuantity;
            return GestureDetector(
              onTap: () {
                widget.onQuantityChanged(qty);
                _triggerPulse();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.Spacing.sm,
                  vertical: design.Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(design.Borders.sm),
                ),
                child: Text(
                  qty >= 1000 ? '${qty ~/ 1000}k' : '$qty',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown(bool isMobile) {
    final service = widget.services[widget.selectedService]!;
    final basePrice = service['basePrice'] * widget.selectedQuantity;
    final discountRate = _getDiscountRate();
    final discount = basePrice * discountRate;
    final finalPrice = basePrice - discount;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.all(design.Spacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1a1a1a),
                  const Color(0xFF2d2d2d),
                ],
              ),
              borderRadius: BorderRadius.circular(design.Borders.lg),
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Breakdown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (discountRate > 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.Spacing.sm,
                          vertical: design.Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(design.Borders.sm),
                        ),
                        child: Text(
                          '${(discountRate * 100).toInt()}% OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: design.Spacing.md),

                // Base price
                _buildPriceRow(
                  'Base Price',
                  '€${basePrice.toStringAsFixed(2)}',
                  Colors.white70,
                ),

                // Discount
                if (discountRate > 0)
                  _buildPriceRow(
                    'Volume Discount',
                    '-€${discount.toStringAsFixed(2)}',
                    Colors.green,
                  ),

                Divider(color: Colors.white30),

                // Final price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Estimated Cost',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '€${finalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: design.Spacing.sm),

                // Unit price
                Text(
                  '€${(finalPrice / widget.selectedQuantity).toStringAsFixed(2)} per piece',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceRow(String label, String price, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.Spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14),
          ),
          Text(
            price,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeDiscountInfo() {
    return Container(
      padding: EdgeInsets.all(design.Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(design.Borders.md),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
              SizedBox(width: design.Spacing.sm),
              Text(
                'Volume Discounts Available',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: design.Spacing.sm),

          Wrap(
            spacing: design.Spacing.lg,
            runSpacing: design.Spacing.sm,
            children: [
              _buildDiscountTier('100+', '5%'),
              _buildDiscountTier('250+', '10%'),
              _buildDiscountTier('500+', '15%'),
              _buildDiscountTier('1000+', '20%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountTier(String quantity, String discount) {
    final isActive = widget.selectedQuantity >= int.parse(quantity.replaceAll('+', ''));
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.Spacing.md,
        vertical: design.Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[600] : Colors.blue[100],
        borderRadius: BorderRadius.circular(design.Borders.sm),
      ),
      child: Text(
        '$quantity pieces: $discount off',
        style: TextStyle(
          color: isActive ? Colors.white : Colors.blue[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}