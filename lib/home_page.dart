import 'package:flutter/material.dart';

import 'theme.dart';
import 'widgets/common.dart';
import 'widgets/sections.dart';

enum PageSection {
  about('About'),
  projects('Projects'),
  skills('Skills'),
  contact('Contact');

  const PageSection(this.label);

  final String label;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _sectionKeys = {for (final s in PageSection.values) s: GlobalKey()};

  static const _scrollDuration = Duration(milliseconds: 500);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Défilement animé vers une section, ou vers le haut si [section] est null.
  void _scrollTo(PageSection? section) {
    if (section == null) {
      _scrollController.animateTo(
        0,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );
      return;
    }
    final context = _sectionKeys[section]!.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _SiteHeader(onNavigate: _scrollTo),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    onViewProjects: () => _scrollTo(PageSection.projects),
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
        ],
      ),
    );
  }
}

class _SiteHeader extends StatelessWidget {
  const _SiteHeader({required this.onNavigate});

  final void Function(PageSection? section) onNavigate;

  @override
  Widget build(BuildContext context) {
    final showLinks = MediaQuery.sizeOf(context).width > 640;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        bottom: false,
        child: PageContainer(
          child: Row(
            children: [
              Hoverable(
                onTap: () => onNavigate(null),
                builder: (context, _) => Text.rich(
                  TextSpan(
                    text: 'Pyre',
                    children: [
                      TextSpan(
                        text: 'Core',
                        style: AppText.style(
                          size: 20,
                          weight: FontWeight.w800,
                          color: AppColors.accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  style: AppText.style(
                    size: 20,
                    weight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (showLinks)
                for (final section in PageSection.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Hoverable(
                      onTap: () => onNavigate(section),
                      builder: (context, hovered) => AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppText.style(
                          size: 15.2,
                          weight: FontWeight.w500,
                          color: hovered ? AppColors.accent : AppColors.muted,
                        ),
                        child: Text(section.label),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SiteFooter extends StatelessWidget {
  const _SiteFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: PageContainer(
        child: Text(
          '© ${DateTime.now().year} PyreCore. Built with Flutter.',
          textAlign: TextAlign.center,
          style: AppText.style(size: 14.4, color: AppColors.muted),
        ),
      ),
    );
  }
}
