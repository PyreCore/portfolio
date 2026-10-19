import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';
import '../l10n.dart';
import '../theme.dart';

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

bool isNarrow(BuildContext context) => MediaQuery.sizeOf(context).width < 640;

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

/// Animation en boucle ; [builder] reçoit la progression `t` entre 0 et 1.
/// Figée si l'utilisateur a demandé à réduire les animations.
class LoopAnimation extends StatefulWidget {
  const LoopAnimation({
    super.key,
    required this.duration,
    required this.builder,
    this.reverse = false,
  });

  final Duration duration;
  final bool reverse;
  final Widget Function(BuildContext context, double t) builder;

  @override
  State<LoopAnimation> createState() => _LoopAnimationState();
}

class _LoopAnimationState extends State<LoopAnimation>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: widget.reverse);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}

/// Fait apparaître [child] en fondu et glissement quand il entre à l'écran.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 700);

  late final _controller = AnimationController(
    vsync: this,
    duration: widget.delay + _duration,
  );
  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMilliseconds / (widget.delay + _duration).inMilliseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
  );
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (!mounted || _controller.status != AnimationStatus.dismissed) return;
    final box = context.findRenderObject() as RenderBox?;
    final position = _position;
    if (box == null || !box.attached || !box.hasSize) return;
    if (position == null) {
      _controller.forward();
      return;
    }
    final viewport = RenderAbstractViewport.of(box);
    final top = viewport.getOffsetToReveal(box, 0).offset - position.pixels;
    if (top < position.viewportDimension * 0.92) {
      position.removeListener(_check);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, 28 * (1 - _animation.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Largeur min(1080px, 90%), centrée.
class PageContainer extends StatelessWidget {
  const PageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(1080.0, constraints.maxWidth * 0.9);
        return Center(
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          AppGradients.fire.createShader(Offset.zero & bounds.size),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}

/// Icône sombre sur un carré arrondi en dégradé.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key, this.size = 48});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.fire,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: AppColors.ink, size: size * 0.5),
    );
  }
}

/// Carte « verre » translucide, avec bordure et halo orange au survol.
BoxDecoration glassDecoration(
  BuildContext context, {
  bool hovered = false,
  double radius = 20,
}) {
  final colors = context.colors;
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        hovered ? colors.cardTopHover : colors.cardTop,
        colors.cardBottom,
      ],
    ),
    border: Border.all(
      color: hovered
          ? AppColors.orange.withValues(alpha: 0.55)
          : colors.glassBorder,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.orange.withValues(alpha: hovered ? 0.18 : 0),
        blurRadius: 40,
        offset: const Offset(0, 16),
      ),
    ],
  );
}

/// Couleur propre à une section, adaptée au thème.
Color sectionColor(BuildContext context, PageSection section) =>
    context.isDark ? section.dark : section.light;

class PageSectionFrame extends StatelessWidget {
  const PageSectionFrame({
    super.key,
    required this.section,
    required this.subtitle,
    required this.child,
  });

  final PageSection section;
  final T subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    final accent = sectionColor(context, section);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: narrow ? 56 : 96),
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        section.number,
                        style: AppText.style(
                          mono: true,
                          size: 14,
                          weight: FontWeight.w700,
                          letterSpacing: 2,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 2,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.tr(section.label),
                    style: AppText.style(
                      display: true,
                      size: narrow ? 32 : 44,
                      weight: FontWeight.w700,
                      letterSpacing: -1,
                      height: 1.15,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr(subtitle),
                    style: AppText.style(size: 17, color: context.colors.muted),
                  ),
                ],
              ),
            ),
            SizedBox(height: narrow ? 32 : 48),
            child,
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = true,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = primary ? AppColors.ink : colors.text;
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: primary ? AppGradients.fire : null,
          color: primary
              ? null
              : colors.tint.withValues(alpha: hovered ? 0.08 : 0.04),
          border: primary
              ? null
              : Border.all(
                  color: hovered
                      ? colors.tint.withValues(alpha: 0.3)
                      : colors.glassBorder,
                ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(
                alpha: primary ? (hovered ? 0.45 : 0.25) : 0,
              ),
              blurRadius: hovered ? 32 : 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.style(
                size: 15.5,
                weight: FontWeight.w600,
                color: foreground,
                height: 1.2,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: foreground),
            ],
          ],
        ),
      ),
    );
  }
}
