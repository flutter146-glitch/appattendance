// lib/features/auth/presentation/screens/device_verification_screen.dart

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceVerificationScreen extends StatefulWidget {
  const DeviceVerificationScreen({super.key});

  @override
  State<DeviceVerificationScreen> createState() =>
      _DeviceVerificationScreenState();
}

class _DeviceVerificationScreenState extends State<DeviceVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _isVerifying = false;

  late AnimationController _animController;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6)),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animController.forward();

    // Testing ke liye (remove in production)
    // _emailController.text = "raj@nutantek.com";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    final email = _emailController.text.trim().toLowerCase();

    if (email.isEmpty || !email.contains('@nutantek.com')) {
      _showSnackBar(
        "Please enter a valid Nutantek email (e.g. name@nutantek.com)",
        isError: true,
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final db = await DBHelper.instance.database;

      // employee_master se email check karo (emp_email field)
      final result = await db.query(
        'employee_master',
        where: 'emp_email = ?',
        whereArgs: [email],
      );

      if (result.isEmpty) {
        _showSnackBar(
          "This email is not registered with Nutantek. Contact HR.",
          isError: true,
        );
        setState(() => _isVerifying = false);
        return;
      }

      // Device verified — save in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_device_verified', true);

      _showSnackBar("Device verified successfully!", isSuccess: true);

      // OTP screen pe jaao
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(email: email),
          ),
        );
      }
    } catch (e) {
      debugPrint("Device verification error: $e");
      _showSnackBar("Verification failed. Please try again.", isError: true);
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isSuccess ? 2 : 4),
      ),
    );
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
                ? [AppColors.primary.withOpacity(0.2), Colors.black]
                : [
                    AppColors.primary.withOpacity(0.08),
                    AppColors.backgroundLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacity,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 40,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 30,
                                offset: Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.verified_user_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        Text(
                          'Device Verification Required',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),

                        Text(
                          'This is the first time you\'re using the app on this device.\nPlease enter your Nutantek company email to continue.',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 60),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Nutantek Email',
                            hintText: 'e.g. raj@nutantek.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: isDark
                                ? Colors.grey[800]
                                : Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),

                        // Verify Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isVerifying ? null : _verifyEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 6,
                            ),
                            child: _isVerifying
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'VERIFY DEVICE',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 60),

                        Text(
                          'Only authorized Nutantek devices are allowed.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
