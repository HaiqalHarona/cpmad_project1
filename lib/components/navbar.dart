import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final NavController navController = Get.find();

  CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => NavigationBar(
      elevation: 5,
      backgroundColor: Colors.white,
      selectedIndex: navController.tabIndex.value,
      onDestinationSelected: navController.changeTabIndex,
      indicatorColor: const Color(0xFF4e74f9).withOpacity(0.2),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book, color: Color(0xFF4e74f9)),
          label: 'Diary',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search, color: Color(0xFF4e74f9)),
          label: 'Search',
        ),
                NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF4e74f9)),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Color(0xFF4e74f9)),
          label: 'Profile',
        ),

      ],
    ));
  }
}