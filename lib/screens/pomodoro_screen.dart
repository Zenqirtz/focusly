import 'package:flutter/material.dart';
import 'dart:async';
import 'break_screen.dart';
import '../data/database.dart';
import '../theme.dart';

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

class _PomodoroScreenState extends State<PomodoroScreen> {
  int seconds = 25 * 60;
  String _title = 'Pomodoro';
  Timer? _timer;
  bool _loaded = false;
  List<SessionSubtask> _subs = [];

  @override
  void initState() {
    super.initState();
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
      setState(() {
        seconds = mins * 60;
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

  @override
  Widget build(BuildContext context) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _title,
                                style: const TextStyle(
                                  color: Color(0xFF7A3EB1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Image.asset(
                              'assets/images/pomodoro.png',
                              width: 140,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$minutes:$secs',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Keep Studying',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _subs.map((e) {
                                  final id = e.id;
                                  final title = e.title;
                                  final done = e.done;
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: done,
                                        onChanged: (v) async {
                                          setState(() {
                                            e.done = v ?? false;
                                          });
                                          try {
                                            await AppDb.instance
                                                .setSessionSubtaskDone(
                                                  id,
                                                  v ?? false,
                                                );
                                          } catch (_) {}
                                        },
                                      ),
                                      Expanded(child: Text(title)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () async {
                                  final args =
                                      (ModalRoute.of(
                                            context,
                                          )?.settings.arguments
                                          as Map?) ??
                                      {};
                                  final id = args['sessionId'] as int?;
                                  if (id != null) {
                                    await AppDb.instance.markPomodoroStart(id);
                                  }
                                  _timer?.cancel();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    BreakScreen.routeName,
                                    arguments: {'sessionId': id},
                                  );
                                },
                                child: const Text('Break'),
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
    super.dispose();
  }
}
