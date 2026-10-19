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

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _minCardWidth = 360.0;
  static const _gap = 24.0;

  @override
  Widget build(BuildContext context) {
    return PageSectionFrame(
      index: 2,
      title: Txt.navProjects,
      subtitle: Txt.projectsSubtitle,
      // Grille auto-adaptative : autant de colonnes de 360px minimum que possible.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = math.max(
            1,
            ((constraints.maxWidth + _gap) / (_minCardWidth + _gap)).floor(),
          );
          final rows = <Widget>[];
          for (var i = 0; i < projects.length; i += columns) {
            final rowProjects = projects.skip(i).take(columns).toList();
            rows.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var j = 0; j < columns; j++) ...[
                      if (j > 0) const SizedBox(width: _gap),
                      Expanded(
                        child: j < rowProjects.length
                            ? Reveal(
                                delay: Duration(milliseconds: 120 * j),
                                child: ProjectCard(project: rowProjects[j]),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const SizedBox(height: _gap),
                rows[i],
              ],
            ],
          );
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => openUrl(project.url),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(28),
        decoration: glassDecoration(hovered: hovered),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBadge(project.icon),
                const Spacer(),
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
            const SizedBox(height: 22),
            Text(
              project.name,
              style: AppText.style(
                display: true,
                size: 22,
                weight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(project.tags).toUpperCase(),
              style: AppText.style(
                size: 12,
                weight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.amber,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              context.tr(project.description),
              style: AppText.style(size: 15.5, color: AppColors.muted),
            ),
            const SizedBox(height: 20),
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
