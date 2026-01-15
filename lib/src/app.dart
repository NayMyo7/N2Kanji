import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_colors.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter();
    final baseTextTheme = ThemeData.light().textTheme;

    return MaterialApp.router(
      title: 'N2 Kanji',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.textOnPrimary,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: AppColors.textOnPrimary,
        ),
        dividerColor: AppColors.divider,
        hintColor: AppColors.textSecondary,
        cardTheme: const CardThemeData(
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          surfaceTintColor: AppColors.primary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: AppColors.background,
        ),
        textTheme: baseTextTheme
            .copyWith(
              displayLarge: baseTextTheme.displayLarge?.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
              displayMedium: baseTextTheme.displayMedium?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
              displaySmall: baseTextTheme.displaySmall?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
              titleLarge: baseTextTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              titleMedium: baseTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              titleSmall: baseTextTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              labelLarge: baseTextTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.2),
            )
            .apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
      ),
      routerConfig: router,
    );
  }
}
