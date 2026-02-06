// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/stats_controller.dart';
import '../model/foodlog_model.dart';
import '../components/loggedin_bg.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsController controller = Get.put(StatsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Progress & Stats", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "Calories"),
              Tab(text: "Weight"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showWeightDialog(context, controller),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.monitor_weight, color: Colors.white),
          label: const Text("Log Weight", style: TextStyle(color: Colors.white)),
        ),
        body: LoggedInBackground(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: TabBarView(
              children: [
                
                _buildCalorieTab(controller),

                _buildWeightTab(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieTab(StatsController controller) {
    return Column(
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Avg. Daily Intake", style: TextStyle(color: Colors.grey)),
                  Obx(() => Text("${controller.averageCalories.value.toInt()} kcal",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4E74F9)))),
                ],
              ),
              const Icon(Icons.bar_chart, size: 40, color: Color(0xFF4E74F9))
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Chart
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Daily Calorie History'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: controller.calorieStats.toList(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: const Color(0xFF4E74F9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                )
              ],
            )),
          ),
        ),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildWeightTab(StatsController controller) {
    return Column(
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Weight", style: TextStyle(color: Colors.grey)),
                  Obx(() => Text("${controller.currentWeight.value} kg",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))),
                ],
              ),
              const Icon(Icons.monitor_weight_outlined, size: 40, color: Colors.orange)
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Chart
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Weight Progress'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                LineSeries<ChartData, String>(
                  dataSource: controller.weightStats.toList(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.orange,
                  width: 3,
                  markerSettings: const MarkerSettings(isVisible: true),
                )
              ],
            )),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  void _showWeightDialog(BuildContext context, StatsController controller) {
    final weightInput = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Log Weight"),
        content: TextField(
          controller: weightInput,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Weight (kg)"),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              double? w = double.tryParse(weightInput.text);
              if (w != null) controller.addNewWeight(w);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}