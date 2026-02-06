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
                _buildTabContent(
                  context,
                  controller,
                  isWeight: false,
                ),

                _buildTabContent(
                  context,
                  controller,
                  isWeight: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A reusable function to build both tabs
  Widget _buildTabContent(BuildContext context, StatsController controller, {required bool isWeight}) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // Hides the side scroller
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Space for FAB
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isWeight ? "Current Weight" : "Avg. Daily Intake", 
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      Obx(() {
                        String value = isWeight 
                            ? "${controller.currentWeight.value} kg" 
                            : "${controller.averageCalories.value.toInt()} kcal";
                        Color color = isWeight ? Colors.orange : const Color(0xFF4E74F9);
                        return Text(value,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color));
                      }),
                    ],
                  ),
                  Icon(
                    isWeight ? Icons.monitor_weight_outlined : Icons.local_fire_department, 
                    size: 40, 
                    color: isWeight ? Colors.orange : const Color(0xFF4E74F9)
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Container(
              height: 300, // Fixed height so it scrolls with the page
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(() {
                final data = isWeight ? controller.weightStats.toList() : controller.calorieStats.toList();
                
                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: isWeight ? 'Weight Progress' : 'Calorie History', textStyle: const TextStyle(fontSize: 12)),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    isWeight 
                    ? LineSeries<ChartData, String>(
                        dataSource: data,
                        xValueMapper: (ChartData d, _) => d.x,
                        yValueMapper: (ChartData d, _) => d.y,
                        color: Colors.orange,
                        width: 3,
                        markerSettings: const MarkerSettings(isVisible: true),
                      )
                    : ColumnSeries<ChartData, String>(
                        dataSource: data,
                        xValueMapper: (ChartData d, _) => d.x,
                        yValueMapper: (ChartData d, _) => d.y,
                        color: const Color(0xFF4E74F9),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                      )
                  ],
                );
              }),
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(isWeight ? "Weight Logs" : "Daily Logs",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            
            Obx(() {
              // Get data and reverse it so newest is at top of list
              var listData = isWeight ? controller.weightStats.toList() : controller.calorieStats.toList();

              if (isWeight) listData = listData.reversed.toList();

              if (listData.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No data yet.", style: TextStyle(color: Colors.white70)),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Scroll with the page, not inside
                  padding: EdgeInsets.zero,
                  itemCount: listData.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = listData[index];
                    return ListTile(
                      title: Text(item.x, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        "${item.y.toStringAsFixed(1)} ${isWeight ? 'kg' : 'kcal'}",
                        style: TextStyle(
                          color: isWeight ? Colors.orange : const Color(0xFF4E74F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
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