import 'package:flutter/material.dart';
import 'main_apps_screen.dart';
import '../data/database.dart';
import '../theme.dart';
import '../widgets/animated_widgets.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  static const routeName = '/personal-info';

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nicknameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight;
          return Stack(
            children: [
              // Breathing gradient background
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
                          color: kPurple.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: StaggeredColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          staggerDelay: const Duration(milliseconds: 100),
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Hi,.....',
                              style: TextStyle(
                                color: kPurple,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "I Don't know your name",
                              style: TextStyle(
                                color: kPurple,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please fill out this information below\nso we can recognize you',
                              style: TextStyle(
                                color: kPurpleDark.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _AnimatedInput(
                              controller: _nameCtrl,
                              hint: 'Fullname',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 14),
                            _AnimatedInput(
                              controller: _nicknameCtrl,
                              hint: 'Nickname',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 24),
                            GlowButton(
                              text: 'Next',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () async {
                                await AppDb.instance.upsertUser(
                                  _nameCtrl.text.trim(),
                                  _nicknameCtrl.text.trim(),
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacementNamed(
                                  context,
                                  MainAppsScreen.routeName,
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Floating mascot
              Positioned(
                right: 10,
                bottom: 10,
                child: FloatingWidget(
                  magnitude: 10,
                  duration: const Duration(milliseconds: 2500),
                  child: Image.asset('assets/images/info.png', width: 200),
                ),
              ),
              // Top label
              Positioned(
                left: 16,
                top: 8,
                child: SafeArea(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Input field with animated focus ring glow.
class _AnimatedInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _AnimatedInput({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  State<_AnimatedInput> createState() => _AnimatedInputState();
}

class _AnimatedInputState extends State<_AnimatedInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: kPurple.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: TextField(
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: kPurpleSoft,
            prefixIcon: Icon(widget.icon, color: Colors.white),
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ),
    );
  }
}
