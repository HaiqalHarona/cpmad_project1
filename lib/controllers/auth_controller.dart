import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../service/firestore_service.dart';
import '../components/navbar_view.dart';
import '../views/login.dart';
import '../views/setup.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  FirestoreService get _firestoreService => FirestoreService();

  var firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  void register(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await _firestoreService.saveUser(
            userCredential.user!.uid,
            email,
            username);

        // Redirect to user setup
        Get.offAll(() => const SetupProfileView()); 
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Error", e.message ?? "Unknown Error",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      
      Get.offAll(() => const Dashboard()); 
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Unknown Error",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAll(() => LoginView());
  }
}