import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';
import 'microritual_screen.dart';

class ConfirmSessionScreen extends StatefulWidget {
  const ConfirmSessionScreen({super.key});
  static const routeName = '/confirm-session';
  @override
  State<ConfirmSessionScreen> createState() => _ConfirmSessionScreenState();
}

class _ConfirmSessionScreenState extends State<ConfirmSessionScreen> {
  Task? _latest;
  int _repeat = 4;
  double _progress = 0.0;
  final _additionalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await AppDb.instance.listTasks();
    Task? latest = tasks.isNotEmpty ? tasks.first : null;
    setState(() {
      _latest = latest;
    });
  }

  @override
  void dispose() {
    _additionalCtrl.dispose();
    super.dispose();
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
          final topHeight = constraints.maxHeight * 0.9;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(gradient: focuslyPrimaryGradient()),
              ),
              Column(
                children: [
                  Container(
                    height: topHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: focuslyGradientBox(radius: 18),
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateText,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Progress',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: kPinkAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: _progress,
                                            minHeight: 10,
                                            backgroundColor: Colors.white24,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(kPinkAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${(_progress * 100).round()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Pomodoro Repeat : ${argRepeat ?? _latest?.repeat ?? _repeat}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Adaptive Focus : $focusLabel',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Work: $workMinutes min • Break: $breakMinutes min',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Additional Task : On',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  // Additional Task input removed per request
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: kPurpleDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                onPressed: () async {
                                  Task? matched;
                                  if (argTitle != null) {
                                    final tasks = await AppDb.instance
                                        .listTasks();
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
                                  final sessionId = await AppDb.instance
                                      .createSession(
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
                                    await AppDb.instance.insertSessionSubtasks(
                                      sessionId,
                                      titles,
                                    );
                                  }
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    MicroritualScreen.routeName,
                                    arguments: {'sessionId': sessionId},
                                  );
                                },
                                child: const Text('Start Session'),
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

String _formatDate(int millis) {
  final d = DateTime.fromMillisecondsSinceEpoch(millis);
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final m = months[d.month - 1];
  return '$m ${d.day}, ${d.year}';
}
