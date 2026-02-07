import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/firestore_service.dart';
import '../model/foodlog_model.dart';

class StatsController extends GetxController {
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Chart Data
  var calorieStats = <ChartData>[].obs;
  var weightStats = <ChartData>[].obs;
  
  // Stats Summary
  var averageCalories = 0.0.obs;
  var currentWeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final user = _auth.currentUser;
    if (user == null) return;

    // Listen to Food History & Aggregate by Day
    _firestore.getHistory(user.uid).listen((logs) {
      Map<String, double> dailyTotals = {};

      for (var log in logs) {
        // Group by Date
        String dayKey = "${log.date.month}/${log.date.day}";
        dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + log.calories;
      }

      // Convert to ChartData
      List<ChartData> data = [];
      dailyTotals.forEach((key, value) {
        data.add(ChartData(key, value, const Color(0xFF4E74F9)));
      });
      
      // Reverse so newest is rightmost
      calorieStats.assignAll(data.reversed.toList());
      
      // Calculate Average
      if (data.isNotEmpty) {
        averageCalories.value = data.fold(0.0, (sum, item) => sum + item.y) / data.length;
      }
    });

    // Listen to Weight History
    _firestore.getWeightHistory(user.uid).listen((logs) {
      List<ChartData> wData = [];
      for (var log in logs) {
        if (log['date'] != null) { // Skip if timestamp hasn't generated yet
           DateTime date = (log['date'] as dynamic).toDate();
           String dayKey = "${date.month}/${date.day}";
           double weight = (log['weight'] as num).toDouble();
           wData.add(ChartData(dayKey, weight, Colors.orange));
           currentWeight.value = weight; // Update current
        }
      }
      weightStats.assignAll(wData);
    });
  }

  void addNewWeight(double weight) {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore.logWeight(user.uid, weight);
      Get.back(); // Close dialog
      Get.snackbar("Success", "Weight logged!", 
        backgroundColor: Colors.green, colorText: Colors.white);
    }
  }
}