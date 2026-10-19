import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/data.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/theme.dart';

void main() {
  setUpAll(() => AppText.useGoogleFonts = false);

  testWidgets('renders all portfolio sections', (tester) async {
    tester.view.physicalSize = const Size(1280, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());

    expect(find.text('PyreCore'), findsNWidgets(2)); // Logo + titre.
    for (final title in ['About', 'Projects', 'Skills', 'Contact']) {
      // Une fois dans la navigation, une fois comme titre de section.
      expect(find.text(title), findsNWidgets(2));
    }
    for (final project in projects) {
      expect(find.text(project.name), findsOneWidget);
    }
    expect(find.text('View on GitHub →'), findsNWidgets(projects.length));
  });

  testWidgets('hides navigation links on narrow screens', (tester) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());

    expect(find.text('About'), findsOneWidget);
  });
}
