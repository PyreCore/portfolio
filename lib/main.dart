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
  const PortfolioApp({super.key, this.initialLang});

  /// Par défaut : français si la langue du navigateur est le français, sinon anglais.
  final Lang? initialLang;

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

  @override
  void dispose() {
    _lang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LangScope(
      notifier: _lang,
      child: MaterialApp(
        onGenerateTitle: (context) => context.tr(Txt.appTitle),
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const HomePage(),
      ),
    );
  }
}
