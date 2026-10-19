import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import 'common.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onViewProjects});

  final VoidCallback onViewProjects;

  @override
  Widget build(BuildContext context) {
    final titleSize = (MediaQuery.sizeOf(context).width * 0.06).clamp(
      40.0,
      64.0,
    );
    return DecoratedBox(
      // radial-gradient(1200px 400px at 50% -10%, rgba(88,166,255,.15), transparent)
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.2),
          radius: 1,
          colors: [
            AppColors.accent.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0),
          ],
          transform: const _EllipseTransform(
            center: Alignment(0, -1.2),
            radiusX: 1200,
            radiusY: 400,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 64),
        child: PageContainer(
          child: Column(
            children: [
              Text(
                "Hello, I'm",
                style: AppText.style(
                  weight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PyreCore',
                style: AppText.style(
                  size: titleSize,
                  weight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    'Python developer · AI & automation enthusiast · '
                    'building tools that make computers feel alive.',
                    textAlign: TextAlign.center,
                    style: AppText.style(size: 17.6, color: AppColors.muted),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  AppButton(label: 'View projects', onTap: onViewProjects),
                  AppButton(
                    label: 'GitHub',
                    primary: false,
                    onTap: () => openUrl(githubUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Étire le cercle d'un [RadialGradient] (radius: 1) en ellipse de rayons en pixels.
class _EllipseTransform extends GradientTransform {
  const _EllipseTransform({
    required this.center,
    required this.radiusX,
    required this.radiusY,
  });

  final Alignment center;
  final double radiusX;
  final double radiusY;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final origin = center.withinRect(bounds);
    final side = bounds.shortestSide;
    return Matrix4.identity()
      ..translateByDouble(origin.dx, origin.dy, 0, 1)
      ..scaleByDouble(radiusX / side, radiusY / side, 1, 1)
      ..translateByDouble(-origin.dx, -origin.dy, 0, 1);
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageSectionFrame(
      title: 'About',
      child: SectionText(
        'I design and automate: from real-time voice assistants to system '
        'administration tooling on Windows and Linux. I enjoy building practical '
        'tools, clean scripts and small products that solve real problems — '
        'one project at a time.',
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _minCardWidth = 280.0;
  static const _gap = 20.0;

  @override
  Widget build(BuildContext context) {
    return PageSectionFrame(
      title: 'Projects',
      alt: true,
      // Équivalent de grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)).
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
                            ? ProjectCard(project: rowProjects[j])
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
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hovered ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: AppText.style(size: 18.4, weight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              project.tags,
              style: AppText.style(
                size: 12.8,
                weight: FontWeight.w600,
                color: AppColors.accent2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: AppText.style(size: 15.2, color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            Hoverable(
              onTap: () => openUrl(project.url),
              builder: (context, linkHovered) => Text(
                'View on GitHub →',
                style: AppText.style(
                  size: 14.4,
                  weight: FontWeight.w600,
                  color: AppColors.accent,
                  decoration: linkHovered ? TextDecoration.underline : null,
                ),
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
      title: 'Skills',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final skill in skills)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 17.6,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                skill,
                style: AppText.style(size: 14.4, weight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PageSectionFrame(
      title: 'Contact',
      alt: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionText('Open to collaboration and interesting projects.'),
          const SizedBox(height: 24),
          Center(
            child: AppButton(
              label: 'Follow on GitHub',
              onTap: () => openUrl(githubUrl),
            ),
          ),
        ],
      ),
    );
  }
}
