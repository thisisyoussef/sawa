import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sawa/features/product_customization/presentation/screens/enhanced_customize_screen.dart';
import 'package:sawa/models/product_customization.dart';
import 'package:sawa/services/customization_service.dart';

void main() {
  group('Enhanced Customize Screen Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });
    
    tearDown(() {
      container.dispose();
    });
    
    testWidgets('Screen loads with initial customization', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify screen title
      expect(find.text('Customizing'), findsOneWidget);
      expect(find.text('Test Hoodie'), findsOneWidget);
      
      // Verify tabs are present
      expect(find.text('Design'), findsOneWidget);
      expect(find.text('Artwork'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Summary'), findsOneWidget);
    });
    
    testWidgets('Color selection updates customization', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Find and tap a color swatch
      final colorSwatches = find.byType(GestureDetector);
      expect(colorSwatches, findsWidgets);
      
      // Tap on a different color (assuming there are multiple)
      await tester.tap(colorSwatches.at(3));
      await tester.pumpAndSettle();
      
      // Verify color selection feedback
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
    
    testWidgets('Quantity selector works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Find quantity controls
      final addButton = find.byIcon(Icons.add_circle_outline);
      final removeButton = find.byIcon(Icons.remove_circle_outline);
      
      expect(addButton, findsOneWidget);
      expect(removeButton, findsOneWidget);
      
      // Increase quantity
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      
      // Verify quantity increased
      expect(find.text('51'), findsOneWidget);
      
      // Decrease quantity
      await tester.tap(removeButton);
      await tester.pumpAndSettle();
      
      expect(find.text('50'), findsOneWidget);
    });
    
    testWidgets('Tab switching works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Switch to Artwork tab
      await tester.tap(find.text('Artwork'));
      await tester.pumpAndSettle();
      
      expect(find.text('Upload Artwork'), findsOneWidget);
      
      // Switch to Label tab
      await tester.tap(find.text('Label'));
      await tester.pumpAndSettle();
      
      expect(find.text('Custom Label'), findsOneWidget);
      
      // Switch to Summary tab
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      
      expect(find.text('Order Summary'), findsOneWidget);
    });
    
    testWidgets('Custom label toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate to Label tab
      await tester.tap(find.text('Label'));
      await tester.pumpAndSettle();
      
      // Find and tap the switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      
      // Verify label input appears
      expect(find.text('Label Text'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
    
    testWidgets('Price breakdown toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Find and tap view details button
      await tester.tap(find.text('View Details'));
      await tester.pumpAndSettle();
      
      // Verify price breakdown is shown
      expect(find.text('Base Price'), findsOneWidget);
      expect(find.text('Hide Details'), findsOneWidget);
      
      // Hide details
      await tester.tap(find.text('Hide Details'));
      await tester.pumpAndSettle();
      
      expect(find.text('Base Price'), findsNothing);
      expect(find.text('View Details'), findsOneWidget);
    });
    
    testWidgets('Save draft shows success message', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: EnhancedCustomizeScreen(
              productId: 'test-product',
              productName: 'Test Hoodie',
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Find and tap save draft button
      await tester.tap(find.text('Save Draft').first);
      await tester.pump();
      
      // Verify snackbar appears
      expect(find.text('Design saved successfully'), findsOneWidget);
    });
  });
  
  group('ProductCustomization Model Tests', () {
    test('calculates unit price correctly', () {
      final customization = ProductCustomization(
        id: 'test',
        productId: 'product-1',
        color: Colors.black,
        colorName: 'True Black',
        dyeType: 'Standard Garment Dye',
        quantity: 50,
      );
      
      // Base price with 5% discount for 50 quantity
      expect(customization.unitPrice, equals(36.575));
    });
    
    test('calculates total price correctly', () {
      final customization = ProductCustomization(
        id: 'test',
        productId: 'product-1',
        color: Colors.black,
        colorName: 'True Black',
        dyeType: 'Standard Garment Dye',
        quantity: 100,
      );
      
      // Base price with 10% discount for 100 quantity
      expect(customization.totalPrice, equals(3465.0));
    });
    
    test('applies price modifiers correctly', () {
      final customization = ProductCustomization(
        id: 'test',
        productId: 'product-1',
        color: Colors.black,
        colorName: 'True Black',
        dyeType: 'Premium Pigment Dye',
        customLabel: true,
        artworkUrl: 'test.png',
        quantity: 1,
      );
      
      // Base (38.5) + Dye (5) + Label (2.5) + Artwork (3) = 49
      expect(customization.unitPrice, equals(49.0));
    });
    
    test('toJson and fromJson work correctly', () {
      final original = ProductCustomization(
        id: 'test-123',
        productId: 'product-1',
        color: Colors.blue,
        colorName: 'Amparo Blue',
        dyeType: 'Standard Garment Dye',
        artworkUrl: 'test.png',
        artworkPosition: const Offset(10, 20),
        artworkScale: 1.5,
        artworkRotation: 45.0,
        customLabel: true,
        labelText: 'MY BRAND',
        quantity: 75,
        placementArea: PlacementArea.front,
      );
      
      final json = original.toJson();
      final restored = ProductCustomization.fromJson(json);
      
      expect(restored.id, equals(original.id));
      expect(restored.productId, equals(original.productId));
      expect(restored.colorName, equals(original.colorName));
      expect(restored.dyeType, equals(original.dyeType));
      expect(restored.artworkUrl, equals(original.artworkUrl));
      expect(restored.artworkPosition, equals(original.artworkPosition));
      expect(restored.artworkScale, equals(original.artworkScale));
      expect(restored.artworkRotation, equals(original.artworkRotation));
      expect(restored.customLabel, equals(original.customLabel));
      expect(restored.labelText, equals(original.labelText));
      expect(restored.quantity, equals(original.quantity));
      expect(restored.placementArea, equals(original.placementArea));
    });
  });
  
  group('CustomizationService Tests', () {
    test('creates new customization correctly', () {
      final service = CustomizationService();
      final customization = service.createNewCustomization('product-123');
      
      expect(customization.productId, equals('product-123'));
      expect(customization.quantity, equals(50));
      expect(customization.color, equals(ProductColor.defaultColors.first.color));
      expect(customization.dyeType, equals(DyeType.options.first.name));
    });
    
    test('updates customization correctly', () {
      final service = CustomizationService();
      service.createNewCustomization('product-123');
      
      final updated = service.currentCustomization!.copyWith(
        quantity: 100,
        colorName: 'True Black',
      );
      
      service.updateCurrentCustomization(updated);
      
      expect(service.currentCustomization!.quantity, equals(100));
      expect(service.currentCustomization!.colorName, equals('True Black'));
    });
    
    test('validates customization correctly', () {
      final service = CustomizationService();
      
      // No current customization
      expect(service.validateCustomization(), equals('No customization found'));
      
      // Valid customization
      service.createNewCustomization('product-123');
      expect(service.validateCustomization(), isNull);
      
      // Invalid quantity (too low)
      service.updateCurrentCustomization(
        service.currentCustomization!.copyWith(quantity: 0),
      );
      expect(service.validateCustomization(), equals('Quantity must be at least 1'));
      
      // Invalid quantity (too high)
      service.updateCurrentCustomization(
        service.currentCustomization!.copyWith(quantity: 10001),
      );
      expect(service.validateCustomization(), equals('Maximum quantity is 10,000'));
      
      // Missing label text
      service.updateCurrentCustomization(
        service.currentCustomization!.copyWith(
          quantity: 50,
          customLabel: true,
          labelText: '',
        ),
      );
      expect(service.validateCustomization(), equals('Please provide label text for custom label'));
    });
    
    test('calculates price breakdown correctly', () {
      final service = CustomizationService();
      service.createNewCustomization('product-123');
      
      service.updateCurrentCustomization(
        service.currentCustomization!.copyWith(
          dyeType: 'Premium Pigment Dye',
          customLabel: true,
          artworkUrl: 'test.png',
          quantity: 100,
        ),
      );
      
      final breakdown = service.getPriceBreakdown();
      
      expect(breakdown['Base Price'], equals(38.5));
      expect(breakdown['Dye Type'], equals(5.0));
      expect(breakdown['Custom Label'], equals(2.5));
      expect(breakdown['Artwork'], equals(3.0));
      expect(breakdown['Volume Discount'], equals(-3.85)); // 10% of base price
    });
    
    test('exports and imports customization correctly', () {
      final service = CustomizationService();
      service.createNewCustomization('product-123');
      
      service.updateCurrentCustomization(
        service.currentCustomization!.copyWith(
          colorName: 'Deep Periwinkle',
          quantity: 200,
          customLabel: true,
          labelText: 'TEST BRAND',
        ),
      );
      
      final json = service.exportCustomization();
      
      // Create new service and import
      final newService = CustomizationService();
      newService.importCustomization(json);
      
      expect(newService.currentCustomization!.colorName, equals('Deep Periwinkle'));
      expect(newService.currentCustomization!.quantity, equals(200));
      expect(newService.currentCustomization!.customLabel, isTrue);
      expect(newService.currentCustomization!.labelText, equals('TEST BRAND'));
    });
  });
}