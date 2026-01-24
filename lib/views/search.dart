import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/httpservice.dart';
import '../service/firestore_service.dart';
import '../model/fooditem_model.dart';
import '../model/foodlog_model.dart';
import '../components/loggedin_bg.dart';

class FoodSearchController extends GetxController {
  // Prevent API spam while typing
  final _debouncer = Debouncer(milliseconds: 500);
  final searchController = TextEditingController();
  
  // Observable variables for UI updates
  var searchResults = <Food>[].obs;
  var isLoading = false.obs;
  var selectedCategory = "".obs;

  // USDA food categories
  final List<String> categories = [
    "Dairy and Egg Products",
    "Fruits",
    "Vegetables and Vegetable Products",
    "Poultry Products",
    "Beef Products",
    "Pork Products",
    "Finfish and Shellfish Products",
    "Cereal Grains and Pasta",
    "Nut and Seed Products",
    "Legumes and Legume Products",
    "Fast Foods",
    "Snacks",
    "Baked Products",
    "Sweets",
    "Beverages",
    "Breakfast Cereals",
    "Meals, Entrees, and Side Dishes"
  ];

  // Helper to safely get macro values
  double getNutrient(Food food, String keyword) {
    try {
      final nutrient = food.foodNutrients.firstWhere(
        (n) => n.nutrientName.toLowerCase().contains(keyword.toLowerCase()),
        orElse: () => FoodNutrient(
            nutrientId: 0,
            nutrientName: '',
            nutrientNumber: '',
            unitName: UnitName.G,
            rank: 0,
            indentLevel: 0,
            foodNutrientId: 0,
            value: 0.0),
      );
      return nutrient.value ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Trigger search when typing stops
  void onSearchChanged(String query) {
    _debouncer.run(() => _performSearch(query));
  }

  // Handle dropdown selection
  void onCategorySelected(String? category) {
    selectedCategory.value = category ?? "";
    _performSearch(searchController.text);
  }

  // Call the API
  void _performSearch(String query) {
    // Don't search if everything is empty
    if (query.isEmpty && selectedCategory.value.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;

    // Fetch data from service
    HttpService.getFoods(
      query, 
      category: selectedCategory.value.isNotEmpty ? selectedCategory.value : null
    ).then((foods) {
      searchResults.assignAll(foods ?? []);
      isLoading.value = false;
    });
  }

  // Calculate totals and save to DB
  void saveFood(Food food, double servings) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Get base macros per serving
    double baseKcal = getNutrient(food, 'Energy');
    double baseProtein = getNutrient(food, 'Protein');
    double baseCarbs = getNutrient(food, 'Carbohydrate');
    double baseFat = getNutrient(food, 'Total lipid');

    // Create the log entry
    FoodLogEntry entry = FoodLogEntry(
      userId: uid,
      name: food.description,
      calories: baseKcal * servings,
      protein: baseProtein * servings,
      carbs: baseCarbs * servings,
      fat: baseFat * servings,
      date: DateTime.now(),
      mealType: "Snack",
    );

    // Save to Firestore
    FirestoreService().logFood(entry);

    // Show success message
    Get.snackbar(
        "Success", "Added ${(baseKcal * servings).toInt()} kcal to your diary",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  // Popup to ask for portion size
  void _showPortionDialog(BuildContext context, FoodSearchController controller, Food food) {
    final TextEditingController portionController =
        TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.description,
              maxLines: 2, overflow: TextOverflow.ellipsis),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter number of servings:"),
              const SizedBox(height: 10),
              TextField(
                controller: portionController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Servings",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double servings =
                    double.tryParse(portionController.text) ?? 1.0;
                controller.saveFood(food, servings);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E74F9)),
              child:
                  const Text("Add Food", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FoodSearchController controller = Get.put(FoodSearchController());

    return Scaffold(
      body: LoggedInBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header text
                    const Text(
                      "Search Food",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    
                    // Search input field
                    TextField(
                      controller: controller.searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "e.g. Apple, Big Mac...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF4E74F9)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: controller.onSearchChanged,
                    ),
                    const SizedBox(height: 10),

                    // Dropdown category filter
                    Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.filter_list, color: Color(0xFF4E74F9)),
                      ),
                      hint: const Text("Filter by Category"),
                      value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem(
                          value: "",
                          child: Text("All Categories", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...controller.categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                      ],
                      onChanged: controller.onCategorySelected,
                    )),
                  ],
                ),
              ),

              // Results list container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Obx(() {
                    // Show loading spinner
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Show empty state if no results
                    if (controller.searchResults.isEmpty) {
                      return _buildEmptyState();
                    }
                    // Show the list of food items
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.searchResults.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final food = controller.searchResults[index];
                        return _buildFoodItem(context, controller, food);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder when list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text("Search for food to see results",
              style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  // Individual food item card
  Widget _buildFoodItem(BuildContext context, FoodSearchController controller, Food food) {
    double kcal = controller.getNutrient(food, 'Energy');
    double protein = controller.getNutrient(food, 'Protein');
    double carbs = controller.getNutrient(food, 'Carbohydrate');
    double fat = controller.getNutrient(food, 'Total lipid');
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      title: Text(
        food.description,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            _buildMacroBadge("🔥 ${kcal.toInt()} kcal", Colors.orange),
            const SizedBox(width: 8),
            _buildMacroBadge("P: ${protein.toInt()}g", Colors.purple),
            const SizedBox(width: 8),
            _buildMacroBadge("C: ${carbs.toInt()}g", Colors.blue),
            const SizedBox(width: 8),
            _buildMacroBadge("F: ${fat.toInt()}g", Colors.red),
          ],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: Color(0xFF4E74F9), size: 32),
        onPressed: () => _showPortionDialog(context, controller, food),
      ),
      onTap: () => _showPortionDialog(context, controller, food),
    );
  }

  // Helper to style the macro tags
  Widget _buildMacroBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Timer to delay API calls
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}