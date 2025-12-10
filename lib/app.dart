// lib/app.dart
import 'package:appattendance/core/providers/theme_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme watch kar
    final themeMode = ref.watch(themeProvider);

    // Auth state watch kar — AsyncValue hai
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Nutantek Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: authState.when(
        // Loading → Splash dikhao
        loading: () => const SplashScreen(),

        // Error → Login dikhao (safe side)
        error: (err, stack) => const LoginScreen(),

        // Data → Agar user logged in hai → Dashboard, warna Login
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          } else {
            // Auto login ho gaya → direct Dashboard
            return const DashboardScreen();
          }
        },
      ),
    );
  }
}
