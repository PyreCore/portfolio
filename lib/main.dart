import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'browser.dart';
import 'data.dart';
import 'home_page.dart';
import 'l10n.dart';
import 'theme.dart';

void main() {
  runApp(const PortfolioApp());
  WidgetsBinding.instance.addPostFrameCallback((_) => removeSplash());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    this.initialLang,
    this.initialThemeMode = ThemeMode.dark,
  });

  /// Par défaut : français si la langue du navigateur est le français, sinon anglais.
  final Lang? initialLang;
  final ThemeMode initialThemeMode;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final _lang = ValueNotifier(
    widget.initialLang ??
        (PlatformDispatcher.instance.locale.languageCode == 'fr'
            ? Lang.fr
            : Lang.en),
  );
  late final _themeMode = ValueNotifier(widget.initialThemeMode);

  @override
  void initState() {
    super.initState();
    _themeMode.addListener(_syncBrowserColor);
    _syncBrowserColor();
  }

  Color get _background => _themeMode.value == ThemeMode.light
      ? AppPalette.light.bg
      : AppPalette.dark.bg;

  /// La barre d'état du téléphone prend la couleur de fond du thème.
  void _syncBrowserColor() => setBrowserThemeColor(_background);

  @override
  void dispose() {
    _lang.dispose();
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LangScope(
      notifier: _lang,
      child: ThemeModeScope(
        notifier: _themeMode,
        child: ValueListenableBuilder(
          valueListenable: _themeMode,
          builder: (context, mode, _) => MaterialApp(
            onGenerateTitle: (context) => context.tr(Txt.appTitle),
            // Sur le web, Flutter reporte cette couleur dans la meta
            // theme-color : elle doit suivre le thème, comme ci-dessus.
            color: _background,
            debugShowCheckedModeBanner: false,
            theme: buildTheme(Brightness.light),
            darkTheme: buildTheme(Brightness.dark),
            themeMode: mode,
            themeAnimationDuration: const Duration(milliseconds: 400),
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
