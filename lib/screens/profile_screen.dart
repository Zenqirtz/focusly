import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  int _taskCount = 0;
  int _studies = 0;
  int _energyPoints = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await AppDb.instance.getUser();
    final taskCount = await AppDb.instance.tasksCount();
    final studies = await AppDb.instance.completedSessionsCount();
    final energy = await AppDb.instance.totalEnergyPoints();
    setState(() {
      _name = (user?['name'] as String?) ?? '';
      _taskCount = taskCount;
      _studies = studies;
      _energyPoints = energy;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: focuslyGradientBox(radius: 24),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 36),
                    const SizedBox(height: 8),
                    Text(
                      _name.isEmpty ? 'User' : _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TopStat(label: 'Studies', value: _studies.toString()),
                        _TopStat(label: 'Task', value: _taskCount.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Your Rank :',
                style: TextStyle(color: kPurple, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPurpleLight, width: 2),
                ),
                child: Column(
                  children: [
                    if (rankImage != null)
                      Image.asset(rankImage, width: 120)
                    else
                      Text(
                        rankName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kPurpleDark,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Image.asset('assets/images/energi.png', width: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: energy / 20.0,
                              minHeight: 12,
                              backgroundColor: Colors.black12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kPurple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$energy/20',
                          style: const TextStyle(color: kPurpleDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'Keep studying to improve your study rank!',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// legacy metric removed

class _TopStat extends StatelessWidget {
  final String label;
  final String value;
  const _TopStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
