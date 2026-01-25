import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    final int totalHits;
    final int currentPage;
    final int totalPages;
    final List<Food> foods;

    Welcome({
        required this.totalHits,
        required this.currentPage,
        required this.totalPages,
        required this.foods,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        totalHits: json["totalHits"] ?? 0,
        currentPage: json["currentPage"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        foods: json["foods"] == null 
            ? [] 
            : List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalHits": totalHits,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    };
}

class Food {
    final int fdcId;
    final String description;
    final String? brandOwner; // Changed to nullable
    final List<FoodNutrient> foodNutrients;

    Food({
        required this.fdcId,
        required this.description,
        this.brandOwner,
        required this.foodNutrients,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        fdcId: json["fdcId"] ?? 0,
        description: json["description"] ?? "No Description",
        brandOwner: json["brandOwner"], // Can be null now
        foodNutrients: json["foodNutrients"] == null 
            ? [] 
            : List<FoodNutrient>.from(json["foodNutrients"].map((x) => FoodNutrient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "fdcId": fdcId,
        "description": description,
        "brandOwner": brandOwner,
        "foodNutrients": List<dynamic>.from(foodNutrients.map((x) => x.toJson())),
    };
}

class FoodNutrient {
    final int nutrientId;
    final String nutrientName;
    final String nutrientNumber;
    final String unitName; // Often causes errors if null
    final double value;
    final int rank;
    final int indentLevel;
    final int foodNutrientId;

    FoodNutrient({
        required this.nutrientId,
        required this.nutrientName,
        required this.nutrientNumber,
        required this.unitName,
        required this.value,
        required this.rank,
        required this.indentLevel,
        required this.foodNutrientId,
    });

    factory FoodNutrient.fromJson(Map<String, dynamic> json) => FoodNutrient(
        nutrientId: json["nutrientId"] ?? 0,
        nutrientName: json["nutrientName"] ?? "Unknown Nutrient",
        nutrientNumber: json["nutrientNumber"] ?? "0",
        // SAFELY HANDLE UNIT NAME
        unitName: json["unitName"] ?? "", 
        // SAFELY HANDLE VALUE (Convert int to double if needed)
        value: (json["value"] as num?)?.toDouble() ?? 0.0,
        rank: json["rank"] ?? 0,
        indentLevel: json["indentLevel"] ?? 0,
        foodNutrientId: json["foodNutrientId"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "nutrientId": nutrientId,
        "nutrientName": nutrientName,
        "nutrientNumber": nutrientNumber,
        "unitName": unitName,
        "value": value,
        "rank": rank,
        "indentLevel": indentLevel,
        "foodNutrientId": foodNutrientId,
    };
}


class UnitName {
    static const String G = "G";
    static const String KCAL = "KCAL";
    static const String MG = "MG";
    static const String UG = "UG";
}