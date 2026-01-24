import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/firestore_service.dart';
import '../components/navbar_view.dart';

class ProfileSetupController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  final ageController = TextEditingController();
  final heightController = TextEditingController(); 
  final weightController = TextEditingController(); 
  final calorieGoalController = TextEditingController(); 

  var recommendedCalories = 0.obs;

  var selectedGender = "Male".obs;
  var selectedActivityLevel = "Sedentary".obs;
  var selectedGoal = "Maintain Weight".obs;

  final List<String> genders = ["Male", "Female"];
  final List<String> activityLevels = [
    "Sedentary", 
    "Lightly Active", 
    "Moderately Active", 
    "Very Active" 
  ];
  final List<String> goals = [
    "Lose Weight", 
    "Maintain Weight", 
    "Gain Weight" 
  ];

  // Mifflin-St Jeor equation
  void calculateRecommendation() {
    int age = int.tryParse(ageController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    if (age == 0 || height == 0 || weight == 0) {
      Get.snackbar("Missing Info", "Please enter Age, Height, and Weight first.",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    double bmr;
    if (selectedGender.value == "Male") {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double tdee;
    switch (selectedActivityLevel.value) {
      case "Sedentary":
        tdee = bmr * 1.2;
        break;
      case "Lightly Active":
        tdee = bmr * 1.375;
        break;
      case "Moderately Active":
        tdee = bmr * 1.55;
        break;
      case "Very Active":
        tdee = bmr * 1.725;
        break;
      default:
        tdee = bmr * 1.2;
    }

    int calculatedGoal;
    switch (selectedGoal.value) {
      case "Lose Weight":
        calculatedGoal = (tdee - 500).toInt();
        break;
      case "Gain Weight":
        calculatedGoal = (tdee + 500).toInt();
        break;
      default:
        calculatedGoal = tdee.toInt();
    }

    // Update Textfield
    recommendedCalories.value = calculatedGoal;
    calorieGoalController.text = calculatedGoal.toString();
  }

  // Write to Firestore
  void saveProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    
    // Parse inputs
    int age = int.tryParse(ageController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    int finalCalories = int.tryParse(calorieGoalController.text) ?? 0;

    if (age == 0 || height == 0 || weight == 0 || finalCalories == 0) {
      Get.snackbar("Error", "Please ensure all fields are filled.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    await _firestoreService.updateUserStats(
        uid, age, height, weight, finalCalories, selectedGender.value);

    Get.offAll(() => const Dashboard());
    Get.snackbar(
        "Profile Saved", "Your daily goal is set to $finalCalories kcal",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4));
  }
}