/// Product data model used for local stub data & future database mapping
///
/// Extend or modify as the project evolves (e.g. add `variants`, `inventory`, etc.).
/// Use [copyWith] when dealing with mutable changes in a state-management scenario.

import 'package:meta/meta.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    this.material,
    this.weight,
    this.tags = const [],
  });

  final String id;
  final String name;
  final double price; // Stored as numeric value, format UI-side.
  final String image; // Asset path or remote URL.
  final String description;
  final String? material;
  final String? weight;
  final List<String> tags;

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? description,
    String? material,
    String? weight,
    List<String>? tags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      material: material ?? this.material,
      weight: weight ?? this.weight,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product(id: $id, name: $name)';
}
