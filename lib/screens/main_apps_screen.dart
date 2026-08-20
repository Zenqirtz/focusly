import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';
import '../widgets/animated_widgets.dart';
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await AppDb.instance.getUser();
    final tasks = await AppDb.instance.listTasks();
    if (!mounted) return;
    setState(() {
      _name =
          (user?['nickname'] as String?) ?? ((user?['name'] as String?) ?? '');
      _tasks = tasks;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _name.isEmpty ? 'Hi, ...' : 'Hi, $_name';
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.92;
          return Stack(
            children: [
              // Breathing gradient background peek
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
                      child: _loading
                          ? _buildShimmer()
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Greeting row
                                  FadeSlideIn(
                                    child: Row(
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
                                              Text(
                                                'What do you want to learn today?',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Profile button with animated ring
                                        _ProfileButton(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              ProfileScreen.routeName,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Welcome banner with mascot
                                  FadeSlideIn(
                                    delay: const Duration(milliseconds: 100),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            kPurple.withOpacity(0.06),
                                            kPurpleSoft.withOpacity(0.08),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: kPurpleLight.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Welcome!',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Let's start studying!",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FloatingWidget(
                                            magnitude: 5,
                                            child: Image.asset(
                                              'assets/images/main.png',
                                              width: 72,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Action cards
                                  FadeSlideIn(
                                    delay: const Duration(milliseconds: 200),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _ActionCard(
                                            title: 'Add Task',
                                            icon: Icons.add_rounded,
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
                                            icon: Icons.play_arrow_rounded,
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
                                  ),
                                  const SizedBox(height: 20),
                                  // Task grid
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 14,
                                      crossAxisSpacing: 14,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemCount: _tasks.length,
                                    itemBuilder: (context, index) {
                                      return FadeSlideIn(
                                        delay: Duration(
                                          milliseconds: 280 + index * 80,
                                        ),
                                        child: _TaskCard(task: _tasks[index]),
                                      );
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 32, width: 180),
          const SizedBox(height: 8),
          const ShimmerBox(height: 16, width: 240),
          const SizedBox(height: 24),
          const ShimmerBox(height: 90),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: ShimmerBox(height: 110)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(height: 110)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: ShimmerBox(height: 130)),
              SizedBox(width: 14),
              Expanded(child: ShimmerBox(height: 130)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Profile Button with animated pulse ring ────────────────────────────────
class _ProfileButton extends StatefulWidget {
  final VoidCallback? onTap;
  const _ProfileButton({this.onTap});

  @override
  State<_ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<_ProfileButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kPurple.withOpacity(0.15 + _ctrl.value * 0.15),
                blurRadius: 8 + _ctrl.value * 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: CircleAvatar(
        backgroundColor: kSurfaceLight,
        radius: 22,
        child: IconButton(
          icon: const Icon(Icons.person_outline, color: kPurpleDark, size: 22),
          onPressed: widget.onTap,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// ─── Action Card with scale tap ─────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _ActionCard({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleTapCard(
      onTap: onTap,
      child: Container(
        decoration: focuslyGradientBox(radius: 20),
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(minHeight: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Date Formatter ─────────────────────────────────────────────────────────
String _formatDate(int millis) {
  final d = DateTime.fromMillisecondsSinceEpoch(millis);
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final m = months[d.month - 1];
  return '$m ${d.day}, ${d.year}';
}

// ─── Task Card with scale tap + animated progress ───────────────────────────
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
        return ScaleTapCard(
          onTap: () {
            Navigator.pushNamed(
              context,
              ConfirmSessionScreen.routeName,
              arguments: {'taskTitle': task.title, 'repeat': task.repeat},
            );
          },
          child: Container(
            decoration: focuslyGradientBox(radius: 20),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(task.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedProgressBar(
                        value: value,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: kPinkAccent,
                        height: 8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
