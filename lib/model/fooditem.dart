// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  int totalHits;
  int currentPage;
  int totalPages;
  List<int> pageList;
  FoodSearchCriteria foodSearchCriteria;
  List<Food> foods;
  Aggregations aggregations;

  Welcome({
    required this.totalHits,
    required this.currentPage,
    required this.totalPages,
    required this.pageList,
    required this.foodSearchCriteria,
    required this.foods,
    required this.aggregations,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        totalHits: json["totalHits"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        pageList: List<int>.from(json["pageList"].map((x) => x)),
        foodSearchCriteria:
            FoodSearchCriteria.fromJson(json["foodSearchCriteria"]),
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        aggregations: Aggregations.fromJson(json["aggregations"]),
      );

  Map<String, dynamic> toJson() => {
        "totalHits": totalHits,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "pageList": List<dynamic>.from(pageList.map((x) => x)),
        "foodSearchCriteria": foodSearchCriteria.toJson(),
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "aggregations": aggregations.toJson(),
      };
}

class Aggregations {
  DataType dataType;
  Nutrients nutrients;

  Aggregations({
    required this.dataType,
    required this.nutrients,
  });

  factory Aggregations.fromJson(Map<String, dynamic> json) => Aggregations(
        dataType: DataType.fromJson(json["dataType"]),
        nutrients: Nutrients.fromJson(json["nutrients"]),
      );

  Map<String, dynamic> toJson() => {
        "dataType": dataType.toJson(),
        "nutrients": nutrients.toJson(),
      };
}

class DataType {
  int branded;
  int srLegacy;
  int surveyFndds;
  int foundation;

  DataType({
    required this.branded,
    required this.srLegacy,
    required this.surveyFndds,
    required this.foundation,
  });

  factory DataType.fromJson(Map<String, dynamic> json) => DataType(
        branded: json["Branded"],
        srLegacy: json["SR Legacy"],
        surveyFndds: json["Survey (FNDDS)"],
        foundation: json["Foundation"],
      );

  Map<String, dynamic> toJson() => {
        "Branded": branded,
        "SR Legacy": srLegacy,
        "Survey (FNDDS)": surveyFndds,
        "Foundation": foundation,
      };
}

class Nutrients {
  Nutrients();

  factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients();

  Map<String, dynamic> toJson() => {};
}

class FoodSearchCriteria {
  List<String> dataType;
  String query;
  String foodCategory;
  int pageNumber;
  String sortBy;
  int numberOfResultsPerPage;
  int pageSize;
  bool requireAllWords;
  List<String> foodTypes;

  FoodSearchCriteria({
    required this.dataType,
    required this.query,
    required this.foodCategory,
    required this.pageNumber,
    required this.sortBy,
    required this.numberOfResultsPerPage,
    required this.pageSize,
    required this.requireAllWords,
    required this.foodTypes,
  });

  factory FoodSearchCriteria.fromJson(Map<String, dynamic> json) =>
      FoodSearchCriteria(
        dataType: List<String>.from(json["dataType"].map((x) => x)),
        query: json["query"],
        foodCategory: json["foodCategory"],
        pageNumber: json["pageNumber"],
        sortBy: json["sortBy"],
        numberOfResultsPerPage: json["numberOfResultsPerPage"],
        pageSize: json["pageSize"],
        requireAllWords: json["requireAllWords"],
        foodTypes: List<String>.from(json["foodTypes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "dataType": List<dynamic>.from(dataType.map((x) => x)),
        "query": query,
        "foodCategory": foodCategory,
        "pageNumber": pageNumber,
        "sortBy": sortBy,
        "numberOfResultsPerPage": numberOfResultsPerPage,
        "pageSize": pageSize,
        "requireAllWords": requireAllWords,
        "foodTypes": List<dynamic>.from(foodTypes.map((x) => x)),
      };
}

class Food {
  int fdcId;
  String description;
  String commonNames;
  String additionalDescriptions;
  String dataType;
  int ndbNumber;
  DateTime publishedDate;
  String foodCategory;
  DateTime mostRecentAcquisitionDate;
  String allHighlightFields;
  double score;
  List<dynamic> microbes;
  List<FoodNutrient> foodNutrients;
  List<dynamic> finalFoodInputFoods;
  List<dynamic> foodMeasures;
  List<dynamic> foodAttributes;
  List<dynamic> foodAttributeTypes;
  List<dynamic> foodVersionIds;

  Food({
    required this.fdcId,
    required this.description,
    required this.commonNames,
    required this.additionalDescriptions,
    required this.dataType,
    required this.ndbNumber,
    required this.publishedDate,
    required this.foodCategory,
    required this.mostRecentAcquisitionDate,
    required this.allHighlightFields,
    required this.score,
    required this.microbes,
    required this.foodNutrients,
    required this.finalFoodInputFoods,
    required this.foodMeasures,
    required this.foodAttributes,
    required this.foodAttributeTypes,
    required this.foodVersionIds,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        fdcId: json["fdcId"],
        description: json["description"],
        commonNames: json["commonNames"],
        additionalDescriptions: json["additionalDescriptions"],
        dataType: json["dataType"],
        ndbNumber: json["ndbNumber"],
        publishedDate: DateTime.parse(json["publishedDate"]),
        foodCategory: json["foodCategory"],
        mostRecentAcquisitionDate:
            DateTime.parse(json["mostRecentAcquisitionDate"]),
        allHighlightFields: json["allHighlightFields"],
        score: json["score"]?.toDouble(),
        microbes: List<dynamic>.from(json["microbes"].map((x) => x)),
        foodNutrients: List<FoodNutrient>.from(
            json["foodNutrients"].map((x) => FoodNutrient.fromJson(x))),
        finalFoodInputFoods:
            List<dynamic>.from(json["finalFoodInputFoods"].map((x) => x)),
        foodMeasures: List<dynamic>.from(json["foodMeasures"].map((x) => x)),
        foodAttributes:
            List<dynamic>.from(json["foodAttributes"].map((x) => x)),
        foodAttributeTypes:
            List<dynamic>.from(json["foodAttributeTypes"].map((x) => x)),
        foodVersionIds:
            List<dynamic>.from(json["foodVersionIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "fdcId": fdcId,
        "description": description,
        "commonNames": commonNames,
        "additionalDescriptions": additionalDescriptions,
        "dataType": dataType,
        "ndbNumber": ndbNumber,
        "publishedDate":
            "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
        "foodCategory": foodCategory,
        "mostRecentAcquisitionDate":
            "${mostRecentAcquisitionDate.year.toString().padLeft(4, '0')}-${mostRecentAcquisitionDate.month.toString().padLeft(2, '0')}-${mostRecentAcquisitionDate.day.toString().padLeft(2, '0')}",
        "allHighlightFields": allHighlightFields,
        "score": score,
        "microbes": List<dynamic>.from(microbes.map((x) => x)),
        "foodNutrients":
            List<dynamic>.from(foodNutrients.map((x) => x.toJson())),
        "finalFoodInputFoods":
            List<dynamic>.from(finalFoodInputFoods.map((x) => x)),
        "foodMeasures": List<dynamic>.from(foodMeasures.map((x) => x)),
        "foodAttributes": List<dynamic>.from(foodAttributes.map((x) => x)),
        "foodAttributeTypes":
            List<dynamic>.from(foodAttributeTypes.map((x) => x)),
        "foodVersionIds": List<dynamic>.from(foodVersionIds.map((x) => x)),
      };
}

class FoodNutrient {
  int nutrientId;
  String nutrientName;
  String nutrientNumber;
  UnitName unitName;
  DerivationCode? derivationCode;
  DerivationDescription? derivationDescription;
  int? derivationId;
  double? value;
  int? foodNutrientSourceId;
  String? foodNutrientSourceCode;
  FoodNutrientSourceDescription? foodNutrientSourceDescription;
  int rank;
  int indentLevel;
  int foodNutrientId;
  int? dataPoints;
  double? min;
  double? max;
  double? median;

  FoodNutrient({
    required this.nutrientId,
    required this.nutrientName,
    required this.nutrientNumber,
    required this.unitName,
    this.derivationCode,
    this.derivationDescription,
    this.derivationId,
    this.value,
    this.foodNutrientSourceId,
    this.foodNutrientSourceCode,
    this.foodNutrientSourceDescription,
    required this.rank,
    required this.indentLevel,
    required this.foodNutrientId,
    this.dataPoints,
    this.min,
    this.max,
    this.median,
  });

  factory FoodNutrient.fromJson(Map<String, dynamic> json) => FoodNutrient(
        nutrientId: json["nutrientId"],
        nutrientName: json["nutrientName"],
        nutrientNumber: json["nutrientNumber"],
        unitName: unitNameValues.map[json["unitName"]]!,
        derivationCode: derivationCodeValues.map[json["derivationCode"]]!,
        derivationDescription:
            derivationDescriptionValues.map[json["derivationDescription"]]!,
        derivationId: json["derivationId"],
        value: json["value"]?.toDouble(),
        foodNutrientSourceId: json["foodNutrientSourceId"],
        foodNutrientSourceCode: json["foodNutrientSourceCode"],
        foodNutrientSourceDescription: foodNutrientSourceDescriptionValues
            .map[json["foodNutrientSourceDescription"]]!,
        rank: json["rank"],
        indentLevel: json["indentLevel"],
        foodNutrientId: json["foodNutrientId"],
        dataPoints: json["dataPoints"],
        min: json["min"]?.toDouble(),
        max: json["max"]?.toDouble(),
        median: json["median"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "nutrientId": nutrientId,
        "nutrientName": nutrientName,
        "nutrientNumber": nutrientNumber,
        "unitName": unitNameValues.reverse[unitName],
        "derivationCode": derivationCodeValues.reverse[derivationCode],
        "derivationDescription":
            derivationDescriptionValues.reverse[derivationDescription],
        "derivationId": derivationId,
        "value": value,
        "foodNutrientSourceId": foodNutrientSourceId,
        "foodNutrientSourceCode": foodNutrientSourceCode,
        "foodNutrientSourceDescription": foodNutrientSourceDescriptionValues
            .reverse[foodNutrientSourceDescription],
        "rank": rank,
        "indentLevel": indentLevel,
        "foodNutrientId": foodNutrientId,
        "dataPoints": dataPoints,
        "min": min,
        "max": max,
        "median": median,
      };
}

enum DerivationCode { A, AS, NC }

final derivationCodeValues = EnumValues(
    {"A": DerivationCode.A, "AS": DerivationCode.AS, "NC": DerivationCode.NC});

enum DerivationDescription { ANALYTICAL, CALCULATED, SUMMED }

final derivationDescriptionValues = EnumValues({
  "Analytical": DerivationDescription.ANALYTICAL,
  "Calculated": DerivationDescription.CALCULATED,
  "Summed": DerivationDescription.SUMMED
});

enum FoodNutrientSourceDescription {
  ANALYTICAL_OR_DERIVED_FROM_ANALYTICAL,
  CALCULATED_OR_IMPUTED
}

final foodNutrientSourceDescriptionValues = EnumValues({
  "Analytical or derived from analytical":
      FoodNutrientSourceDescription.ANALYTICAL_OR_DERIVED_FROM_ANALYTICAL,
  "Calculated or imputed": FoodNutrientSourceDescription.CALCULATED_OR_IMPUTED
});

enum UnitName { G, IU, KCAL, MG, UG }

final unitNameValues = EnumValues({
  "G": UnitName.G,
  "IU": UnitName.IU,
  "KCAL": UnitName.KCAL,
  "MG": UnitName.MG,
  "UG": UnitName.UG
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
