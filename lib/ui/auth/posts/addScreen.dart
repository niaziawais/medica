import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medica2/provider/add_screen_provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => AddScreenProvider(),
      child: Consumer<AddScreenProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,

            // ✅ allows layout to move up when keyboard opens
            resizeToAvoidBottomInset: true,

            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

                  return SingleChildScrollView(
                    // ✅ extra space when keyboard opens (prevents bottom overflow)
                    padding: EdgeInsets.only(bottom: bottomInset),

                    child: ConstrainedBox(
                      // ✅ ensures content can expand properly on small screens
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),

                      child: Column(
                        children: [
                          /// 🌱 Form Section
                          Container(
                            color: theme.scaffoldBackgroundColor,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Scientific Name
                                TextFormField(
                                  controller: provider.scientificNameController,
                                  style: TextStyle(color: theme.colorScheme.onBackground),
                                  decoration: InputDecoration(
                                    labelText: "Scientific Name",
                                    labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                                    prefixIcon: Icon(Icons.science, color: theme.colorScheme.primary),
                                    filled: true,
                                    fillColor: isDark ? Colors.grey[800] : Colors.green.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                /// Common Name
                                TextFormField(
                                  controller: provider.commonNameController,
                                  style: TextStyle(color: theme.colorScheme.onBackground),
                                  decoration: InputDecoration(
                                    labelText: "Common Name",
                                    labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                                    prefixIcon: Icon(Icons.eco, color: theme.colorScheme.primary),
                                    filled: true,
                                    fillColor: isDark ? Colors.grey[800] : Colors.green.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                /// 🖼 Image Picker
                                GestureDetector(
                                  onTap: provider.pickImage,
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.grey[800] : Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: provider.selectedImage == null
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add_a_photo, size: 50, color: theme.colorScheme.primary),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Tap to upload image",
                                                  style: TextStyle(color: theme.colorScheme.primary),
                                                ),
                                              ],
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.file(
                                                provider.selectedImage!,
                                                fit: BoxFit.contain,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),

                                /// Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () => provider.submitPlantSafe(context), // ✅ (provider me ye method hai)
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: provider.isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                          )
                                        : const Text(
                                            "Submit",
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                  ),
                                ),

                                // ✅ optional: show provider error text without overflow
                                if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    provider.errorMessage!,
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🌑 Black Section
                          // ✅ remove fixed height risk by using constraints instead of hard 320
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 260),
                            color: isDark ? Colors.grey[900] : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// LEFT: Static Plant Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'lib/assets/submit.jpg',
                                    width: 120,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 24), // ✅ slight reduce spacing (helps small screens)

                                /// RIGHT: Text Content
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Here",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 52,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const SizedBox(
                                          width: 220,
                                          child: Divider(color: Colors.white, thickness: 4),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "You can submit the plant with your own research",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Georgia',
                                            letterSpacing: 1.8,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 5,
                                                color: Colors.white38,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
