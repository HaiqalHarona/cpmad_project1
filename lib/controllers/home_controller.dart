import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService _firestore = FirestoreService();

  var caloriesConsumed = 0.0.obs;
  var proteinConsumed = 0.0.obs;
  var carbsConsumed = 0.0.obs;
  var fatConsumed = 0.0.obs;
  var calorieGoal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _firestore.getUserDetails(user.uid).then((userModel) {
      if (userModel != null) {
        calorieGoal.value = userModel.calorieGoal;
      }
    });

    _firestore.getDailyLog(user.uid, DateTime.now()).listen((logs) {
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

  double get caloriesRemaining =>
      (calorieGoal.value - caloriesConsumed.value).clamp(0, double.infinity);

  // Added check: If goal is 0 (loading), return 0% to avoid "Division by Zero" error
  double get progressPercent => calorieGoal.value == 0
      ? 0.0
      : (caloriesConsumed.value / calorieGoal.value * 100).clamp(0, 100);
}
