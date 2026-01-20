import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medica2/provider/add_screen_provider.dart';
import 'package:medica2/provider/image_provider.dart';
import 'package:medica2/provider/plant_provider.dart';
import 'package:medica2/ui/auth/posts/theme_controller.dart';
import 'package:medica2/ui/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://jdsyleczpxtabdvbiwbt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impkc3lsZWN6cHh0YWJkdmJpd2J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyMTk4MzIsImV4cCI6MjA3Mzc5NTgzMn0.qQIYXXx_NbWgTppelaOcTmg3EBe7KJbISpo6rTRdj7A',
  );

  // Securely store Hugging Face token
  const storage = FlutterSecureStorage();
  const hfToken = "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";
  final existingToken = await storage.read(key: "hf_token");
  if (existingToken == null) {
    await storage.write(key: "hf_token", value: hfToken);
    debugPrint("✅ Hugging Face token stored securely.");
  } else {
    debugPrint("🔐 Token already exists in secure storage.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageProviderClass()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AddScreenProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF47BEA6),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF47BEA6),
        foregroundColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.tealAccent,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medica',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: themeController.themeMode,
      home: const SplashScreen(),
    );
  }
}
