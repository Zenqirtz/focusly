import 'package:flutter/material.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key});
  static const routeName = '/end';

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _celebCtrl;
  late final Animation<double> _celebScale;

  @override
  void initState() {
    super.initState();
    _celebCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _celebScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _celebCtrl, curve: Curves.elasticOut),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _celebCtrl.forward();
    });
  }

  @override
  void dispose() {
    _celebCtrl.dispose();
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FadeSlideIn(
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pemrograman Mobile',
                                  style: TextStyle(
                                    color: kPurple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 100),
                              child: FloatingWidget(
                                magnitude: 6,
                                child: Image.asset(
                                  'assets/images/end.png',
                                  width: 130,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 150),
                              child: const Text(
                                '00:00',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: kPurpleDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: Text(
                                'You did it, Good Job! 🎉',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 250),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Reward :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Reward card with scale-in bounce
                            ScaleTransition(
                              scale: _celebScale,
                              child: _RewardCard(),
                            ),
                            const SizedBox(height: 28),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 400),
                              child: GlowButton(
                                text: 'Finish',
                                icon: Icons.check_circle_outline_rounded,
                                onPressed: () async {
                                  final args =
                                      (ModalRoute.of(context)
                                              ?.settings
                                              .arguments as Map?) ??
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
                                    (route) =>
                                        route.settings.name == '/main',
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

class _RewardCard extends StatefulWidget {
  @override
  State<_RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<_RewardCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: kPurpleLight.withValues(alpha: 0.3 + _glowCtrl.value * 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kPurple.withValues(alpha: 0.06 + _glowCtrl.value * 0.08),
                blurRadius: 12 + _glowCtrl.value * 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingWidget(
            magnitude: 4,
            child: Image.asset('assets/images/energi.png', width: 52),
          ),
          const SizedBox(height: 10),
          const AnimatedCountUp(
            value: 2,
            style: TextStyle(
              color: kPurple,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
