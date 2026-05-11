import 'package:flutter/material.dart';
import '../data/database.dart';
import '../theme.dart';

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
  String _category = 'Study';
  final List<String> _subs = [];

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            Text(
                              'Ready for next task?',
                              style: const TextStyle(
                                color: kPurple,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _taskCtrl,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFB084E8),
                                hintText: 'Name of Study',
                                prefixIcon: const Icon(
                                  Icons.menu_book,
                                  color: Colors.white,
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<int>(
                              initialValue: _repeat,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFB084E8),
                                hintText: 'Pomodoro Repeat',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
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
                            const SizedBox(height: 18),
                            Slider(
                              value: _priority,
                              onChanged: (v) => setState(() => _priority = v),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Low'),
                                Text('Medium'),
                                Text('High'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _durationLabel(_priority),
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            const Text('Add additional task?'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kPurpleLight,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: _additionalCtrl,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFB084E8),
                                      hintText: 'Additional Task',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          final s = _additionalCtrl.text.trim();
                                          if (s.isEmpty) return;
                                          setState(() {
                                            _subs.add(s);
                                            _additionalCtrl.clear();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPurple,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(Icons.add, size: 16),
                                        label: const Text('Add'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _subs
                                        .map(
                                          (t) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kPurple,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.bookmark,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  t,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                InkWell(
                                                  onTap: () {
                                                    setState(
                                                      () => _subs.remove(t),
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white70,
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
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
                                  final taskId = await AppDb.instance
                                      .insertTask(t);
                                  await AppDb.instance.insertTaskSubtasks(
                                    taskId,
                                    _subs,
                                  );
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: kPurpleDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                child: const Text('Save'),
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
