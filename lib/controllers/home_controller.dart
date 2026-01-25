// ignore_for_file: avoid_log

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/firestore_service.dart';
import '../model/foodlog_model.dart';
import 'dart:developer';

class HomeController extends GetxController {
  final FirestoreService _firestore = FirestoreService();

  // Observable variables for the dashboard UI
  var caloriesConsumed = 0.0.obs;
  var proteinConsumed = 0.0.obs;
  var carbsConsumed = 0.0.obs;
  var fatConsumed = 0.0.obs;
  var calorieGoal = 0.obs;

  // Data for the weekly progress chart and recent history list
  var weeklyChartData = <ChartData>[].obs;
  var historyLogs = <FoodLogEntry>[].obs;

  StreamSubscription? _dailyLogSubscription;
  StreamSubscription? _historySubscription;
  Timer? _midnightTimer;
  DateTime _currentDate = DateTime.now();
  var customFoodTemplates = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
    _startMidnightCheck();
  }

  @override
  void onClose() {
    _dailyLogSubscription?.cancel();
    _historySubscription?.cancel();
    _midnightTimer?.cancel();
    super.onClose();
  }

  // Load initial user data and set up listeners
  void _initData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _firestore.getCustomFoods(user.uid).listen((foods) {
      customFoodTemplates.assignAll(foods);
    });

    _firestore.getUserDetails(user.uid).then((userModel) {
      if (userModel != null) {
        calorieGoal.value = userModel.calorieGoal;
      }
    });

    _subscribeToDailyLog(user.uid);

    _historySubscription = _firestore.getHistory(user.uid).listen((logs) {
      historyLogs.assignAll(logs);
      _calculateWeeklyProgress(logs);
    });
  }

  // Check every minute if the day has changed to reset daily stats
  void _startMidnightCheck() {
    _midnightTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.day != _currentDate.day) {
        _currentDate = now;
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _subscribeToDailyLog(user.uid);
        }
      }
    });
  }

  // Listen to food logs for the specific date and calculate totals
  void _subscribeToDailyLog(String uid) {
    log("Subscribing to log for: ${_currentDate.year}-${_currentDate.month}-${_currentDate.day}");

    _dailyLogSubscription?.cancel();
    _dailyLogSubscription =
        _firestore.getDailyLog(uid, _currentDate).listen((logs) {
      log("Logs received: ${logs.length}"); // See how many logs come back

      double cal = 0, prot = 0, carb = 0, fat = 0;
      for (var log in logs) {
        cal += log.calories;
        prot += log.protein;
        carb += log.carbs;
        fat += log.fat;
      }
      caloriesConsumed.value = cal;
      proteinConsumed.value = prot;
      carbsConsumed.value = carb;
      fatConsumed.value = fat;
    });
  }

  // Aggregate calorie data for the last 7 days for the chart
  void _calculateWeeklyProgress(List<FoodLogEntry> allLogs) {
    Map<int, double> last7Days = {};
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime date = now.subtract(Duration(days: i));
      DateTime key = DateTime(date.year, date.month, date.day);
      last7Days[key.millisecondsSinceEpoch] = 0;
    }

    for (var log in allLogs) {
      DateTime logDate = DateTime(log.date.year, log.date.month, log.date.day);
      if (last7Days.containsKey(logDate.millisecondsSinceEpoch)) {
        last7Days[logDate.millisecondsSinceEpoch] =
            (last7Days[logDate.millisecondsSinceEpoch] ?? 0) + log.calories;
      }
    }

    List<ChartData> result = [];
    List<int> sortedKeys = last7Days.keys.toList()..sort();

    List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    for (var key in sortedKeys) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(key);
      String dayName = weekDays[date.weekday - 1];
      result.add(ChartData(dayName, last7Days[key]!, const Color(0xFF4E74F9)));
    }

    weeklyChartData.assignAll(result);
  }

  // Add a manual food entry to the database
  void addCustomEntry(String name, double cal, double prot, double carb,
      double fat, bool saveToMyFoods) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FoodLogEntry entry = FoodLogEntry(
      userId: user.uid,
      name: name,
      calories: cal,
      protein: prot,
      carbs: carb,
      fat: fat,
      date: DateTime.now(),
      mealType: "Snack",
    );
    _firestore.logFood(entry);

    if (saveToMyFoods) {
      _firestore.addCustomFood(user.uid, name, cal, prot, carb, fat);
    }

    Get.snackbar("Success", "Added $name to your diary",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  double get caloriesRemaining => (calorieGoal.value - caloriesConsumed.value);

  double get progressPercent => calorieGoal.value == 0
      ? 0.0
      : (caloriesConsumed.value / calorieGoal.value * 100);
}
