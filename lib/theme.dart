import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPurpleDark = Color(0xFF2E0042);
const Color kPurple = Color(0xFF7500A8);
const Color kPurpleLight = Color(0xFF9546B7);
const Color kPrimaryStop1 = Color(0xFF7500A8);
const Color kPrimaryStop2 = Color(0xFF9546B7);
const Color kPrimaryStop3 = Color(0xFF2E0042);
const Color kPinkAccent = Color(0xFFE35D8E);
const Color kSurfaceLight = Color(0xFFF7F4FB);

ThemeData buildFocuslyTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final textTheme = GoogleFonts.poppinsTextTheme(
    base.textTheme,
  ).apply(bodyColor: kPurpleDark, displayColor: kPurpleDark);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPurple,
      brightness: Brightness.light,
      primary: kPurple,
      secondary: kPinkAccent,
      surface: kSurfaceLight,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: kPurpleDark,
      elevation: 0,
      centerTitle: true,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: kSurfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.all(0),
    ),
  );
}

LinearGradient focuslyPrimaryGradient() => const LinearGradient(
  colors: [kPrimaryStop1, kPrimaryStop2, kPrimaryStop3],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

BoxDecoration focuslyGradientBox({double radius = 20}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: focuslyPrimaryGradient(),
  );
}

Widget focuslyHeader(String title, {Widget? trailing}) {
  return Container(
    decoration: focuslyGradientBox(radius: 24),
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tetap produktif dan konsisten',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    ),
  );
}
