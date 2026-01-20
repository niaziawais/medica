import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Detect dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors that adapt to theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final headingColor = isDarkMode ? Colors.green.shade300 : Colors.green.shade800;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🌱 Neem Plant Image at Top
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                "lib/assets/neem.jpg",
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // 🌿 Plant Common Name
            Text(
              "Neem",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 8),

            // 🔬 Scientific Name
            Text(
              "Azadirachta indica",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.green.shade200 : Colors.green.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // 📝 Project Purpose Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About Our Project",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 📖 Project Description Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: cardColor,
                elevation: isDarkMode ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Our project helps users identify medicinal plants by simply capturing "
                    "or uploading a plant image. The app provides its common name, "
                    "scientific name, and medicinal properties.\n\n"
                    "This tool promotes awareness about natural remedies, biodiversity "
                    "conservation, and encourages the use of traditional knowledge through "
                    "modern technology.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: textColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🌿 Plant Benefits Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Neem Plant Benefits",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Benefits List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BenefitItem(text: "Boosts immunity and fights infections.", isDarkMode: isDarkMode),
                  BenefitItem(text: "Helps in treating skin conditions like acne and eczema.", isDarkMode: isDarkMode),
                  BenefitItem(text: "Acts as a natural blood purifier.", isDarkMode: isDarkMode),
                  BenefitItem(text: "Has anti-inflammatory and antibacterial properties.", isDarkMode: isDarkMode),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 👨‍💻 Developers Section Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Meet the Developers",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 👨‍💻 Developers Cards Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DeveloperCard(
                    image: "lib/assets/frontend.jpg",
                    name: "Awais Khan",
                    role: "Frontend Developer",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 10),
                  DeveloperCard(
                    image: "lib/assets/backend.jpg",
                    name: "Awais Khan",
                    role: "Backend Developer",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 10),
                  DeveloperCard(
                    image: "lib/assets/database.jpg",
                    name: "Upcoming Developer",
                    role: "Database Developer",
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📜 Footer
            Text(
              "© 2025 Medicinal Plant Identification Project",
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 🌟 Benefit Item Widget
class BenefitItem extends StatelessWidget {
  final String text;
  final bool isDarkMode;
  const BenefitItem({required this.text, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 👨‍💻 Developer Card Widget
class DeveloperCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final bool isDarkMode;

  const DeveloperCard({
    required this.image,
    required this.name,
    required this.role,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: isDarkMode ? 0 : 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
