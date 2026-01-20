import 'package:flutter/material.dart';
import 'package:medica2/firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🌿 Background Image
          Image.asset(
            "lib/assets/lsbackground.png", // ✅ Add your background image here
            fit: BoxFit.cover,
          ),

          /// 🌱 Center Logo + Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// App Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    "lib/assets/logo.png", // ✅ Your logo image
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                /// App Name
                Text(
                  "Medica",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A2F6B), // Dark Blue
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                /// Loading Indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green, // Herbal theme color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
