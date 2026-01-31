Medica2 – Medicinal Plant Identification & Classification App

Medica2 is an intelligent Flutter application designed to identify and classify medicinal plants from images. Leveraging a custom-trained deep learning model, the app provides users with accurate predictions and detailed information about medicinal plants, including their scientific names, common names, and uses.

🌿 Project Overview

Medica2 aims to simplify access to medicinal plant knowledge by combining AI-powered classification with a rich plant encyclopedia. The application empowers users to:

Identify plant species instantly from images.

Explore medicinal properties and uses.

Contribute new plant images to enhance the AI model.

Ensure data reliability through expert verification.

👨‍💻 Developer

Awais Khan – Final Year Project (FYP) developer.
This project reflects 8–9 months of continuous research, development, and refinement in AI, Flutter, and mobile application development.

🔑 Key Features

AI Classification: Predicts plant species with high accuracy using a custom-trained deep learning model.

Community Contribution: Users can upload plant images to improve the model over time.

Expert Verification: Contributed images and data are validated by experts.

Plant Encyclopedia: Detailed information on medicinal plants and their properties.

🛠 Platforms & Requirements

To run Medica2, ensure you have:

Firebase: For authentication

Supabase: For storage

Provider: For state management in Flutter

Cloud Platform (optional): For hosting the AI model API (e.g., Hugging Face)

Flutter & Dart SDK: Core framework and language

VS Code or Android Studio: IDE for Flutter development

Emulator or Simulator: To run the app locally

All packages are installed via pub.dev
.

💻 Technologies & Languages Used

Flutter – Cross-platform mobile framework

Dart – Programming language for Flutter

Provider – State management solution

Firebase – Authentication & backend services

Supabase – Cloud storage & database

🚀 Setup Instructions

Clone the repository:

git clone https://github.com/niaziawais/medica.git
cd medica


Install dependencies:

flutter pub get


Configure Firebase & Supabase:

Add your google-services.json (Android) and GoogleService-Info.plist (iOS).

Set up Supabase URL and API key in your app.

Run the app:

flutter run


Make sure an emulator, simulator, or physical device is connected.

Optional: Host your AI model on a cloud platform (Hugging Face, etc.) and update the API URL in the app.

📦 Project Structure
lib/
 ├─ main.dart
 ├─ firebase_services/
 ├─ provider/
 ├─ ui/
 ├─ utils/
 └─ widgets/
assets/
 ├─ images/
 └─ model/
plant_classifier_medica.h5 (Git LFS tracked)

⚡ Notes

The .h5 model file is tracked via Git LFS due to its large size.

Ensure proper environment configuration for Firebase and Supabase before running the app.

🔗 References

Flutter

Dart

Firebase

Supabase

Git LFS

📜 License

This project is open-source for educational purposes and non-commercial use.
