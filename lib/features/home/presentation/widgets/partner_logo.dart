import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../models/partner.dart';

/// A widget that displays a partner logo with a text fallback if the image fails to load
class PartnerLogo extends StatelessWidget {
  final Partner partner;
  final double height;
  final double width;

  const PartnerLogo({
    Key? key,
    required this.partner,
    this.height = 50,
    this.width = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FutureBuilder<ImageType>(
        // Try to determine the image type and if it exists
        future: _checkImageType(context, partner.logoPath),
        builder: (context, snapshot) {
          // If still loading, show a placeholder
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          // Based on the image type, show the appropriate widget
          switch (snapshot.data!) {
            case ImageType.png:
              return Image.asset(
                partner.logoPath,
                fit: BoxFit.contain,
              );
            case ImageType.svg:
              final svgPath = partner.logoPath.replaceAll('.png', '.svg');
              return SvgPicture.asset(
                svgPath,
                fit: BoxFit.contain,
              );
            case ImageType.none:
            default:
              return _buildTextLogo(context);
          }
        },
      ),
    );
  }

  /// Checks what type of image is available
  Future<ImageType> _checkImageType(
      BuildContext context, String assetPath) async {
    try {
      // Try loading as PNG first
      final provider = AssetImage(assetPath);
      await precacheImage(provider, context);
      return ImageType.png;
    } catch (_) {
      // If PNG fails, try SVG
      try {
        final svgPath = assetPath.replaceAll('.png', '.svg');
        // This is a simple check - we're not actually loading the SVG here
        // Just checking if the file exists in the asset bundle
        await DefaultAssetBundle.of(context).loadString(svgPath);
        return ImageType.svg;
      } catch (e) {
        // If both fail, use text fallback
        return ImageType.none;
      }
    }
  }

  /// Build a text-based logo as a fallback
  Widget _buildTextLogo(BuildContext context) {
    // Generate a consistent color based on the partner name
    final colorValue = partner.name.hashCode % 0xFFFFFF;
    final backgroundColor = Color(0xFF000000 | colorValue).withOpacity(0.1);
    final textColor = Color(0xFF000000 | colorValue);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: backgroundColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          partner.name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Types of images that can be displayed
enum ImageType {
  png,
  svg,
  none,
}
