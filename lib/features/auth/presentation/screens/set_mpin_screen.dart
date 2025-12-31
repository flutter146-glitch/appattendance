// lib/features/auth/presentation/screens/set_mpin_screen.dart
// Final production-ready Set MPIN Screen
// Opens after set_password_screen.dart (password set hone ke baad)
// Saves 6-digit MPIN in 'user' table (local SQLite dummy mode)
// Future API-ready (commented)
// Full validation, auto-focus, dark mode, loading & error handling
// Navigation to Dashboard on success
// Current date context: December 29, 2025

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetMPINScreen extends ConsumerStatefulWidget {
  final String email;

  const SetMPINScreen({super.key, required this.email});

  @override
  ConsumerState<SetMPINScreen> createState() => _SetMPINScreenState();
}

class _SetMPINScreenState extends ConsumerState<SetMPINScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isSaving = false;
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  String get _mpin => _controllers.map((c) => c.text).join();

  Future<void> _saveMPIN() async {
    if (_mpin.length != 6) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final db = await DBHelper.instance.database;

      // Find user by email
      final userRows = await db.query(
        'user',
        where: 'email_id = ?',
        whereArgs: [widget.email.trim().toLowerCase()],
      );

      if (userRows.isEmpty) {
        throw Exception('User not found');
      }

      final userRow = userRows.first;
      final empId = userRow['emp_id'] as String;

      // Update MPIN
      await db.update(
        'user',
        {'mpin': _mpin},
        where: 'emp_id = ?',
        whereArgs: [empId],
      );

      // Success → Navigate to Dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
                        Icons.pin_rounded,
                        size: 100,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'Set Your MPIN',
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
                      'Create a 6-digit MPIN for quick login',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // MPIN Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            obscureText: true,
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

                              // Auto-save on last digit
                              if (index == 5 && value.isNotEmpty) {
                                _saveMPIN();
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving || _mpin.length != 6
                            ? null
                            : _saveMPIN,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'SAVE MPIN',
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

// // lib/features/auth/presentation/screens/set_mpin_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SetMPINScreen extends StatefulWidget {
//   final String email;

//   const SetMPINScreen({super.key, required this.email});

//   @override
//   State<SetMPINScreen> createState() => _SetMPINScreenState();
// }

// class _SetMPINScreenState extends State<SetMPINScreen>
//     with SingleTickerProviderStateMixin {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

//   bool _isSaving = false;
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

//   Future<void> _saveMPIN() async {
//     final mpin = _controllers.map((c) => c.text).join();

//     if (mpin.length != 6) {
//       _showSnackBar("Please enter complete 6-digit MPIN");
//       return;
//     }

//     setState(() => _isSaving = true);

//     // Fake save - real mein DB ya API mein save karenge
//     await Future.delayed(const Duration(seconds: 2));

//     _showSnackBar("MPIN set successfully!", isSuccess: true);

//     if (mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   void _skipSetup() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   void _showSnackBar(String message, {bool isSuccess = false}) {
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
//                         // Logo/Icon
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
//                               Icons.pin_rounded,
//                               size: 60,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         Text(
//                           'Set Your MPIN',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         const SizedBox(height: 16),

//                         Text(
//                           'Create a 6-digit MPIN for quick and secure login',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark ? Colors.white70 : Colors.grey[700],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 60),

//                         // MPIN Boxes
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: List.generate(
//                             6,
//                             (index) => _buildMpinBox(index, isDark),
//                           ),
//                         ),
//                         const SizedBox(height: 60),

//                         // Save Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: _isSaving ? null : _saveMPIN,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               elevation: 6,
//                             ),
//                             child: _isSaving
//                                 ? SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : Text(
//                                     'SAVE MPIN',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // Info Box
//                         Container(
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: AppColors.primary.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.info_outline,
//                                 color: AppColors.primary,
//                               ),
//                               SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   "You can use this MPIN for quick login instead of password",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: isDark
//                                         ? Colors.white70
//                                         : Colors.grey[700],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 40),
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

//   Widget _buildMpinBox(int index, bool isDark) {
//     return SizedBox(
//       width: 50,
//       height: 60,
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         obscureText: true,
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

//           // Auto save on last digit
//           if (index == 5 && value.isNotEmpty) {
//             final mpin = _controllers.map((c) => c.text).join();
//             if (mpin.length == 6) {
//               _saveMPIN();
//             }
//           }
//         },
//       ),
//     );
//   }
// }
