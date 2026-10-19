import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui' show Color, VoidCallback;

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

/// Vrai quand le navigateur propose d'installer le site comme application
/// (voir pyreInstallPrompt dans web/index.html).
bool canInstallApp() => globalContext['pyreInstallPrompt'] != null;

void installApp() => globalContext.callMethod('pyreInstall'.toJS);

/// Appelle [listener] quand l'installation devient possible ou ne l'est plus.
/// Renvoie la fonction qui retire l'écoute.
VoidCallback onInstallAvailabilityChanged(VoidCallback listener) {
  final callback = ((web.Event _) => listener()).toJS;
  web.window.addEventListener('pyre-installable', callback);
  return () => web.window.removeEventListener('pyre-installable', callback);
}
