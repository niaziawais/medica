import 'package:flutter/foundation.dart';

/// 🌿 Plant Model
class Plant {
  final String name;
  final String medicinalUses;
  final String image;

  Plant({
    required this.name,
    required this.medicinalUses,
    required this.image,
  });
}

/// 🌱 Plant Provider
class PlantProvider with ChangeNotifier {
  final List<Plant> _plants = [
    Plant(
      name: "Tulsi",
      medicinalUses: "Boosts immunity, cures cough and cold",
      image: "lib/assets/tulsi.jpg",
    ),
    Plant(
      name: "Neem",
      medicinalUses: "Good for skin, antibacterial properties",
      image: "lib/assets/neem.jpg",
    ),
    Plant(
      name: "Aloe Vera",
      medicinalUses: "Heals burns, improves digestion",
      image: "lib/assets/alovera.JPG",
    ),
    Plant(
      name: "Amrutha",
      medicinalUses: "Boosts immunity, reduces fever",
      image: "lib/assets/amrutha.jpg",
    ),
    Plant(
      name: "Peppermint",
      medicinalUses: "Helps in digestion and relieves headaches",
      image: "lib/assets/peppermint.jpg",
    ),
  ];

  String _query = "";

  /// Filter plants by search query
  List<Plant> get filteredPlants {
    if (_query.isEmpty) return _plants;
    return _plants
        .where(
          (plant) => plant.name.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
  }

  /// Update search query
  void updateQuery(String query) {
    _query = query;
    notifyListeners();
  }
}
