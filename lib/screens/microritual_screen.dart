import 'package:flutter/material.dart';
import 'dart:async';
import 'pomodoro_screen.dart';
import '../data/database.dart';
import '../theme.dart';

class MicroritualScreen extends StatefulWidget {
  const MicroritualScreen({super.key});
  static const routeName = '/microritual';
  @override
  State<MicroritualScreen> createState() => _MicroritualScreenState();
}

class _MicroritualScreenState extends State<MicroritualScreen> {
  int seconds = 60;
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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: kPurpleLight,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Microritual Session',
                                      style: TextStyle(
                                        color: kPurpleDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Make yourself comfortable, grab some music,\ncoffee, or do a motivational writing',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 14),
                                  Image.asset(
                                    'assets/images/micro.png',
                                    width: 140,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '$minutes:$secs',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Your study session will start soon',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
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
                                    await AppDb.instance.markMicroritualStart(
                                      id,
                                    );
                                  }
                                  _timer?.cancel();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    PomodoroScreen.routeName,
                                    arguments: {'sessionId': id},
                                  );
                                },
                                child: const Text('Start Pomodoro'),
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
