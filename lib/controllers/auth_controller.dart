import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../service/firestore_service.dart';
import '../views/dashboard.dart';
import '../views/login.dart';

class AuthController extends GetxController {
  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  FirestoreService get _firestoreService => FirestoreService();

  // if null no user logged in
  var firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    //Check logged in session
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // register function
  void register(String email, String password, String username) async {
    try {
      // create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // save credentials to db
      if (userCredential.user != null) {
        await _firestoreService.saveUser(
            userCredential.user!.uid,
            email,
            username);

        // force sign out to ensure user log in manually
        await _auth.signOut(); 

        Get.snackbar("Success", "Account created! Please log in.",
            backgroundColor: Colors.greenAccent);
        Get.offAll(() => LoginView());                                      
      }
    } on FirebaseAuthException catch (e) {
      // check for existing user
      Get.snackbar("Registration Error", e.message ?? "Unknown Error",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }


  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      
      Get.offAll(() => Dashboard()); 
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Check your credentials",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // logout user
  void logout() async {
    await _auth.signOut();
    Get.offAll(() => LoginView());
  }
}