import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Tokens ───────────────────────────────────────────────────────────
const Color kPurpleDark = Color(0xFF2E0042);
const Color kPurple = Color(0xFF7500A8);
const Color kPurpleLight = Color(0xFF9546B7);
const Color kPurpleSoft = Color(0xFFB084E8);
const Color kPrimaryStop1 = Color(0xFF7500A8);
const Color kPrimaryStop2 = Color(0xFF9546B7);
const Color kPrimaryStop3 = Color(0xFF2E0042);
const Color kPinkAccent = Color(0xFFE35D8E);
const Color kSurfaceLight = Color(0xFFF7F4FB);
const Color kGlowPurple = Color(0xFFAA66DD);
const Color kCardBg = Color(0xFFFAF7FE);

// Dark mode tokens
const Color kDarkBg = Color(0xFF121018);
const Color kDarkSurface = Color(0xFF1E1A26);
const Color kDarkCard = Color(0xFF2A2434);

// ─── Gradient Helpers ───────────────────────────────────────────────────────
LinearGradient focuslyPrimaryGradient({
  Alignment begin = Alignment.topLeft,
  Alignment end = Alignment.bottomRight,
}) =>
    LinearGradient(
      colors: const [kPrimaryStop1, kPrimaryStop2, kPrimaryStop3],
      begin: begin,
      end: end,
    );

LinearGradient focuslySoftGradient() => const LinearGradient(
      colors: [Color(0xFF9546B7), Color(0xFF7500A8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

// ─── Box Decorations ────────────────────────────────────────────────────────
BoxDecoration focuslyGradientBox({
  double radius = 20,
  List<BoxShadow>? shadows,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: focuslyPrimaryGradient(),
    boxShadow: shadows ??
        [
          BoxShadow(
            color: kPurple.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
  );
}

BoxDecoration focuslyGlassDecoration({
  double radius = 24,
  Color tint = Colors.white,
  double opacity = 0.12,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: tint.withOpacity(opacity),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1.2,
    ),
  );
}

// ─── Theme Builder ──────────────────────────────────────────────────────────
ThemeData buildFocuslyTheme({bool dark = false}) {
  final base =
      dark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
  final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
    bodyColor: dark ? Colors.white : kPurpleDark,
    displayColor: dark ? Colors.white : kPurpleDark,
  );
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPurple,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: kPurple,
      secondary: kPinkAccent,
      surface: dark ? kDarkSurface : kSurfaceLight,
    ),
    scaffoldBackgroundColor: dark ? kDarkBg : Colors.white,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: dark ? Colors.white : kPurpleDark,
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
      fillColor: dark ? kDarkCard : kSurfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: dark ? kDarkCard : kSurfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.all(0),
    ),
  );
}

// ─── Page Transition ────────────────────────────────────────────────────────
class FocuslyPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FocuslyPageRoute({required this.page, super.settings})
      : super(
          pageBuilder: (ctx, a1, a2) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final fadeIn = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            final slideIn = Tween<Offset>(
              begin: const Offset(0.0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            return FadeTransition(
              opacity: fadeIn,
              child: SlideTransition(position: slideIn, child: child),
            );
          },
        );
}

// ─── Header Widget ──────────────────────────────────────────────────────────
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
