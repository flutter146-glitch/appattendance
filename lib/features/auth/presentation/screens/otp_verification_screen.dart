// lib/features/auth/presentation/screens/otp_verification_screen.dart
// Final production-ready OTP Verification Screen
// Uses local DB for dummy OTP validation (e.g., "123456")
// Future API-ready (commented)
// Full error handling, loading, dark mode, auto-focus OTP fields
// Role-based flow (employee/manager) + navigation to dashboard
// Current date context: December 29, 2025

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/screens/set_password_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
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

    // Auto-focus first field
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // Dummy OTP validation (in real: API call)
      // Future API: await dio.post('/auth/verify-otp', data: {'email': widget.email, 'otp': _otp});
      const dummyOtp = '123456'; // From dummy_data.json or hardcoded for demo

      if (_otp != dummyOtp) {
        throw Exception('Invalid OTP');
      }

      // OTP valid → Proceed to next step (e.g., set password)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SetPasswordScreen(email: widget.email),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
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
                    // Icon
                    Center(
                      child: Icon(
                        Icons.lock_open_rounded,
                        size: 100,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'OTP Verification',
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
                      'Enter the 6-digit code sent to\n${widget.email}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // OTP Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                            (index) => SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }

                              // Auto-verify on last digit
                              if (index == 5 && value.isNotEmpty) {
                                _verifyOtp();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Verify Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isVerifying || _otp.length != 6
                            ? null
                            : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: _isVerifying
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'VERIFY OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Resend OTP
                    TextButton(
                      onPressed: _isVerifying
                          ? null
                          : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OTP Resent! (Dummy)'),
                          ),
                        );
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(color: AppColors.primary, fontSize: 16),
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

// // lib/features/auth/presentation/screens/otp_verification_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/set_password_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   final String email;

//   const OtpVerificationScreen({super.key, required this.email});

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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

//     // Auto focus first box
//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (mounted) _focusNodes[0].requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) controller.dispose();
//     for (var node in _focusNodes) node.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyOtp() async {
//     final otp = _controllers.map((c) => c.text).join();

//     if (otp.length != 6) {
//       _showSnackBar("Please enter complete 6-digit OTP", isError: true);
//       return;
//     }

//     setState(() => _isVerifying = true);

//     // Fake delay - real mein API call jayega
//     await Future.delayed(const Duration(seconds: 2));

//     // Fake OTP accept - testing ke liye
//     if (otp == "123456") {
//       _showSnackBar("OTP verified successfully!", isSuccess: true);

//       if (mounted) {
//         // OTP success pe
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => SetPasswordScreen(email: widget.email),
//           ),
//         );
//         // Success pe login pe wapas (future mein new password screen jayega)
//         // Navigator.pushAndRemoveUntil(
//         //   context,
//         //   MaterialPageRoute(builder: (_) => const LoginScreen()),
//         //   (route) => false,
//         // );
//       }
//     } else {
//       _showSnackBar("Invalid OTP. Please try again.", isError: true);
//     }

//     setState(() => _isVerifying = false);
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
//                               Icons.sms_rounded,
//                               size: 60,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         Text(
//                           'Verify OTP',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         const SizedBox(height: 16),

//                         Text(
//                           'We have sent a 6-digit code to',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark ? Colors.white70 : Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.email,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 60),

//                         // OTP Boxes
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: List.generate(
//                             6,
//                             (index) => _buildOtpBox(index, isDark),
//                           ),
//                         ),
//                         const SizedBox(height: 60),

//                         // Verify Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: _isVerifying ? null : _verifyOtp,
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
//                                     'VERIFY OTP',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // Resend OTP
//                         TextButton(
//                           onPressed: () {
//                             _showSnackBar("New OTP sent!");
//                           },
//                           child: Text(
//                             "Didn't receive code? Resend",
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontSize: 16,
//                             ),
//                           ),
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

//   Widget _buildOtpBox(int index, bool isDark) {
//     return SizedBox(
//       width: 50,
//       height: 60,
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: isDark ? Colors.white : Colors.black87,
//         ),
//         decoration: InputDecoration(
//           counterText: "",
//           filled: true,
//           fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColors.primary, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColors.primary, width: 3),
//           ),
//         ),
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) {
//             _focusNodes[index + 1].requestFocus();
//           } else if (value.isEmpty && index > 0) {
//             _focusNodes[index - 1].requestFocus();
//           }

//           // Auto verify on last digit
//           if (index == 5 && value.isNotEmpty) {
//             final otp = _controllers.map((c) => c.text).join();
//             if (otp.length == 6) {
//               _verifyOtp();
//             }
//           }
//         },
//       ),
//     );
//   }
// }

// // lib/features/auth/presentation/screens/otp_verification_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   final String email; // Jo email forgot password se aaya hai

//   const OtpVerificationScreen({super.key, required this.email});

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final List<TextEditingController> _otpControllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

//   bool _isVerifying = false;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Animation for smooth entry
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();

//     // Auto focus first box
//     Future.delayed(Duration(milliseconds: 300), () {
//       if (mounted) _focusNodes[0].requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _otpControllers) controller.dispose();
//     for (var node in _focusNodes) node.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   // Fake OTP verify - real mein API call jayega
//   Future<void> _verifyOtp() async {
//     final otp = _otpControllers.map((c) => c.text).join();

//     if (otp.length != 6) {
//       _showSnackBar("Please enter complete 6-digit OTP", isError: true);
//       return;
//     }

//     setState(() => _isVerifying = true);

//     // Fake delay
//     await Future.delayed(const Duration(seconds: 2));

//     // Fake OTP accept karega "123456"
//     if (otp == "123456") {
//       _showSnackBar("OTP verified successfully!", isSuccess: true);

//       // Success pe login pe wapas bhej do (real mein new password screen jayega)
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//           (route) => false,
//         );
//       }
//     } else {
//       _showSnackBar("Invalid OTP. Please try again.", isError: true);
//     }

//     setState(() => _isVerifying = false);
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
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: isDark ? Colors.white : Colors.black,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: isDark
//                 ? [Colors.black, Colors.grey[900]!]
//                 : [AppColors.primary.withOpacity(0.08), Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 top: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: 40),

//                   // OTP Icon
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primary, AppColors.primaryLight],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primary.withOpacity(0.3),
//                           blurRadius: 20,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.sms_rounded,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                   ),

//                   SizedBox(height: 50),

//                   Text(
//                     "Verify OTP",
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? Colors.white : Colors.black87,
//                     ),
//                   ),

//                   SizedBox(height: 16),

//                   Text(
//                     "We sent a 6-digit code to",
//                     style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                   ),
//                   Text(
//                     widget.email,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),

//                   SizedBox(height: 60),

//                   // OTP Boxes
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(6, (index) => _buildOtpBox(index)),
//                   ),

//                   SizedBox(height: 60),

//                   // Verify Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _isVerifying ? null : _verifyOtp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 6,
//                       ),
//                       child: _isVerifying
//                           ? SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               "VERIFY OTP",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   // Resend OTP
//                   TextButton(
//                     onPressed: () {
//                       _showSnackBar("New OTP sent to your email");
//                     },
//                     child: Text(
//                       "Didn't receive code? Resend",
//                       style: TextStyle(color: AppColors.primary, fontSize: 15),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOtpBox(int index) {
//     return SizedBox(
//       width: 50,
//       height: 60,
//       child: TextField(
//         controller: _otpControllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         decoration: InputDecoration(
//           counterText: "",
//           filled: true,
//           fillColor: Theme.of(context).brightness == Brightness.dark
//               ? Colors.grey[800]
//               : Colors.grey[50],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColors.primary, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColors.primary, width: 3),
//           ),
//         ),
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) {
//             _focusNodes[index + 1].requestFocus();
//           } else if (value.isEmpty && index > 0) {
//             _focusNodes[index - 1].requestFocus();
//           }

//           // Auto verify when all filled
//           if (index == 5 && value.isNotEmpty) {
//             final otp = _otpControllers.map((c) => c.text).join();
//             if (otp.length == 6) {
//               _verifyOtp();
//             }
//           }
//         },
//       ),
//     );
//   }
// }
