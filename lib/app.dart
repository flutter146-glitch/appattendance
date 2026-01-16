// lib/app.dart

import 'package:appattendance/core/providers/theme_notifier.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/select_role_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/set_mpin_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/set_password_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Session timeout: 10 min inactivity + 1 min background
    final sessionConfig = SessionConfig(
      invalidateSessionForUserInactivity: const Duration(minutes: 10),
      invalidateSessionForAppLostFocus: const Duration(minutes: 1),
    );

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: MaterialApp(
        title: 'Nutantek Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ref.watch(themeProvider),
        home: const AppStartupWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/device_verification': (context) => const DeviceVerificationScreen(),
          '/otp_verification': (context) => OtpVerificationScreen(
            email: ModalRoute.of(context)!.settings.arguments as String,
          ),
          '/set_password': (context) => SetPasswordScreen(
            email: ModalRoute.of(context)!.settings.arguments as String,
          ),
          '/set_mpin': (context) => SetMPINScreen(
            email: ModalRoute.of(context)!.settings.arguments as String,
          ),
          '/select-role': (context) => const SelectRoleScreen(),
        },
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: MediaQuery.of(
                context,
              ).textScaleFactor.clamp(0.85, 1.15),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

class AppStartupWrapper extends ConsumerStatefulWidget {
  const AppStartupWrapper({super.key});

  @override
  ConsumerState<AppStartupWrapper> createState() => _AppStartupWrapperState();
}

class _AppStartupWrapperState extends ConsumerState<AppStartupWrapper> {
  @override
  void initState() {
    super.initState();
    _checkFirstTimeFlow();
  }

  Future<void> _checkFirstTimeFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

    if (!isDeviceVerified) {
      // First time → Device Verification → OTP → Password → MPIN → Login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DeviceVerificationScreen()),
        );
      }
    } else {
      // Subsequent times → Direct to Login (device verified)
      ref.invalidate(authProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Logged in → Check if manager → Select Role, else direct Dashboard
          if (user.isManagerial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/select-role');
              }
            });
          } else {
            return const DashboardScreen();
          }
        }
        // Not logged in → Login
        return const LoginScreen();
      },
      loading: () => const SplashScreen(),
      error: (error, stack) => _buildErrorScreen(context, error, stack, ref),
    );
  }

  Widget _buildErrorScreen(
    BuildContext context,
    Object error,
    StackTrace stack,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  'App Initialization Failed',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Please check your connection or restart the app.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 54),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    ref.invalidate(authProvider);
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/app.dart
// // FINAL UPDATED VERSION - January 05, 2026
// // Features:
// // - First time: Splash → Device Verification → OTP → Password → MPIN → Login
// // - Subsequent times: Splash → Direct Login (device verified)
// // - Role-aware Dashboard
// // - Session timeout: 10 min inactivity + 1 min background
// // - Responsive + overflow-safe error screen

// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/set_mpin_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/set_password_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Session timeout configuration
//     final sessionConfig = SessionConfig(
//       invalidateSessionForUserInactivity: const Duration(minutes: 10),
//       invalidateSessionForAppLostFocus: const Duration(minutes: 1),
//     );

//     return SessionTimeoutManager(
//       sessionConfig: sessionConfig,
//       child: MaterialApp(
//         title: 'Nutantek Attendance',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ref.watch(themeProvider),
//         home: const AppStartupWrapper(),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/dashboard': (context) => const DashboardScreen(),
//           '/device_verification': (context) => const DeviceVerificationScreen(),
//           '/otp_verification': (context) => OtpVerificationScreen(
//             email: ModalRoute.of(context)!.settings.arguments as String,
//           ),
//           '/set_password': (context) => SetPasswordScreen(
//             email: ModalRoute.of(context)!.settings.arguments as String,
//           ),
//           '/set_mpin': (context) => SetMPINScreen(
//             email: ModalRoute.of(context)!.settings.arguments as String,
//           ),
//         },
//         onGenerateRoute: (settings) {
//           // Fallback for unknown routes
//           return MaterialPageRoute(builder: (context) => const SplashScreen());
//         },
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(
//               textScaleFactor: MediaQuery.of(
//                 context,
//               ).textScaleFactor.clamp(0.85, 1.15),
//             ),
//             child: child!,
//           );
//         },
//       ),
//     );
//   }
// }

// class AppStartupWrapper extends ConsumerStatefulWidget {
//   const AppStartupWrapper({super.key});

//   @override
//   ConsumerState<AppStartupWrapper> createState() => _AppStartupWrapperState();
// }

// class _AppStartupWrapperState extends ConsumerState<AppStartupWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     _checkDeviceVerification();
//   }

//   // Check if device is already verified (first time only)
//   Future<void> _checkDeviceVerification() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

//     if (!isDeviceVerified) {
//       // First time → Device Verification chain
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const DeviceVerificationScreen()),
//       );
//     }
//     ref.invalidate(authProvider);
//     // Else: Device already verified → direct to Login (handled by auth state)
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);

//     return authState.when(
//       data: (user) {
//         if (user != null) {
//           // Logged in → Dashboard (role-based content inside)
//           return const DashboardScreen();
//         }
//         // Not logged in → Login
//         return const LoginScreen();
//       },
//       loading: () => const SplashScreen(),
//       error: (error, stack) => _buildErrorScreen(context, error, stack, ref),
//     );
//   }

//   Widget _buildErrorScreen(
//     BuildContext context,
//     Object error,
//     StackTrace stack,
//     WidgetRef ref,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 32.0,
//               vertical: 24.0,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline_rounded,
//                   size: 80,
//                   color: Theme.of(context).colorScheme.error,
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   'App Initialization Failed',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.error,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Please check your connection or restart the app.',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: 8),
//                 if (kDebugMode)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Text(
//                       'Error: $error\nStack: $stack',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 const SizedBox(height: 32),
//                 FilledButton.icon(
//                   icon: const Icon(Icons.refresh),
//                   label: const Text('Retry'),
//                   style: FilledButton.styleFrom(
//                     minimumSize: const Size(200, 54),
//                   ),
//                   onPressed: () {
//                     ref.invalidate(authProvider);
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                   child: const Text('Go to Login'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/data/services/offline_attendance_service.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/settings_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:workmanager/workmanager.dart';

// // Top-level Workmanager callback (required for background isolate)
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     if (task == "syncOfflineAttendance") {
//       await OfflineAttendanceService().backgroundSyncCallback();
//     }
//     return Future.value(true);
//   });
// }

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     // Session configuration
//     final sessionConfig = SessionConfig(
//       invalidateSessionForUserInactivity: const Duration(minutes: 10),
//       invalidateSessionForAppLostFocus: const Duration(minutes: 1),
//     );

//     // Listen for session timeouts
//     sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
//       _handleSessionTimeout(timeoutEvent, context, ref);
//     });

//     return SessionTimeoutManager(
//       sessionConfig: sessionConfig,
//       child: MaterialApp(
//         title: 'Nutantek Attendance Pro',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//             primary: AppColors.primary,
//             secondary: AppColors.secondary,
//             error: AppColors.error,
//             background: AppColors.backgroundLight,
//             surface: AppColors.surfaceLight,
//           ),
//           appBarTheme: AppBarTheme(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             elevation: 2,
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ),
//         darkTheme: ThemeData.dark().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//             brightness: Brightness.dark,
//             primary: AppColors.primary,
//             secondary: AppColors.secondary,
//             error: AppColors.error,
//             background: AppColors.backgroundDark,
//             surface: AppColors.surfaceDark,
//           ),
//           appBarTheme: AppBarTheme(
//             backgroundColor: AppColors.primary.withOpacity(0.8),
//             elevation: 2,
//           ),
//         ),
//         themeMode: themeMode,
//         home: const AppStartupWrapper(),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/dashboard': (context) => const DashboardScreen(),
//           '/device_verification': (context) => const DeviceVerificationScreen(),
//           '/settings': (context) => const SettingsScreen(),
//         },
//         onGenerateRoute: (settings) {
//           // Handle unknown routes - redirect to splash
//           return MaterialPageRoute(builder: (context) => const SplashScreen());
//         },
//         builder: (context, child) {
//           return MediaQuery(
//             // Ensure text scaling doesn't break UI
//             data: MediaQuery.of(context).copyWith(
//               textScaleFactor: MediaQuery.of(
//                 context,
//               ).textScaleFactor.clamp(0.8, 1.2),
//             ),
//             child: child!,
//           );
//         },
//       ),
//     );
//   }

//   void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       if (task == "syncOfflineAttendance") {
//         await OfflineAttendanceService.backgroundSyncCallback();
//       }
//       return Future.value(true);
//     });
//   }

//   void _handleSessionTimeout(
//     SessionTimeoutState timeoutEvent,
//     BuildContext context,
//     WidgetRef ref,
//   ) {
//     if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
//         timeoutEvent == SessionTimeoutState.appFocusTimeout) {
//       // Logout from auth provider
//       try {
//         ref.read(authProvider.notifier).logout();
//       } catch (e) {
//         // Silently handle logout errors
//         debugPrint('Logout error during session timeout: $e');
//       }

//       // Navigate to login screen
//       if (Navigator.canPop(context)) {
//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil('/login', (route) => false);
//       }

//       // Show session timeout message
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text(
//               'Session timed out due to inactivity. Please log in again.',
//             ),
//             duration: const Duration(seconds: 4),
//             action: SnackBarAction(
//               label: 'OK',
//               onPressed: () {
//                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               },
//             ),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       }
//     }
//   }
// }

// // Updated AppStartupWrapper with better error handling
// class AppStartupWrapper extends ConsumerWidget {
//   const AppStartupWrapper({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authProvider);

//     return authState.when(
//       data: (user) {
//         if (user != null) {
//           // User is logged in - go to dashboard
//           return const DashboardScreen();
//         } else {
//           // User is not logged in - go to login
//           return const LoginScreen();
//         }
//       },
//       loading: () => const SplashScreen(),
//       error: (error, stackTrace) {
//         // Handle initialization errors gracefully
//         debugPrint('App startup error: $error\n$stackTrace');

//         // Show error screen with retry option
//         return Scaffold(
//           body: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 20),
//                   Text(
//                     'App Initialization Failed',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       color: AppColors.error,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Please restart the app or check your connection.',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Error: ${error.toString()}',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodySmall?.copyWith(color: Colors.grey),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Retry initialization
//                       ref.invalidate(authProvider);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 12,
//                       ),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                   const SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () {
//                       // Go to login screen directly
//                       Navigator.of(
//                         context,
//                       ).pushNamedAndRemoveUntil('/login', (route) => false);
//                     },
//                     child: const Text('Go to Login'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/settings_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart'; // Correct import
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     final sessionConfig = SessionConfig(
//       invalidateSessionForUserInactivity: const Duration(minutes: 10),
//       invalidateSessionForAppLostFocus: const Duration(minutes: 1),
//     );

//     // Logout on timeout
//     sessionConfig.stream.listen((timeoutEvent) {
//       if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
//           timeoutEvent == SessionTimeoutState.appFocusTimeout) {
//         ref.read(authProvider.notifier).logout();

//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil('/login', (route) => false);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Session timed out due to inactivity. Please log in again.',
//             ),
//             duration: Duration(seconds: 5),
//           ),
//         );
//       }
//     });

//     return SessionTimeoutManager(
//       sessionConfig: sessionConfig,
//       child: MaterialApp(
//         title: 'Nutantek Attendance Pro',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
//         ),
//         darkTheme: ThemeData.dark().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//             brightness: Brightness.dark,
//           ),
//         ),
//         themeMode: themeMode,
//         home:
//             const SplashScreen(), // Direct SplashScreen – yahi sab handle karega
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/dashboard': (context) => const DashboardScreen(),
//           '/device_verification': (context) => const DeviceVerificationScreen(),
//           '/settings': (context) => const SettingsScreen(),
//         },
//       ),
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/core/utils/app_colors.dart'; // ← New
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/settings_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     final sessionConfig = SessionConfig(
//       invalidateSessionForUserInactivity: const Duration(minutes: 10),
//       invalidateSessionForAppLostFocus: const Duration(minutes: 1),
//       // warningDuration: const Duration(seconds: 30), // ← Uncommented + added
//     );

//     // Logout on timeout
//     sessionConfig.stream.listen((timeoutEvent) {
//       if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
//           timeoutEvent == SessionTimeoutState.appFocusTimeout) {
//         ref.read(authProvider.notifier).logout();

//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil('/login', (route) => false);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Session timed out due to inactivity. Please log in again.',
//             ),
//             duration: Duration(seconds: 5),
//           ),
//         );
//       }
//     });

//     return SessionTimeoutManager(
//       sessionConfig: sessionConfig,
//       child: MaterialApp(
//         title: 'Nutantek Attendance Pro',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//           ), // ← Custom theme integration
//         ),
//         darkTheme: ThemeData.dark().copyWith(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//             brightness: Brightness.dark,
//           ),
//         ),
//         themeMode: themeMode,
//         home: const AppStartupWrapper(),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/dashboard': (context) => const DashboardScreen(),
//           '/device_verification': (context) => const DeviceVerificationScreen(),
//           '/settings': (context) => const SettingsScreen(),
//         },
//       ),
//     );
//   }
// }

// // AppStartupWrapper (minor cleanup + error handling)
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
//     try {
//       await Future.delayed(
//         const Duration(milliseconds: 2500),
//       ); // Splash delay (config se better)

//       final prefs = await SharedPreferences.getInstance();
//       final bool isDeviceVerified =
//           prefs.getBool('is_device_verified') ?? false;

//       Widget nextScreen;

//       if (!isDeviceVerified) {
//         nextScreen = const DeviceVerificationScreen();
//       } else {
//         final authState = ref.read(authProvider);
//         nextScreen = authState.when(
//           loading: () =>
//               const Scaffold(body: Center(child: CircularProgressIndicator())),
//           error: (_, __) => const LoginScreen(),
//           data: (user) =>
//               user != null ? const DashboardScreen() : const LoginScreen(),
//         );
//       }

//       if (mounted) {
//         setState(() {
//           _isChecking = false;
//           _nextScreen = nextScreen;
//         });
//       }
//     } catch (e) {
//       // Error handling in startup
//       if (mounted) {
//         setState(() {
//           _isChecking = false;
//           _nextScreen = const LoginScreen(); // Fallback to login on error
//         });
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Startup error: $e')));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isChecking || _nextScreen == null) {
//       return const SplashScreen();
//     }

//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 800),
//       transitionBuilder: (child, animation) =>
//           FadeTransition(opacity: animation, child: child),
//       child: _nextScreen!,
//     );
//   }
// }

// // lib/app.dart
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/settings_screen.dart'; // ← New
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     final sessionConfig = SessionConfig(
//       invalidateSessionForUserInactivity: const Duration(
//         minutes: 10,
//       ), // 10 min no activity
//       invalidateSessionForAppLostFocus: const Duration(
//         minutes: 1,
//       ), // background mein 1 min
//       // warningDuration: const Duration(
//       //   seconds: 30,
//       // ), // 30 sec pe warning (optional)
//     );

//     // Logout on timeout
//     sessionConfig.stream.listen((timeoutEvent) {
//       if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
//           timeoutEvent == SessionTimeoutState.appFocusTimeout) {
//         ref.read(authProvider.notifier).logout();

//         // Clear navigation stack and go to login
//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil('/login', (route) => false);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Session timed out due to inactivity')),
//         );
//       }
//     });

//     return SessionTimeoutManager(
//       sessionConfig: sessionConfig,
//       child: MaterialApp(
//         title: 'Nutantek Attendance Pro',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light().copyWith(useMaterial3: true),
//         darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
//         themeMode: themeMode,
//         home: const AppStartupWrapper(),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/dashboard': (context) => const DashboardScreen(),
//           '/device_verification': (context) => const DeviceVerificationScreen(),
//           '/settings': (context) => const SettingsScreen(), // ← New route
//         },
//       ),
//     );
//   }
// }

// // AppStartupWrapper remains same (minor cleanup)
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
//     await Future.delayed(const Duration(milliseconds: 2500)); // Splash delay

//     final prefs = await SharedPreferences.getInstance();
//     final bool isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

//     Widget nextScreen;

//     if (!isDeviceVerified) {
//       nextScreen = const DeviceVerificationScreen();
//     } else {
//       final authState = ref.read(authProvider);
//       nextScreen = authState.when(
//         loading: () =>
//             const Scaffold(body: Center(child: CircularProgressIndicator())),
//         error: (_, __) => const LoginScreen(),
//         data: (user) =>
//             user != null ? const DashboardScreen() : const LoginScreen(),
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
//     if (_isChecking || _nextScreen == null) {
//       return const SplashScreen();
//     }

//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 800),
//       transitionBuilder: (child, animation) =>
//           FadeTransition(opacity: animation, child: child),
//       child: _nextScreen!,
//     );
//   }
// }

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
