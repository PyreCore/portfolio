import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'data.dart';
import 'home_page.dart';
import 'l10n.dart';
import 'theme.dart';

void main() {
  runApp(const PortfolioApp());
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
