import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddScreenProvider extends ChangeNotifier {
  final scientificNameController = TextEditingController();
  final commonNameController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  String? errorMessage;

  void _setError(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (isLoading == value) return;
    isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      _setError(null);
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // ✅ thora compress: upload fast + less errors
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (picked != null) {
        selectedImage = File(picked.path);
      }
      notifyListeners();
    } catch (e) {
      _setError("Image pick error: $e");
    }
  }

  void clearFields() {
    scientificNameController.clear();
    commonNameController.clear();
    selectedImage = null;
    errorMessage = null;
    notifyListeners();
  }

  void _snack(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// ✅ Supabase submit (safe + more reliable)
  Future<void> submitPlantSafe(BuildContext context) async {
    _setError(null);

    final sci = scientificNameController.text.trim();
    final common = commonNameController.text.trim();

    if (sci.isEmpty || common.isEmpty || selectedImage == null) {
      _setError("Please fill all fields and select an image");
      _snack(context, errorMessage!);
      return;
    }

    try {
      setLoading(true);

      final supabase = Supabase.instance.client;

      // ✅ Unique filename + folder (better organization)
      final fileName = "${const Uuid().v4()}.jpg";
      final storagePath = "plants/$fileName";

      // ✅ Upload with correct contentType
      await supabase.storage.from('user_upload').upload(
            storagePath,
            selectedImage!,
            fileOptions: const FileOptions(
              upsert: false,
              contentType: "image/jpeg",
            ),
          );

      // ✅ Public URL (bucket must be public OR you must use signed url)
      final imageUrl =
          supabase.storage.from('user_upload').getPublicUrl(storagePath);

      // ✅ Insert into table
      await supabase.from('plants').insert({
        'scientific_name': sci,
        'common_name': common,
        'image_url': imageUrl,
      });

      clearFields();
      _snack(context, "Plant submitted successfully!");
    } on StorageException catch (e) {
      _setError("Storage error: ${e.message}");
      _snack(context, errorMessage!);
    } on PostgrestException catch (e) {
      _setError("DB error: ${e.message}");
      _snack(context, errorMessage!);
    } catch (e) {
      _setError("Error: $e");
      _snack(context, errorMessage!);
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    scientificNameController.dispose();
    commonNameController.dispose();
    super.dispose();
  }
}
