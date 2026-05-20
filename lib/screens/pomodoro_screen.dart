import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'break_screen.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});
  static const routeName = '/pomodoro';

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class SessionSubtask {
  final int id;
  final String title;
  bool done;
  SessionSubtask({required this.id, required this.title, required this.done});
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  int seconds = 25 * 60;
  int _totalSeconds = 25 * 60;
  String _title = 'Pomodoro';
  Timer? _timer;
  bool _loaded = false;
  List<SessionSubtask> _subs = [];
  late final AnimationController _ringCtrl;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadDuration().then((_) => _startTimer());
    }
  }

  Future<void> _loadDuration() async {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final id = args['sessionId'] as int?;
    if (id != null) {
      final s = await AppDb.instance.getSession(id);
      final mins = (s?['duration_minutes'] as int?) ?? 25;
      final title = (s?['task_title'] as String?) ?? _title;
      final rows = await AppDb.instance.listSessionSubtasks(id);
      final subs = rows
          .map(
            (e) => SessionSubtask(
              id: (e['id'] as num).toInt(),
              title: e['title'] as String,
              done: ((e['done'] as num? ?? 0).toInt()) == 1,
            ),
          )
          .toList();
      if (!mounted) return;
      setState(() {
        seconds = mins * 60;
        _totalSeconds = mins * 60;
        _title = title;
        _subs = subs;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FadeSlideIn(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _title,
                                  style: const TextStyle(
                                    color: kPurple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Floating mascot
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 100),
                              child: FloatingWidget(
                                magnitude: 8,
                                child: Image.asset(
                                  'assets/images/pomodoro.png',
                                  width: 130,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Circular timer ring
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: SizedBox(
                                width: 180,
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Animated ring
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: _progress),
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeOut,
                                      builder: (context, value, child) {
                                        return CustomPaint(
                                          size: const Size(180, 180),
                                          painter: _TimerRingPainter(
                                            progress: value,
                                            trackColor: kPurple
                                                .withValues(alpha: 0.1),
                                            progressColor: kPurple,
                                            glowColor: kGlowPurple,
                                          ),
                                        );
                                      },
                                    ),
                                    // Timer text with pulse
                                    PulseWidget(
                                      minScale: 0.97,
                                      maxScale: 1.02,
                                      duration:
                                          const Duration(milliseconds: 1000),
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
                            const SizedBox(height: 8),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 250),
                              child: Text(
                                'Keep Studying',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Subtasks
                            if (_subs.isNotEmpty)
                              Expanded(
                                child: FadeSlideIn(
                                  delay: const Duration(milliseconds: 300),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _subs.length,
                                    itemBuilder: (_, i) {
                                      final e = _subs[i];
                                      return _AnimatedCheckRow(
                                        title: e.title,
                                        done: e.done,
                                        onChanged: (v) async {
                                          setState(() => e.done = v ?? false);
                                          try {
                                            await AppDb.instance
                                                .setSessionSubtaskDone(
                                                    e.id, v ?? false);
                                          } catch (_) {}
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              const Spacer(),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 350),
                              child: GlowButton(
                                text: 'Take a Break',
                                icon: Icons.coffee_rounded,
                                glowColor: kPurpleSoft,
                                onPressed: () async {
                                  final args =
                                      (ModalRoute.of(context)
                                              ?.settings
                                              .arguments as Map?) ??
                                          {};
                                  final id = args['sessionId'] as int?;
                                  if (id != null) {
                                    await AppDb.instance
                                        .markPomodoroStart(id);
                                  }
                                  _timer?.cancel();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    BreakScreen.routeName,
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

  @override
  void dispose() {
    _timer?.cancel();
    _ringCtrl.dispose();
    super.dispose();
  }
}

// ─── Circular Timer Ring Painter ────────────────────────────────────────────
class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final Color glowColor;

  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 8.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc with glow
    if (progress > 0) {
      final glowPaint = Paint()
        ..color = glowColor.withValues(alpha: 0.3)
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
        ..color = progressColor
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
  bool shouldRepaint(_TimerRingPainter old) => old.progress != progress;
}

// ─── Animated Checkbox Row ──────────────────────────────────────────────────
class _AnimatedCheckRow extends StatelessWidget {
  final String title;
  final bool done;
  final ValueChanged<bool?>? onChanged;
  const _AnimatedCheckRow({
    required this.title,
    required this.done,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: done
            ? kPurple.withValues(alpha: 0.06)
            : Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: done,
              onChanged: onChanged,
              activeColor: kPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                decoration: done ? TextDecoration.lineThrough : null,
                color: done
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
