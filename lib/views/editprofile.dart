// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../components/loggedin_bg.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("My Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LoggedInBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Icon
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF4E74F9)),
                ),
                const SizedBox(height: 20),

                // Form Fields
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildTextField("Username", controller.usernameController,
                          Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField("New Password (Optional)",
                          controller.passwordController, Icons.lock,
                          isObscure: true),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  "Weight (kg)",
                                  controller.weightController,
                                  Icons.monitor_weight,
                                  isNumber: true)),
                          const SizedBox(width: 15),
                          Expanded(
                              child: _buildTextField("Height (cm)",
                                  controller.heightController, Icons.height,
                                  isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField("Daily Calorie Goal",
                          controller.calorieGoalController, Icons.flag,
                          isNumber: true),

                      const SizedBox(height: 25),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.updateProfile(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4E74F9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text("Save Changes",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.logout(),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Log Out",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isObscure = false, bool isNumber = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
