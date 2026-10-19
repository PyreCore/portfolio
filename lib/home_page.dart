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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withValues(alpha: 0.55),
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
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
    return Hoverable(
      onTap: onTap,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PyreLogo(size: isNarrow(context) ? 24 : 30),
          SizedBox(width: isNarrow(context) ? 6 : 10),
          Text('Pyre', style: style),
          GradientText('Core', style: style),
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
              color: hovered ? AppColors.text : AppColors.muted,
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

class _LangToggle extends StatelessWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context) {
    final lang = LangScope.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
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
                          ? AppColors.bg
                          : (hovered ? AppColors.text : AppColors.muted),
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
    return PopupMenuButton<PageSection>(
      icon: const Icon(Icons.menu_rounded, color: AppColors.text),
      color: AppColors.menu,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.glassBorder),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.glassBorder,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              '© ${DateTime.now().year} PyreCore · ${context.tr(Txt.footer)}',
              textAlign: TextAlign.center,
              style: AppText.style(size: 14, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
