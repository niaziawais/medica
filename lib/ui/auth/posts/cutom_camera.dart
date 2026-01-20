import 'package:flutter/material.dart';


class CustomCameraScreen extends StatefulWidget {
  final bool isGuest;
  const CustomCameraScreen({Key? key, required this.isGuest}) : super(key: key);

  @override
  _CustomCameraScreenState createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Simple black background instead of scan animation
         
        ],
      ),
    );
  }
}
