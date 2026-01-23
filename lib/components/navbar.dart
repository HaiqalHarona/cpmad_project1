import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../controllers/navbar.dart';

import '../views/dashboard.dart';
import '../views/search.dart';
import '../views/editprofile.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final NavController navController = Get.put(NavController());

  final List<Widget> _pages = [
    // const DashboardView(),
    // const SearchView(),
    // const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navController.tabIndex.value,
        children: _pages,
      )),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}