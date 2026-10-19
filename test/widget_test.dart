import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/data.dart';
import 'package:portfolio/l10n.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/theme.dart';

Future<void> pumpPortfolio(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const PortfolioApp(initialLang: Lang.en));
  // Les animations tournent en boucle : pas de pumpAndSettle.
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  setUpAll(() => AppText.useGoogleFonts = false);

  testWidgets('renders all portfolio sections', (tester) async {
    await pumpPortfolio(tester, const Size(1280, 6000));

    expect(find.text('PyreCore'), findsOneWidget);
    for (final title in ['About', 'Projects', 'Skills', 'Contact']) {
      // Une fois dans la navigation, une fois comme titre de section.
      expect(find.text(title), findsNWidgets(2));
    }
    for (final project in projects) {
      expect(find.text(project.name), findsOneWidget);
    }
    // Seul le projet phare affiche le lien en toutes lettres.
    expect(find.text('View on GitHub'), findsOneWidget);
  });

  testWidgets('filters projects by category', (tester) async {
    await pumpPortfolio(tester, const Size(1280, 900));

    // Centré à l'écran pour ne pas être masqué par l'en-tête fixe.
    await Scrollable.ensureVisible(
      tester.element(find.text('System admin')),
      alignment: 0.5,
    );
    // Démarre puis termine l'animation d'apparition (Reveal).
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('System admin'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    for (final project in projects) {
      expect(
        find.text(project.name),
        project.category == ProjectCategory.sysadmin
            ? findsOneWidget
            : findsNothing,
      );
    }
  });

  testWidgets('switches the language to French', (tester) async {
    await pumpPortfolio(tester, const Size(1280, 6000));

    await tester.tap(find.text('FR'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('À propos'), findsNWidgets(2));
    expect(find.text('Voir sur GitHub'), findsOneWidget);
    expect(find.text('About'), findsNothing);
  });

  testWidgets('uses a menu instead of links on narrow screens', (tester) async {
    await pumpPortfolio(tester, const Size(400, 8000));

    expect(find.text('About'), findsOneWidget);
  });
}
