import 'package:flutter/material.dart';
import '../../../../core/constants/design_system.dart' as design;
import '../../../../data/sample_case_studies.dart';
import '../../../../models/case_study.dart';

class CaseStudiesSection extends StatefulWidget {
  const CaseStudiesSection({Key? key}) : super(key: key);

  @override
  State<CaseStudiesSection> createState() => _CaseStudiesSectionState();
}

class _CaseStudiesSectionState extends State<CaseStudiesSection> {
  int _hoveredIndex = -1;

  // Use the sample case studies data
  final List<CaseStudy> _caseStudies = kSampleCaseStudies;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(
        vertical: design.Spacing.xxxl,
        horizontal: isMobile ? design.Spacing.lg : design.Spacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case Studies header
          Text(
            'Customer Spotlights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
          ),
          SizedBox(height: design.Spacing.md),

          // Main heading
          Container(
            width: isMobile ? double.infinity : screenWidth * 0.6,
            margin: EdgeInsets.only(bottom: design.Spacing.xxl),
            child: Text(
              'Real Stories, Real Results',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    height: 1.1,
                  ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Case studies grid/list
              Expanded(
                flex: isMobile ? 1 : 3,
                child: isMobile
                    ? Column(
                        children: List.generate(_caseStudies.length, (index) {
                          return Column(
                            children: [
                              _buildCaseStudyCard(context, index),
                              if (index < _caseStudies.length - 1)
                                SizedBox(height: design.Spacing.xxl),
                            ],
                          );
                        }),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_caseStudies.length, (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < _caseStudies.length - 1
                                    ? design.Spacing.xl
                                    : 0,
                              ),
                              child: _buildCaseStudyCard(context, index),
                            ),
                          );
                        }),
                      ),
              ),

              if (!isMobile) ...[
                SizedBox(width: design.Spacing.xxxl),

                // Right side content
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'See how businesses and organizations of all sizes use custom apparel to build brand recognition, celebrate achievements, and create memorable experiences. We\'re proud to support clients across all industries.',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                        ),
                        SizedBox(height: design.Spacing.xl),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to more case studies
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View more success stories',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                SizedBox(width: design.Spacing.xs),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaseStudyCard(BuildContext context, int index) {
    final caseStudy = _caseStudies[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < design.Breakpoints.mobile;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to case study detail
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with hover effect
            Stack(
              children: [
                // Main image with animated scale on hover
                ClipRRect(
                  borderRadius: BorderRadius.circular(design.Borders.md),
                  child: AnimatedContainer(
                    duration: design.Durations.medium,
                    curve: Curves.easeInOut,
                    height: 400,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image or placeholder
                        AnimatedScale(
                          scale: _hoveredIndex == index ? 1.05 : 1.0,
                          duration: design.Durations.medium,
                          child: Image.asset(
                            caseStudy.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.3),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Darken overlay on hover
                        AnimatedContainer(
                          duration: design.Durations.medium,
                          color: Colors.black
                              .withOpacity(_hoveredIndex == index ? 0.5 : 0.3),
                        ),

                        // Brand/Client name at bottom
                        Positioned(
                          bottom: design.Spacing.xl,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              caseStudy.clientName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),

                        // Product type tag
                        if (caseStudy.productType != null)
                          Positioned(
                            top: design.Spacing.lg,
                            left: design.Spacing.lg,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.Spacing.md,
                                vertical: design.Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius:
                                    BorderRadius.circular(design.Borders.sm),
                              ),
                              child: Text(
                                caseStudy.productType!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),

                        // View case study hint on hover
                        AnimatedOpacity(
                          opacity: _hoveredIndex == index ? 1.0 : 0.0,
                          duration: design.Durations.short,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.Spacing.lg,
                                vertical: design.Spacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(design.Borders.md),
                              ),
                              child: Text(
                                'View Case Study',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Case study info
            Padding(
              padding: EdgeInsets.only(
                top: design.Spacing.lg,
                bottom: design.Spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caseStudy.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: design.Spacing.sm),
                  Text(
                    caseStudy.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                          height: 1.5,
                        ),
                  ),
                  if (caseStudy.results != null) ...[
                    SizedBox(height: design.Spacing.md),
                    Container(
                      padding: EdgeInsets.all(design.Spacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(design.Borders.sm),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: design.Spacing.sm),
                          Expanded(
                            child: Text(
                              caseStudy.results!,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 