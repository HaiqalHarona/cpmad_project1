import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import 'navbar.dart';
import '../views/home.dart';
import '../views/search.dart';
import '../views/editprofile.dart';
import '../views/stats.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.put(NavController());

    final List<Widget> pages = [
      const HomeView(),
      const SearchView(),
      const ProfileView(),
      const StatsView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navController.tabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
