import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // Example state variable
  String selectedImagePath = '';

  void updateImagePath(String path) {
    selectedImagePath = path;
    notifyListeners();
  }
}
