import 'package:flutter/material.dart';
import 'dart:async';
import 'pomodoro_screen.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class MicroritualScreen extends StatefulWidget {
  const MicroritualScreen({super.key});
  static const routeName = '/microritual';
  @override
  State<MicroritualScreen> createState() => _MicroritualScreenState();
}

class _MicroritualScreenState extends State<MicroritualScreen> {
  int seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.92;
          return Stack(
            children: [
              BreathingGradient(
                colors: const [kPrimaryStop1, kPrimaryStop2, kPrimaryStop3],
                child: const SizedBox.expand(),
              ),
              Column(
                children: [
                  Container(
                    height: topHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kPurple.withValues(alpha: 0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Ritual card with animated border glow
                            FadeSlideIn(
                              child: _GlowBorderCard(
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Microritual Session',
                                        style: TextStyle(
                                          color: kPurpleDark,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Make yourself comfortable, grab some music,\ncoffee, or do a motivational writing',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    FloatingWidget(
                                      magnitude: 8,
                                      child: Image.asset(
                                        'assets/images/micro.png',
                                        width: 140,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    PulseWidget(
                                      minScale: 0.96,
                                      maxScale: 1.04,
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      child: Text(
                                        '$minutes:$secs',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w700,
                                          color: kPurpleDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your study session will start soon',
                                      style: TextStyle(
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: GlowButton(
                                text: 'Start Pomodoro',
                                icon: Icons.play_arrow_rounded,
                                onPressed: () async {
                                  final args =
                                      (ModalRoute.of(context)
                                              ?.settings
                                              .arguments as Map?) ??
                                          {};
                                  final id = args['sessionId'] as int?;
                                  if (id != null) {
                                    await AppDb.instance
                                        .markMicroritualStart(id);
                                  }
                                  _timer?.cancel();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    PomodoroScreen.routeName,
                                    arguments: {'sessionId': id},
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Card with animated glowing border.
class _GlowBorderCard extends StatefulWidget {
  final Widget child;
  const _GlowBorderCard({required this.child});

  @override
  State<_GlowBorderCard> createState() => _GlowBorderCardState();
}

class _GlowBorderCardState extends State<_GlowBorderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
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
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kPurpleLight.withValues(alpha: 0.3 + _ctrl.value * 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kPurple.withValues(alpha: 0.05 + _ctrl.value * 0.08),
                blurRadius: 12 + _ctrl.value * 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
