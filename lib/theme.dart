import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette reprise des variables CSS du site d'origine.
abstract final class AppColors {
  static const bg = Color(0xFF0D1117);
  static const bgAlt = Color(0xFF161B22);
  static const surface = Color(0xFF1C2333);
  static const text = Color(0xFFE6EDF3);
  static const muted = Color(0xFF9DA7B3);
  static const accent = Color(0xFF58A6FF);
  static const accent2 = Color(0xFF22D3EE);
  static const border = Color(0xFF2B3441);
}

abstract final class AppText {
  /// Désactivé dans les tests, où le téléchargement des polices est impossible.
  static bool useGoogleFonts = true;

  static TextStyle style({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.6,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: color,
    );
    return useGoogleFonts ? GoogleFonts.inter(textStyle: base) : base;
  }
}

ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent2,
      surface: AppColors.bg,
      onSurface: AppColors.text,
    ),
    textTheme: TextTheme(bodyMedium: AppText.style()),
  );
}
