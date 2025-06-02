import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../util/svg_generator.dart';
import '../../../../data/app_images.dart';

class SvgGeneratorScreen extends StatefulWidget {
  const SvgGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<SvgGeneratorScreen> createState() => _SvgGeneratorScreenState();
}

class _SvgGeneratorScreenState extends State<SvgGeneratorScreen> {
  final List<Map<String, dynamic>> _logos = [
    {
      'name': 'Tadabur',
      'path': AppImages.brandTadabur.replaceAll('.png', '.svg'),
      'color': '#3a86ff',
    },
    {
      'name': 'Pali Imports',
      'path': AppImages.brandPaliImports.replaceAll('.png', '.svg'),
      'color': '#8338ec',
    },
  ];

  String _status = '';
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Logo Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This utility generates SVG placeholder logos for brands',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Status message
            if (_status.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isGenerating
                      ? Colors.blue.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isGenerating
                        ? Colors.blue.shade200
                        : Colors.green.shade200,
                  ),
                ),
                child: Text(_status),
              ),
              const SizedBox(height: 16),
            ],

            // Generate button
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateLogos,
              icon: const Icon(Icons.file_download),
              label: const Text('Generate SVG Logos'),
            ),

            const SizedBox(height: 24),
            const Text(
              'Logos to Generate:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // List of logos
            Expanded(
              child: ListView.builder(
                itemCount: _logos.length,
                itemBuilder: (context, index) {
                  final logo = _logos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(logo['name']),
                      subtitle: Text(logo['path']),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _hexToColor(logo['color']),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateLogos() async {
    setState(() {
      _isGenerating = true;
      _status = 'Generating SVG logos...';
    });

    try {
      for (final logo in _logos) {
        final name = logo['name'] as String;
        final path = logo['path'] as String;
        final color = logo['color'] as String;

        // Generate SVG content
        final svgContent = SvgGenerator.generateTextLogo(
          name,
          backgroundColor: '#ffffff',
          textColor: color,
          width: 300,
          height: 150,
          fontSize: 40,
        );

        // Get the absolute file path
        final filePath = 'assets/${path.split('assets/').last}';
        setState(() {
          _status = 'Saving $filePath...';
        });

        // Create directory if it doesn't exist
        final directory =
            Directory(filePath.substring(0, filePath.lastIndexOf('/')));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Write the SVG file
        final file = File(filePath);
        await file.writeAsString(svgContent);

        // Pause to show status
        await Future.delayed(const Duration(milliseconds: 500));
      }

      setState(() {
        _isGenerating = false;
        _status =
            'All logos generated successfully! Location: assets/images/brands/';
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _status = 'Error generating logos: $e';
      });
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
