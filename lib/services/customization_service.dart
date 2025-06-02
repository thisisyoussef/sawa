import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product_customization.dart';
import 'package:path_provider/path_provider.dart';

/// Service for managing product customizations
class CustomizationService extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<ProductCustomization> _customizations = [];
  ProductCustomization? _currentCustomization;
  
  // Get all customizations
  List<ProductCustomization> get customizations => List.unmodifiable(_customizations);
  
  // Get current customization
  ProductCustomization? get currentCustomization => _currentCustomization;
  
  // Create a new customization
  ProductCustomization createNewCustomization(String productId) {
    final customization = ProductCustomization(
      id: _uuid.v4(),
      productId: productId,
      color: ProductColor.defaultColors.first.color,
      colorName: ProductColor.defaultColors.first.name,
      dyeType: DyeType.options.first.name,
      quantity: 50,
      placementArea: PlacementArea.front,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _currentCustomization = customization;
    notifyListeners();
    return customization;
  }
  
  // Update current customization
  void updateCurrentCustomization(ProductCustomization customization) {
    _currentCustomization = customization.copyWith(
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }
  
  // Save customization
  Future<void> saveCustomization() async {
    if (_currentCustomization == null) return;
    
    // Check if it already exists
    final existingIndex = _customizations.indexWhere(
      (c) => c.id == _currentCustomization!.id,
    );
    
    if (existingIndex >= 0) {
      _customizations[existingIndex] = _currentCustomization!;
    } else {
      _customizations.add(_currentCustomization!);
    }
    
    // Save to local storage
    await _saveToLocalStorage();
    notifyListeners();
  }
  
  // Delete customization
  void deleteCustomization(String id) {
    _customizations.removeWhere((c) => c.id == id);
    if (_currentCustomization?.id == id) {
      _currentCustomization = null;
    }
    _saveToLocalStorage();
    notifyListeners();
  }
  
  // Load customization for editing
  void loadCustomization(String id) {
    final customization = _customizations.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Customization not found'),
    );
    _currentCustomization = customization;
    notifyListeners();
  }
  
  // Save to local storage
  Future<void> _saveToLocalStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/customizations.json');
      final json = jsonEncode(
        _customizations.map((c) => c.toJson()).toList(),
      );
      await file.writeAsString(json);
    } catch (e) {
      debugPrint('Error saving customizations: $e');
    }
  }
  
  // Load from local storage
  Future<void> loadFromLocalStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/customizations.json');
      
      if (await file.exists()) {
        final json = await file.readAsString();
        final List<dynamic> data = jsonDecode(json);
        _customizations.clear();
        _customizations.addAll(
          data.map((item) => ProductCustomization.fromJson(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading customizations: $e');
    }
  }
  
  // Calculate price breakdown
  Map<String, double> getPriceBreakdown() {
    if (_currentCustomization == null) return {};
    
    final customization = _currentCustomization!;
    final basePrice = 38.5;
    final dyePriceModifier = DyeType.options
        .firstWhere((d) => d.name == customization.dyeType)
        .priceModifier;
    
    return {
      'Base Price': basePrice,
      'Dye Type': dyePriceModifier,
      'Custom Label': customization.customLabel ? 2.5 : 0.0,
      'Artwork': customization.artworkUrl != null ? 3.0 : 0.0,
      'Volume Discount': customization.quantity >= 100 
          ? -(basePrice * 0.1) 
          : customization.quantity >= 50 
              ? -(basePrice * 0.05) 
              : 0.0,
    };
  }
  
  // Validate customization
  String? validateCustomization() {
    if (_currentCustomization == null) return 'No customization found';
    
    final customization = _currentCustomization!;
    
    if (customization.quantity < 1) {
      return 'Quantity must be at least 1';
    }
    
    if (customization.quantity > 10000) {
      return 'Maximum quantity is 10,000';
    }
    
    if (customization.customLabel && 
        (customization.labelText == null || customization.labelText!.isEmpty)) {
      return 'Please provide label text for custom label';
    }
    
    return null; // Valid
  }
  
  // Export customization as JSON
  String exportCustomization() {
    if (_currentCustomization == null) return '{}';
    return jsonEncode(_currentCustomization!.toJson());
  }
  
  // Import customization from JSON
  void importCustomization(String json) {
    try {
      final data = jsonDecode(json);
      _currentCustomization = ProductCustomization.fromJson(data);
      notifyListeners();
    } catch (e) {
      throw Exception('Invalid customization data');
    }
  }
}