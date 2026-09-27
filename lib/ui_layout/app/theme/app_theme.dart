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
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: SurfColors.surf,
          brightness: brightness,
          surface: dark ? SurfColors.deep : const Color(0xFFF4F8FA),
        ).copyWith(
          primary: dark ? SurfColors.surf : const Color(0xFF006B91),
          secondary: dark ? SurfColors.tide : const Color(0xFF006B60),
          error: dark ? SurfColors.coral : const Color(0xFFBA1A1A),
          onSurface: dark ? SurfColors.foam : SurfColors.ink,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? SurfColors.ink : const Color(0xFFF7FAFC),
      cardTheme: CardThemeData(
        color: dark ? SurfColors.deep : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SurfRadii.md),
          side: BorderSide(
            color: dark ? SurfColors.raised : const Color(0xFFD9E4EA),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? SurfColors.deep : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SurfRadii.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SurfRadii.sm),
          borderSide: BorderSide(
            color: dark ? SurfColors.raised : const Color(0xFFD9E4EA),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: dark ? SurfColors.deep : Colors.white,
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
        backgroundColor: dark ? SurfColors.deep : Colors.white,
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
