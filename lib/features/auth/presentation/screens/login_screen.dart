// lib/features/auth/presentation/screens/login_screen.dart
// FINAL SIMPLIFIED & PROFESSIONAL VERSION - January 08, 2026
// Device verification & binding removed (no first-time check)
// Biometrics kept (optional), 20-min auto-logout, remember me
// Role-based redirect: Employee → Dashboard, Manager → Select Role
// Clean UI, null-safe, fast & reliable

import 'dart:async';

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/core/services/biometric_service.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final BiometricService _biometricService = BiometricService();

  late AnimationController _animController;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isAuthenticating = false;

  int _failedAttempts = 0;
  DateTime? _lockoutUntil;
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();

    _initAnimations();
    _loadPreferences();

    // Auto-redirect if already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = ref.read(authProvider).value;
      if (user != null) {
        _redirectBasedOnRole(user);
      }
    });
  }

  void _initAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final remember = prefs.getBool('remember_me') ?? false;

    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }

    if (mounted) {
      setState(() => _rememberMe = remember);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    _logoutTimer?.cancel();
    super.dispose();
  }

  void _startLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(const Duration(minutes: 20), () {
      if (mounted) {
        ref.read(authProvider.notifier).logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session timed out. Please login again.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Future<void> _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Lockout check
    if (_lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!)) {
      final remaining = _lockoutUntil!.difference(DateTime.now());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Too many attempts. Try again in ${remaining.inMinutes} minutes',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (mounted) setState(() => _isAuthenticating = true);

    try {
      // Clear any previous session
      await ref.read(authProvider.notifier).logout();

      // Fresh login
      await ref.read(authProvider.notifier).login(email, password);

      final user = ref.read(authProvider).value;
      if (user == null) throw Exception('User not found');

      // Biometric check (optional)
      if (user.biometricEnabled) {
        final canUse = await _biometricService.canCheckBiometrics();
        if (canUse) {
          final authenticated = await _biometricService.authenticate(
            reason: 'Verify your identity',
          );
          if (!authenticated) throw Exception('Biometric verification failed');
        }
      }

      // Remember me
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_email', email);
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_email');
        await prefs.setBool('remember_me', false);
      }

      // Reset failures & start timer
      _failedAttempts = 0;
      _lockoutUntil = null;
      _startLogoutTimer();

      // Role-based navigation
      if (mounted) {
        _redirectBasedOnRole(user);
      }
    } catch (e) {
      _failedAttempts++;
      if (_failedAttempts >= 5) {
        _lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  void _redirectBasedOnRole(UserModel user) {
    if (!mounted) return;

    if (user.isManagerial) {
      Navigator.pushReplacementNamed(context, '/select-role');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isButtonDisabled = _isAuthenticating || authState.isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.primaryDark.withOpacity(0.8), Colors.black87]
                : [AppColors.primary.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF2171C9)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.4),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/nutantek_logo.png',
                      width: 70,
                      height: 70,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.business_center,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 48),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Company Email',
                          hintText: 'e.g. name@nutantek.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          filled: true,
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                        onFieldSubmitted: (_) => _performLogin(),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                          ),
                          const Text('Remember me'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isButtonDisabled ? null : _performLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isButtonDisabled
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Text(
                  '© 2025 Nutantek • Enterprise Edition',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/features/auth/presentation/screens/login_screen.dart
// // FINAL POLISHED VERSION - January 06, 2026
// // Features:
// // - Device verification check (first time only)
// // - Biometrics + device binding
// // - Role-based redirection: Employee → Dashboard, Manager → Select Role → Dashboard
// // - 20-minute auto-logout timer after successful login
// // - Full error handling, loading, remember me
// // - Null-safe, no circular dependency

// import 'dart:async';
// import 'dart:io';

// import 'package:appattendance/core/constants/role_constants.dart';
// import 'package:appattendance/core/providers/remember_me_provider.dart';
// import 'package:appattendance/core/services/biometric_service.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
// import 'package:appattendance/features/auth/presentation/screens/select_role_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final BiometricService _biometricService = BiometricService();

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//   bool _isAuthenticating = false;

//   // Rate limiting
//   int _failedAttempts = 0;
//   DateTime? _lockoutUntil;

//   // Auto-logout timer
//   Timer? _logoutTimer;

//   @override
//   void initState() {
//     super.initState();

//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
//         );

//     _animController.forward();

//     // Load saved preferences
//     _loadPreferences();
//   }

//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedEmail = prefs.getString('saved_email');
//     final remember = prefs.getBool('remember_me') ?? false;

//     if (savedEmail != null) {
//       _emailController.text = savedEmail;
//     }

//     if (mounted) {
//       setState(() {
//         _rememberMe = remember;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     _logoutTimer?.cancel();
//     super.dispose();
//   }

//   // Start 20-minute auto-logout timer after successful login
//   void _startLogoutTimer() {
//     _logoutTimer?.cancel();
//     _logoutTimer = Timer(const Duration(minutes: 20), () {
//       if (mounted) {
//         ref.read(authProvider.notifier).logout();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Session timed out. Please login again.'),
//           ),
//         );
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     });
//   }

//   Future<void> _performLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     // final isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

//     // if (!isDeviceVerified) {
//     //   if (mounted) {
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(
//     //         content: Text('Device not verified. Please verify first.'),
//     //       ),
//     //     );
//     //     Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(builder: (_) => const DeviceVerificationScreen()),
//     //     );
//     //   }
//     //   return;
//     // }

//     if (!_formKey.currentState!.validate()) return;

//     // Check lockout
//     if (_lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!)) {
//       final remaining = _lockoutUntil!.difference(DateTime.now());
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Too many attempts. Try again in ${remaining.inMinutes} minutes',
//             ),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//       return;
//     }

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (mounted) {
//       setState(() => _isAuthenticating = true);
//     }

//     try {
//       // Step 1: Login attempt
//       await ref.read(authProvider.notifier).login(email, password);

//       final user = ref.read(authProvider).value;
//       if (user == null) throw Exception('User not found');

//       // Step 2: Biometric check (if enabled)
//       if (user.biometricEnabled) {
//         final canUseBiometrics = await _biometricService.canCheckBiometrics();
//         if (canUseBiometrics) {
//           final authenticated = await _biometricService.authenticate(
//             reason: 'Verify your identity with Face ID',
//           );
//           if (!authenticated) throw Exception('Face authentication failed');
//         } else {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Biometrics not available. Proceeding...'),
//               ),
//             );
//           }
//         }
//       }

//       // Step 3: Device binding check
//       // try {
//       //   final deviceInfo = DeviceInfoPlugin();
//       //   String currentDeviceId;

//       //   if (Platform.isAndroid) {
//       //     final androidInfo = await deviceInfo.androidInfo;
//       //     currentDeviceId = androidInfo.id;
//       //   } else if (Platform.isIOS) {
//       //     final iosInfo = await deviceInfo.iosInfo;
//       //     currentDeviceId = iosInfo.identifierForVendor ?? 'unknown_ios';
//       //   } else {
//       //     currentDeviceId =
//       //         'other_platform_${DateTime.now().millisecondsSinceEpoch}';
//       //   }

//       //   final storedDeviceId = prefs.getString('bound_device_id');

//       //   if (storedDeviceId == null) {
//       //     await prefs.setString('bound_device_id', currentDeviceId);
//       //     if (mounted) {
//       //       ScaffoldMessenger.of(context).showSnackBar(
//       //         const SnackBar(
//       //           content: Text('Device successfully bound to your account'),
//       //         ),
//       //       );
//       //     }
//       //   } else if (storedDeviceId != currentDeviceId) {
//       //     throw Exception(
//       //       'This account is bound to another device. Contact admin.',
//       //     );
//       //   }
//       // } catch (bindingError) {
//       //   if (mounted) {
//       //     ScaffoldMessenger.of(context).showSnackBar(
//       //       SnackBar(
//       //         content: Text('Device binding failed: $bindingError'),
//       //         backgroundColor: Colors.redAccent,
//       //       ),
//       //     );
//       //   }
//       //   ref.read(authProvider.notifier).logout();
//       //   return;
//       // }

//       // Step 4: Remember Me
//       if (_rememberMe) {
//         await prefs.setString('saved_email', email);
//         await prefs.setBool('remember_me', true);
//       } else {
//         await prefs.remove('saved_email');
//         await prefs.setBool('remember_me', false);
//       }

//       // Reset failed attempts
//       _failedAttempts = 0;
//       _lockoutUntil = null;

//       // Step 5: Start 20-min auto-logout timer
//       _startLogoutTimer();

//       // Step 6: Role-based navigation - FIXED with post-frame callback
//       if (mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted)
//             return; // Safety net (dispose ke baad call aaye toh ignore)

//           final currentUser = ref.read(authProvider).value;
//           if (currentUser == null) return; // No user, no navigation

//           if (currentUser.isManagerial) {
//             Navigator.pushReplacementNamed(context, '/select-role');
//           } else {
//             Navigator.pushReplacementNamed(context, '/dashboard');
//           }
//         });
//       }
//     } catch (e) {
//       _failedAttempts++;
//       if (_failedAttempts >= 5) {
//         _lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'Too many failed attempts. Account locked for 5 minutes.',
//               ),
//               backgroundColor: Colors.redAccent,
//               duration: Duration(seconds: 5),
//             ),
//           );
//         }
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Login failed: ${e.toString().replaceAll('Exception: ', '')}',
//             ),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isAuthenticating = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final isButtonDisabled = _isAuthenticating || authState.isLoading;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isDark
//                 ? [AppColors.primaryDark.withOpacity(0.8), Colors.black87]
//                 : [AppColors.primary.withOpacity(0.1), Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
//             child: Column(
//               children: [
//                 // Logo
//                 Container(
//                   width: 110,
//                   height: 110,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF4A90E2), Color(0xFF2171C9)],
//                     ),
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF4A90E2).withOpacity(0.4),
//                         blurRadius: 30,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       'assets/images/nutantek_logo.png',
//                       width: 70,
//                       height: 70,
//                       errorBuilder: (_, __, ___) => const Icon(
//                         Icons.business_center,
//                         size: 60,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 Text(
//                   'Welcome Back',
//                   style: Theme.of(context).textTheme.headlineLarge,
//                 ),
//                 Text(
//                   'Sign in to continue',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: 48),

//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           labelText: 'Company Email',
//                           hintText: 'e.g. name@nutantek.com',
//                           prefixIcon: const Icon(Icons.email_outlined),
//                           filled: true,
//                         ),
//                         validator: (v) =>
//                             v?.isEmpty ?? true ? 'Required' : null,
//                       ),
//                       const SizedBox(height: 24),

//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: _obscurePassword,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () => setState(
//                               () => _obscurePassword = !_obscurePassword,
//                             ),
//                           ),
//                           filled: true,
//                         ),
//                         validator: (v) =>
//                             v?.isEmpty ?? true ? 'Required' : null,
//                         onFieldSubmitted: (_) => _performLogin(),
//                       ),

//                       const SizedBox(height: 16),

//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _rememberMe,
//                             onChanged: (v) =>
//                                 setState(() => _rememberMe = v ?? false),
//                           ),
//                           const Text('Remember me'),
//                         ],
//                       ),

//                       const SizedBox(height: 24),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: ElevatedButton(
//                           onPressed: isButtonDisabled ? null : _performLogin,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: isButtonDisabled
//                               ? const SizedBox(
//                                   height: 24,
//                                   width: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Text(
//                                   'LOGIN',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       TextButton(
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const ForgotPasswordScreen(),
//                           ),
//                         ),
//                         child: const Text('Forgot Password?'),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//                 Text(
//                   '© 2025 Nutantek • Enterprise Edition',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
