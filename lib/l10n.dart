import 'package:flutter/widgets.dart';

enum Lang { en, fr }

/// Texte disponible en anglais et en français.
class T {
  const T(this.en, this.fr);

  /// Texte identique dans les deux langues.
  const T.same(String text) : en = text, fr = text;

  final String en;
  final String fr;

  String of(Lang lang) => lang == Lang.fr ? fr : en;
}

/// Rend la langue courante accessible à tout l'arbre et reconstruit au changement.
class LangScope extends InheritedNotifier<ValueNotifier<Lang>> {
  const LangScope({
    super.key,
    required ValueNotifier<Lang> super.notifier,
    required super.child,
  });

  static ValueNotifier<Lang> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LangScope>()!.notifier!;
}

extension LangContext on BuildContext {
  Lang get lang => LangScope.of(this).value;

  String tr(T text) => text.of(lang);
}
