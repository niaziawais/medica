import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medica2/provider/home_provider.dart';
import 'package:medica2/ui/auth/login_screen.dart';
import 'package:medica2/ui/auth/posts/about_screen.dart';
import 'package:medica2/ui/auth/posts/addScreen.dart';
import 'package:medica2/ui/auth/posts/edit_profile.dart';
import 'package:medica2/ui/auth/posts/home_design.dart' hide HomeProvider;
import 'package:medica2/ui/auth/posts/searchScreen.dart';
import 'package:medica2/ui/auth/posts/theme_changer.dart';
import 'package:medica2/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _signOut(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirmed) {
      auth.signOut().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
       HomeDesign(),
      const SearchScreen(),
      const AddScreen(),
       AboutScreen(),
    ];

    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Medica",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),

        // ===== Drawer =====
        drawer: Drawer(
          child: FutureBuilder<DocumentSnapshot>(
            future: firestore.collection("users").doc(auth.currentUser?.uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              String name = userData?['name'] ?? "User";
              String email = userData?['email'] ?? auth.currentUser?.email ?? "";
              String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";

              return Container(
                color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white54,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                    ),

                    // ===== Drawer Items =====
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.white),
                      title: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.brightness_6, color: Colors.white),
                      title: const Text(
                        "Theme Change",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThemeChangerScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _signOut(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        body: screens[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          ],
        ),
      ),
    );
  }
}
