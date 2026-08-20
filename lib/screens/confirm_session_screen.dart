import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';
import '../widgets/animated_widgets.dart';
import 'microritual_screen.dart';

class ConfirmSessionScreen extends StatefulWidget {
  const ConfirmSessionScreen({super.key});
  static const routeName = '/confirm-session';
  @override
  State<ConfirmSessionScreen> createState() => _ConfirmSessionScreenState();
}

class _ConfirmSessionScreenState extends State<ConfirmSessionScreen> {
  Task? _latest;
  final int _repeat = 4;
  final double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await AppDb.instance.listTasks();
    Task? latest = tasks.isNotEmpty ? tasks.first : null;
    if (!mounted) return;
    setState(() {
      _latest = latest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final argTitle = args['taskTitle'] as String?;
    final title = argTitle ?? _latest?.title ?? 'Pemrograman Mobile';
    final argRepeat = args['repeat'] as int?;
    final createdAt =
        _latest?.createdAt ?? DateTime.now().millisecondsSinceEpoch;
    final dateText = _formatDate(createdAt);
    final focusLabel = _latest == null
        ? 'Medium'
        : (_latest!.priority < 0.34
              ? 'Low'
              : (_latest!.priority < 0.67 ? 'Medium' : 'High'));
    int workMinutes;
    const int breakMinutes = 5;
    if (focusLabel == 'Low') {
      workMinutes = 15;
    } else if (focusLabel == 'High') {
      workMinutes = 55;
    } else {
      workMinutes = 25;
    }

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
                          color: kPurple.withOpacity(0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Session detail card
                            FadeSlideIn(
                              child: Container(
                                decoration: focuslyGradientBox(radius: 22),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dateText,
                                      style: TextStyle(
                                        color:
                                            Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Progress',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: kPinkAccent,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: kPinkAccent.withOpacity(0.5),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: AnimatedProgressBar(
                                            value: _progress,
                                            backgroundColor: Colors.white
                                                .withOpacity(0.2),
                                            valueColor: kPinkAccent,
                                            height: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${(_progress * 100).round()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    _DetailRow(
                                      label: 'Pomodoro Repeat',
                                      value:
                                          '${argRepeat ?? _latest?.repeat ?? _repeat}',
                                    ),
                                    const SizedBox(height: 6),
                                    _DetailRow(
                                      label: 'Adaptive Focus',
                                      value: focusLabel,
                                    ),
                                    const SizedBox(height: 6),
                                    _DetailRow(
                                      label: 'Duration',
                                      value:
                                          'Work: $workMinutes min • Break: $breakMinutes min',
                                    ),
                                    const SizedBox(height: 6),
                                    const _DetailRow(
                                      label: 'Additional Task',
                                      value: 'On',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: GlowButton(
                                text: 'Start Session',
                                icon: Icons.play_arrow_rounded,
                                onPressed: () async {
                                  Task? matched;
                                  if (argTitle != null) {
                                    final tasks =
                                        await AppDb.instance.listTasks();
                                    matched = tasks.firstWhere(
                                      (t) => t.title == argTitle,
                                      orElse: () => Task(
                                        title: title,
                                        category: 'Study',
                                        priority: 0.5,
                                        createdAt: DateTime.now()
                                            .millisecondsSinceEpoch,
                                      ),
                                    );
                                  } else {
                                    matched = _latest;
                                  }
                                  final sessionId =
                                      await AppDb.instance.createSession(
                                    title: title,
                                    category: matched?.category ?? 'Study',
                                    durationMinutes: workMinutes,
                                  );
                                  if (matched?.id != null) {
                                    final subs = await AppDb.instance
                                        .listTaskSubtasks(matched!.id!);
                                    final titles = subs
                                        .map((e) => (e['title'] as String))
                                        .toList();
                                    await AppDb.instance
                                        .insertSessionSubtasks(
                                            sessionId, titles);
                                  }
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    MicroritualScreen.routeName,
                                    arguments: {'sessionId': sessionId},
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

String _formatDate(int millis) {
  final d = DateTime.fromMillisecondsSinceEpoch(millis);
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final m = months[d.month - 1];
  return '$m ${d.day}, ${d.year}';
}
