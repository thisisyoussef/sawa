import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sawa/core/theme/app_theme.dart';
import 'package:sawa/core/utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialization will be added later

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SAWA Clothing Manufacturing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // We'll add theme switching later
      routerConfig: AppRouter.router,
    );
  }
}
