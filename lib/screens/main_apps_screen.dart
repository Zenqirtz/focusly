import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'confirm_session_screen.dart';

class MainAppsScreen extends StatefulWidget {
  const MainAppsScreen({super.key});
  static const routeName = '/main';
  @override
  State<MainAppsScreen> createState() => _MainAppsScreenState();
}

class _MainAppsScreenState extends State<MainAppsScreen> {
  String _name = '';
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await AppDb.instance.getUser();
    final tasks = await AppDb.instance.listTasks();
    setState(() {
      _name =
          (user?['nickname'] as String?) ?? ((user?['name'] as String?) ?? '');
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _name.isEmpty ? 'Hi, ...' : 'Hi, $_name';
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        greeting,
                                        style: const TextStyle(
                                          color: kPurple,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'What do you want to learn today?',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: kSurfaceLight,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.person_outline,
                                      color: kPurpleDark,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        ProfileScreen.routeName,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: kPurpleLight,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Let's start studying!",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/main.png',
                                    width: 72,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    title: 'Add Task',
                                    icon: Icons.add,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AddTaskScreen.routeName,
                                      ).then((_) => _load());
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ActionCard(
                                    title: 'Start Session',
                                    icon: Icons.play_arrow,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        ConfirmSessionScreen.routeName,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1.05,
                                  ),
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                final t = _tasks[index];
                                return _TaskCard(task: t);
                              },
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

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _ActionCard({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: focuslyGradientBox(radius: 18),
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(minHeight: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _Metric removed per new design (hide Task/Minutes summary)

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

class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object?>?>(
      future: AppDb.instance.latestSessionByTitle(task.title),
      builder: (context, snapshot) {
        final s = snapshot.data;
        double value = 0.0;
        int percent = 0;
        if (s != null) {
          final int? endedAt = s['ended_at'] as int?;
          final int? startedAt = s['started_at'] as int?;
          final int duration = (s['duration_minutes'] as int?) ?? 0;
          if (endedAt != null) {
            value = 1.0;
            percent = 100;
          } else if (startedAt != null && duration > 0) {
            final now = DateTime.now().millisecondsSinceEpoch;
            final elapsedMinutes = (now - startedAt) / 60000;
            final clamped = elapsedMinutes.clamp(0, duration);
            value = (clamped / duration).toDouble();
            if (value > 1.0) value = 1.0;
            percent = (value * 100).round();
          }
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ConfirmSessionScreen.routeName,
              arguments: {'taskTitle': task.title, 'repeat': task.repeat},
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: focuslyGradientBox(radius: 18),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(task.createdAt),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            kPinkAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$percent%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
