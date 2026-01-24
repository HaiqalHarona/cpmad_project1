// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/foodlog_model.dart';
import '../model/user_model.dart';

class FirestoreService {
  // Collection Creation
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('food_logs');

  // Register User
  Future<void> saveUser(String uid, String email, String username) async {
    // Create the user object
    UserModel newUser = UserModel(
      uid: uid,
      email: email,
      username: username,
      // Default values for new users
      age: 0,
      height: 0,
      weight: 0,
      calorieGoal: 2000,
    );


    await usersCollection.doc(uid).set(
      newUser.toMap()..addAll({
        'created_at': DateTime.now().toIso8601String(),
      }),
    );
  }
  // Update User Stats on new user register
  Future<void> updateUserStats(String uid, int age, double height, double weight, int calorieGoal, String gender) async {
    await usersCollection.doc(uid).update({
      'age': age,
      'height': height,
      'weight': weight,
      'calorie_goal': calorieGoal,
      'gender': gender,
    });
  }


  Future<void> logFood(FoodLogEntry entry) async {
    await foodCollection.add(entry.toMap());
  }

  Stream<List<FoodLogEntry>> getDailyLog(String uid, DateTime date) {
    String dateString = "${date.year}-${date.month}-${date.day}";

    return foodCollection
        .where('userId', isEqualTo: uid)
        .where('date_string', isEqualTo: dateString)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodLogEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<FoodLogEntry>> getHistory(String uid) {
    return foodCollection
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodLogEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addCustomFood(String uid, String name, double cal, double p, double c, double f) async {
    await usersCollection.doc(uid).collection('custom_foods').add({
      'name': name,
      'calories': cal,
      'protein': p,
      'carbs': c,
      'fat': f,
    });
  }

  Stream<List<Map<String, dynamic>>> getCustomFoods(String uid) {
    return usersCollection
        .doc(uid)
        .collection('custom_foods')
        .snapshots()
        .map((snapshot) => snapshot.docs
            // ignore: unnecessary_cast
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }
}