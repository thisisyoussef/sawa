import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../constants/design_system.dart';

class SawaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTransparent;

  const SawaAppBar({
    Key? key,
    this.isTransparent = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < Breakpoints.mobile;

    return Container(
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.transparent
            : Theme.of(context).colorScheme.background,
        boxShadow: isTransparent ? null : Shadows.subtle,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? Spacing.lg : Spacing.xxxl,
        vertical: Spacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () => context.go(AppRoutes.home),
            child: Text(
              'SAWA',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: isTransparent
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),

          // Navigation links
          if (!isMobile)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavLink(
                  title: 'Samples',
                  route: AppRoutes.products,
                  isTransparent: isTransparent,
                ),
                SizedBox(width: Spacing.xl),
                _NavLink(
                  title: 'Services',
                  route: AppRoutes.services,
                  isTransparent: isTransparent,
                ),
                SizedBox(width: Spacing.xl),
                _NavLink(
                  title: 'How it works',
                  route: AppRoutes.about,
                  isTransparent: isTransparent,
                ),
                SizedBox(width: Spacing.xl),
                _NavLink(
                  title: 'Case Studies',
                  route: AppRoutes.caseStudies,
                  isTransparent: isTransparent,
                ),
              ],
            ),

          // CTA Button
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.productShowcase),
            child: Text('Start designing'),
          ),

          // Mobile menu icon
          if (isMobile)
            IconButton(
              icon: Icon(
                Icons.menu,
                color: isTransparent
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // TODO: Show mobile menu
              },
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final String route;
  final bool isTransparent;

  const _NavLink({
    Key? key,
    required this.title,
    required this.route,
    required this.isTransparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isCurrentRoute = currentLocation == route;

    return InkWell(
      onTap: () => context.go(route),
      borderRadius: Borders.buttonRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isCurrentRoute ? FontWeight.w500 : FontWeight.w400,
                color: isTransparent
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
        ),
      ),
    );
  }
}
