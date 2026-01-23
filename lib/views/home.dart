import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../components/gradient_bg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double caloriesConsumed = 1250;
    final double calorieGoal = 2000;
    final double caloriesRemaining = calorieGoal - caloriesConsumed;
    final double progressPercent = (caloriesConsumed / calorieGoal) * 100;

    final List<ChartData> chartData = [
      ChartData('Intake', caloriesConsumed, const Color(0xFF4E74F9)),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("Today's Diary",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Calories Remaining",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 5),
                          Text("${caloriesRemaining.toInt()}",
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                              "Goal: ${calorieGoal.toInt()}  -  Food: ${caloriesConsumed.toInt()}",
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
                            pointColorMapper: (ChartData data, _) => data.color,
                            maximumValue: calorieGoal,
                            radius: '100%',
                            innerRadius: '80%',
                            cornerStyle: CornerStyle.bothCurve,
                            trackColor: Colors.grey.shade200,
                          )
                        ],
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Text(
                              "${progressPercent.toInt()}%",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroCard("Protein", "120g", Colors.purpleAccent),
                  _buildMacroCard("Carbs", "230g", Colors.orangeAccent),
                  _buildMacroCard("Fat", "60g", Colors.redAccent),
                ],
              ),
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
        color: Colors.white.withOpacity(0.2), // Semi-transparent
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
