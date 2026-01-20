import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:medica2/ui/auth/posts/theme_controller.dart';

class HomeProvider extends ChangeNotifier {
  File? _selectedImage;

  String _prediction = "";
  double _confidence = 0.0;
  String _scientificName = "";
  String _medicinalUses = "";

  bool _loading = false;
  Map<String, dynamic>? _debug;

  File? get selectedImage => _selectedImage;
  String get prediction => _prediction;
  double get confidence => _confidence;
  String get scientificName => _scientificName;
  String get medicinalUses => _medicinalUses;
  bool get loading => _loading;
  Map<String, dynamic>? get debug => _debug;

  // ✅ Change IP if your PC IP changes
  static const String _baseUrl = "http://192.168.100.94:8000";
  static final Uri _predictUri = Uri.parse("$_baseUrl/predict");

  void setImage(File image) {
    _selectedImage = image;
    _prediction = "";
    _confidence = 0.0;
    _scientificName = "";
    _medicinalUses = "";
    _debug = null;
    notifyListeners();
  }

  void _setError(String message) {
    _prediction = message;
    _confidence = 0.0;
    _scientificName = "";
    _medicinalUses = "";
    _debug = null;
  }

  Future<void> sendToApi(File imageFile) async {
    _loading = true;
    notifyListeners();

    try {
      final request = http.MultipartRequest('POST', _predictUri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // ✅ Increased timeout (HF queue/cold start can be slow)
      final streamedResponse =
          await request.send().timeout(const Duration(minutes: 5));

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Response Code: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          _setError("Error: Invalid JSON response");
        } else {
          _prediction = decoded["label"]?.toString() ?? "Unknown";

          // server may return 0..1 confidence
          final conf = decoded["confidence"];
          if (conf is num) {
            _confidence = conf.toDouble() * 100.0;
          } else {
            _confidence = 0.0;
          }

          _scientificName =
              decoded["scientific_name"]?.toString() ?? "Unknown";
          _medicinalUses =
              decoded["medicinal_uses"]?.toString() ?? "Not available";

          final dbg = decoded["debug"];
          if (dbg is Map<String, dynamic>) {
            _debug = dbg;
          } else {
            _debug = null;
          }
        }
      } else {
        // ✅ Show server detail nicely
        String msg = "Error: ${response.statusCode}";
        try {
          final decodedErr = jsonDecode(response.body);
          if (decodedErr is Map && decodedErr["detail"] != null) {
            msg = "Error: ${response.statusCode} - ${decodedErr["detail"]}";
          }
        } catch (_) {}
        _setError(msg);
      }
    } on TimeoutException {
      _setError(
        "Timeout: Model slow/queue mein hai (HF cold start). 1 dafa dubara try karo.",
      );
    } catch (e) {
      debugPrint("❌ Exception while calling API: $e");
      _setError("Error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

class HomeDesign extends StatefulWidget {
  const HomeDesign({super.key});

  @override
  State<HomeDesign> createState() => _HomeDesignState();
}

class _HomeDesignState extends State<HomeDesign> {
  final ImagePicker _picker = ImagePicker();
  late final HomeProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = HomeProvider();
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,

      // ✅ Reduce size (big images = slow upload + slow HF)
      imageQuality: 70,
      maxWidth: 1400,
      maxHeight: 1400,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      _provider.setImage(file);
      await _provider.sendToApi(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    // keep existing
    final themeController = Provider.of<ThemeController>(context);

    return ChangeNotifierProvider<HomeProvider>.value(
      value: _provider,
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: Column(
              children: [
                // CAMERA
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _pickImage(context, ImageSource.camera),
                          child: _buildOptionCard(
                            iconPath: "lib/assets/cam_img.png",
                            fallbackIcon: Icons.camera_alt,
                            label: "Camera",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // GALLERY
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _pickImage(context, ImageSource.gallery),
                          child: _buildOptionCard(
                            iconPath: "lib/assets/select_image.png",
                            fallbackIcon: Icons.image,
                            label: "Gallery",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // RESULT AREA
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Wondering about your plant detail?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            constraints:
                                const BoxConstraints(minHeight: 340),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: provider.loading
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 10),
                                        Text("Predicting... please wait"),
                                      ],
                                    )
                                  : provider.selectedImage == null
                                      ? const Text(
                                          "Scan Area",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.file(
                                                  provider.selectedImage!,
                                                  fit: BoxFit.cover,
                                                  width: 150,
                                                  height: 150,
                                                ),
                                              ),
                                              const SizedBox(height: 12),

                                              Text(
                                                "🌿 ${provider.prediction}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),

                                              if (provider.scientificName
                                                      .isNotEmpty &&
                                                  !provider.scientificName
                                                      .startsWith("Error"))
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                    "Scientific name: ${provider.scientificName}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),

                                              if (provider.confidence > 0)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    "Confidence: ${provider.confidence.toStringAsFixed(2)}%",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),

                                              if (provider.medicinalUses
                                                      .isNotEmpty &&
                                                  !provider.medicinalUses
                                                      .startsWith("Error"))
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Text(
                                                    provider.medicinalUses,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),

                                              // optional debug in UI (if you want)
                                              if (provider.debug != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Text(
                                                    "Debug: ${provider.debug}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionCard({
    required String iconPath,
    required IconData fallbackIcon,
    required String label,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                Icon(fallbackIcon, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
