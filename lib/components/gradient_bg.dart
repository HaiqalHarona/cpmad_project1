import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Blue/Purple Gradient Background
        Container(
          height: MediaQuery.of(context).size.height * 0.35, // Covers top 35%
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E3B8D), // Dark Blue
                Color(0xFF4E74F9), // Main Blue
                Color(0xFF8DA4F7), // Light Purple/Blue
              ],
            ),
          ),
        ),
        // 2. Decorative Abstract Circles
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: -40,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
        ),
        // 3. The Page Content
        child,
      ],
    );
  }
}