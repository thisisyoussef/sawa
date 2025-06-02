import '../models/product.dart';
import 'package:uuid/uuid.dart';
import 'app_images.dart';

/// ----------------------------------------------------------------------------
/// Local sample data used at development-time.
/// Swap this file with a repository implementation once a real database is
/// connected (e.g. Supabase).
/// ----------------------------------------------------------------------------

const _uuid = Uuid();

/// Generates a deterministic UUID based on the product name.
String _id(String name) => Uuid().v5(Uuid.NAMESPACE_URL, name);

final List<Product> kSampleProducts = [
  Product(
    id: _id('Tote Bags'),
    name: 'Tote Bags',
    price: 13.85,
    image: AppImages.productToteBag,
    description:
        'Versatile tote bags that make great promotional items or merchandise.',
    material: '100% Organic Cotton',
    weight: '280 g/m²',
    tags: ['bag', 'cotton', 'organic'],
  ),
  Product(
    id: _id('Hoodies'),
    name: 'Hoodies',
    price: 28.60,
    image: AppImages.productHoodie,
    description: 'Premium quality hoodies with multiple customization options.',
    material: '85% Cotton, 15% Polyester',
    weight: '500 g/m²',
    tags: ['hoodie', 'sweater', 'apparel'],
  ),
  Product(
    id: _id('T-Shirts'),
    name: 'T-Shirts',
    price: 9.95,
    image: AppImages.productTShirt,
    description: 'Classic fit t-shirts made from soft, durable fabric.',
    material: '100% Combed Cotton',
    weight: '200 g/m²',
    tags: ['tshirt', 'cotton'],
  ),
  Product(
    id: _id('Sweatshirts'),
    name: 'Sweatshirts',
    price: 24.95,
    image: AppImages.productSweatshirt,
    description: 'Comfortable sweatshirts perfect for any season.',
    material: '80% Cotton, 20% Polyester',
    weight: '330 g/m²',
    tags: ['sweatshirt', 'fleece'],
  ),
  Product(
    id: _id('Caps'),
    name: 'Caps',
    price: 14.50,
    image: AppImages.productCap,
    description:
        'Stylish caps with embroidery options for your logo or design.',
    material: 'Twill Cotton',
    weight: '180 g/m²',
    tags: ['cap', 'hat'],
  ),
];
