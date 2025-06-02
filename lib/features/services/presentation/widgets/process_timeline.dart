import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/design_system.dart' as design;
import '../../../../core/widgets/animated_reveal.dart';

class ProcessTimeline extends StatefulWidget {
  final bool isMobile;

  const ProcessTimeline({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<ProcessTimeline> createState() => _ProcessTimelineState();
}

class _ProcessTimelineState extends State<ProcessTimeline>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  int _activeStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Design & Consultation',
      'description': 'Work with our team to finalize your design and specifications',
      'duration': '1-2 days',
      'icon': Icons.design_services,
      'color': const Color(0xFF3B82F6),
      'details': [
        'Free design consultation',
        'Artwork review and optimization',
        'Print method recommendation',
        'Material selection guidance',
      ],
    },
    {
      'title': 'Sample Production',
      'description': 'Create and ship sample garments for your approval',
      'duration': '3-5 days',
      'icon': Icons.inventory_2,
      'color': const Color(0xFF8B5CF6),
      'details': [
        'Physical sample creation',
        'Quality control check',
        'Express shipping included',
        'Revision if needed',
      ],
    },
    {
      'title': 'Production',
      'description': 'Begin full production once samples are approved',
      'duration': '7-10 days',
      'icon': Icons.factory,
      'color': const Color(0xFF10B981),
      'details': [
        'Bulk production begins',
        'Quality control at each stage',
        'Progress updates provided',
        'Final inspection',
      ],
    },
    {
      'title': 'Packaging & Shipping',
      'description': 'Careful packaging and reliable delivery to your location',
      'duration': '2-3 days',
      'icon': Icons.local_shipping,
      'color': const Color(0xFFF59E0B),
      'details': [
        'Professional packaging',
        'Individual poly bags',
        'Tracking information provided',
        'Delivery confirmation',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Start the timeline animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressController.forward();
      _startStepAnimation();
    });

    _pulseController.repeat(reverse: true);
  }

  void _startStepAnimation() {
    for (int i = 0; i < _steps.length; i++) {
      Future.delayed(Duration(milliseconds: 1000 + (i * 1500)), () {
        if (mounted) {
          setState(() => _activeStep = i);
        }
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      child: Container(
        padding: EdgeInsets.all(design.Spacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(design.Borders.xl),
          boxShadow: design.Shadows.medium,
        ),
        child: widget.isMobile
            ? _buildMobileTimeline()
            : _buildDesktopTimeline(),
      ),
    );
  }

  Widget _buildDesktopTimeline() {
    return Column(
      children: [
        // Timeline header with total duration
        _buildTimelineHeader(),
        SizedBox(height: design.Spacing.xxl),

        // Main timeline
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Steps
            Expanded(
              child: Row(
                children: List.generate(_steps.length, (index) {
                  return Expanded(
                    child: _buildTimelineStep(index, false),
                  );
                }),
              ),
            ),
          ],
        ),

        SizedBox(height: design.Spacing.xxl),

        // Active step details
        _buildStepDetails(),
      ],
    );
  }

  Widget _buildMobileTimeline() {
    return Column(
      children: [
        // Timeline header
        _buildTimelineHeader(),
        SizedBox(height: design.Spacing.xl),

        // Mobile timeline (vertical)
        ...List.generate(_steps.length, (index) {
          return Column(
            children: [
              _buildTimelineStep(index, true),
              if (index < _steps.length - 1)
                _buildConnector(index, true),
            ],
          );
        }),

        SizedBox(height: design.Spacing.xl),

        // Active step details
        _buildStepDetails(),
      ],
    );
  }

  Widget _buildTimelineHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: design.Spacing.sm),
            Text(
              'Total Timeline: 13-20 Business Days',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: design.Spacing.sm),
        Text(
          'Rush orders available with 2-3 day expedited delivery',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(int index, bool isMobile) {
    final step = _steps[index];
    final isActive = index == _activeStep;
    final isCompleted = index < _activeStep;
    final isPast = index <= _activeStep;

    return GestureDetector(
      onTap: () => setState(() => _activeStep = index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            // Step circle
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final pulseScale = isActive 
                    ? 1.0 + (_pulseController.value * 0.1) 
                    : 1.0;
                
                return Transform.scale(
                  scale: pulseScale,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isPast ? step['color'] : Colors.grey[300],
                      shape: BoxShape.circle,
                      boxShadow: isActive 
                          ? [
                              BoxShadow(
                                color: step['color'].withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : design.Shadows.subtle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : step['icon'],
                      color: isPast ? Colors.white : Colors.grey[600],
                      size: isCompleted ? 30 : 28,
                    ),
                  ),
                );
              },
            ),
            
            if (!isMobile) ...[
              SizedBox(height: design.Spacing.lg),
              
              // Progress connector
              if (index < _steps.length - 1)
                _buildConnector(index, false),
            ],

            SizedBox(height: design.Spacing.lg),

            // Step info
            Column(
              children: [
                Text(
                  step['title'],
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? step['color'] : Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.Spacing.xs),
                
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.Spacing.sm,
                    vertical: design.Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isPast 
                        ? step['color'].withOpacity(0.1) 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(design.Borders.lg),
                  ),
                  child: Text(
                    step['duration'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPast ? step['color'] : Colors.grey[600],
                    ),
                  ),
                ),
                
                if (isMobile) ...[
                  SizedBox(height: design.Spacing.sm),
                  Text(
                    step['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(int index, bool isMobile) {
    final isCompleted = index < _activeStep;
    
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progress = _progressAnimation.value;
        final segmentProgress = (progress * _steps.length - index).clamp(0.0, 1.0);
        
        return Container(
          width: isMobile ? 4 : 80,
          height: isMobile ? 40 : 4,
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : design.Spacing.md,
            vertical: isMobile ? design.Spacing.sm : 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              // Background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: isMobile ? 4 : (80 * segmentProgress),
                height: isMobile ? (40 * segmentProgress) : 4,
                decoration: BoxDecoration(
                  color: isCompleted ? _steps[index]['color'] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepDetails() {
    final step = _steps[_activeStep];
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(_activeStep),
        padding: EdgeInsets.all(design.Spacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              step['color'].withOpacity(0.1),
              step['color'].withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(design.Borders.lg),
          border: Border.all(
            color: step['color'].withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(design.Spacing.sm),
                  decoration: BoxDecoration(
                    color: step['color'],
                    borderRadius: BorderRadius.circular(design.Borders.sm),
                  ),
                  child: Icon(
                    step['icon'],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: design.Spacing.md),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: step['color'],
                        ),
                      ),
                      Text(
                        step['description'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.Spacing.md,
                    vertical: design.Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: step['color'],
                    borderRadius: BorderRadius.circular(design.Borders.lg),
                  ),
                  child: Text(
                    step['duration'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: design.Spacing.lg),
            
            // Step details
            Text(
              'What happens in this step:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: design.Spacing.md),
            
            Wrap(
              spacing: design.Spacing.lg,
              runSpacing: design.Spacing.md,
              children: step['details'].map<Widget>((detail) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: step['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: design.Spacing.sm),
                    Text(
                      detail,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}