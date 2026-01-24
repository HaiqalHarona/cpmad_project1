import 'package:flutter/material.dart';

class LoggedInBackground extends StatelessWidget {
  final Widget child;

  const LoggedInBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4E74F9), // Vibrant Blue (Top)
            Color(0xFF5B4FE1), // Deep Purple (Bottom)
          ],
        ),
      ),
      child: child,
    );
  }
}
