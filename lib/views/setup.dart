// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setup_controller.dart';
import '../components/loggedin_bg.dart';

class SetupProfileView extends StatelessWidget {
  const SetupProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.put(ProfileSetupController());

    return Scaffold(
      body: LoggedInBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Setup Your Profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your stats to calculate your daily calorie needs.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildGenderBtn("Male", controller)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildGenderBtn("Female", controller)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildTextField("Age", "Years", controller.ageController),
                    const SizedBox(height: 15),
                    _buildTextField(
                        "Height", "cm", controller.heightController),
                    const SizedBox(height: 15),
                    _buildTextField(
                        "Weight", "kg", controller.weightController),

                    const SizedBox(height: 20),

                    _buildActivityDropdown(
                        "Activity Level",
                        controller.activityLevels,
                        controller.selectedActivityLevel),

                    const SizedBox(height: 15),

                    _buildDropdown(
                        "Goal", controller.goals, controller.selectedGoal),

                    const SizedBox(height: 25),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.calculateRecommendation,
                        icon: Icon(Icons.calculate_outlined, size: 18),
                        label: Text("Calculate Recommendation"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF0F4FF),
                          foregroundColor: Color(0xFF4E74F9),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Divider(),
                    const SizedBox(height: 15),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Your Daily Calorie Goal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        "You can use our recommendation or enter your own.",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 15),

                    // Final Input Field (Populated by calculation but editable)
                    TextField(
                      controller: controller.calorieGoalController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E74F9)),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "0",
                        suffixText: "kcal/day",
                        filled: true,
                        fillColor: Color(0xFFF0F4FF),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4E74F9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text("Save & Continue",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderBtn(String gender, ProfileSetupController controller) {
    return Obx(() {
      bool isSelected = controller.selectedGender.value == gender;
      return GestureDetector(
        onTap: () => controller.selectedGender.value = gender,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4E74F9) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(
      String label, String suffix, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildActivityDropdown(
      String label, List<String> items, RxString selectedValue) {
    Map<String, String> activityDescriptions = {
      "Sedentary": "Little to no exercise",
      "Lightly Active": "Light exercise 1-3 days/week",
      "Moderately Active": "Moderate exercise 3-5 days/week",
      "Very Active": "Hard exercise 6-7 days/week",
    };

    return Obx(() => DropdownButtonFormField<String>(
          value: selectedValue.value,
          isExpanded: true,
          itemHeight: null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),

          // Fix to overflow text
          selectedItemBuilder: (BuildContext context) {
            return items.map((String value) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value, // Just the main text "Very Active"
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },

          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    activityDescriptions[value] ?? "",
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => selectedValue.value = val!,
        ));
  }

  Widget _buildDropdown(
      String label, List<String> items, RxString selectedValue) {
    return Obx(() => DropdownButtonFormField<String>(
          value: selectedValue.value,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) => selectedValue.value = val!,
        ));
  }
}

// This setup page and controller is developed through ALOT OF HELP WITH AI
