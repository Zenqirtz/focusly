import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'welcome': 'Welcome to Focusly',
      'subtitle': 'Your personal pomodoro friends',
      'get_started': 'Get Started',
      'start_session': 'Start Session',
      'take_break': 'Take a Break',
      'keep_studying': 'Keep Studying',
      'add_task': 'Add Task',
      'finish': 'Finish',
      'you_did_it': 'You did it, Good Job! 🎉',
      'reward': 'Reward :',
    },
    'id': {
      'welcome': 'Selamat Datang di Focusly',
      'subtitle': 'Teman pemacu konsentrasi Anda',
      'get_started': 'Mulai Sekarang',
      'start_session': 'Mulai Sesi',
      'take_break': 'Istirahat Sejenak',
      'keep_studying': 'Tetap Belajar',
      'add_task': 'Tambah Tugas',
      'finish': 'Selesai',
      'you_did_it': 'Kerja Bagus, Kamu Berhasil! 🎉',
      'reward': 'Hadiah :',
    },
  };

  String get(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async {
    return AppStrings(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
