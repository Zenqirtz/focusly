import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/logo.dart';
import '../widgets/animated_widgets.dart';
import 'personal_info_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.55;
          return Stack(
            children: [
              // Breathing gradient background
              BreathingGradient(
                colors: const [kPrimaryStop1, kPrimaryStop2, kPrimaryStop3],
                child: const SizedBox.expand(),
              ),
              Column(
                children: [
                  // White top card with logo
                  FadeSlideIn(
                    offset: const Offset(0, -40),
                    duration: const Duration(milliseconds: 700),
                    child: Container(
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
                            color: kPurple.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: FloatingWidget(
                          magnitude: 6,
                          child: FocuslyLogo(width: 220),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Bottom content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: StaggeredColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      staggerDelay: const Duration(milliseconds: 120),
                      children: [
                        const Text(
                          'Welcome to Focusly',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your personal pomodoro friends',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        GlowButton(
                          text: 'Get Started',
                          icon: Icons.arrow_forward_rounded,
                          backgroundColor: Colors.white,
                          foregroundColor: kPurpleDark,
                          glowColor: Colors.white,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              PersonalInfoScreen.routeName,
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                      ],
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
