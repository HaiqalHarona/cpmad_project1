// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../components/loggedin_bg.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
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
      body: LoggedInBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            children: [
              // --- CALORIE CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Obx(() {
                  // Listen to live data
                  final consumed = controller.caloriesConsumed.value;
                  final goal = controller.calorieGoal.value;
                  final remaining = controller.caloriesRemaining;
                  final percent = controller.progressPercent;

                  final List<ChartData> chartData = [
                    ChartData('Intake', consumed, const Color(0xFF4E74F9)),
                  ];

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Calories Remaining",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 5),
                            Text("${remaining.toInt()}",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(
                                "Goal: ${goal.toInt()}  -  Food: ${consumed.toInt()}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
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
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              maximumValue: goal.toDouble(),
                              radius: '100%',
                              innerRadius: '80%',
                              cornerStyle: CornerStyle.bothCurve,
                              trackColor: Colors.grey.shade200,
                            )
                          ],
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                              widget: Text(
                                "${percent.toInt()}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Macronutrients",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),

              // --- MACRO CARDS ---
              Obx(() => Row(
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
                      _buildMacroCard(
                          "Fat",
                          "${controller.fatConsumed.value.toInt()}g",
                          Colors.redAccent),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: .1), width: 1),
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
}

class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}
