import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medica2/utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var user = auth.currentUser;
    if (user != null) {
      var doc = await firestore.collection("users").doc(user.uid).get();
      var data = doc.data();
      nameController.text = data?["name"] ?? "";
      emailController.text = user.email ?? "";
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      User? user = auth.currentUser;

      if (user != null) {
        // 🔑 Step 1: Reauthenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);

        // 🔑 Step 2: Update Firestore name
        await firestore.collection("users").doc(user.uid).update({
          "name": nameController.text,
        });

        // ❌ Removed email update logic

        // 🔑 Step 3: Update Password if entered
        if (newPasswordController.text.trim().isNotEmpty) {
          await user.updatePassword(newPasswordController.text.trim());
          Utils().toastMessage("Password updated successfully!");
        }

        Utils().toastMessage("Profile updated successfully!");
      }
    } catch (e) {
      Utils().toastMessage("Error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                readOnly: true, // 👈 make email not editable
                decoration: const InputDecoration(
                  labelText: "Email (cannot be changed)",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Current Password"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your current password" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "New Password (optional)"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: loading ? null : _updateProfile,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit",
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
