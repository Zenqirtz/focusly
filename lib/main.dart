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
      darkTheme: buildFocuslyTheme(dark: true),
      themeMode: ThemeMode.light,
      initialRoute: SplashScreen.routeName,
      onGenerateInitialRoutes: (initialRoute) {
        return [
          FocuslyPageRoute(
            page: const SplashScreen(),
            settings: const RouteSettings(name: SplashScreen.routeName),
          ),
        ];
      },
      onGenerateRoute: (settings) {
        final routes = <String, Widget>{
          SplashScreen.routeName: const SplashScreen(),
          WelcomeScreen.routeName: const WelcomeScreen(),
          PersonalInfoScreen.routeName: const PersonalInfoScreen(),
          MainAppsScreen.routeName: const MainAppsScreen(),
          AddTaskScreen.routeName: const AddTaskScreen(),
          ConfirmSessionScreen.routeName: const ConfirmSessionScreen(),
          MicroritualScreen.routeName: const MicroritualScreen(),
          PomodoroScreen.routeName: const PomodoroScreen(),
          BreakScreen.routeName: const BreakScreen(),
          EndScreen.routeName: const EndScreen(),
          ProfileScreen.routeName: const ProfileScreen(),
        };
        final page = routes[settings.name];
        if (page != null) {
          return FocuslyPageRoute(page: page, settings: settings);
        }
        return null;
      },
    );
  }
}
