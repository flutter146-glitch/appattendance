// lib/features/auth/presentation/screens/device_verification_screen.dart
// Final production-ready Device Verification Screen
// Uses local DB (SQLite) for email check + dummy OTP simulation
// Role-based flow (employee/manager) + future API-ready (commented)
// Error handling, loading, dark mode support
// Current date context: December 29, 2025

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceVerificationScreen extends ConsumerStatefulWidget {
  const DeviceVerificationScreen({super.key});

  @override
  ConsumerState<DeviceVerificationScreen> createState() =>
      _DeviceVerificationScreenState();
}

class _DeviceVerificationScreenState
    extends ConsumerState<DeviceVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim().toLowerCase();
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid company email');
      }

      final db = await DBHelper.instance.database;

      // Check if email exists in user table
      final userRows = await db.query(
        'user',
        where: 'email_id = ?',
        whereArgs: [email],
      );

      if (userRows.isEmpty) {
        throw Exception('Email not registered. Contact HR.');
      }

      // Dummy OTP simulation (in real: send to email/SMS)
      // Future API: await dio.post('/auth/send-otp', data: {'email': email});

      // Navigate to OTP screen
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerificationScreen(email: email)),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.blueGrey.shade900, Colors.black87]
                : [AppColors.primary.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo / Icon
                    Center(
                      child: Icon(
                        Icons.security_rounded,
                        size: 100,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'Device Verification',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Enter your company email to verify your device',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Email Input
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Company Email',
                        hintText: 'e.g. name@nutantek.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _verifyEmail(),
                    ),
                    const SizedBox(height: 16),

                    // Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Verify Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'VERIFY DEVICE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Back to Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer
                    Text(
                      '© 2025 Nutantek • Enterprise Edition',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey[600],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/features/auth/presentation/screens/device_verification_screen.dart

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DeviceVerificationScreen extends StatefulWidget {
//   const DeviceVerificationScreen({super.key});

//   @override
//   State<DeviceVerificationScreen> createState() =>
//       _DeviceVerificationScreenState();
// }

// class _DeviceVerificationScreenState extends State<DeviceVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final _emailController = TextEditingController();
//   bool _isVerifying = false;

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();

//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6)),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
//           ),
//         );

//     _animController.forward();

//     // Testing ke liye (remove in production)
//     // _emailController.text = "raj@nutantek.com";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyEmail() async {
//     final email = _emailController.text.trim().toLowerCase();

//     if (email.isEmpty || !email.contains('@nutantek.com')) {
//       _showSnackBar(
//         "Please enter a valid Nutantek email (e.g. name@nutantek.com)",
//         isError: true,
//       );
//       return;
//     }

//     setState(() => _isVerifying = true);

//     try {
//       final db = await DBHelper.instance.database;

//       // employee_master se email check karo (emp_email field)
//       final result = await db.query(
//         'employee_master',
//         where: 'emp_email = ?',
//         whereArgs: [email],
//       );

//       if (result.isEmpty) {
//         _showSnackBar(
//           "This email is not registered with Nutantek. Contact HR.",
//           isError: true,
//         );
//         setState(() => _isVerifying = false);
//         return;
//       }

//       // Device verified — save in SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_device_verified', true);

//       _showSnackBar("Device verified successfully!", isSuccess: true);

//       // OTP screen pe jaao
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OtpVerificationScreen(email: email),
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("Device verification error: $e");
//       _showSnackBar("Verification failed. Please try again.", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isVerifying = false);
//       }
//     }
//   }

//   void _showSnackBar(
//     String message, {
//     bool isError = false,
//     bool isSuccess = false,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: isSuccess ? 2 : 4),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isDark
//                 ? [AppColors.primary.withOpacity(0.2), Colors.black]
//                 : [
//                     AppColors.primary.withOpacity(0.08),
//                     AppColors.backgroundLight,
//                   ],
//           ),
//         ),
//         child: SafeArea(
//           child: AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _opacity,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                       left: 24,
//                       right: 24,
//                       top: 40,
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                     ),
//                     child: Column(
//                       children: [
//                         // Logo
//                         Container(
//                           width: 110,
//                           height: 110,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.primary,
//                                 AppColors.primaryLight,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.primary.withOpacity(0.4),
//                                 blurRadius: 30,
//                                 offset: Offset(0, 15),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.verified_user_rounded,
//                               size: 60,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         Text(
//                           'Device Verification Required',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 20),

//                         Text(
//                           'This is the first time you\'re using the app on this device.\nPlease enter your Nutantek company email to continue.',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark ? Colors.white70 : Colors.grey[700],
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 60),

//                         // Email Field
//                         TextField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: 'Nutantek Email',
//                             hintText: 'e.g. raj@nutantek.com',
//                             prefixIcon: Icon(Icons.email_outlined),
//                             filled: true,
//                             fillColor: isDark
//                                 ? Colors.grey[800]
//                                 : Colors.grey[50],
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 50),

//                         // Verify Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: _isVerifying ? null : _verifyEmail,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               elevation: 6,
//                             ),
//                             child: _isVerifying
//                                 ? SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2.5,
//                                     ),
//                                   )
//                                 : Text(
//                                     'VERIFY DEVICE',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         SizedBox(height: 60),

//                         Text(
//                           'Only authorized Nutantek devices are allowed.',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: isDark ? Colors.white60 : Colors.grey[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/auth/presentation/screens/device_verification_screen.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DeviceVerificationScreen extends StatefulWidget {
//   const DeviceVerificationScreen({super.key});

//   @override
//   State<DeviceVerificationScreen> createState() =>
//       _DeviceVerificationScreenState();
// }

// class _DeviceVerificationScreenState extends State<DeviceVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final _emailController = TextEditingController();
//   bool _isVerifying = false;

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();

//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6)),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
//           ),
//         );

//     _animController.forward();

//     // Testing ke liye
//     _emailController.text = "";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyEmail() async {
//     final email = _emailController.text.trim();

//     if (email.isEmpty || !email.contains('@')) {
//       _showSnackBar("Please enter a valid company email", isError: true);
//       return;
//     }

//     setState(() => _isVerifying = true);

//     try {
//       final db = await DBHelper.instance.database;

//       final result = await db.query(
//         'employee_master',
//         where: 'emp_email = ?',
//         whereArgs: [email],
//       );

//       await Future.delayed(const Duration(seconds: 1)); // Fake delay

//       if (result.isNotEmpty) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('is_device_verified', true);

//         _showSnackBar("Device verified successfully!", isSuccess: true);

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OtpVerificationScreen(email: email),
//             ),
//           );
//         }
//       } else {
//         _showSnackBar("Email not registered. Contact HR.", isError: true);
//       }
//     } catch (e) {
//       _showSnackBar("Verification failed. Try again.", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isVerifying = false);
//       }
//     }
//   }

//   void _showSnackBar(
//     String message, {
//     bool isError = false,
//     bool isSuccess = false,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isDark
//                 ? [AppColors.primary.withOpacity(0.2), Colors.black]
//                 : [
//                     AppColors.primary.withOpacity(0.08),
//                     AppColors.backgroundLight,
//                   ],
//           ),
//         ),
//         child: SafeArea(
//           child: AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _opacity,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                       left: 24,
//                       right: 24,
//                       top: 40,
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                     ),
//                     child: Column(
//                       children: [
//                         // Logo
//                         Container(
//                           width: 110,
//                           height: 110,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 AppColors.primary,
//                                 AppColors.primaryLight,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.primary.withOpacity(0.4),
//                                 blurRadius: 30,
//                                 offset: const Offset(0, 15),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.verified_user_rounded,
//                               size: 60,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         Text(
//                           'Device Verification Required',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 20),

//                         Text(
//                           'This is the first time you\'re using the app on this device.\nPlease enter your company email to continue.',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark ? Colors.white70 : Colors.grey[700],
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 60),

//                         // Email Field
//                         TextField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: 'Company Email',
//                             hintText: 'e.g. name@nutantek.com',
//                             prefixIcon: const Icon(Icons.email_outlined),
//                             filled: true,
//                             fillColor: isDark
//                                 ? Colors.grey[800]
//                                 : Colors.grey[50],
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 50),

//                         // Verify Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: _isVerifying ? null : _verifyEmail,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               elevation: 6,
//                             ),
//                             child: _isVerifying
//                                 ? const SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2.5,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'VERIFY DEVICE',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(height: 60),

//                         Text(
//                           'Only authorized company devices are allowed.',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: isDark ? Colors.white60 : Colors.grey[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/auth/presentation/screens/device_verification_screen.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DeviceVerificationScreen extends StatefulWidget {
//   const DeviceVerificationScreen({super.key});

//   @override
//   State<DeviceVerificationScreen> createState() =>
//       _DeviceVerificationScreenState();
// }

// class _DeviceVerificationScreenState extends State<DeviceVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final _empIdController = TextEditingController();
//   bool _isVerifying = false;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();

//     // Testing ke liye pre-fill
//     _empIdController.text = "EMP001";
//   }

//   @override
//   void dispose() {
//     _empIdController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyDevice() async {
//     final empId = _empIdController.text.trim().toUpperCase();

//     if (empId.isEmpty) {
//       _showSnackBar("Please enter your Employee ID", isError: true);
//       return;
//     }

//     setState(() => _isVerifying = true);

//     try {
//       final db = await DBHelper.instance.database;

//       final List<Map<String, dynamic>> result = await db.query(
//         'employee_master',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//       );

//       if (result.isNotEmpty) {
//         // Valid Employee ID found
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('is_device_verified', true);

//         _showSnackBar(
//           "Device successfully verified for $empId",
//           isSuccess: true,
//         );

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const LoginScreen()),
//           );
//         }
//       } else {
//         _showSnackBar(
//           "Invalid Employee ID. Please contact HR/Admin.",
//           isError: true,
//         );
//       }
//     } catch (e) {
//       _showSnackBar("Verification failed. Please try again.", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isVerifying = false);
//       }
//     }
//   }

//   void _showSnackBar(
//     String message, {
//     bool isError = false,
//     bool isSuccess = false,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess
//             ? Colors.green
//             : (isError ? Colors.red : Colors.blue),
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: isSuccess ? 2 : 4),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: isDark
//                 ? [Colors.black, Colors.grey[900]!]
//                 : [AppColors.primary.withOpacity(0.1), Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.only(
//                   left: 24,
//                   right: 24,
//                   top: 60,
//                   bottom: MediaQuery.of(context).viewInsets.bottom + 30,
//                 ),
//                 child: Column(
//                   children: [
//                     // Logo
//                     Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [AppColors.primary, AppColors.primaryLight],
//                         ),
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.primary.withOpacity(0.4),
//                             blurRadius: 30,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.verified_user_rounded,
//                           size: 80,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 50),

//                     Text(
//                       "Device Verification Required",
//                       style: Theme.of(context).textTheme.headlineMedium
//                           ?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white : Colors.black87,
//                           ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),

//                     Text(
//                       "For security reasons, this app requires device verification on first use.\nPlease enter your company-issued Employee ID.",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isDark ? Colors.white70 : Colors.grey[700],
//                         height: 1.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 60),

//                     // Employee ID Input
//                     TextField(
//                       controller: _empIdController,
//                       textCapitalization: TextCapitalization.characters,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "Employee ID",
//                         hintText: "e.g. EMP001",
//                         prefixIcon: const Icon(Icons.badge_rounded),
//                         filled: true,
//                         fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 50),

//                     // Verify Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: ElevatedButton(
//                         onPressed: _isVerifying ? null : _verifyDevice,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 8,
//                         ),
//                         child: _isVerifying
//                             ? const SizedBox(
//                                 height: 28,
//                                 width: 28,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 3,
//                                 ),
//                               )
//                             : const Text(
//                                 "VERIFY DEVICE",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 50),

//                     Text(
//                       "Only authorized employees can use this app on registered devices.",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: isDark ? Colors.white60 : Colors.grey[600],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
