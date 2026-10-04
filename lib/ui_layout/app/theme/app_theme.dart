import 'package:flutter/material.dart';

abstract final class SurfColors {
  static const ink = Color(0xFF071018);
  static const deep = Color(0xFF0B1620);
  static const surface = Color(0xFF122331);
  static const raised = Color(0xFF193246);
  static const foam = Color(0xFFE9F7FF);
  static const muted = Color(0xFF93A9B8);
  static const surf = Color(0xFF32B8F0);
  static const tide = Color(0xFF41D6C3);
  static const coral = Color(0xFFFF7A72);
}

abstract final class SurfSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class SurfRadii {
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 28.0;
}

abstract final class SurfTheme {
  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: SurfColors.surf,
          brightness: Brightness.dark,
          surface: SurfColors.deep,
        ).copyWith(
          primary: SurfColors.surf,
          secondary: SurfColors.tide,
          error: SurfColors.coral,
          onSurface: SurfColors.foam,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: SurfColors.ink,
      cardTheme: CardThemeData(
        color: SurfColors.deep,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SurfRadii.md),
          side: const BorderSide(color: SurfColors.raised),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SurfColors.deep,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SurfRadii.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SurfRadii.sm),
          borderSide: const BorderSide(color: SurfColors.raised),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: SurfColors.deep,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: SurfColors.deep,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? scheme.onPrimary : null,
        ),
      ),
    );
  }
}
