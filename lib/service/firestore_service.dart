import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/foodlog_model.dart';
import '../model/user_model.dart';

class FirestoreService {

  // Collection References
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('food_logs');

  // User Creation
  Future<void> saveUser(String uid, String email, String username) async {
    UserModel newUser = UserModel(
      uid: uid,
      email: email,
      username: username,
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

  // User Stats Update
  Future<void> updateUserStats(String uid, int age, double height, double weight, int calorieGoal, String gender) async {
    await usersCollection.doc(uid).update({
      'age': age,
      'height': height,
      'weight': weight,
      'calorie_goal': calorieGoal,
      'gender': gender,
    });
  }

  // Log Food Entry
  Future<void> logFood(FoodLogEntry entry) async {
    Map<String, dynamic> data = entry.toMap();

    DateTime d = entry.date;
    String month = d.month.toString().padLeft(2, '0');
    String day = d.day.toString().padLeft(2, '0');
    String dateString = "${d.year}-$month-$day";
    
    data['date_string'] = dateString;

    if (data['timestamp'] == null) {
      data['timestamp'] = FieldValue.serverTimestamp();
    }

    await foodCollection.add(data);
  }
  // Get Daily Food Log
  Stream<List<FoodLogEntry>> getDailyLog(String uid, DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String dateString = "${date.year}-$month-$day";

    return foodCollection
        .where('userId', isEqualTo: uid)
        .where('date_string', isEqualTo: dateString)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodLogEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get Food Diary History
  Stream<List<FoodLogEntry>> getHistory(String uid) {
    return foodCollection
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodLogEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Add Custom Food
  Future<void> addCustomFood(String uid, String name, double cal, double p, double c, double f) async {
    await usersCollection.doc(uid).collection('custom_foods').add({
      'name': name,
      'calories': cal,
      'protein': p,
      'carbs': c,
      'fat': f,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Get Custom Foods
  Stream<List<Map<String, dynamic>>> getCustomFoods(String uid) {
    return usersCollection
        .doc(uid)
        .collection('custom_foods')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data())
            .toList());
  }

  // Get User Details
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user: $e");
    }
    return null;
  }

  // Remove Food Entry
  Future<void> removeFoodEntry(String docId) async {
    await foodCollection.doc(docId).delete();
  }
}