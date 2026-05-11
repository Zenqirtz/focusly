import 'package:flutter/material.dart';

class FocuslyLogo extends StatelessWidget {
  final double? width;
  final double? height;
  const FocuslyLogo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) {
        return const Text(
          'focusly',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        );
      },
    );
  }
}
