import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import '../service/firestore_service.dart';
import '../views/login.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Text Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final calorieGoalController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // Fetch current data to pre-fill the form
  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      UserModel? userData = await _firestoreService.getUserDetails(user.uid);
      if (userData != null) {
        usernameController.text = userData.username;
        heightController.text = userData.height.toString();
        weightController.text = userData.weight.toString();
        calorieGoalController.text = userData.calorieGoal.toString();
      }
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    final user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestoreService.updateUserStats(
          user.uid,
          0, 
          double.tryParse(heightController.text) ?? 0,
          double.tryParse(weightController.text) ?? 0,
          int.tryParse(calorieGoalController.text) ?? 2000,
          "Male", // Default or add Gender selector if needed
        );

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': usernameController.text,
        });

        // 2. Update Password (if typed)
        if (passwordController.text.isNotEmpty) {
          await user.updatePassword(passwordController.text);
          Get.snackbar("Success", "Password updated!", 
            backgroundColor: Colors.green, colorText: Colors.white);
        }

        Get.snackbar("Saved", "Profile updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
            
      } catch (e) {
        Get.snackbar("Error", e.toString(),
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    await _auth.signOut();
    
    // Removes all previous screens 
    Get.offAll(() =>  LoginView()); 
  }
}
  