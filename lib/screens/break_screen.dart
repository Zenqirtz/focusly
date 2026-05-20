import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'end_screen.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class BreakScreen extends StatefulWidget {
  const BreakScreen({super.key});
  static const routeName = '/break';
  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  int seconds = 5 * 60;
  final int _totalSeconds = 5 * 60;
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

  double get _progress {
    if (_totalSeconds == 0) return 0;
    return 1.0 - (seconds / _totalSeconds);
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
              // Calmer breathing gradient for break
              BreathingGradient(
                colors: const [
                  Color(0xFF8E4EC6),
                  Color(0xFF6B3FA0),
                  Color(0xFF3D1F6D),
                ],
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FadeSlideIn(
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pemrograman Mobile',
                                  style: TextStyle(
                                    color: kPurple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Slower floating mascot for break calm
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 100),
                              child: FloatingWidget(
                                magnitude: 6,
                                duration: const Duration(milliseconds: 3000),
                                child: Image.asset(
                                  'assets/images/break.png',
                                  width: 130,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Circular timer ring
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: SizedBox(
                                width: 180,
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: _progress),
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeOut,
                                      builder: (context, value, child) {
                                        return CustomPaint(
                                          size: const Size(180, 180),
                                          painter: _BreakRingPainter(
                                            progress: value,
                                          ),
                                        );
                                      },
                                    ),
                                    PulseWidget(
                                      minScale: 0.97,
                                      maxScale: 1.02,
                                      duration:
                                          const Duration(milliseconds: 1400),
                                      child: Text(
                                        '$minutes:$secs',
                                        style: const TextStyle(
                                          fontSize: 38,
                                          fontWeight: FontWeight.w700,
                                          color: kPurpleDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 250),
                              child: Text(
                                'Have a break! Refresh your mind ☕',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 300),
                              child: GlowButton(
                                text: 'Start Pomodoro',
                                icon: Icons.play_arrow_rounded,
                                glowColor: kPurpleSoft,
                                onPressed: () async {
                                  final args =
                                      (ModalRoute.of(context)
                                              ?.settings
                                              .arguments as Map?) ??
                                          {};
                                  final id = args['sessionId'] as int?;
                                  if (id != null) {
                                    await AppDb.instance.incrementBreak(id);
                                  }
                                  _timer?.cancel();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    EndScreen.routeName,
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

class _BreakRingPainter extends CustomPainter {
  final double progress;
  _BreakRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 8.0;

    final trackPaint = Paint()
      ..color = kPurple.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final glowPaint = Paint()
        ..color = kPurpleSoft.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        glowPaint,
      );

      final progressPaint = Paint()
        ..color = kPurpleSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_BreakRingPainter oldDelegate) => oldDelegate.progress != progress;
}
