import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';

// We'll add screen imports here as we build them
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/debug_assets_screen.dart';
import '../../features/home/presentation/screens/svg_generator_screen.dart';
import '../../features/products/presentation/screens/product_showcase_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/product_customization/presentation/screens/customize_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.productShowcase,
        name: 'productShowcase',
        builder: (context, state) => const ProductShowcaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: AppRoutes.customize,
        name: 'customize',
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return CustomizeScreen(productId: productId);
        },
      ),
      GoRoute(
        path: AppRoutes.services,
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),
      // Debug routes
      GoRoute(
        path: AppRoutes.debugAssets,
        name: 'debugAssets',
        builder: (context, state) => const DebugAssetsScreen(),
      ),
      GoRoute(
        path: AppRoutes.svgGenerator,
        name: 'svgGenerator',
        builder: (context, state) => const SvgGeneratorScreen(),
      ),
      // We'll add more routes as we build the screens
    ],
  );
}
