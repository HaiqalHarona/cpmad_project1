// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/loggedin_bg.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("About NutriTrack",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Hides back button since it is in the bottom nav
      ),
      body: LoggedInBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [
              // App Version and Logo
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Icon(
                  Icons.local_dining_rounded, 
                  size: 60, 
                  color: Color(0xFF4E74F9)
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "NutriTrack",
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.white70
                ),
              ),
              const SizedBox(height: 30),

              // Information Card
              _buildInfoCard(
                icon: Icons.info_outline,
                title: "What is NutriTrack?",
                content: "NutriTrack is your personal nutrition companion. "
                    "We help you log meals, track calories, and monitor your macronutrients "
                    "to achieve your health goals effectively.",
              ),
              const SizedBox(height: 20),

              _buildInfoCard(
                icon: Icons.security,
                title: "Privacy & Data",
                content: "Your data is important. We use secure cloud storage to keep your "
                    "food logs and profile information safe and private. "
                    "We do not share your personal data with third parties.",
              ),
              const SizedBox(height: 20),

              _buildInfoCard(
                icon: Icons.code,
                title: "Development Team",
                content: "Built with Flutter & Firebase.\n\n"
                    "• Haiqal Harona (232363L)\n"
                    "• Project 1",
              ),
              
              const SizedBox(height: 30),

              // Contact Support Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _launchEmail,
                  icon: const Icon(Icons.email_outlined, color: Color(0xFF4E74F9)),
                  label: const Text("Contact Support", 
                      style: TextStyle(color: Color(0xFF4E74F9), fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Copyright Footer
              const Text(
                "© 2026 NutriTrack Inc. All rights reserved.",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 80), // Bottom padding for navbar visibility
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4E74F9), size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14, 
              color: Colors.grey[700],
              height: 1.5 // Line height for better readability
            ),
          ),
        ],
      ),
    );
  }

  // Helper to open email app
  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@nutritrack.com',
      query: 'subject=NutriTrack Support Request',
    );
    
    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      // If email app can't open, just print to console (prevents crash)
      debugPrint("Could not launch email client: $e");
    }
  } 
}