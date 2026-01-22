import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login.dart';

void main() {
  runApp(const NutritrackApp());
}

class NutritrackApp extends StatelessWidget {
  const NutritrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutritrack',
      theme: ThemeData(
        primaryColor: const Color(0xFF4e74f9),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial', 
      ),
      home: LoginView(),
    );
  }
}