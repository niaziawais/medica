import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medica2/ui/auth/posts/theme_controller.dart';

class ThemeChangerScreen extends StatelessWidget {
  const ThemeChangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Theme Changer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Slider stays at top
          children: [
            const Text(
              "Enable Dark Mode",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme(value);
              },
              activeColor: Colors.green,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "When enabled, the entire app will switch to a dark theme.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
