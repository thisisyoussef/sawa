import 'package:meta/meta.dart';

/// Represents a case study featuring successful client projects
@immutable
class CaseStudy {
  const CaseStudy({
    required this.id,
    required this.clientName,
    required this.title,
    required this.description,
    required this.imagePath,
    this.productType,
    this.results,
    this.testimonial,
    this.testimonialAuthor,
    this.year,
  });

  final String id;
  final String clientName;
  final String title;
  final String description;
  final String imagePath; // Asset path or remote URL
  final String? productType;
  final String? results;
  final String? testimonial;
  final String? testimonialAuthor;
  final int? year;

  CaseStudy copyWith({
    String? id,
    String? clientName,
    String? title,
    String? description,
    String? imagePath,
    String? productType,
    String? results,
    String? testimonial,
    String? testimonialAuthor,
    int? year,
  }) {
    return CaseStudy(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      productType: productType ?? this.productType,
      results: results ?? this.results,
      testimonial: testimonial ?? this.testimonial,
      testimonialAuthor: testimonialAuthor ?? this.testimonialAuthor,
      year: year ?? this.year,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseStudy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CaseStudy(id: $id, clientName: $clientName, title: $title)';
}
