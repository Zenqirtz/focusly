import 'package:flutter/material.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  static const routeName = '/add-task';

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskCtrl = TextEditingController();
  final _additionalCtrl = TextEditingController();
  double _priority = 0.5;
  int _repeat = 1;
  final String _category = 'Study';
  final List<String> _subs = [];

  @override
  void dispose() {
    _taskCtrl.dispose();
    _additionalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeSlideIn(
                              child: const Text(
                                'Ready for next task?',
                                style: TextStyle(
                                  color: kPurple,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 80),
                              child: _PurpleInput(
                                controller: _taskCtrl,
                                hint: 'Name of Study',
                                icon: Icons.menu_book,
                              ),
                            ),
                            const SizedBox(height: 14),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 160),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPurpleSoft,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Pomodoro Repeat',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    const Spacer(),
                                    DropdownButton<int>(
                                      value: _repeat,
                                      dropdownColor: kPurpleSoft,
                                      underline: const SizedBox.shrink(),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      items: List.generate(8, (i) => i + 1)
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text('$e'),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => _repeat = v ?? _repeat),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 240),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: kPurple,
                                      inactiveTrackColor:
                                          kPurple.withValues(alpha: 0.15),
                                      thumbColor: kPurple,
                                      overlayColor:
                                          kPurple.withValues(alpha: 0.12),
                                      trackHeight: 6,
                                    ),
                                    child: Slider(
                                      value: _priority,
                                      onChanged: (v) =>
                                          setState(() => _priority = v),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Low',
                                          style: TextStyle(
                                            color: _priority < 0.34
                                                ? kPurple
                                                : Colors.black45,
                                            fontWeight: _priority < 0.34
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Medium',
                                          style: TextStyle(
                                            color: _priority >= 0.34 &&
                                                    _priority < 0.67
                                                ? kPurple
                                                : Colors.black45,
                                            fontWeight:
                                                _priority >= 0.34 &&
                                                        _priority < 0.67
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'High',
                                          style: TextStyle(
                                            color: _priority >= 0.67
                                                ? kPurple
                                                : Colors.black45,
                                            fontWeight: _priority >= 0.67
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      _durationLabel(_priority),
                                      style: TextStyle(
                                        color:
                                            Colors.black.withValues(alpha: 0.45),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 320),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add additional task?',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            kPurpleLight.withValues(alpha: 0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _PurpleInput(
                                          controller: _additionalCtrl,
                                          hint: 'Additional Task',
                                          icon: Icons.bookmark_add_outlined,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            _MiniPurpleButton(
                                              label: 'Add',
                                              icon: Icons.add,
                                              onTap: () {
                                                final s = _additionalCtrl.text
                                                    .trim();
                                                if (s.isEmpty) return;
                                                setState(() {
                                                  _subs.add(s);
                                                  _additionalCtrl.clear();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        if (_subs.isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: _subs
                                                .map((t) => _SubChip(
                                                      label: t,
                                                      onRemove: () =>
                                                          setState(() =>
                                                              _subs.remove(t)),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 400),
                              child: GlowButton(
                                text: 'Save',
                                icon: Icons.check_rounded,
                                onPressed: () async {
                                  final title = _taskCtrl.text.trim();
                                  if (title.isEmpty) return;
                                  final t = Task(
                                    title: title,
                                    category: _category,
                                    priority: _priority,
                                    createdAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                    repeat: _repeat,
                                  );
                                  final taskId =
                                      await AppDb.instance.insertTask(t);
                                  await AppDb.instance
                                      .insertTaskSubtasks(taskId, _subs);
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
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

  String _durationLabel(double p) {
    if (p < 0.34) return 'Work: 15 min • Break: 5 min';
    if (p < 0.67) return 'Work: 25 min • Break: 5 min';
    return 'Work: 55 min • Break: 5 min';
  }
}

class _PurpleInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  const _PurpleInput({
    required this.controller,
    required this.hint,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: kPurpleSoft,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _MiniPurpleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _MiniPurpleButton({
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPurple,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;
  const _SubChip({required this.label, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: focuslySoftGradient(),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kPurple.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                color: Colors.white.withValues(alpha: 0.7),
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
