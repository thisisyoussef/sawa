import '../models/partner.dart';
import 'package:uuid/uuid.dart';
import 'app_images.dart';

/// ----------------------------------------------------------------------------
/// Local sample data for trusted brand partners.
/// Used for development and will be replaced with dynamic data from backend.
/// ----------------------------------------------------------------------------

const _uuid = Uuid();

/// Generates a deterministic UUID based on the partner name.
String _id(String name) => Uuid().v5(Uuid.NAMESPACE_URL, name);

final List<Partner> kSamplePartners = [
  Partner(
    id: _id('UMMA'),
    name: 'UMMA',
    logoPath: AppImages.brandUMMA,
    websiteUrl: 'https://www.umma.org',
  ),
  Partner(
    id: _id('Osool'),
    name: 'Osool',
    logoPath: AppImages.brandOsool,
    websiteUrl: 'https://www.osool.com',
  ),
  Partner(
    id: _id('Tadabur'),
    name: 'Tadabur',
    logoPath: AppImages.brandTadabur,
    websiteUrl: 'https://www.tadabur.com',
  ),
  Partner(
    id: _id('Pali Imports'),
    name: 'Pali Imports',
    logoPath: AppImages.brandPaliImports,
    websiteUrl: 'https://www.paliimports.com',
  ),
];
