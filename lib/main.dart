import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/main_apps_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/confirm_session_screen.dart';
import 'screens/microritual_screen.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/break_screen.dart';
import 'screens/end_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FocuslyApp());
}

class FocuslyApp extends StatelessWidget {
  const FocuslyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focusly',
      debugShowCheckedModeBanner: false,
      theme: buildFocuslyTheme(),
      initialRoute: SplashScreen.routeName,
      onGenerateInitialRoutes: (initialRoute) {
        return [
          MaterialPageRoute(
            builder: (_) => const SplashScreen(),
            settings: const RouteSettings(name: SplashScreen.routeName),
          ),
        ];
      },
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        PersonalInfoScreen.routeName: (_) => const PersonalInfoScreen(),
        MainAppsScreen.routeName: (_) => const MainAppsScreen(),
        AddTaskScreen.routeName: (_) => const AddTaskScreen(),
        ConfirmSessionScreen.routeName: (_) => const ConfirmSessionScreen(),
        MicroritualScreen.routeName: (_) => const MicroritualScreen(),
        PomodoroScreen.routeName: (_) => const PomodoroScreen(),
        BreakScreen.routeName: (_) => const BreakScreen(),
        EndScreen.routeName: (_) => const EndScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
      },
    );
  }
}
