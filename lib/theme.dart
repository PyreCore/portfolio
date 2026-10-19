import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const bg = Color(0xFF09090F);
  static const menu = Color(0xFF16141D);
  static const text = Color(0xFFF4F2F7);
  static const muted = Color(0xFFA9A4B5);
  static const amber = Color(0xFFFFC837);
  static const orange = Color(0xFFFF7A18);
  static const ember = Color(0xFFFF3D6E);
  static const violet = Color(0xFF7B2FF7);
  static const online = Color(0xFF3DDC97);
  static const glass = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);
}

abstract final class AppGradients {
  static const fire = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.amber, AppColors.orange, AppColors.ember],
  );
}

abstract final class AppText {
  /// Désactivé dans les tests, où le téléchargement des polices est impossible.
  static bool useGoogleFonts = true;

  /// [display] utilise Space Grotesk (titres), sinon Inter (texte courant).
  static TextStyle style({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double height = 1.6,
    double? letterSpacing,
    bool display = false,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
    if (!useGoogleFonts) return base;
    return display
        ? GoogleFonts.spaceGrotesk(textStyle: base)
        : GoogleFonts.inter(textStyle: base);
  }
}

ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      secondary: AppColors.ember,
      surface: AppColors.bg,
      onSurface: AppColors.text,
    ),
    textTheme: TextTheme(bodyMedium: AppText.style()),
  );
}
