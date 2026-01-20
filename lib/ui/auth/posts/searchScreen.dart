import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medica2/provider/plant_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<PlantProvider>(
                builder: (context, provider, _) => TextField(
                  onChanged: provider.updateQuery,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search plants...",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            /// 🌿 Plant List + Black Background Section
            Expanded(
              child: Consumer<PlantProvider>(
                builder: (context, provider, _) {
                  final plants = provider.filteredPlants;

                  if (plants.isEmpty) {
                    return Center(
                      child: Text(
                        "No plants found",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final rowCount = (plants.length / 2).ceil();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    itemCount: rowCount + 1, // +1 for black section
                    itemBuilder: (context, index) {
                      /// 🖤 After 4 Plant Cards -> Show Black Background Section
                      if (index == (4 / 2).ceil()) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: BlackBackgroundSection(),
                        );
                      }

                      final firstIndex = index * 2;
                      final secondIndex = firstIndex + 1;

                      /// 🪴 Grid Row for Plant Cards
                      if (firstIndex >= plants.length) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: PlantCard(plant: plants[firstIndex]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: secondIndex < plants.length
                                  ? PlantCard(plant: plants[secondIndex])
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🪴 Plant Card Widget
class PlantCard extends StatelessWidget {
  final Plant plant;
  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🌱 Plant Image
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(plant.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 📜 Plant Details
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  plant.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  plant.medicinalUses,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 13,
                    height: 1.3,
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

/// 🖤 Black Background Section with updated text and smaller image
/// 🖤 Black Background Section with full width
class BlackBackgroundSection extends StatelessWidget {
  const BlackBackgroundSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // ✅ Full device width

    return Container(
      width: screenWidth, // ✅ Ensures it matches the phone's width
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🌱 LEFT: Updated Gradient Text
          Expanded(
            flex: 2,
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF66BB6A), // Light green
                    Color(0xFF43A047), // Medium green
                    Color(0xFF1B5E20), // Dark green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  "Here you search the name of the plant\nand learn about its benefits",
                  style: TextStyle(
                    color: Colors.white, // Gradient will override
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    height: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
          ),

          const SizedBox(width: 24),

          /// 🌿 RIGHT: Beautiful Image Card
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 160, // Slightly compact
                  height: 200, // Clean balanced height
                  child: Image.asset(
                    "lib/assets/search1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
