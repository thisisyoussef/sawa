import 'package:meta/meta.dart';

/// Represents a trusted brand partner to be displayed in the carousel
@immutable
class Partner {
  const Partner({
    required this.id,
    required this.name,
    required this.logoPath,
    this.websiteUrl,
  });

  final String id;
  final String name;
  final String logoPath; // Asset path or remote URL
  final String? websiteUrl;

  Partner copyWith({
    String? id,
    String? name,
    String? logoPath,
    String? websiteUrl,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      websiteUrl: websiteUrl ?? this.websiteUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Partner && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Partner(id: $id, name: $name)';
}
