import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
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
    final colors = context.colors;
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
                        color: colors.muted,
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
                          color: colors.muted,
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
        color: context.colors.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colors.glassBorder),
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
                  color: hovered ? context.colors.text : context.colors.muted,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: hovered ? AppColors.orange : context.colors.muted,
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
                color: context.colors.text.withValues(alpha: 0.85),
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
        decoration: glassDecoration(context, hovered: hovered),
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
                      color: context.colors.muted,
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
      child: Reveal(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
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
            const SizedBox(height: 24),
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
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              // Une nouvelle clé par filtre : le carrousel repart du début.
              child: _ProjectCarousel(
                key: ValueKey(_filter),
                projects: visible,
              ),
            ),
          ],
        ),
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
    final colors = context.colors;
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) {
        final foreground = selected
            ? AppColors.ink
            : (hovered ? colors.text : colors.muted);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected ? AppGradients.fire : null,
            color: selected
                ? null
                : colors.tint.withValues(alpha: hovered ? 0.08 : 0.04),
            border: Border.all(
              color: selected ? Colors.transparent : colors.glassBorder,
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

/// Cartes de projets en défilement horizontal (glisser, pavé tactile ou
/// flèches), avec une barre de progression.
class _ProjectCarousel extends StatefulWidget {
  const _ProjectCarousel({super.key, required this.projects});

  final List<Project> projects;

  @override
  State<_ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<_ProjectCarousel> {
  static const _gap = 20.0;

  final _controller = ScrollController();
  double _cardWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  /// Avance ou recule d'une carte.
  void _step(int direction) {
    final position = _controller.position;
    _controller.animateTo(
      (position.pixels + direction * (_cardWidth + _gap)).clamp(
        0,
        position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Deux cartes et demie sur grand écran, une et un peu sur mobile :
        // la carte coupée invite à faire défiler.
        _cardWidth = constraints.maxWidth >= 860
            ? (constraints.maxWidth - 2 * _gap) / 2.6
            : constraints.maxWidth * 0.86;

        final metrics = _controller.hasClients &&
                _controller.position.hasContentDimensions
            ? _controller.position
            : null;
        final scrollable = metrics != null && metrics.maxScrollExtent > 0;

        return NotificationListener<ScrollMetricsNotification>(
          onNotification: (_) {
            _refresh();
            return false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScrollConfiguration(
                // Sur le web, permet aussi de glisser les cartes à la souris.
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: PointerDeviceKind.values.toSet(),
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  // Marge pour le soulèvement et le halo des cartes au survol.
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < widget.projects.length; i++) ...[
                          if (i > 0) const SizedBox(width: _gap),
                          SizedBox(
                            width: _cardWidth,
                            child: ProjectCard(
                              project: widget.projects[i],
                              featured: i == 0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (scrollable)
                Row(
                  children: [
                    Expanded(child: _ScrollProgress(metrics: metrics)),
                    const SizedBox(width: 20),
                    _ArrowButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: context.tr(Txt.projectsPrevious),
                      onTap: metrics.pixels > 0 ? () => _step(-1) : null,
                    ),
                    const SizedBox(width: 10),
                    _ArrowButton(
                      icon: Icons.arrow_forward_rounded,
                      tooltip: context.tr(Txt.projectsNext),
                      onTap: metrics.pixels < metrics.maxScrollExtent
                          ? () => _step(1)
                          : null,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Fine barre dont le curseur suit la position du carrousel.
class _ScrollProgress extends StatelessWidget {
  const _ScrollProgress({required this.metrics});

  final ScrollMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final total = metrics.maxScrollExtent + metrics.viewportDimension;
    final thumb = metrics.viewportDimension / total;
    final progress = (metrics.pixels / metrics.maxScrollExtent).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          height: 4,
          decoration: BoxDecoration(
            color: context.colors.glassBorder,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: progress * width * (1 - thumb)),
            width: width * thumb,
            decoration: BoxDecoration(
              gradient: AppGradients.fire,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;

  /// Null quand on est déjà au bout : le bouton est alors estompé.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Hoverable(
        onTap: onTap,
        builder: (context, hovered) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled && hovered ? AppGradients.fire : null,
            color: enabled && hovered ? null : colors.glass,
            border: Border.all(
              color: enabled && hovered
                  ? Colors.transparent
                  : colors.glassBorder,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: !enabled
                ? colors.muted.withValues(alpha: 0.4)
                : (hovered ? AppColors.ink : colors.text),
          ),
        ),
      ),
    );
  }
}

/// Numéro du projet dans la liste complète : 01, 02…
String _projectNumber(Project project) =>
    (projects.indexOf(project) + 1).toString().padLeft(2, '0');

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.featured = false});

  final Project project;

  /// Premier projet affiché : teinte orangée et badge « Projet phare ».
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final narrow = isNarrow(context);
    return Hoverable(
      onTap: () => openUrl(project.url),
      builder: (context, hovered) {
        var decoration = glassDecoration(context, hovered: hovered, radius: 24);
        if (featured) {
          decoration = decoration.copyWith(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.orange.withValues(alpha: hovered ? 0.16 : 0.11),
                AppColors.ember.withValues(alpha: 0.05),
                colors.tint.withValues(alpha: 0.02),
              ],
            ),
          );
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
          padding: EdgeInsets.all(narrow ? 24 : 28),
          decoration: decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(project.icon, size: 52),
                  const Spacer(),
                  if (featured)
                    _FeaturedBadge(color: colors.highlight)
                  else
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 250),
                      turns: hovered ? 0 : -0.125,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: hovered ? AppColors.orange : colors.muted,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),
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
                  size: narrow ? 23 : 26,
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
                  color: colors.highlight,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                context.tr(project.description),
                style: AppText.style(size: 15.5, color: colors.muted),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              Row(
                children: [
                  Text(
                    context.tr(Txt.projectLink),
                    style: AppText.style(
                      size: 14.5,
                      weight: FontWeight.w600,
                      color: colors.link,
                    ),
                  ),
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.only(left: hovered ? 10 : 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: colors.link,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            context.tr(Txt.projectFeatured).toUpperCase(),
            style: AppText.style(
              size: 11.5,
              weight: FontWeight.w700,
              letterSpacing: 1.2,
              height: 1.2,
              color: color,
            ),
          ),
        ],
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
              : context.colors.glass,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: hovered
                ? AppColors.orange.withValues(alpha: 0.5)
                : context.colors.glassBorder,
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
                context.colors.tint.withValues(alpha: 0.03),
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
                  style: AppText.style(size: 17, color: context.colors.muted),
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
