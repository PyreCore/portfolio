import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Couleurs communes aux deux thèmes.
abstract final class AppColors {
  /// Texte et icônes posés sur le dégradé feu.
  static const ink = Color(0xFF09090F);
  static const amber = Color(0xFFFFC837);
  static const orange = Color(0xFFFF7A18);
  static const ember = Color(0xFFFF3D6E);
  static const violet = Color(0xFF7B2FF7);
  static const online = Color(0xFF3DDC97);
}

/// Couleurs qui changent entre le thème sombre et le thème clair.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.menu,
    required this.text,
    required this.muted,
    required this.glass,
    required this.glassBorder,
    required this.cardTop,
    required this.cardTopHover,
    required this.cardBottom,
    required this.tint,
    required this.highlight,
    required this.link,
  });

  static const dark = AppPalette(
    bg: Color(0xFF09090F),
    menu: Color(0xFF16141D),
    text: Color(0xFFF4F2F7),
    muted: Color(0xFFA9A4B5),
    glass: Color(0x0FFFFFFF),
    glassBorder: Color(0x1AFFFFFF),
    cardTop: Color(0x0FFFFFFF),
    cardTopHover: Color(0x17FFFFFF),
    cardBottom: Color(0x05FFFFFF),
    tint: Colors.white,
    highlight: AppColors.amber,
    link: AppColors.orange,
  );

  static const light = AppPalette(
    bg: Color(0xFFFBF7F2),
    menu: Color(0xFFFFFFFF),
    text: Color(0xFF1B1622),
    muted: Color(0xFF615A6D),
    glass: Color(0xB3FFFFFF),
    glassBorder: Color(0x17000000),
    cardTop: Color(0xD9FFFFFF),
    cardTopHover: Color(0xF2FFFFFF),
    cardBottom: Color(0x8CFFFFFF),
    tint: Colors.black,
    highlight: Color(0xFFB45309),
    link: Color(0xFFD9480F),
  );

  final Color bg;
  final Color menu;
  final Color text;
  final Color muted;

  /// Fond et bordure des pastilles et cartes translucides.
  final Color glass;
  final Color glassBorder;

  /// Dégradé des cartes « verre ».
  final Color cardTop;
  final Color cardTopHover;
  final Color cardBottom;

  /// Couleur des voiles de survol (blanc sur sombre, noir sur clair).
  final Color tint;

  /// Texte accentué (étiquettes) et liens, lisibles sur le fond.
  final Color highlight;
  final Color link;

  @override
  AppPalette copyWith({
    Color? bg,
    Color? menu,
    Color? text,
    Color? muted,
    Color? glass,
    Color? glassBorder,
    Color? cardTop,
    Color? cardTopHover,
    Color? cardBottom,
    Color? tint,
    Color? highlight,
    Color? link,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      menu: menu ?? this.menu,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      glass: glass ?? this.glass,
      glassBorder: glassBorder ?? this.glassBorder,
      cardTop: cardTop ?? this.cardTop,
      cardTopHover: cardTopHover ?? this.cardTopHover,
      cardBottom: cardBottom ?? this.cardBottom,
      tint: tint ?? this.tint,
      highlight: highlight ?? this.highlight,
      link: link ?? this.link,
    );
  }

  /// Permet la transition en fondu lors du changement de thème.
  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      bg: mix(bg, other.bg),
      menu: mix(menu, other.menu),
      text: mix(text, other.text),
      muted: mix(muted, other.muted),
      glass: mix(glass, other.glass),
      glassBorder: mix(glassBorder, other.glassBorder),
      cardTop: mix(cardTop, other.cardTop),
      cardTopHover: mix(cardTopHover, other.cardTopHover),
      cardBottom: mix(cardBottom, other.cardBottom),
      tint: mix(tint, other.tint),
      highlight: mix(highlight, other.highlight),
      link: mix(link, other.link),
    );
  }
}

extension PaletteContext on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

/// Rend le mode de thème modifiable depuis n'importe quel widget.
class ThemeModeScope extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const ThemeModeScope({
    super.key,
    required ValueNotifier<ThemeMode> super.notifier,
    required super.child,
  });

  static ValueNotifier<ThemeMode> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeModeScope>()!.notifier!;
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
  /// Sans [color], le texte prend la couleur du thème.
  static TextStyle style({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color? color,
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

ThemeData buildTheme(Brightness brightness) {
  final palette = brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
  final scheme = brightness == Brightness.dark
      ? const ColorScheme.dark(
          primary: AppColors.orange,
          secondary: AppColors.ember,
        )
      : const ColorScheme.light(
          primary: AppColors.orange,
          secondary: AppColors.ember,
        );
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: palette.bg,
    colorScheme: scheme.copyWith(
      surface: palette.bg,
      onSurface: palette.text,
    ),
    textTheme: TextTheme(bodyMedium: AppText.style(color: palette.text)),
    extensions: [palette],
  );
}
