// lib/app.dart

import 'package:appattendance/core/providers/theme_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Nutantek Attendance Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(useMaterial3: true),
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      themeMode: themeMode,
      home: const AppStartupWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/device_verification': (context) => const DeviceVerificationScreen(),
      },
    );
  }
}

class AppStartupWrapper extends ConsumerStatefulWidget {
  const AppStartupWrapper({super.key});

  @override
  ConsumerState<AppStartupWrapper> createState() => _AppStartupWrapperState();
}

class _AppStartupWrapperState extends ConsumerState<AppStartupWrapper> {
  bool _isChecking = true;
  Widget? _nextScreen;

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    // Splash screen 2.5 seconds ke liye dikhao
    await Future.delayed(const Duration(milliseconds: 2500));

    final prefs = await SharedPreferences.getInstance();

    // Device verification status check
    final bool isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

    // Auth state check
    final authState = ref.read(authProvider);

    Widget nextScreen;

    // Agar device verify nahi hai → Device Verification pe jaao
    if (!isDeviceVerified) {
      nextScreen = const DeviceVerificationScreen();
    }
    // Agar device verified hai → Auth state check karo
    else {
      nextScreen = authState.when(
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const LoginScreen(),
        data: (user) {
          return user != null ? const DashboardScreen() : const LoginScreen();
        },
      );
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
        _nextScreen = nextScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || _nextScreen == null) {
      return const SplashScreen();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _nextScreen,
    );
  }
}

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     return MaterialApp(
//       title: 'Nutantek Attendance Pro',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
//       themeMode: themeMode,
//       home: const AppStartupWrapper(), // ← Yeh naya wrapper banaya
//     );
//   }
// }

// // NAYA WRAPPER — Startup logic yahan handle karega
// class AppStartupWrapper extends ConsumerStatefulWidget {
//   const AppStartupWrapper({super.key});

//   @override
//   ConsumerState<AppStartupWrapper> createState() => _AppStartupWrapperState();
// }

// class _AppStartupWrapperState extends ConsumerState<AppStartupWrapper> {
//   bool _isChecking = true;
//   Widget? _nextScreen;

//   @override
//   void initState() {
//     super.initState();
//     _determineInitialScreen();
//   }

//   Future<void> _determineInitialScreen() async {
//     // Pehle Splash dikhao — 2.5 seconds ke liye
//     await Future.delayed(const Duration(milliseconds: 2500));

//     final prefs = await SharedPreferences.getInstance();
//     final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
//     final bool isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

//     Widget nextScreen;

//     if (isFirstLaunch || !isDeviceVerified) {
//       // First time on device → Device verification
//       await prefs.setBool('is_first_launch', false);
//       nextScreen = const DeviceVerificationScreen();
//     } else {
//       // Device already verified → Check auth state
//       final authState = ref.read(authProvider);

//       nextScreen = authState.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => const LoginScreen(),
//         data: (userMap) {
//           return userMap != null
//               ? const DashboardScreen()
//               : const LoginScreen();
//         },
//       );
//     }

//     if (mounted) {
//       setState(() {
//         _isChecking = false;
//         _nextScreen = nextScreen;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Splash hamesha pehle dikhega
//     if (_isChecking || _nextScreen == null) {
//       return const SplashScreen();
//     }

//     // Splash ke baad determined screen dikhao
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 800),
//       transitionBuilder: (child, animation) {
//         return FadeTransition(opacity: animation, child: child);
//       },
//       child: _nextScreen,
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Theme
//     final themeMode = ref.watch(themeProvider);

//     // Auth state
//     final authState = ref.watch(authProvider);

//     // IMPORTANT: App start pe checkLoginStatus() call karna zaroori hai
//     // Kyunki ab token alag se save hai
//     ref.listen(authProvider, (previous, next) {
//       // Jab app start ho → pehli baar null aayega → tab check karo
//       if (previous?.value == null && next is AsyncLoading) {
//         // No need to do anything — checkLoginStatus already called in provider
//       }
//     });

//     return MaterialApp(
//       title: 'Nutantek Attendance',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
//       themeMode: themeMode,
//       home: authState.when(
//         // App start pe loading → Splash dikhao
//         loading: () => const SplashScreen(),

//         // Agar error aaya → Login pe bhejo
//         error: (err, stack) {
//           debugPrint("Auth Error: $err");
//           return const LoginScreen();
//         },

//         // Success: User mila ya nahi?
//         data: (userMap) {
//           if (userMap == null) {
//             return const LoginScreen();
//           } else {
//             // User logged in → Dashboard
//             return const DashboardScreen();
//           }
//         },
//       ),
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Theme watch kar
//     final themeMode = ref.watch(themeProvider);

//     // Auth state watch kar — AsyncValue hai
//     final authState = ref.watch(authProvider);

//     return MaterialApp(
//       title: 'Nutantek Attendance',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeMode,
//       home: authState.when(
//         // Loading → Splash dikhao
//         loading: () => const SplashScreen(),

//         // Error → Login dikhao (safe side)
//         error: (err, stack) => const LoginScreen(),

//         // Data → Agar user logged in hai → Dashboard, warna Login
//         data: (user) {
//           if (user == null) {
//             return const LoginScreen();
//           } else {
//             // Auto login ho gaya → direct Dashboard
//             return const DashboardScreen();
//           }
//         },
//       ),
//     );
//   }
// }
