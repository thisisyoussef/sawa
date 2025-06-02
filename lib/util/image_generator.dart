import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility to generate placeholder logo images for debugging purposes
class ImageGenerator {
  /// Generates a simple colored rectangle with text as a placeholder logo
  /// Returns the ByteData of a PNG image
  static Future<ByteData> createLogoPlaceholder(
    String text, {
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
    double width = 300,
    double height = 150,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = backgroundColor;

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(2, 2, width - 4, height - 4), borderPaint);

    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: width, maxWidth: width);
    textPainter.paint(
      canvas,
      Offset(0, (height - textPainter.height) / 2),
    );

    // Convert to image
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to generate image');
    }

    return byteData;
  }
}
