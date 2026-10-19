import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'data.dart';
import 'l10n.dart';
import 'theme.dart';
import 'widgets/background.dart';
import 'widgets/common.dart';
import 'widgets/logo.dart';
import 'widgets/sections.dart';

const _headerHeight = 72.0;

enum PageSection {
  about(Txt.navAbout),
  projects(Txt.navProjects),
  skills(Txt.navSkills),
  contact(Txt.navContact);

  const PageSection(this.label);

  final T label;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _sectionKeys = {for (final s in PageSection.values) s: GlobalKey()};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Défilement animé vers une section (sous l'en-tête), ou vers le haut si null.
  void _scrollTo(PageSection? section) {
    var target = 0.0;
    if (section != null) {
      final box =
          _sectionKeys[section]!.currentContext?.findRenderObject()
              as RenderBox?;
      if (box == null) return;
      final viewport = RenderAbstractViewport.of(box);
      target =
          viewport.getOffsetToReveal(box, 0).offset -
          _headerHeight -
          MediaQuery.paddingOf(context).top;
    }
    _scrollController.animateTo(
      target.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    topInset: _headerHeight + MediaQuery.paddingOf(context).top,
                    onViewProjects: () => _scrollTo(PageSection.projects),
                    onScrollDown: () => _scrollTo(PageSection.about),
                  ),
                  AboutSection(key: _sectionKeys[PageSection.about]),
                  ProjectsSection(key: _sectionKeys[PageSection.projects]),
                  SkillsSection(key: _sectionKeys[PageSection.skills]),
                  ContactSection(key: _sectionKeys[PageSection.contact]),
                  const _SiteFooter(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _SiteHeader(onNavigate: _scrollTo),
          ),
        ],
      ),
    );
  }
}

/// En-tête en verre dépoli, fixé au-dessus du contenu qui défile.
class _SiteHeader extends StatelessWidget {
  const _SiteHeader({required this.onNavigate});

  final void Function(PageSection? section) onNavigate;

  @override
  Widget build(BuildContext context) {
    final showLinks = !isNarrow(context);
    final colors = context.colors;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: colors.bg.withValues(alpha: 0.55),
            border: Border(bottom: BorderSide(color: colors.glassBorder)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: _headerHeight,
              child: PageContainer(
                child: Row(
                  children: [
                    _Logo(onTap: () => onNavigate(null)),
                    const Spacer(),
                    if (showLinks)
                      for (final section in PageSection.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 28),
                          child: _NavLink(
                            label: context.tr(section.label),
                            onTap: () => onNavigate(section),
                          ),
                        ),
                    const _ThemeToggle(),
                    const SizedBox(width: 10),
                    const _LangToggle(),
                    if (!showLinks) _MenuButton(onNavigate: onNavigate),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppText.style(
      display: true,
      size: 21,
      weight: FontWeight.w700,
      height: 1.2,
    );
    // Sur mobile, l'emblème seul laisse la place aux boutons de thème et de langue.
    final narrow = isNarrow(context);
    return Hoverable(
      onTap: onTap,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PyreLogo(size: narrow ? 28 : 30),
          if (!narrow) ...[
            const SizedBox(width: 10),
            Text('Pyre', style: style),
            GradientText('Core', style: style),
          ],
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppText.style(
              size: 15,
              weight: FontWeight.w500,
              height: 1.2,
              color: hovered ? context.colors.text : context.colors.muted,
            ),
            child: Text(label),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: hovered ? 20 : 0,
            height: 2,
            decoration: BoxDecoration(
              gradient: AppGradients.fire,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bascule entre le thème sombre et le thème clair.
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final mode = ThemeModeScope.of(context);
    final dark = context.isDark;
    final colors = context.colors;
    return Tooltip(
      message: context.tr(dark ? Txt.themeToLight : Txt.themeToDark),
      child: Hoverable(
        onTap: () => mode.value = dark ? ThemeMode.light : ThemeMode.dark,
        builder: (context, hovered) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hovered ? colors.tint.withValues(alpha: 0.08) : colors.glass,
            border: Border.all(color: colors.glassBorder),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: Tween(begin: 0.5, end: 1.0).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Icon(
              dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(dark),
              size: 19,
              color: hovered ? AppColors.orange : colors.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context) {
    final lang = LangScope.of(context);
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in Lang.values)
            Hoverable(
              onTap: () => lang.value = option,
              builder: (context, hovered) {
                final selected = lang.value == option;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: selected ? AppGradients.fire : null,
                  ),
                  child: Text(
                    option.name.toUpperCase(),
                    style: AppText.style(
                      size: 12.5,
                      weight: FontWeight.w700,
                      letterSpacing: 1,
                      height: 1.2,
                      color: selected
                          ? AppColors.ink
                          : (hovered ? colors.text : colors.muted),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onNavigate});

  final void Function(PageSection? section) onNavigate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PopupMenuButton<PageSection>(
      icon: Icon(Icons.menu_rounded, color: colors.text),
      color: colors.menu,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.glassBorder),
      ),
      onSelected: onNavigate,
      itemBuilder: (context) => [
        for (final section in PageSection.values)
          PopupMenuItem(
            value: section,
            child: Text(
              context.tr(section.label),
              style: AppText.style(weight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}

class _SiteFooter extends StatelessWidget {
  const _SiteFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: PageContainer(
        child: Column(
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    context.colors.glassBorder,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              '© ${DateTime.now().year} PyreCore · ${context.tr(Txt.footer)}',
              textAlign: TextAlign.center,
              style: AppText.style(size: 14, color: context.colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
