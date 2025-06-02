import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';

class QuoteBuilder extends StatefulWidget {
  final bool isMobile;

  const QuoteBuilder({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<QuoteBuilder> createState() => _QuoteBuilderState();
}

class _QuoteBuilderState extends State<QuoteBuilder>
    with TickerProviderStateMixin {
  late AnimationController _dropController;
  late AnimationController _totalController;
  late Animation<double> _dropAnimation;
  late Animation<double> _totalPulseAnimation;

  final List<Map<String, dynamic>> _availableServices = [
    {
      'id': 'screen-print',
      'name': 'Screen Printing',
      'icon': '🎨',
      'basePrice': 18.50,
      'description': '1-6 colors on front/back',
    },
    {
      'id': 'dtg',
      'name': 'DTG Printing',
      'icon': '🖨️',
      'basePrice': 24.95,
      'description': 'Full-color photo quality',
    },
    {
      'id': 'embroidery',
      'name': 'Embroidery',
      'icon': '🧵',
      'basePrice': 32.50,
      'description': 'Premium stitched finish',
    },
    {
      'id': 'patches',
      'name': 'Custom Patches',
      'icon': '🏷️',
      'basePrice': 8.75,
      'description': 'Woven or PVC patches',
    },
    {
      'id': 'labels',
      'name': 'Custom Labels',
      'icon': '📍',
      'basePrice': 3.50,
      'description': 'Neck/care labels',
    },
    {
      'id': 'packaging',
      'name': 'Custom Packaging',
      'icon': '📦',
      'basePrice': 2.25,
      'description': 'Branded poly bags/boxes',
    },
  ];

  final List<Map<String, dynamic>> _selectedServices = [];
  int _quantity = 100;
  String _productType = 'hoodies';
  bool _rushOrder = false;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _totalController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dropAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.elasticOut),
    );

    _totalPulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _totalController, curve: Curves.easeInOut),
    );

    _calculateTotal();
  }

  @override
  void dispose() {
    _dropController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _addService(Map<String, dynamic> service) {
    setState(() {
      _selectedServices.add({...service, 'quantity': 1});
    });
    _dropController.forward().then((_) => _dropController.reset());
    _calculateTotal();
  }

  void _removeService(int index) {
    setState(() {
      _selectedServices.removeAt(index);
    });
    _calculateTotal();
  }

  void _updateServiceQuantity(int index, int quantity) {
    setState(() {
      _selectedServices[index]['quantity'] = quantity;
    });
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0.0;
    
    for (final service in _selectedServices) {
      total += (service['basePrice'] as double) * (service['quantity'] as int);
    }

    // Apply quantity discounts
    double discount = 1.0;
    if (_quantity >= 1000) discount = 0.80;
    else if (_quantity >= 500) discount = 0.85;
    else if (_quantity >= 250) discount = 0.90;
    else if (_quantity >= 100) discount = 0.95;

    total *= _quantity * discount;

    // Rush order fee
    if (_rushOrder) {
      total *= 1.25; // 25% rush fee
    }

    setState(() {
      _totalPrice = total;
    });

    _totalController.forward().then((_) => _totalController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(design.Spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(design.Borders.xl),
        boxShadow: design.Shadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Build Your Quote',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Drag services to your cart and configure options',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Total price display
              AnimatedBuilder(
                animation: _totalPulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _totalPulseAnimation.value,
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
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '€${_totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: design.Spacing.xl),

          // Configuration options
          _buildConfigurationSection(),

          SizedBox(height: design.Spacing.xl),

          // Service selection area
          widget.isMobile
              ? _buildMobileServiceBuilder()
              : _buildDesktopServiceBuilder(),

          SizedBox(height: design.Spacing.xl),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Container(
      padding: EdgeInsets.all(design.Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(design.Borders.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: design.Spacing.md),

          // Product type and quantity
          Row(
            children: [
              // Product type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: design.Spacing.xs),
                    DropdownButtonFormField<String>(
                      value: _productType,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: design.Spacing.md,
                          vertical: design.Spacing.sm,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(design.Borders.sm),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(value: 'hoodies', child: Text('Hoodies')),
                        DropdownMenuItem(value: 'tshirts', child: Text('T-Shirts')),
                        DropdownMenuItem(value: 'sweatshirts', child: Text('Sweatshirts')),
                        DropdownMenuItem(value: 'caps', child: Text('Caps')),
                      ],
                      onChanged: (value) {
                        setState(() => _productType = value!);
                        _calculateTotal();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: design.Spacing.lg),

              // Quantity
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: design.Spacing.xs),
                    DropdownButtonFormField<int>(
                      value: _quantity,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: design.Spacing.md,
                          vertical: design.Spacing.sm,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(design.Borders.sm),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [50, 100, 250, 500, 1000, 2500]
                          .map((qty) => DropdownMenuItem(
                                value: qty,
                                child: Text('$qty pieces'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _quantity = value!);
                        _calculateTotal();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: design.Spacing.md),

          // Rush order toggle
          Row(
            children: [
              Switch(
                value: _rushOrder,
                onChanged: (value) {
                  setState(() => _rushOrder = value);
                  _calculateTotal();
                },
                activeColor: Colors.orange,
              ),
              SizedBox(width: design.Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rush Order (+25%)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _rushOrder ? Colors.orange : Colors.grey[700],
                      ),
                    ),
                    Text(
                      '3-5 day delivery instead of 7-10 days',
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
        ],
      ),
    );
  }

  Widget _buildDesktopServiceBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available services
        Expanded(
          flex: 1,
          child: _buildAvailableServices(),
        ),

        SizedBox(width: design.Spacing.xl),

        // Selected services (drop zone)
        Expanded(
          flex: 1,
          child: _buildSelectedServices(),
        ),
      ],
    );
  }

  Widget _buildMobileServiceBuilder() {
    return Column(
      children: [
        _buildAvailableServices(),
        SizedBox(height: design.Spacing.xl),
        _buildSelectedServices(),
      ],
    );
  }

  Widget _buildAvailableServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Services',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: design.Spacing.md),

        ...List.generate(_availableServices.length, (index) {
          final service = _availableServices[index];
          final isAdded = _selectedServices.any((s) => s['id'] == service['id']);

          return AnimatedReveal(
            delay: Duration(milliseconds: 50 * index),
            child: Container(
              margin: EdgeInsets.only(bottom: design.Spacing.md),
              child: Draggable<Map<String, dynamic>>(
                data: service,
                feedback: _buildServiceCard(service, true, true),
                childWhenDragging: _buildServiceCard(service, true, false, opacity: 0.5),
                child: GestureDetector(
                  onTap: isAdded ? null : () => _addService(service),
                  child: _buildServiceCard(service, isAdded, false),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSelectedServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Your Quote',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: design.Spacing.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.Spacing.sm,
                vertical: design.Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(design.Borders.lg),
              ),
              child: Text(
                '${_selectedServices.length}',
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

        // Drop zone
        DragTarget<Map<String, dynamic>>(
          onAccept: (service) {
            _addService(service);
          },
          builder: (context, candidateData, rejectedData) {
            final isHighlighted = candidateData.isNotEmpty;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: _selectedServices.isEmpty ? 200 : null,
              padding: EdgeInsets.all(design.Spacing.lg),
              decoration: BoxDecoration(
                color: isHighlighted 
                    ? Colors.blue.withOpacity(0.1) 
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(design.Borders.lg),
                border: Border.all(
                  color: isHighlighted 
                      ? Colors.blue 
                      : (_selectedServices.isEmpty ? Colors.grey[300]! : Colors.transparent),
                  width: 2,
                  style: _selectedServices.isEmpty ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: _selectedServices.isEmpty
                  ? _buildEmptyDropZone(isHighlighted)
                  : _buildSelectedServicesList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyDropZone(bool isHighlighted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _dropAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_dropAnimation.value * 0.1),
              child: Icon(
                Icons.add_circle_outline,
                size: 48,
                color: isHighlighted ? Colors.blue : Colors.grey[400],
              ),
            );
          },
        ),
        SizedBox(height: design.Spacing.md),
        Text(
          isHighlighted ? 'Drop service here' : 'Drag services here to build your quote',
          style: TextStyle(
            color: isHighlighted ? Colors.blue : Colors.grey[600],
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectedServicesList() {
    return Column(
      children: List.generate(_selectedServices.length, (index) {
        final service = _selectedServices[index];
        return Container(
          margin: EdgeInsets.only(bottom: design.Spacing.md),
          padding: EdgeInsets.all(design.Spacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(design.Borders.md),
            boxShadow: design.Shadows.subtle,
          ),
          child: Row(
            children: [
              // Service info
              Text(service['icon'], style: TextStyle(fontSize: 20)),
              SizedBox(width: design.Spacing.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '€${service['basePrice'].toStringAsFixed(2)} per piece',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Quantity controls
              Row(
                children: [
                  IconButton(
                    onPressed: service['quantity'] > 1 
                        ? () => _updateServiceQuantity(index, service['quantity'] - 1)
                        : null,
                    icon: Icon(Icons.remove_circle_outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  
                  Container(
                    width: 30,
                    child: Text(
                      '${service['quantity']}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  IconButton(
                    onPressed: () => _updateServiceQuantity(index, service['quantity'] + 1),
                    icon: Icon(Icons.add_circle_outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),

              // Remove button
              IconButton(
                onPressed: () => _removeService(index),
                icon: Icon(Icons.close, size: 20, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildServiceCard(
    Map<String, dynamic> service,
    bool isAdded,
    bool isDragging, {
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: isDragging ? 200 : double.infinity,
        padding: EdgeInsets.all(design.Spacing.md),
        decoration: BoxDecoration(
          color: isAdded ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(design.Borders.md),
          border: Border.all(
            color: isAdded ? Colors.grey[400]! : Colors.grey[300]!,
          ),
          boxShadow: isDragging ? design.Shadows.medium : design.Shadows.subtle,
        ),
        child: Row(
          children: [
            Text(service['icon'], style: TextStyle(fontSize: 20)),
            SizedBox(width: design.Spacing.md),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isAdded ? Colors.grey[600] : Colors.black,
                    ),
                  ),
                  Text(
                    service['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '€${service['basePrice'].toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isAdded ? Colors.grey[600] : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedServices.clear();
                _quantity = 100;
                _productType = 'hoodies';
                _rushOrder = false;
              });
              _calculateTotal();
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: design.Spacing.lg),
            ),
            child: Text('Clear All'),
          ),
        ),
        
        SizedBox(width: design.Spacing.lg),
        
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _selectedServices.isNotEmpty ? () {
              _showQuoteDialog();
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: design.Spacing.lg),
            ),
            child: Text(
              'Request Detailed Quote',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void _showQuoteDialog() {
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
                          'Quote Summary',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${_selectedServices.length} services • $_quantity pieces',
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

              // Total
              Container(
                padding: EdgeInsets.all(design.Spacing.lg),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(design.Borders.lg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '€${_totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: design.Spacing.lg),

              Text(
                'A detailed quote with exact pricing will be sent to your email within 2 hours.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
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
                      child: Text('Continue Building'),
                    ),
                  ),
                  SizedBox(width: design.Spacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigate to contact form
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Send Quote'),
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