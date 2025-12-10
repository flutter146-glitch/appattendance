// lib/main.dart
import 'package:appattendance/app.dart';
import 'package:appattendance/core/providers/theme_notifier.dart';
import 'package:appattendance/core/services/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Yeh zaroori hai DB, SharedPrefs, FCM ke liye
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDB.init();
  // Optional: Agar baad mein FCM ya notifications chahiye toh yahan init kar dena
  // await Firebase.initializeApp();
  // await NotificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme live watch kar — dark/light toggle ke liye
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Nutantek Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066FF)),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
      ),
      themeMode: themeMode, // ← YEH LIVE SWITCH HOGA!
      home:
          const App(), // ← app.dart mein sab routing (Splash → Login → Dashboard)
    );
  }
}
