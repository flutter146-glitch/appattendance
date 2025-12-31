// lib/features/auth/presentation/screens/login_screen.dart
// Final production-ready Login Screen (updated for your current setup)
// Uses SQLite (dummy_data.json + db_helper.dart) for login
// Supports UserModel (freezed) + privileges from extension
// Role-based navigation (employee → dashboard, manager → dashboard with team view)
// Loading, error handling, dark mode, animations, secure input
// Current date context: December 29, 2025

// lib/features/auth/presentation/screens/login_screen.dart
// Latest production-ready version (Riverpod + UserModel + privileges)

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  late AnimationController _animController;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await ref.read(authProvider.notifier).login(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Auto navigation on success
    ref.listen<AsyncValue<UserModel?>>(authProvider, (previous, next) {
      if (!mounted) return;
      next.whenData((user) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      });
    });

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
                Icon(
                  Icons.business_center_rounded,
                  size: 100,
                  color: AppColors.primary,
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
                        onFieldSubmitted: (_) => _login(),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _login,
                          child: authState.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(fontSize: 18),
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
// // Final production-ready Login Screen (updated for your current setup)
// // Uses SQLite (dummy_data.json + db_helper.dart) for login
// // Supports UserModel (freezed) + privileges from extension
// // Role-based navigation (employee → dashboard, manager → dashboard with team view)
// // Loading, error handling, dark mode, animations, secure input
// // Current date context: December 29, 2025

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();

//     // Smooth animation setup
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
//     );

//     _animController.forward();

//     // Optional: Auto-fill for testing (remove in production)
//     // _emailController.text = "emp1@nutantek.com";
//     // _passwordController.text = "emp123";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final email = _emailController.text.trim();
//       final password = _passwordController.text.trim();

//       // Call AuthNotifier login
//       await ref.read(authProvider.notifier).login(email, password);

//       // On success, navigation is handled by authProvider listener in main.dart or splash
//       // Or you can listen here too (optional)
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Login failed: $e'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Listen to auth state for navigation on success
//     ref.listen<AsyncValue<UserModel?>>(
//       authProvider,
//       (previous, next) {
//         if (!mounted) return;

//         next.whenData((user) {
//           if (user != null) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         });
//       },
//     );

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
//           child: AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _opacity,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                       left: 32,
//                       right: 32,
//                       top: 40,
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 40,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Logo / Icon
//                         Center(
//                           child: Icon(
//                             Icons.business_center_rounded,
//                             size: 100,
//                             color: isDark ? Colors.white : AppColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         // Welcome Text
//                         Text(
//                           'Welcome Back',
//                           style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white : Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Sign in to continue',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark ? Colors.white70 : Colors.grey[700],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 48),

//                         // Login Card
//                         Card(
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                           color: isDark ? Colors.grey[900] : Colors.white,
//                           child: Padding(
//                             padding: const EdgeInsets.all(32.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   // Email Field
//                                   TextFormField(
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     textInputAction: TextInputAction.next,
//                                     decoration: InputDecoration(
//                                       labelText: 'Company Email',
//                                       hintText: 'e.g. name@nutantek.com',
//                                       prefixIcon: const Icon(Icons.email_outlined),
//                                       filled: true,
//                                       fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.trim().isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       if (!value.contains('@')) {
//                                         return 'Enter a valid email';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const SizedBox(height: 24),

//                                   // Password Field
//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     textInputAction: TextInputAction.done,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(Icons.lock_outline),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                         ),
//                                         onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your password';
//                                       }
//                                       if (value.length < 6) {
//                                         return 'Password must be at least 6 characters';
//                                       }
//                                       return null;
//                                     },
//                                     onFieldSubmitted: (_) => _login(),
//                                   ),
//                                   const SizedBox(height: 32),

//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: _isLoading || authState.isLoading ? null : _login,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                         elevation: 6,
//                                       ),
//                                       child: _isLoading || authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   // Forgot Password
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => const ForgotPasswordScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(color: AppColors.primary, fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 40),

//                         // Footer
//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: isDark ? Colors.white60 : Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
                      
//               ],
            
//             ),
//           ),
//         ),
//               ),

//       ),
//         ),
//       ),
//     );
  
//   }
// }

// // lib/features/auth/presentation/screens/login_screen.dart

// import 'package:appattendance/core/database/db_helper.dart'; // DB ke liye
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();

//     // Animation setup — smooth entry ke liye
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
//       ),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
//           ),
//         );

//     _animController.forward();

//     // Testing ke liye empty rakha — real mein user daalega
//     // _emailController.text = "samal@nutantek.com";
//     // _passwordController.text = "pass123";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   // Ab real login — user table se verify + employee_master se full data leke save
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     // Loading show karo
//     ref.read(authProvider.notifier).setLoading(true);

//     try {
//       final db = await DBHelper.instance.database;

//       // Step 1: user table se email + password check karo
//       final userResult = await db.query(
//         'user',
//         where: 'email_id = ? AND password = ?',
//         whereArgs: [email, password],
//       );

//       if (userResult.isEmpty) {
//         ref.read(authProvider.notifier).setError("Invalid email or password");
//         return;
//       }

//       // Step 2: employee_master se full profile le aao
//       final empResult = await db.query(
//         'employee_master',
//         where: 'emp_email = ?',
//         whereArgs: [email],
//       );

//       if (empResult.isEmpty) {
//         ref.read(authProvider.notifier).setError("Profile not found");
//         return;
//       }

//       final fullUserData = empResult.first;

//       // Step 3: Session save kar do
//       await DBHelper.instance.saveCurrentUser(fullUserData);

//       // Step 4: Auth provider mein full data bhej do
//       ref.read(authProvider.notifier).setUser(fullUserData);
//     } catch (e) {
//       debugPrint("Login error: $e");
//       ref.read(authProvider.notifier).setError("Login failed. Try again.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Success ya error pe handle
//     ref.listen<AsyncValue>(authProvider, (previous, next) {
//       if (!mounted) return;

//       next.whenOrNull(
//         data: (userMap) {
//           if (userMap != null) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         },
//         error: (err, stack) {
//           if (err.toString().isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(err.toString()),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//       );
//     });

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
//                             child: Image.asset(
//                               'assets/images/nutantek_logo.png',
//                               width: 70,
//                               height: 70,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.business_center,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         Text(
//                           'Welcome Back',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         Text(
//                           'Sign in to continue',
//                           style: TextStyle(
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         // Login Card
//                         Card(
//                           elevation: 12,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   // Company Email
//                                   TextFormField(
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: InputDecoration(
//                                       labelText: 'Company Email',
//                                       hintText: 'e.g. name@nutantek.com',
//                                       prefixIcon: const Icon(
//                                         Icons.email_outlined,
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.trim().isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       if (!value.contains('@')) {
//                                         return 'Enter a valid email';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const SizedBox(height: 20),

//                                   // Password
//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                       ),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                         ),
//                                         onPressed: () => setState(
//                                           () => _obscurePassword =
//                                               !_obscurePassword,
//                                         ),
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your password';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const SizedBox(height: 32),

//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : _login,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             14,
//                                           ),
//                                         ),
//                                         elevation: 6,
//                                       ),
//                                       child: authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   // Forgot Password
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               const ForgotPasswordScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 60),

//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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

// // lib/features/auth/presentation/screens/login_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/forgot_password_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();

//     // Animation setup
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
//       ),
//     );

//     _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
//           ),
//         );

//     _animController.forward();

//     // Pre-fill for testing (remove in production)
//     _emailController.text = "";
//     _passwordController.text = "";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   // Temporary fake login - will replace with real API later
//   Future<void> _loginWithFakeData() async {
//     if (!_formKey.currentState!.validate()) return;

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     // Show loading
//     ref.read(authProvider.notifier).setLoading(true);

//     // Simulate
//     await Future.delayed(const Duration(seconds: 1));

//     // Dummy users based on our DB schema
//     final dummyUsers = {
//       "samal@nutantek.com": {
//         "emp_id": "EMP001",
//         "emp_name": "Vainyala Samal",
//         "emp_email": "samal@nutantek.com",
//         "emp_role": "Employee",
//         "emp_department": "Mobile Development",
//         "emp_phone": "9876543210",
//         "check_in_out_status": "checked_out",
//       },
//       "raj@nutantek.com": {
//         "emp_id": "EMP002",
//         "emp_name": "Raj Sharma",
//         "emp_email": "raj@nutantek.com",
//         "emp_role": "Manager",
//         "emp_department": "Management",
//         "emp_phone": "9123456780",
//         "check_in_out_status": "checked_in",
//       },
//     };

//     if (dummyUsers.containsKey(email) && password == "pass123") {
//       ref.read(authProvider.notifier).setUser(dummyUsers[email]!);
//     } else {
//       ref.read(authProvider.notifier).setError("Invalid email or password");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Listen for auth changes
//     ref.listen<AsyncValue>(authProvider, (previous, next) {
//       if (!mounted) return;

//       next.whenOrNull(
//         data: (userMap) {
//           if (userMap != null) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         },
//         error: (err, stack) {
//           if (err.toString().isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(err.toString()),
//                 backgroundColor: AppColors.error,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//       );
//     });

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
//                             child: Image.asset(
//                               'assets/images/nutantek_logo.png',
//                               width: 70,
//                               height: 70,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.business_center,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         Text(
//                           'Welcome Back',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         Text(
//                           'Sign in to continue',
//                           style: TextStyle(
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         // Login Card
//                         Card(
//                           elevation: 12,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   // Company Email Field
//                                   TextFormField(
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: InputDecoration(
//                                       labelText: 'Company Email',
//                                       hintText: 'e.g. name@nutantek.com',
//                                       prefixIcon: const Icon(
//                                         Icons.email_outlined,
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.trim().isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       if (!value.contains('@') ||
//                                           !value.endsWith('.com')) {
//                                         return 'Enter a valid company email';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const SizedBox(height: 20),

//                                   // Password Field
//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                       ),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             _obscurePassword =
//                                                 !_obscurePassword;
//                                           });
//                                         },
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your password';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const SizedBox(height: 32),

//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : _loginWithFakeData,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             14,
//                                           ),
//                                         ),
//                                         elevation: 6,
//                                       ),
//                                       child: authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   // Forgot Password Link
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               const ForgotPasswordScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 60),

//                         // Copyright
//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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

// // lib/features/auth/presentation/screens/login_screen.dart
// import 'dart:convert';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/screens/forget_password_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _empIdController = TextEditingController();
//   final _passwordController = TextEditingController();

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;

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

//     // Testing ke liye default values
//     _empIdController.text = "EMP001";
//     _passwordController.text = "pass123";
//   }

//   @override
//   void dispose() {
//     _empIdController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   // FAKE API SIMULATION (Kal real API daal denge)
//   Future<void> _loginWithFakeAPI() async {
//     if (!_formKey.currentState!.validate()) return;

//     final empId = _empIdController.text.trim();
//     final password = _passwordController.text.trim();

//     ref.read(authProvider.notifier).setLoading(true);

//     // 1 second delay — real API jaisa feel
//     await Future.delayed(const Duration(seconds: 1));

//     // Default users (tere database tables ke hisaab se)
//     final Map<String, Map<String, dynamic>> fakeUsers = {
//       "EMP001": {
//         "emp_id": "EMP001",
//         "emp_name": "Vainyala Samal",
//         "emp_email": "samal@nutantek.com",
//         "emp_role": "Employee",
//         "emp_department": "Mobile Development",
//         "emp_phone": "9876543210",
//         "check_in_out_status": "checked_out",
//       },
//       "EMP002": {
//         "emp_id": "EMP002",
//         "emp_name": "Raj Sharma",
//         "emp_email": "raj@nutantek.com",
//         "emp_role": "Manager",
//         "emp_department": "Management",
//         "emp_phone": "9123456780",
//         "check_in_out_status": "checked_in",
//       },
//     };

//     // Fake login check
//     if (fakeUsers.containsKey(empId) && password == "pass123") {
//       final userData = fakeUsers[empId]!;
//       ref.read(authProvider.notifier).setUser(userData);
//     } else {
//       ref
//           .read(authProvider.notifier)
//           .setError("Invalid Employee ID or Password");
//     }
//   }

//   // JAB REAL API MILEGA — YE FUNCTION USE KARNA
//   // Future<void> _loginWithRealAPI() async {
//   //   final empId = _empIdController.text.trim();
//   //   final password = _passwordController.text.trim();
//   //
//   //   ref.read(authProvider.notifier).setLoading(true);
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse("http://192.168.1.100:3000/api/v1/auth/login"),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: jsonEncode({"emp_id": empId, "password": password}),
//   //     );
//   //
//   //     final data = jsonDecode(response.body);
//   //
//   //     if (response.statusCode == 200 && data['success'] == true) {
//   //       ref.read(authProvider.notifier).setUser(data['user']);
//   //     } else {
//   //       ref.read(authProvider.notifier).setError(data['message'] ?? "Login failed");
//   //     }
//   //   } catch (e) {
//   //     ref.read(authProvider.notifier).setError("Server down or no internet");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     ref.listen<AsyncValue>(authProvider, (previous, next) {
//       next.whenOrNull(
//         data: (userMap) {
//           if (userMap != null && mounted) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         },
//         error: (err, stack) {
//           if (mounted && err.toString().isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(err.toString()),
//                 backgroundColor: AppColors.error,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//       );
//     });

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
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       children: [
//                         const Spacer(flex: 2),

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
//                             child: Image.asset(
//                               'assets/images/nutantek_logo.png',
//                               width: 70,
//                               height: 70,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.business,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         Text(
//                           'Welcome Back',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         Text(
//                           'Sign in to continue',
//                           style: TextStyle(
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         Card(
//                           elevation: 12,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   // Employee ID instead of Email
//                                   TextFormField(
//                                     controller: _empIdController,
//                                     keyboardType: TextInputType.text,
//                                     textCapitalization:
//                                         TextCapitalization.characters,
//                                     decoration: InputDecoration(
//                                       labelText: 'Employee ID',
//                                       prefixIcon: const Icon(Icons.badge),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Employee ID required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 20),

//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                       ),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                         ),
//                                         onPressed: () => setState(
//                                           () => _obscurePassword =
//                                               !_obscurePassword,
//                                         ),
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Password required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 32),

//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : _loginWithFakeAPI, // ← Abhi fake use kar rahe hain
//                                       // onPressed: authState.isLoading ? null : _loginWithRealAPI, // ← Kal real API ke liye
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             14,
//                                           ),
//                                         ),
//                                         elevation: 6,
//                                       ),
//                                       child: authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               const ForgotPasswordScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const Spacer(flex: 3),

//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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

// // lib/features/auth/presentation/screens/login_screen.dart
// import 'dart:convert';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

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

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;

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

//     // Pre-fill for testing (remove in production)
//     _emailController.text = "rahul@company.com";
//     _passwordController.text = "123456";
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   // REAL API CALL TO MONGODB BACKEND
//   Future<void> _loginWithAPI() async {
//     if (!_formKey.currentState!.validate()) return;

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     ref.read(authProvider.notifier).setLoading(true);

//     try {
//       final response = await http
//           .post(
//             Uri.parse(
//               "http://192.168.1.100:5000/api/login",
//             ), // Apna IP daal dena (ya localhost:3000)
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({"email": email, "password": password}),
//           )
//           .timeout(const Duration(seconds: 10));

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         final userData = data['user'];
//         // Save user in Riverpod state
//         ref.read(authProvider.notifier).setUser(userData);
//       } else {
//         ref
//             .read(authProvider.notifier)
//             .setError(data['message'] ?? "Login failed");
//       }
//     } catch (e) {
//       ref.read(authProvider.notifier).setError("No internet or server down");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Listen for login success
//     ref.listen<AsyncValue>(authProvider, (previous, next) {
//       next.whenOrNull(
//         data: (userMap) {
//           if (userMap != null && mounted) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         },
//         error: (err, stack) {
//           if (mounted && err.toString().isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(err.toString()),
//                 backgroundColor: AppColors.error,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//       );
//     });

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
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       children: [
//                         const Spacer(flex: 2),

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
//                             child: Image.asset(
//                               'assets/images/nutantek_logo.png',
//                               width: 70,
//                               height: 70,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.business,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         Text(
//                           'Welcome Back',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                         ),
//                         Text(
//                           'Sign in to continue',
//                           style: TextStyle(
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         // Form Card
//                         Card(
//                           elevation: 12,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: InputDecoration(
//                                       labelText: 'Email',
//                                       prefixIcon: const Icon(
//                                         Icons.email_outlined,
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Email required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 20),

//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                       ),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                         ),
//                                         onPressed: () => setState(
//                                           () => _obscurePassword =
//                                               !_obscurePassword,
//                                         ),
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Password required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 32),

//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : _loginWithAPI,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             14,
//                                           ),
//                                         ),
//                                         elevation: 6,
//                                       ),
//                                       child: authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   TextButton(
//                                     onPressed: () {},
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const Spacer(flex: 3),

//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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

// // lib/features/auth/presentation/screens/login_screen.dart
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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

//   late AnimationController _animController;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;

//   bool _obscurePassword = true;

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
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       ref
//           .read(authProvider.notifier)
//           .login(_emailController.text.trim(), _passwordController.text.trim());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     ref.listen<AsyncValue>(authProvider, (previous, next) {
//       next.whenOrNull(
//         data: (user) {
//           if (user != null && mounted) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             );
//           }
//         },
//         error: (err, stack) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(err.toString()),
//                 backgroundColor: AppColors.error,
//               ),
//             );
//           }
//         },
//       );
//     });

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
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       children: [
//                         const Spacer(flex: 2),

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
//                                 offset: const Offset(0, 15),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Image.asset(
//                               'assets/images/nutantek_logo.png',
//                               width: 70,
//                               height: 70,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.business,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         Text(
//                           'Welcome Back',
//                           style: Theme.of(context).textTheme.headlineMedium
//                               ?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Sign in to continue',
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                         const SizedBox(height: 48),

//                         // Form Card
//                         Card(
//                           elevation: 12,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   // Email Field
//                                   TextFormField(
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: InputDecoration(
//                                       labelText: 'Email',
//                                       prefixIcon: const Icon(
//                                         Icons.email_outlined,
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Email required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 20),

//                                   // Password Field
//                                   TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: _obscurePassword,
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                       ),
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                         ),
//                                         onPressed: () => setState(
//                                           () => _obscurePassword =
//                                               !_obscurePassword,
//                                         ),
//                                       ),
//                                       filled: true,
//                                       fillColor: isDark
//                                           ? Colors.grey[800]
//                                           : Colors.grey[50],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     validator: (v) => v?.isEmpty == true
//                                         ? 'Password required'
//                                         : null,
//                                   ),
//                                   const SizedBox(height: 32),

//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : _login,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             14,
//                                           ),
//                                         ),
//                                         elevation: 6,
//                                       ),
//                                       child: authState.isLoading
//                                           ? const SizedBox(
//                                               height: 24,
//                                               width: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2.5,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),

//                                   TextButton(
//                                     onPressed: () {
//                                       // Forgot password screen
//                                     },
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const Spacer(flex: 3),

//                         // Footer
//                         Text(
//                           '© 2025 Nutantek • Enterprise Edition',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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
//DEBUG