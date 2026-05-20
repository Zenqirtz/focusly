import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// ─── FadeSlideIn ────────────────────────────────────────────────────────────
/// Fades and slides a child in from the bottom on first build.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.offset = const Offset(0, 30),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero)
        .animate(curved);
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(offset: _slide.value, child: child),
      ),
      child: widget.child,
    );
  }
}

// ─── BreathingGradient ──────────────────────────────────────────────────────
/// Animated gradient that shifts alignment subtly, creating a "breathing" feel.
class BreathingGradient extends StatefulWidget {
  final List<Color> colors;
  final Widget? child;
  final BorderRadius? borderRadius;
  const BreathingGradient({
    super.key,
    required this.colors,
    this.child,
    this.borderRadius,
  });

  @override
  State<BreathingGradient> createState() => _BreathingGradientState();
}

class _BreathingGradientState extends State<BreathingGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final t = _ctrl.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment(-1.0 + t * 0.5, -1.0 + t * 0.3),
              end: Alignment(1.0 - t * 0.3, 1.0 - t * 0.5),
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ─── GlowButton ─────────────────────────────────────────────────────────────
/// A filled button with an animated pulsing glow shadow.
class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color glowColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final IconData? icon;
  const GlowButton({
    super.key,
    required this.text,
    this.onPressed,
    this.glowColor = const Color(0xFF9546B7),
    this.backgroundColor = const Color(0xFF7500A8),
    this.foregroundColor = Colors.white,
    this.height = 54,
    this.icon,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final glow = 8.0 + _ctrl.value * 14.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.3 + _ctrl.value * 0.25),
                blurRadius: glow,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: widget.height,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              onPressed: widget.onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.icon, size: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── FloatingWidget ─────────────────────────────────────────────────────────
/// Gently bobs a child up and down to feel alive.
class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double magnitude;
  final Duration duration;
  const FloatingWidget({
    super.key,
    required this.child,
    this.magnitude = 8,
    this.duration = const Duration(milliseconds: 2200),
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final dy = math.sin(_ctrl.value * math.pi) * widget.magnitude;
        return Transform.translate(offset: Offset(0, -dy), child: child);
      },
      child: widget.child,
    );
  }
}

// ─── PulseWidget ────────────────────────────────────────────────────────────
/// Pulsing scale animation (great for timers).
class PulseWidget extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;
  const PulseWidget({
    super.key,
    required this.child,
    this.minScale = 0.97,
    this.maxScale = 1.03,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// ─── ShimmerBox ─────────────────────────────────────────────────────────────
/// A shimmer loading placeholder.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 14,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _ctrl.value * 3, 0),
              end: Alignment(-0.5 + _ctrl.value * 3, 0),
              colors: const [
                Color(0xFFEEEAF4),
                Color(0xFFF7F3FB),
                Color(0xFFEEEAF4),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── GlassmorphicContainer ──────────────────────────────────────────────────
/// Frosted-glass container with blur and translucent fill.
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blur;
  final Color tintColor;
  final double opacity;
  final Border? border;
  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(20),
    this.blur = 18,
    this.tintColor = Colors.white,
    this.opacity = 0.15,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tintColor.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── AnimatedProgressBar ────────────────────────────────────────────────────
/// Smooth tween-animated linear progress bar.
class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color valueColor;
  final double height;
  final double borderRadius;
  final Duration duration;
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.backgroundColor = const Color(0x44FFFFFF),
    this.valueColor = const Color(0xFFE35D8E),
    this.height = 10,
    this.borderRadius = 8,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: v,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [valueColor, valueColor.withValues(alpha: 0.7)],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── ScaleTapCard ───────────────────────────────────────────────────────────
/// Card that scales down on press and springs back — premium touch feedback.
class ScaleTapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  const ScaleTapCard({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
  });

  @override
  State<ScaleTapCard> createState() => _ScaleTapCardState();
}

class _ScaleTapCardState extends State<ScaleTapCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ─── StaggeredColumn ────────────────────────────────────────────────────────
/// Wraps children in staggered FadeSlideIn animations.
class StaggeredColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Duration staggerDelay;
  final Duration itemDuration;
  const StaggeredColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          FadeSlideIn(
            delay: Duration(milliseconds: staggerDelay.inMilliseconds * i),
            duration: itemDuration,
            child: children[i],
          ),
      ],
    );
  }
}

// ─── AnimatedCountUp ────────────────────────────────────────────────────────
/// Counts up from 0 to [value] with animation.
class AnimatedCountUp extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  const AnimatedCountUp({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Text(v.round().toString(), style: style),
    );
  }
}
