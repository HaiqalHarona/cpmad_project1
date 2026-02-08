// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../components/loggedin_bg.dart';
import '../controllers/home_controller.dart';
import '../model/foodlog_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("Today's Diary",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "custom_food_button",
        onPressed: () => _showAddCustomFoodDialog(context, controller),
        backgroundColor: const Color(0xFF4E74F9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: LoggedInBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                // Main card showing daily calorie progress
                _buildCalorieCard(controller),

                const SizedBox(height: 25),

                // Row displaying macronutrient breakdown
                _buildMacrosSection(controller),

                const SizedBox(height: 25),

                // Chart showing calorie intake over the last week
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Past 7 Days",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                _buildWeeklyChart(controller),

                const SizedBox(height: 25),

                // Horizontal list of user's saved custom foods
                Obx(() {
                  if (controller.customFoodTemplates.isEmpty)
                    return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("My Saved Foods",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height:
                            140, // Fixed height for the horizontal scrolling list
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.customFoodTemplates.length,
                          separatorBuilder: (c, i) => const SizedBox(width: 15),
                          itemBuilder: (context, index) {
                            final food = controller.customFoodTemplates[index];
                            return _buildSavedFoodCard(
                                context, controller, food);
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  );
                }),

                // List of recently added food items
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Recent Entries",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(() {
                    var displayList = controller.historyLogs.take(20).toList();
                    displayList.sort((a, b) => a.date.compareTo(b.date));

                    if (displayList.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Text("No food added yet.",
                                style: TextStyle(color: Colors.grey))),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // Remove default padding to prevent extra spacing
                      padding: EdgeInsets.zero,
                      itemCount: displayList.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = displayList[index];
                        final now = DateTime.now();
                        bool isToday = log.date.year == now.year &&
                            log.date.month == now.month &&
                            log.date.day == now.day;
                        return ListTile(
                          title: Text(log.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "${log.date.month}/${log.date.day} • ${log.mealType}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Prevent overflow by minimizing row width
                            children: [
                              // Kcal text
                              Text("${log.calories.toInt()} kcal",
                                  style: const TextStyle(
                                      color: Color(0xFF4E74F9),
                                      fontWeight: FontWeight.bold)),

                              if (isToday)

                                // Delete only today's entries
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.grey, size: 20),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Item?",
                                      middleText:
                                          "Are you sure you want to remove ${log.name}?",
                                      textConfirm: "Delete",
                                      textCancel: "Cancel",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () {
                                        controller.deleteFoodEntry(log);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for individual saved food items
  Widget _buildSavedFoodCard(BuildContext context, HomeController controller,
      Map<String, dynamic> food) {
    return GestureDetector(
      onTap: () {
        // Open the dialog pre-filled with this food's data
        _showAddCustomFoodDialog(context, controller, prefillData: food);
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4E74F9).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.restaurant_menu, color: Color(0xFF4E74F9)),
            ),
            const SizedBox(height: 10),
            Text(food['name'] ?? 'Food',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 5),
            Text("${(food['calories'] ?? 0).toInt()} kcal",
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Helper widget for the main calorie progress card
  Widget _buildCalorieCard(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Obx(() {
        final consumed = controller.caloriesConsumed.value;
        final goal = controller.calorieGoal.value;
        final remaining = controller.caloriesRemaining;

        double rawPercent = (goal > 0) ? (consumed / goal) * 100 : 0.0;
        if (rawPercent.isNaN || rawPercent.isInfinite) rawPercent = 0.0;

        double chartMax = (goal > 0) ? goal.toDouble() : 2000.0;
        bool isOverflow = consumed > goal && goal > 0;
        Color barColor =
            isOverflow ? Colors.redAccent : const Color(0xFF4E74F9);

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Calories Remaining",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text("${remaining.toInt()}",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isOverflow ? Colors.red : Colors.black)),
                  const SizedBox(height: 5),
                  Text("Goal: ${goal.toInt()}  -  Food: ${consumed.toInt()}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              width: 120,
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                    dataSource: [ChartData('Intake', consumed, barColor)],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    pointColorMapper: (ChartData data, _) => data.color,
                    maximumValue: chartMax,
                    radius: '100%',
                    innerRadius: '80%',
                    cornerStyle: CornerStyle.bothCurve,
                    trackColor: Colors.grey.shade200,
                  )
                ],
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Text("${rawPercent.toInt()}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isOverflow ? Colors.red : Colors.black)),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper widget for the macronutrient breakdown row
  Widget _buildMacrosSection(HomeController controller) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMacroCard(
                "Protein",
                "${controller.proteinConsumed.value.toInt()}g",
                const Color.fromARGB(255, 0, 81, 255)),
            _buildMacroCard(
                "Carbs",
                "${controller.carbsConsumed.value.toInt()}g",
                Colors.orangeAccent),
            _buildMacroCard("Fat", "${controller.fatConsumed.value.toInt()}g",
                Colors.redAccent),
          ],
        ));
  }

  Widget _buildWeeklyChart(HomeController controller) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Obx(() => SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(isVisible: false),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: controller.weeklyChartData.toList(),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                color: const Color(0xFF4E74F9),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              )
            ],
          )),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color.fromARGB(179, 0, 0, 0), fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  // Dialog for adding custom food entries
  void _showAddCustomFoodDialog(BuildContext context, HomeController controller,
      {Map<String, dynamic>? prefillData}) {
    // Initialize controllers with pre-filled data if available
    final nameController =
        TextEditingController(text: prefillData?['name'] ?? "");
    final calController = TextEditingController(
        text: prefillData != null ? prefillData['calories'].toString() : "");
    final proteinController = TextEditingController(
        text: prefillData != null ? prefillData['protein'].toString() : "");
    final carbController = TextEditingController(
        text: prefillData != null ? prefillData['carbs'].toString() : "");
    final fatController = TextEditingController(
        text: prefillData != null ? prefillData['fat'].toString() : "");

    // Default to not saving if it's already a template
    RxBool saveToMyFoods = false.obs;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(prefillData != null
              ? "Add ${prefillData['name']}"
              : "Add Custom Food"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Food Name")),
                const SizedBox(height: 10),
                TextField(
                    controller: calController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Calories (kcal)")),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: proteinController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Prot (g)"))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            controller: carbController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Carb (g)"))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            controller: fatController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Fat (g)"))),
                  ],
                ),
                const SizedBox(height: 20),
                // Option to save as a template for future use
                if (prefillData == null)
                  Obx(() => Row(
                        children: [
                          Checkbox(
                              value: saveToMyFoods.value,
                              onChanged: (val) => saveToMyFoods.value = val!),
                          const Text("Save to 'My Foods' for later"),
                        ],
                      )),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    calController.text.isNotEmpty) {
                  controller.addCustomEntry(
                    nameController.text,
                    double.tryParse(calController.text) ?? 0,
                    double.tryParse(proteinController.text) ?? 0,
                    double.tryParse(carbController.text) ?? 0,
                    double.tryParse(fatController.text) ?? 0,
                    saveToMyFoods.value,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E74F9)),
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
