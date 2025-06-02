import '../models/case_study.dart';
import 'package:uuid/uuid.dart';
import 'app_images.dart';

/// ----------------------------------------------------------------------------
/// Local sample data for case studies.
/// Used for development and will be replaced with dynamic data from backend.
/// ----------------------------------------------------------------------------

const _uuid = Uuid();

/// Generates a deterministic UUID based on the case study title.
String _id(String title) => Uuid().v5(Uuid.NAMESPACE_URL, title);

final List<CaseStudy> kSampleCaseStudies = [
  CaseStudy(
    id: _id('ASICS Summer Collection'),
    clientName: 'ASICS',
    title: 'ASICS Summer Collection',
    description:
        'Produced a limited edition summer collection featuring custom embroidery and eco-friendly materials for ASICS global flagship stores.',
    imagePath: AppImages.caseStudyTShirt,
    productType: 'T-Shirts & Shorts',
    results: 'Sold out in 48 hours across 12 countries',
    testimonial:
        'Sawa delivered exceptional quality that exceeded our expectations. Their attention to detail with the embroidery was outstanding.',
    testimonialAuthor: 'Sarah Chen, Global Apparel Director',
    year: 2023,
  ),
  CaseStudy(
    id: _id('BeReal Team Apparel'),
    clientName: 'BeReal',
    title: 'BeReal Team Apparel',
    description:
        'Created custom hoodies for BeReal\'s growing team across Europe and North America, with location-specific designs.',
    imagePath: AppImages.caseStudyHoodie,
    productType: 'Hoodies & Crewnecks',
    results: 'Delivered 1,200 units across 4 office locations',
    testimonial:
        'Our team loved the hoodies! The quality is excellent and the custom designs for each office location added a special touch.',
    testimonialAuthor: 'Julien Lambert, Head of Culture',
    year: 2023,
  ),
  CaseStudy(
    id: _id('Universal Music Tour Merchandise'),
    clientName: 'Universal Music',
    title: 'Universal Music Tour Merchandise',
    description:
        'Designed and produced tour merchandise for three major artists under the Universal Music label, focusing on sustainability.',
    imagePath: AppImages.caseStudySweatshirt,
    productType: 'Tour Merchandise Collection',
    results: 'Generated \$3.2M in additional tour revenue',
    testimonial:
        'Sawa\'s quick turnaround and commitment to sustainable materials aligned perfectly with our artists\' values. The merchandise quality exceeded previous tour collections.',
    testimonialAuthor: 'Miguel Santos, Merchandise Director',
    year: 2022,
  ),
  CaseStudy(
    id: _id('NYU Graduation Collection'),
    clientName: 'New York University',
    title: 'NYU Graduation Collection',
    description:
        'Created a premium graduation merchandise collection for NYU\'s class of 2023, featuring custom embroidery and sustainable materials.',
    imagePath: AppImages.caseStudyTShirt,
    productType: 'Graduation Collection',
    results: 'Surpassed previous years\' sales by 45%',
    testimonial:
        'The quality and design of the graduation collection was exceptional. Students and families appreciated the sustainable approach.',
    testimonialAuthor: 'Dr. Jennifer Wu, Alumni Relations',
    year: 2023,
  ),
];
