import 'dart:async';
import 'dart:ui' show Color;

import 'package:web/web.dart' as web;

/// Colore la barre d'état du téléphone (meta theme-color) et le fond de la
/// page, pour qu'ils suivent le thème de l'app.
void setBrowserThemeColor(Color color) {
  final hex =
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  web.document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute('content', hex);
  web.document.body?.style.backgroundColor = hex;
  (web.document.documentElement as web.HTMLElement?)?.style.backgroundColor =
      hex;
}

/// Fait disparaître en fondu l'écran de chargement défini dans web/index.html.
void removeSplash() {
  final splash = web.document.getElementById('splash');
  if (splash == null) return;
  splash.classList.add('hidden');
  Timer(const Duration(milliseconds: 400), () => splash.remove());
}
