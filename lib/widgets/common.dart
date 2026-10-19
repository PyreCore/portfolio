import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

/// Fournit l'état de survol à [builder] et un curseur « main » si [onTap] est défini.
class Hoverable extends StatefulWidget {
  const Hoverable({super.key, required this.builder, this.onTap});

  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.builder(context, _hovered),
      ),
    );
  }
}

/// Équivalent de `.container` : largeur min(960px, 90%), centrée.
class PageContainer extends StatelessWidget {
  const PageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(960.0, constraints.maxWidth * 0.9);
        return Center(
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}

class PageSectionFrame extends StatelessWidget {
  const PageSectionFrame({
    super.key,
    required this.title,
    required this.child,
    this.alt = false,
  });

  final String title;
  final Widget child;
  final bool alt;

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(color: AppColors.border);
    return DecoratedBox(
      decoration: alt
          ? const BoxDecoration(
              color: AppColors.bgAlt,
              border: Border(top: borderSide, bottom: borderSide),
            )
          : const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: AppText.style(size: 28, weight: FontWeight.w700),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: SizedBox(
                      height: 1,
                      child: ColoredBox(color: AppColors.border),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  const SectionText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Text(text, style: AppText.style(color: AppColors.muted)),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) {
        final button = AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22.4, vertical: 11.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: primary
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, AppColors.accent2],
                  )
                : null,
            border: primary ? null : Border.all(color: AppColors.border),
          ),
          child: Text(
            label,
            style: AppText.style(
              weight: FontWeight.w600,
              color: primary ? AppColors.bg : AppColors.text,
            ),
          ),
        );
        // Équivalent de `filter: brightness(1.1)` au survol.
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(_brightness(hovered ? 1.1 : 1)),
          child: button,
        );
      },
    );
  }

  static List<double> _brightness(double b) => [
    b, 0, 0, 0, 0, //
    0, b, 0, 0, 0, //
    0, 0, b, 0, 0, //
    0, 0, 0, 1, 0, //
  ];
}
