import 'package:cloud_firestore/cloud_firestore.dart';
import 'fooditem_model.dart';
import 'dart:ui';

class FoodLogEntry {
  final String? id;          
  final String userId;       
  final String name;         
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime date;       
  final String mealType;     

  FoodLogEntry({
    this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
    required this.mealType,
  });

// Translate json from API
  factory FoodLogEntry.fromApi(Food apiFood, String uid, String mealType) {
    
    // Get Nutrient Values from API
    double getNutrient(String keyword) {
      try {
        final nutrient = apiFood.foodNutrients.firstWhere(
          (n) => n.nutrientName.toLowerCase().contains(keyword.toLowerCase()),
          orElse: () => FoodNutrient(
            nutrientId: 0, 
            nutrientName: '', 
            nutrientNumber: '', 
            unitName: UnitName.G, 
            rank: 0, 
            indentLevel: 0, 
            foodNutrientId: 0, 
            value: 0.0
          ),
        );
        return nutrient.value ?? 0.0;
      } catch (e) {
        return 0.0;
      }
    }

    return FoodLogEntry(
      userId: uid,
      name: apiFood.description, // USDA description
      calories: getNutrient('Energy'),
      protein: getNutrient('Protein'),
      fat: getNutrient('Total lipid'),
      carbs: getNutrient('Carbohydrate'),
      date: DateTime.now(),
      mealType: mealType,
    );
  }

  //Writer
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date_string': "${date.year}-${date.month}-${date.day}", // For queries
      'timestamp': date, // For sorting
      'mealType': mealType,
    };
  }

  // Reader
  factory FoodLogEntry.fromMap(Map<String, dynamic> map, String docId) {
    return FoodLogEntry(
      id: docId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'Unknown Food',
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      date: (map['timestamp'] as Timestamp).toDate(),
      mealType: map['mealType'] ?? 'Snack',
    );
  }
  
}

class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}