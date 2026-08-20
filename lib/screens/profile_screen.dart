import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';
import '../widgets/animated_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String _name = '';
  int _taskCount = 0;
  int _studies = 0;
  int _energyPoints = 0;
  bool _loaded = false;

  late final AnimationController _badgeCtrl;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeCtrl, curve: Curves.elasticOut),
    );
    _load();
  }

  Future<void> _load() async {
    final user = await AppDb.instance.getUser();
    final taskCount = await AppDb.instance.tasksCount();
    final studies = await AppDb.instance.completedSessionsCount();
    final energy = await AppDb.instance.totalEnergyPoints();
    if (!mounted) return;
    setState(() {
      _name = (user?['name'] as String?) ?? '';
      _taskCount = taskCount;
      _studies = studies;
      _energyPoints = energy;
      _loaded = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _badgeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rankLevel = _energyPoints ~/ 20;
    final energy = _energyPoints % 20;
    final rankNames = ['ROOKIE', 'ADEPT', 'PRO', 'MASTER'];
    final rankName = rankNames[rankLevel.clamp(0, rankNames.length - 1)];
    String? rankImage;
    if (rankName == 'ROOKIE') {
      rankImage = 'assets/images/rookie.png';
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              FadeSlideIn(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: kPurpleDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              // Profile header card
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: Container(
                  decoration: focuslyGradientBox(radius: 28),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with glow ring
                      _AvatarGlow(
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _name.isEmpty ? 'User' : _name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AnimatedStat(
                            label: 'Points',
                            value: _loaded ? _energyPoints : 0,
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _AnimatedStat(
                            label: 'Task',
                            value: _loaded ? _taskCount : 0,
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _AnimatedStat(
                            label: 'Studies',
                            value: _loaded ? _studies : 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Rank section
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Your Rank :',
                  style: TextStyle(
                    color: kPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Rank card with badge bounce-in
              FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: _RankGlowCard(
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _badgeScale,
                        child: rankImage != null
                            ? Image.asset(rankImage, width: 120)
                            : Text(
                                rankName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: kPurpleDark,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          FloatingWidget(
                            magnitude: 3,
                            child: Image.asset(
                              'assets/images/energi.png',
                              width: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AnimatedProgressBar(
                              value: energy / 20.0,
                              backgroundColor: Colors.black.withOpacity(0.08),
                              valueColor: kPurple,
                              height: 14,
                              borderRadius: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$energy/20',
                            style: const TextStyle(
                              color: kPurpleDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeSlideIn(
                delay: const Duration(milliseconds: 350),
                child: Center(
                  child: Text(
                    'Keep studying to improve your study rank!',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Avatar with Animated Glow Ring ─────────────────────────────────────────
class _AvatarGlow extends StatefulWidget {
  final Widget child;
  const _AvatarGlow({required this.child});

  @override
  State<_AvatarGlow> createState() => _AvatarGlowState();
}

class _AvatarGlowState extends State<_AvatarGlow>
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
                color: Colors.white.withOpacity(0.15 + _ctrl.value * 0.2),
                blurRadius: 14 + _ctrl.value * 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ─── Animated Stat with CountUp ─────────────────────────────────────────────
class _AnimatedStat extends StatelessWidget {
  final String label;
  final int value;
  const _AnimatedStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCountUp(
          value: value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}

// ─── Rank Card with Glow ────────────────────────────────────────────────────
class _RankGlowCard extends StatefulWidget {
  final Widget child;
  const _RankGlowCard({required this.child});

  @override
  State<_RankGlowCard> createState() => _RankGlowCardState();
}

class _RankGlowCardState extends State<_RankGlowCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
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
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: kPurpleLight.withOpacity(0.25 + _ctrl.value * 0.25),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kPurple.withOpacity(0.05 + _ctrl.value * 0.08),
                blurRadius: 10 + _ctrl.value * 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
