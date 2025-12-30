// lib/features/splash/presentation/screens/splash_screen.dart

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart';
import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateAfterSplash();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  Future<void> _navigateAfterSplash() async {
    // Splash dikhao 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

    Widget nextScreen;

    if (!isDeviceVerified) {
      // First time ya new device → Device verification dikhao
      nextScreen = const DeviceVerificationScreen();
    } else {
      // Device already verified → Check login status
      final currentUser = await DBHelper.instance.getCurrentUser();
      nextScreen = currentUser != null
          ? const DashboardScreen()
          : const LoginScreen();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tere original beautiful splash UI yahan rahegi
    // Logo, Nutantek text, tagline, copyright — sab same
    // Main ne sirf logic update kiya hai

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.black, Colors.grey[900]!]
                : [Color(0xFF4A90E2).withOpacity(0.08), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF2171C9)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withOpacity(0.4),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/nutantek_logo.png',
                      width: 70,
                      height: 70,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.business_center,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Nutantek',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A90E2).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ATTENDANCE PRO',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // lib/features/splash/presentation/screens/splash_screen.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/device_verification_screen.dart'; // Naya screen
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeApp();
//   }

//   void _initializeAnimations() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();
//   }

//   Future<void> _initializeApp() async {
//     await Future.delayed(const Duration(milliseconds: 2500)); // Splash duration

//     if (!mounted) return;

//     final prefs = await SharedPreferences.getInstance();
//     final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
//     final bool isDeviceVerified = prefs.getBool('is_device_verified') ?? false;

//     Widget nextScreen;

//     if (isFirstLaunch || !isDeviceVerified) {
//       // First time on this device → Device verification
//       await prefs.setBool('is_first_launch', false);
//       nextScreen = const DeviceVerificationScreen();
//     } else {
//       // Already verified → Check if user is logged in
//       final currentUser = await DBHelper.instance.getCurrentUser();
//       nextScreen = currentUser != null
//           ? const DashboardScreen()
//           : const LoginScreen();
//     }

//     Navigator.pushReplacement(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(1.0, 0.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;

//           var tween = Tween(
//             begin: begin,
//             end: end,
//           ).chain(CurveTween(curve: curve));
//           var offsetAnimation = animation.drive(tween);

//           return SlideTransition(
//             position: offsetAnimation,
//             child: FadeTransition(opacity: animation, child: child),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 800),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final isLandscape = mediaQuery.orientation == Orientation.landscape;
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;

//     final backgroundColor = isDarkMode
//         ? Colors.black
//         : AppColors.backgroundLight;
//     final textColor = isDarkMode ? Colors.white : AppColors.textPrimary;
//     final secondaryTextColor = isDarkMode
//         ? Colors.white.withOpacity(0.8)
//         : AppColors.textSecondary;
//     final subtleTextColor = isDarkMode
//         ? Colors.white.withOpacity(0.5)
//         : AppColors.textDisabled;
//     final chipColor = isDarkMode
//         ? Colors.white.withOpacity(0.1)
//         : AppColors.grey100;
//     final chipBorderColor = isDarkMode
//         ? Colors.white.withOpacity(0.2)
//         : AppColors.grey300;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: isDarkMode
//                 ? RadialGradient(
//                     center: Alignment.topLeft,
//                     radius: 2.0,
//                     colors: [
//                       AppColors.primary.withOpacity(0.15),
//                       AppColors.secondary.withOpacity(0.1),
//                       Colors.black,
//                     ],
//                     stops: const [0.0, 0.5, 1.0],
//                   )
//                 : LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       AppColors.primary.withOpacity(0.05),
//                       AppColors.secondary.withOpacity(0.03),
//                       AppColors.backgroundLight,
//                     ],
//                   ),
//           ),
//           child: Stack(
//             children: [
//               _buildMainContent(
//                 screenHeight,
//                 screenWidth,
//                 isLandscape,
//                 textColor,
//                 secondaryTextColor,
//                 chipColor,
//                 chipBorderColor,
//               ),
//               _buildCopyright(screenHeight, isLandscape, subtleTextColor),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Baaki sab widgets same rahenge (logo, app name, tagline, copyright)
//   // Tere original code se copy kar le

//   Widget _buildMainContent(
//     double screenHeight,
//     double screenWidth,
//     bool isLandscape,
//     Color textColor,
//     Color secondaryTextColor,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     return SingleChildScrollView(
//       child: Container(
//         width: screenWidth,
//         height: isLandscape ? null : screenHeight,
//         padding: EdgeInsets.symmetric(
//           horizontal: isLandscape ? screenWidth * 0.1 : 24.0,
//           vertical: isLandscape ? 40.0 : 0.0,
//         ),
//         child: Column(
//           mainAxisAlignment: isLandscape
//               ? MainAxisAlignment.start
//               : MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (isLandscape) SizedBox(height: screenHeight * 0.05),

//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: _buildLogo(isLandscape, screenWidth),
//             ),

//             SizedBox(height: isLandscape ? 20 : 40),

//             SlideTransition(
//               position: _slideAnimation,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: _buildAppName(isLandscape, screenWidth, textColor),
//               ),
//             ),

//             SizedBox(height: isLandscape ? 10 : 20),

//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: _buildTagline(
//                 isLandscape,
//                 screenWidth,
//                 secondaryTextColor,
//                 chipColor,
//                 chipBorderColor,
//               ),
//             ),

//             SizedBox(height: isLandscape ? 30 : 60),
//             if (isLandscape) SizedBox(height: screenHeight * 0.05),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo(bool isLandscape, double screenWidth) {
//     final logoSize = isLandscape ? screenWidth * 0.12 : 100.0;

//     return Container(
//       width: logoSize,
//       height: logoSize,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.primary, AppColors.primaryLight],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Center(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Image.asset(
//             'assets/images/nutantek_logo.png',
//             width: logoSize * 0.6,
//             height: logoSize * 0.6,
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 width: logoSize * 0.6,
//                 height: logoSize * 0.6,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.business_center_rounded,
//                   size: logoSize * 0.4,
//                   color: AppColors.primary,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppName(bool isLandscape, double screenWidth, Color textColor) {
//     final appNameFontSize = isLandscape ? screenWidth * 0.05 : 36.0;
//     final proFontSize = isLandscape ? screenWidth * 0.018 : 14.0;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Nutantek',
//           style: TextStyle(
//             fontSize: appNameFontSize,
//             fontWeight: FontWeight.w800,
//             color: textColor,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: isLandscape ? 4 : 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//           ),
//           child: Text(
//             'ATTENDANCE PRO',
//             style: TextStyle(
//               fontSize: proFontSize,
//               fontWeight: FontWeight.w600,
//               color: textColor.withOpacity(0.9),
//               letterSpacing: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTagline(
//     bool isLandscape,
//     double screenWidth,
//     Color textColor,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     final mainTaglineFontSize = isLandscape ? screenWidth * 0.016 : 14.0;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Enterprise Workforce Management',
//           style: TextStyle(
//             fontSize: mainTaglineFontSize,
//             fontWeight: FontWeight.w500,
//             color: textColor,
//             letterSpacing: 0.8,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: isLandscape ? 6 : 10),
//         Wrap(
//           spacing: 8,
//           runSpacing: 4,
//           alignment: WrapAlignment.center,
//           children: [
//             _buildFeatureChip(
//               'Real-time Tracking',
//               Icons.track_changes_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//             _buildFeatureChip(
//               'Smart Analytics',
//               Icons.analytics_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//             _buildFeatureChip(
//               'Secure',
//               Icons.security_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureChip(
//     String text,
//     IconData icon,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: chipColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: chipBorderColor),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 10, color: AppColors.accent),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 9,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCopyright(
//     double screenHeight,
//     bool isLandscape,
//     Color textColor,
//   ) {
//     return Positioned(
//       bottom: isLandscape ? 15 : 20,
//       left: 0,
//       right: 0,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '© 2025 Nutantek. All rights reserved.',
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: isLandscape ? 8 : 10,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: isLandscape ? 1 : 2),
//             Text(
//               'ENTERPRISE EDITION v1.0.0',
//               style: TextStyle(
//                 color: textColor.withOpacity(0.8),
//                 fontSize: isLandscape ? 7 : 9,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/splash/presentation/screens/splash_screen.dart
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/core/utils/app_styles.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeApp();
//     _debugDatabase(); // Dummy data check karne ke liye
//   }

//   void _debugDatabase() async {
//     // Optional: Pehli baar app khule toh dummy data insert ho jaye
//     final db = await DBHelper.instance.database;
//     print("Database initialized with all tables!");
//   }

//   void _initializeAnimations() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();
//   }

//   void _initializeApp() async {
//     await Future.delayed(const Duration(milliseconds: 2500)); // Splash time

//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               const LoginScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             const begin = Offset(1.0, 0.0);
//             const end = Offset.zero;
//             const curve = Curves.easeInOut;

//             var tween = Tween(
//               begin: begin,
//               end: end,
//             ).chain(CurveTween(curve: curve));
//             var offsetAnimation = animation.drive(tween);

//             return SlideTransition(
//               position: offsetAnimation,
//               child: FadeTransition(opacity: animation, child: child),
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 800),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final isLandscape = mediaQuery.orientation == Orientation.landscape;
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;

//     final backgroundColor = isDarkMode
//         ? Colors.black
//         : AppColors.backgroundLight;
//     final textColor = isDarkMode ? Colors.white : AppColors.textPrimary;
//     final secondaryTextColor = isDarkMode
//         ? Colors.white.withOpacity(0.8)
//         : AppColors.textSecondary;
//     final subtleTextColor = isDarkMode
//         ? Colors.white.withOpacity(0.5)
//         : AppColors.textDisabled;
//     final chipColor = isDarkMode
//         ? Colors.white.withOpacity(0.1)
//         : AppColors.grey100;
//     final chipBorderColor = isDarkMode
//         ? Colors.white.withOpacity(0.2)
//         : AppColors.grey300;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: isDarkMode
//                 ? RadialGradient(
//                     center: Alignment.topLeft,
//                     radius: 2.0,
//                     colors: [
//                       AppColors.primary.withOpacity(0.15),
//                       AppColors.secondary.withOpacity(0.1),
//                       Colors.black,
//                     ],
//                     stops: const [0.0, 0.5, 1.0],
//                   )
//                 : LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       AppColors.primary.withOpacity(0.05),
//                       AppColors.secondary.withOpacity(0.03),
//                       AppColors.backgroundLight,
//                     ],
//                   ),
//           ),
//           child: Stack(
//             children: [
//               _buildMainContent(
//                 screenHeight,
//                 screenWidth,
//                 isLandscape,
//                 textColor,
//                 secondaryTextColor,
//                 chipColor,
//                 chipBorderColor,
//               ),
//               _buildCopyright(screenHeight, isLandscape, subtleTextColor),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent(
//     double screenHeight,
//     double screenWidth,
//     bool isLandscape,
//     Color textColor,
//     Color secondaryTextColor,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     return SingleChildScrollView(
//       child: Container(
//         width: screenWidth,
//         height: isLandscape ? null : screenHeight,
//         padding: EdgeInsets.symmetric(
//           horizontal: isLandscape ? screenWidth * 0.1 : 24.0,
//           vertical: isLandscape ? 40.0 : 0.0,
//         ),
//         child: Column(
//           mainAxisAlignment: isLandscape
//               ? MainAxisAlignment.start
//               : MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (isLandscape) SizedBox(height: screenHeight * 0.05),

//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: _buildLogo(isLandscape, screenWidth),
//             ),

//             SizedBox(height: isLandscape ? 20 : 40),

//             SlideTransition(
//               position: _slideAnimation,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: _buildAppName(isLandscape, screenWidth, textColor),
//               ),
//             ),

//             SizedBox(height: isLandscape ? 10 : 20),

//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: _buildTagline(
//                 isLandscape,
//                 screenWidth,
//                 secondaryTextColor,
//                 chipColor,
//                 chipBorderColor,
//               ),
//             ),

//             SizedBox(height: isLandscape ? 30 : 60),
//             if (isLandscape) SizedBox(height: screenHeight * 0.05),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo(bool isLandscape, double screenWidth) {
//     final logoSize = isLandscape ? screenWidth * 0.12 : 100.0;

//     return Container(
//       width: logoSize,
//       height: logoSize,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.primary, AppColors.primaryLight],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Center(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Image.asset(
//             'assets/images/nutantek_logo.png',
//             width: logoSize * 0.6,
//             height: logoSize * 0.6,
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 width: logoSize * 0.6,
//                 height: logoSize * 0.6,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.business_center_rounded,
//                   size: logoSize * 0.4,
//                   color: AppColors.primary,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppName(bool isLandscape, double screenWidth, Color textColor) {
//     final appNameFontSize = isLandscape ? screenWidth * 0.05 : 36.0;
//     final proFontSize = isLandscape ? screenWidth * 0.018 : 14.0;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Nutantek',
//           style: TextStyle(
//             fontSize: appNameFontSize,
//             fontWeight: FontWeight.w800,
//             color: textColor,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: isLandscape ? 4 : 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//           ),
//           child: Text(
//             'ATTENDANCE PRO',
//             style: TextStyle(
//               fontSize: proFontSize,
//               fontWeight: FontWeight.w600,
//               color: textColor.withOpacity(0.9),
//               letterSpacing: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTagline(
//     bool isLandscape,
//     double screenWidth,
//     Color textColor,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     final mainTaglineFontSize = isLandscape ? screenWidth * 0.016 : 14.0;
//     final subTaglineFontSize = isLandscape ? screenWidth * 0.012 : 11.0;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Enterprise Workforce Management',
//           style: TextStyle(
//             fontSize: mainTaglineFontSize,
//             fontWeight: FontWeight.w500,
//             color: textColor,
//             letterSpacing: 0.8,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: isLandscape ? 6 : 10),
//         Wrap(
//           spacing: 8,
//           runSpacing: 4,
//           alignment: WrapAlignment.center,
//           children: [
//             _buildFeatureChip(
//               'Real-time Tracking',
//               Icons.track_changes_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//             _buildFeatureChip(
//               'Smart Analytics',
//               Icons.analytics_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//             _buildFeatureChip(
//               'Secure',
//               Icons.security_rounded,
//               chipColor,
//               chipBorderColor,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureChip(
//     String text,
//     IconData icon,
//     Color chipColor,
//     Color chipBorderColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: chipColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: chipBorderColor),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 10, color: AppColors.accent),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 9,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCopyright(
//     double screenHeight,
//     bool isLandscape,
//     Color textColor,
//   ) {
//     return Positioned(
//       bottom: isLandscape ? 15 : 20,
//       left: 0,
//       right: 0,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '© 2025 Nutantek. All rights reserved.',
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: isLandscape ? 8 : 10,
//                 letterSpacing: 0.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: isLandscape ? 1 : 2),
//             Text(
//               'ENTERPRISE EDITION v1.0.0',
//               style: TextStyle(
//                 color: textColor.withOpacity(0.8),
//                 fontSize: isLandscape ? 7 : 9,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/screens/splash_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/screens/login_screen.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAppInitialization();
//   }

//   void _initializeAnimations() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2200),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();
//   }

//   void _startAppInitialization() async {
//     // Simulate app loading (DB init, permissions, etc.)
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     // Navigate to Login with beautiful transition
//     Navigator.pushReplacement(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             const LoginScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 800),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Riverpod se theme access karo (agar AppTheme provider bana hai)
//     // Ya phir direct Theme.of(context) use karo (recommended)
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//     final mediaQuery = MediaQuery.of(context);
//     final isLandscape = mediaQuery.orientation == Orientation.landscape;

//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : AppColors.backgroundLight,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: isDark
//               ? RadialGradient(
//                   center: Alignment.topLeft,
//                   radius: 2.0,
//                   colors: [
//                     AppColors.primary.withOpacity(0.15),
//                     AppColors.secondary.withOpacity(0.1),
//                     Colors.black,
//                   ],
//                 )
//               : LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     AppColors.primary.withOpacity(0.05),
//                     AppColors.secondary.withOpacity(0.03),
//                     AppColors.backgroundLight,
//                   ],
//                 ),
//         ),
//         child: Stack(
//           children: [
//             _buildMainContent(isDark, isLandscape),
//             _buildCopyright(isDark, isLandscape),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent(bool isDark, bool isLandscape) {
//     final textColor = isDark ? Colors.white : AppColors.textPrimary;
//     final secondaryTextColor = isDark
//         ? Colors.white.withOpacity(0.8)
//         : AppColors.textSecondary;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Logo
//           ScaleTransition(
//             scale: _scaleAnimation,
//             child: Container(
//               width: 110,
//               height: 110,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.primaryLight],
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.4),
//                     blurRadius: 30,
//                     offset: const Offset(0, 15),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Image.asset(
//                   'assets/images/nutantek_logo.png',
//                   width: 70,
//                   height: 70,
//                   errorBuilder: (_, __, ___) =>
//                       Icon(Icons.business, size: 60, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),

//           // App Name
//           SlideTransition(
//             position: _slideAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 children: [
//                   Text(
//                     'Nutantek',
//                     style: TextStyle(
//                       fontSize: 42,
//                       fontWeight: FontWeight.w800,
//                       color: textColor,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: AppColors.primary.withOpacity(0.4),
//                       ),
//                     ),
//                     child: Text(
//                       'ATTENDANCE PRO',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: textColor.withOpacity(0.9),
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Tagline
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: Text(
//               'Enterprise Workforce Management',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: secondaryTextColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),

//           // Features
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: Wrap(
//               spacing: 12,
//               runSpacing: 8,
//               children: [
//                 _chip('Real-time Tracking', Icons.track_changes_rounded),
//                 _chip('Smart Analytics', Icons.analytics_rounded),
//                 _chip('Secure & Reliable', Icons.security_rounded),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chip(String text, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: AppColors.accent),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCopyright(bool isDark, bool isLandscape) {
//     final textColor = isDark ? Colors.white70 : Colors.black54;

//     return Positioned(
//       bottom: 30,
//       left: 0,
//       right: 0,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             Text(
//               '© 2025 Nutantek. All rights reserved.',
//               style: TextStyle(fontSize: 11, color: textColor),
//             ),
//             Text(
//               'ENTERPRISE EDITION v1.0.0',
//               style: TextStyle(
//                 fontSize: 10,
//                 color: textColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
