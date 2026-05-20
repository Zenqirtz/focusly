import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/animated_widgets.dart';
import '../theme.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    // Logo bounce-in
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut),
    );
    // Fade out before transition
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
    );

    _scaleCtrl.forward();

    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (!mounted) return;
      await _fadeCtrl.forward();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    });
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BreathingGradient(
        colors: const [kPrimaryStop1, kPrimaryStop2, kPrimaryStop3],
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleCtrl, _fadeCtrl]),
            builder: (_, child) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: child,
                ),
              );
            },
            child: const FocuslyLogo(width: 220),
          ),
        ),
      ),
    );
  }
}
