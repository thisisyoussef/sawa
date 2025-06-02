/// Central registry for all image paths & URLs used in the app.
///
/// Replace values at will—widgets should import this file instead of hard
/// coding paths. Makes swapping images trivial and paves the way for future
/// CDN bucket or CMS-driven sources.
class AppImages {
  // ---------------------------------------------------------------------------
  // Hero & Backgrounds
  // ---------------------------------------------------------------------------
  static const heroBackground = 'assets/images/hero_bg.jpg';
  static const clothingFactory = 'assets/images/clothing_factory.jpg';

  // ---------------------------------------------------------------------------
  // Case Studies
  // ---------------------------------------------------------------------------
  static const caseStudyTShirt = 'assets/images/case_studies/tshirt_case.jpg';
  static const caseStudyHoodie = 'assets/images/case_studies/hoodie_case.jpg';
  static const caseStudySweatshirt =
      'assets/images/case_studies/sweatshirt_case.jpg';

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------
  static const productToteBag = 'assets/images/products/tote_bag.jpg';
  static const productHoodie = 'assets/images/products/hoodie.jpg';
  static const productTShirt = 'assets/images/products/tshirt.jpg';
  static const productSweatshirt = 'assets/images/products/sweatshirt.jpg';
  static const productCap = 'assets/images/products/cap.jpg';

  // ---------------------------------------------------------------------------
  // Brand Logos
  // ---------------------------------------------------------------------------
  static const brandAsics = 'assets/images/brands/asics.png';
  static const brandBeReal = 'assets/images/brands/bereal.png';
  static const brandUniversal = 'assets/images/brands/universal.png';
  static const brandSpotify = 'assets/images/brands/spotify.png';
  static const brandNotion = 'assets/images/brands/notion.png';
  static const brandFigma = 'assets/images/brands/figma.png';
  static const brandNyu = 'assets/images/brands/nyu.png';
  static const brandCalm = 'assets/images/brands/calm.png';
  static const brandUMMA = 'assets/images/brands/umma.png';
  static const brandTadabur = 'assets/images/brands/tadabur.png';
  static const brandPaliImports = 'assets/images/brands/pali_imports.png';
  static const brandOsool = 'assets/images/brands/osool.png';

  // ---------------------------------------------------------------------------
  // Brand Logos (placeholder text logos currently)
  // ---------------------------------------------------------------------------
  // When real SVG/PNG logos are added, update here.
  static const brandSoccerLeague = 'soccer_league';
  static const brandNonProfit = 'nonprofit';
  static const brandUniversity = 'university';
}
