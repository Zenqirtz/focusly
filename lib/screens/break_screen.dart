import 'package:flutter/material.dart';
import 'dart:async';
import 'end_screen.dart';
import '../data/database.dart';
import '../theme.dart';

class BreakScreen extends StatefulWidget {
  const BreakScreen({super.key});
  static const routeName = '/break';
  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  int seconds = 5 * 60;
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
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Break',
                                style: TextStyle(
                                  color: kPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Image.asset('assets/images/break.png', width: 140),
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
                              'Take a break! Refresh your mind',
                              style: TextStyle(color: Colors.black54),
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
                                child: const Text('Finish'),
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
