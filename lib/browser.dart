// Accès à la page web hôte ; sans effet hors navigateur (tests).
export 'browser_stub.dart' if (dart.library.js_interop) 'browser_web.dart';
