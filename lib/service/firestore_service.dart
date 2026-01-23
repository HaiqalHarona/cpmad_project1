import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Collection Creation
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('food_logs');

  // Register User
  Future<void> saveUser(String uid, String email, String username) async {

    await usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'created_at': DateTime.now().toIso8601String(),
      // Default values for new users
      'age': 0,
      'height': 0,
      'weight': 0,
      'calorie_goal': 2000,
    });
  }


}
