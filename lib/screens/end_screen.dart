import 'package:flutter/material.dart';
import '../data/database.dart';
import '../theme.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});
  static const routeName = '/end';

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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'End',
                                style: TextStyle(
                                  color: kPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Image.asset('assets/images/end.png', width: 140),
                            const SizedBox(height: 16),
                            const Text(
                              '00:00',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'You did it, Good Job',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text('Reward :'),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kPurpleLight,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 6),
                                  Image.asset(
                                    'assets/images/energi.png',
                                    width: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '2',
                                    style: TextStyle(
                                      color: kPurple,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
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
                                    await AppDb.instance.finishSession(
                                      id,
                                      rewardPoints: 2,
                                    );
                                  }
                                  if (!context.mounted) return;
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.settings.name == '/main',
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
