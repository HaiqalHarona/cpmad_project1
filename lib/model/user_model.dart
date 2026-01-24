
class UserModel {
  final String uid;
  final String email;
  final String username;
  final int age;
  final double height;
  final double weight;
  final int calorieGoal;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
    required this.calorieGoal,
  });

// Reader
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? 'User',
      age: data['age'] ?? 0,
      // Handle potential int/double confusion from Firestore
      height: (data['height'] ?? 0).toDouble(),
      weight: (data['weight'] ?? 0).toDouble(),
      calorieGoal: data['calorie_goal'] ?? 2000,
    );
  }

// Writer
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'age': age,
      'height': height,
      'weight': weight,
      'calorie_goal': calorieGoal,
    };
  }
}
