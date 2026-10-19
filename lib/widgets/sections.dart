import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n.dart';
import '../theme.dart';
import 'common.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.topInset,
    required this.onViewProjects,
    required this.onScrollDown,
  });

  final double topInset;
  final VoidCallback onViewProjects;
  final VoidCallback onScrollDown;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final narrow = isNarrow(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: math.max(size.height, 560)),
      child: Padding(
        padding: EdgeInsets.only(top: topInset + 40, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageContainer(
              child: Column(
                children: [
                  const Reveal(child: _StatusBadge()),
                  const SizedBox(height: 28),
                  Reveal(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      context.tr(Txt.heroEyebrow),
                      style: AppText.style(
                        size: narrow ? 18 : 22,
                        weight: FontWeight.w500,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Reveal(
                    delay: const Duration(milliseconds: 200),
                    child: _ShimmerTitle(
                      size: (size.width * 0.11).clamp(52.0, 116.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Reveal(
                    delay: const Duration(milliseconds: 300),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        context.tr(Txt.heroTagline),
                        textAlign: TextAlign.center,
                        style: AppText.style(
                          size: narrow ? 17 : 20,
                          color: AppColors.muted,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Reveal(
                    delay: const Duration(milliseconds: 400),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        AppButton(
                          label: context.tr(Txt.heroCta),
                          icon: Icons.arrow_downward_rounded,
                          onTap: onViewProjects,
                        ),
                        AppButton(
                          label: context.tr(Txt.heroGithub),
                          icon: Icons.arrow_outward_rounded,
                          primary: false,
                          onTap: () => openUrl(githubUrl),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
            Reveal(
              delay: const Duration(milliseconds: 700),
              child: _ScrollHint(onTap: onScrollDown),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoopAnimation(
            duration: const Duration(milliseconds: 1800),
            builder: (context, t) => SizedBox.square(
              dimension: 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 8 + 8 * t,
                    height: 8 + 8 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.online.withValues(alpha: 0.5 * (1 - t)),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.online,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            context.tr(Txt.heroBadge),
            style: AppText.style(
              size: 13.5,
              weight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// « PyreCore » en dégradé feu qui ondule lentement.
class _ShimmerTitle extends StatelessWidget {
  const _ShimmerTitle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return LoopAnimation(
      duration: const Duration(seconds: 6),
      builder: (context, t) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: const [
            AppColors.amber,
            AppColors.orange,
            AppColors.ember,
            AppColors.orange,
          ],
          tileMode: TileMode.mirror,
          transform: _SlideGradient(t),
        ).createShader(Offset.zero & bounds.size),
        child: Text(
          'PyreCore',
          style: AppText.style(
            display: true,
            size: size,
            weight: FontWeight.w700,
            letterSpacing: -3,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

/// Décale le dégradé d'une période complète (2 largeurs en mode miroir) sur t ∈ [0, 1].
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.t);

  final double t;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * 2 * t, 0, 0);
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => LoopAnimation(
        duration: const Duration(milliseconds: 1400),
        reverse: true,
        builder: (context, t) => Transform.translate(
          offset: Offset(0, 6 * Curves.easeInOut.transform(t)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr(Txt.scroll).toUpperCase(),
                style: AppText.style(
                  size: 11.5,
                  weight: FontWeight.w600,
                  letterSpacing: 3,
                  color: hovered ? AppColors.text : AppColors.muted,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: hovered ? AppColors.orange : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PageSectionFrame(
      index: 1,
      title: Txt.navAbout,
      subtitle: Txt.aboutSubtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 820;
          final text = Reveal(
            child: Text(
              context.tr(Txt.aboutText),
              style: AppText.style(
                size: wide ? 19 : 17,
                color: AppColors.text.withValues(alpha: 0.85),
                height: 1.75,
              ),
            ),
          );
          final focus = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < focusAreas.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                Reveal(
                  delay: Duration(milliseconds: 120 * i),
                  child: _FocusCard(area: focusAreas[i]),
                ),
              ],
            ],
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [text, const SizedBox(height: 32), focus],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: text),
              const SizedBox(width: 56),
              Expanded(flex: 5, child: focus),
            ],
          );
        },
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.area});

  final FocusArea area;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: glassDecoration(hovered: hovered),
        child: Row(
          children: [
            IconBadge(area.icon, size: 44),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(area.title),
                    style: AppText.style(
                      display: true,
                      size: 17,
                      weight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr(area.text),
                    style: AppText.style(
                      size: 14.5,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  /// Catégorie affichée ; null = tous les projets.
  ProjectCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (final project in projects)
        if (_filter == null || project.category == _filter) project,
    ];
    return PageSectionFrame(
      index: 2,
      title: Txt.navProjects,
      subtitle: Txt.projectsSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Reveal(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _FilterChip(
                  label: context.tr(Txt.projectsAll),
                  count: projects.length,
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final category in ProjectCategory.values)
                  _FilterChip(
                    label: context.tr(category.label),
                    count: projects.where((p) => p.category == category).length,
                    selected: _filter == category,
                    onTap: () => setState(() => _filter = category),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topCenter,
              children: [...previous, ?current],
            ),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _ProjectsLayout(
              key: ValueKey(_filter),
              projects: visible,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) {
        final foreground = selected
            ? AppColors.bg
            : (hovered ? AppColors.text : AppColors.muted);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected ? AppGradients.fire : null,
            color: selected
                ? null
                : Colors.white.withValues(alpha: hovered ? 0.08 : 0.04),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppText.style(
                  size: 14.5,
                  weight: FontWeight.w600,
                  height: 1.2,
                  color: foreground,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: AppText.style(
                  size: 12.5,
                  weight: FontWeight.w700,
                  height: 1.2,
                  color: foreground.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Le premier projet en grande carte, les suivants en liste numérotée à côté
/// (ou dessous sur écran étroit).
class _ProjectsLayout extends StatelessWidget {
  const _ProjectsLayout({super.key, required this.projects});

  final List<Project> projects;

  static const _gap = 20.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 860;
        final featured = IntrinsicHeight(
          child: Reveal(child: FeaturedProjectCard(project: projects.first)),
        );
        final others = projects.skip(1).toList();
        if (others.isEmpty) return featured;

        final list = [
          for (var i = 0; i < others.length; i++)
            Reveal(
              delay: Duration(milliseconds: 100 * (i + 1)),
              child: ProjectRow(project: others[i], showNumber: !isNarrow(context)),
            ),
        ];
        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              featured,
              for (final row in list) ...[const SizedBox(height: _gap), row],
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: featured),
              const SizedBox(width: _gap),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < list.length; i++) ...[
                      if (i > 0) const SizedBox(height: _gap),
                      Expanded(child: list[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Numéro du projet dans la liste complète : 01, 02…
String _projectNumber(Project project) =>
    (projects.indexOf(project) + 1).toString().padLeft(2, '0');

class FeaturedProjectCard extends StatelessWidget {
  const FeaturedProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    return Hoverable(
      onTap: () => openUrl(project.url),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
        padding: EdgeInsets.all(narrow ? 24 : 32),
        decoration: glassDecoration(hovered: hovered, radius: 24).copyWith(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.orange.withValues(alpha: hovered ? 0.16 : 0.11),
              AppColors.ember.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBadge(project.icon, size: 60),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: AppColors.amber.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.amber.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.tr(Txt.projectFeatured).toUpperCase(),
                        style: AppText.style(
                          size: 11.5,
                          weight: FontWeight.w700,
                          letterSpacing: 1.2,
                          height: 1.2,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GradientText(
              _projectNumber(project),
              style: AppText.style(
                display: true,
                size: 15,
                weight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              project.name,
              style: AppText.style(
                display: true,
                size: narrow ? 26 : 32,
                weight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(project.tags).toUpperCase(),
              style: AppText.style(
                size: 12,
                weight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.amber,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr(project.description),
              style: AppText.style(size: 16.5, color: AppColors.muted),
            ),
            const SizedBox(height: 28),
            const Spacer(),
            Row(
              children: [
                Text(
                  context.tr(Txt.projectLink),
                  style: AppText.style(
                    size: 14.5,
                    weight: FontWeight.w600,
                    color: AppColors.orange,
                  ),
                ),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.only(left: hovered ? 10 : 6),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectRow extends StatelessWidget {
  const ProjectRow({super.key, required this.project, this.showNumber = true});

  final Project project;
  final bool showNumber;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => openUrl(project.url),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(hovered ? 4 : 0, 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: glassDecoration(hovered: hovered),
        child: Row(
          children: [
            if (showNumber) ...[
              GradientText(
                _projectNumber(project),
                style: AppText.style(
                  display: true,
                  size: 15,
                  weight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 20),
            ],
            IconBadge(project.icon, size: 44),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: AppText.style(
                      display: true,
                      size: 19,
                      weight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr(project.tags).toUpperCase(),
                    style: AppText.style(
                      size: 11.5,
                      weight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.amber,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(project.description),
                    style: AppText.style(
                      size: 14.5,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            AnimatedRotation(
              duration: const Duration(milliseconds: 250),
              turns: hovered ? 0 : -0.125,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: hovered ? AppColors.orange : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PageSectionFrame(
      index: 3,
      title: Txt.navSkills,
      subtitle: Txt.skillsSubtitle,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < skills.length; i++)
            Reveal(
              delay: Duration(milliseconds: 60 * i),
              child: _SkillChip(label: context.tr(skills[i])),
            ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: hovered
              ? AppColors.orange.withValues(alpha: 0.12)
              : AppColors.glass,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: hovered
                ? AppColors.orange.withValues(alpha: 0.5)
                : AppColors.glassBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.fire,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppText.style(
                size: 15,
                weight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    return PageSectionFrame(
      index: 4,
      title: Txt.navContact,
      subtitle: Txt.contactSubtitle,
      child: Reveal(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 24 : 56,
            vertical: narrow ? 40 : 64,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.orange.withValues(alpha: 0.18),
                AppColors.ember.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                context.tr(Txt.contactHeading),
                textAlign: TextAlign.center,
                style: AppText.style(
                  display: true,
                  size: narrow ? 28 : 40,
                  weight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  context.tr(Txt.contactText),
                  textAlign: TextAlign.center,
                  style: AppText.style(size: 17, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: context.tr(Txt.contactCta),
                icon: Icons.arrow_outward_rounded,
                onTap: () => openUrl(githubUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
