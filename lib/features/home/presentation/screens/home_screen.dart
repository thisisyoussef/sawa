import 'package:flutter/material.dart';
import 'package:sawa/core/widgets/sawa_app_bar.dart';
import 'package:sawa/features/home/presentation/widgets/hero_section.dart';
import 'package:sawa/features/home/presentation/widgets/brands_carousel.dart';
import 'package:sawa/features/home/presentation/widgets/case_studies_section.dart';
import 'package:sawa/features/home/presentation/widgets/product_samples_section.dart';
import 'package:sawa/features/home/presentation/widgets/features_benefits_section.dart';
import 'package:sawa/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:sawa/features/home/presentation/widgets/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Custom app bar + hero section stack
            Stack(
              children: [
                // Hero section
                const HeroSection(),

                // Transparent app bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SawaAppBar(isTransparent: true),
                  ),
                ),
              ],
            ),

            // Brands carousel section
            const BrandsCarousel(),

            // Product samples section (new)
            const ProductSamplesSection(),

            // Features and benefits section (new)
            const FeaturesBenefitsSection(),

            // Case studies section
            const CaseStudiesSection(),

            // How it works section (new)
            const HowItWorksSection(),

            // Footer section
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
