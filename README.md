# 🥗 Nutritrack

Nutritrack is a cross-platform mobile application built with **Flutter** that helps users track their daily nutrition. It allows users to log meals, monitor calorie intake, and visualize macronutrient breakdowns (Protein, Carbs, Fats) in real-time.

The app integrates **Firebase** for backend services (Authentication & Database) and the **Nutritionix API** for accurate food data.

## 📱 Features

* **Authentication**: Secure Sign Up and Login using Firebase Auth.
* **Dashboard**:
    * Visual progress bar for daily calorie goals.
    * Real-time breakdown of macros (Protein, Carbs, Fats).
    * Categorized meal logging (Breakfast, Lunch, Dinner, Snacks).
* **Food Search**:
    * Integration with **Nutritionix API** to search for thousands of food items.
    * Detailed nutritional information (Calories, Serving Size, Macros).
* **User Profile**:
    * Manage personal stats (Weight, Height, Age).
    * Set custom calorie goals.
* **Architecture**: Built using the **MVC Pattern** with **GetX** for state management.

## 🛠️ Tech Stack

* **Framework**: Flutter (Dart)
* **State Management**: GetX
* **Backend**: Firebase (Core, Auth, Firestore)
* **API**: Nutritionix (HTTP requests)
* **UI Components**: `percent_indicator`, Custom Bottom Navigation

## 📂 Folder Structure

The project follows a clean MVC (Model-View-Controller) + Service architecture:

```text
lib/
├── components/          # Reusable UI widgets (Navbar, Gradients)
├── controllers/         # Logic & State Management (Auth, Dashboard, Search)
├── models/              # Data Models (FoodLog, NutritionixResponse)
├── services/            # External Data Handling (Firestore, API calls)
├── views/               # UI Screens (Login, Dashboard, Search, Profile)
├── main.dart            # Entry point & Firebase Initialization
└── firebase_options.dart # Generated Firebase Configuration                    