import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Represents a customization for a product
@immutable
class ProductCustomization {
  const ProductCustomization({
    required this.id,
    required this.productId,
    required this.color,
    required this.colorName,
    required this.dyeType,
    this.artworkUrl,
    this.artworkPosition = Offset.zero,
    this.artworkScale = 1.0,
    this.artworkRotation = 0.0,
    this.customLabel = false,
    this.labelText,
    this.quantity = 1,
    this.placementArea = PlacementArea.front,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String productId;
  final Color color;
  final String colorName;
  final String dyeType;
  final String? artworkUrl;
  final Offset artworkPosition;
  final double artworkScale;
  final double artworkRotation;
  final bool customLabel;
  final String? labelText;
  final int quantity;
  final PlacementArea placementArea;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get totalPrice => unitPrice * quantity;
  
  double get unitPrice {
    // Base price calculation logic
    double base = 38.5;
    if (dyeType == 'Premium Pigment Dye') base += 5.0;
    if (customLabel) base += 2.5;
    if (artworkUrl != null) base += 3.0;
    
    // Volume discounts
    if (quantity >= 100) base *= 0.9;
    else if (quantity >= 50) base *= 0.95;
    
    return base;
  }

  ProductCustomization copyWith({
    String? id,
    String? productId,
    Color? color,
    String? colorName,
    String? dyeType,
    String? artworkUrl,
    Offset? artworkPosition,
    double? artworkScale,
    double? artworkRotation,
    bool? customLabel,
    String? labelText,
    int? quantity,
    PlacementArea? placementArea,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductCustomization(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      color: color ?? this.color,
      colorName: colorName ?? this.colorName,
      dyeType: dyeType ?? this.dyeType,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      artworkPosition: artworkPosition ?? this.artworkPosition,
      artworkScale: artworkScale ?? this.artworkScale,
      artworkRotation: artworkRotation ?? this.artworkRotation,
      customLabel: customLabel ?? this.customLabel,
      labelText: labelText ?? this.labelText,
      quantity: quantity ?? this.quantity,
      placementArea: placementArea ?? this.placementArea,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'color': color.value,
      'colorName': colorName,
      'dyeType': dyeType,
      'artworkUrl': artworkUrl,
      'artworkPosition': {
        'dx': artworkPosition.dx,
        'dy': artworkPosition.dy,
      },
      'artworkScale': artworkScale,
      'artworkRotation': artworkRotation,
      'customLabel': customLabel,
      'labelText': labelText,
      'quantity': quantity,
      'placementArea': placementArea.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ProductCustomization.fromJson(Map<String, dynamic> json) {
    return ProductCustomization(
      id: json['id'] as String,
      productId: json['productId'] as String,
      color: Color(json['color'] as int),
      colorName: json['colorName'] as String,
      dyeType: json['dyeType'] as String,
      artworkUrl: json['artworkUrl'] as String?,
      artworkPosition: Offset(
        (json['artworkPosition']['dx'] as num).toDouble(),
        (json['artworkPosition']['dy'] as num).toDouble(),
      ),
      artworkScale: (json['artworkScale'] as num).toDouble(),
      artworkRotation: (json['artworkRotation'] as num).toDouble(),
      customLabel: json['customLabel'] as bool,
      labelText: json['labelText'] as String?,
      quantity: json['quantity'] as int,
      placementArea: PlacementArea.values.firstWhere(
        (e) => e.name == json['placementArea'],
        orElse: () => PlacementArea.front,
      ),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

enum PlacementArea {
  front,
  back,
  leftSleeve,
  rightSleeve,
  neck,
}

/// Available color options for products
class ProductColor {
  const ProductColor({
    required this.name,
    required this.color,
    required this.hexCode,
    this.isAvailable = true,
  });

  final String name;
  final Color color;
  final String hexCode;
  final bool isAvailable;

  static const List<ProductColor> defaultColors = [
    ProductColor(
      name: 'Bright White',
      color: Colors.white,
      hexCode: '#FFFFFF',
    ),
    ProductColor(
      name: 'True Black',
      color: Colors.black,
      hexCode: '#000000',
    ),
    ProductColor(
      name: 'Indian Almond',
      color: Color(0xFF8B8578),
      hexCode: '#8B8578',
    ),
    ProductColor(
      name: 'Buffalo Chip',
      color: Color(0xFF7B5E57),
      hexCode: '#7B5E57',
    ),
    ProductColor(
      name: 'Silver Bullet',
      color: Color(0xFFB0B7C3),
      hexCode: '#B0B7C3',
    ),
    ProductColor(
      name: 'Amparo Blue',
      color: Color(0xFF4969B1),
      hexCode: '#4969B1',
    ),
    ProductColor(
      name: 'Ecru',
      color: Color(0xFFF5E9DA),
      hexCode: '#F5E9DA',
    ),
    ProductColor(
      name: 'Oat Milk',
      color: Color(0xFFF3E5C2),
      hexCode: '#F3E5C2',
    ),
    ProductColor(
      name: 'Coca Mocha',
      color: Color(0xFF7B4B3A),
      hexCode: '#7B4B3A',
    ),
    ProductColor(
      name: 'Glacier Lake',
      color: Color(0xFFB6D6E1),
      hexCode: '#B6D6E1',
    ),
    ProductColor(
      name: 'Deep Periwinkle',
      color: Color(0xFF6C7BAE),
      hexCode: '#6C7BAE',
    ),
    ProductColor(
      name: 'Blue Ribbon',
      color: Color(0xFF1A237E),
      hexCode: '#1A237E',
    ),
    ProductColor(
      name: 'Forest Green',
      color: Color(0xFF2C5F2D),
      hexCode: '#2C5F2D',
    ),
    ProductColor(
      name: 'Sage',
      color: Color(0xFF97BC62),
      hexCode: '#97BC62',
    ),
    ProductColor(
      name: 'Dusty Rose',
      color: Color(0xFFDCB8B0),
      hexCode: '#DCB8B0',
    ),
    ProductColor(
      name: 'Burgundy',
      color: Color(0xFF800020),
      hexCode: '#800020',
    ),
  ];
}

/// Dye type options
class DyeType {
  const DyeType({
    required this.id,
    required this.name,
    required this.description,
    required this.priceModifier,
  });

  final String id;
  final String name;
  final String description;
  final double priceModifier;

  static const List<DyeType> options = [
    DyeType(
      id: 'standard',
      name: 'Standard Garment Dye',
      description: 'Classic dye process for vibrant, long-lasting colors',
      priceModifier: 0.0,
    ),
    DyeType(
      id: 'premium',
      name: 'Premium Pigment Dye',
      description: 'Vintage wash effect with unique color variations',
      priceModifier: 5.0,
    ),
    DyeType(
      id: 'eco',
      name: 'Eco-Friendly Dye',
      description: 'Sustainable dye process using natural materials',
      priceModifier: 7.5,
    ),
  ];
}