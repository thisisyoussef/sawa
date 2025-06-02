import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/app_images.dart';
import '../../../../data/sample_partners.dart';
import '../../../../util/image_generator.dart';
import 'package:path_provider/path_provider.dart';

class DebugAssetsScreen extends StatefulWidget {
  const DebugAssetsScreen({Key? key}) : super(key: key);

  @override
  State<DebugAssetsScreen> createState() => _DebugAssetsScreenState();
}

class _DebugAssetsScreenState extends State<DebugAssetsScreen> {
  bool _isGenerating = false;
  String _statusMessage = '';
  final List<Map<String, dynamic>> _missingImages = [
    {'name': 'Tadabur', 'path': AppImages.brandTadabur},
    {'name': 'Pali Imports', 'path': AppImages.brandPaliImports},
  ];

  @override
  Widget build(BuildContext context) {
    final assetPaths = [
      AppImages.brandUMMA,
      AppImages.brandOsool,
      AppImages.brandTadabur,
      AppImages.brandPaliImports,
      // Add case study images
      AppImages.caseStudyTShirt,
      AppImages.caseStudyHoodie,
      AppImages.caseStudySweatshirt,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateMissingLogos,
            tooltip: 'Generate missing logos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _statusMessage.isNotEmpty ? 50 : 0,
            color: _isGenerating ? Colors.blue.shade100 : Colors.green.shade100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _statusMessage.isNotEmpty
                ? Row(
                    children: [
                      if (_isGenerating)
                        const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                            color: _isGenerating
                                ? Colors.blue.shade800
                                : Colors.green.shade800,
                          ),
                        ),
                      ),
                      if (!_isGenerating)
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => setState(() => _statusMessage = ''),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  )
                : null,
          ),

          // Asset display
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asset Paths',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  for (final path in assetPaths) ...[
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Path: $path',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  path,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.red.shade100,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 48,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Error: ${error.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Image.asset',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateMissingLogos() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _statusMessage = 'Generating placeholder logos...';
    });

    try {
      for (final image in _missingImages) {
        final name = image['name'] as String;
        final path = image['path'] as String;

        // Extract the filename from the path
        final filename = path.split('/').last;
        setState(() {
          _statusMessage = 'Generating $filename...';
        });

        // Generate the logo image
        final bytes = await ImageGenerator.createLogoPlaceholder(
          name,
          backgroundColor: Colors.white,
          textColor: Colors.black87,
        );

        // Save to assets directory (requires package:path_provider)
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$filename';

        final file = File(filePath);
        await file.writeAsBytes(bytes.buffer.asUint8List());

        setState(() {
          _statusMessage = 'Saved $filename to ${directory.path}';
        });

        // Wait a bit to show the user what happened
        await Future.delayed(const Duration(seconds: 1));
      }

      setState(() {
        _isGenerating = false;
        _statusMessage =
            'All logos generated. Copy them to your assets/images/brands/ folder.';
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _statusMessage = 'Error: $e';
      });
    }
  }
}
