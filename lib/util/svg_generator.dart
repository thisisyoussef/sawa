/// A utility class to generate SVG text logos
class SvgGenerator {
  /// Generate a simple text logo as SVG
  static String generateTextLogo(
    String text, {
    String backgroundColor = '#f5f5f5',
    String textColor = '#333333',
    int width = 300,
    int height = 150,
    int fontSize = 40,
  }) {
    final safeText = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');

    return '''
<svg width="$width" height="$height" xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" fill="$backgroundColor" rx="4" ry="4" />
  <rect x="1" y="1" width="${width - 2}" height="${height - 2}" 
        stroke="#88888833" fill="none" stroke-width="2" rx="3" ry="3"/>
  <text x="50%" y="50%" font-family="Arial, sans-serif" font-size="$fontSize"
        font-weight="bold" fill="$textColor" text-anchor="middle" 
        dominant-baseline="middle">$safeText</text>
</svg>
''';
  }
}
