// lib/core/theme/app_gradients.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  static LinearGradient dashboard(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryDark.withOpacity(0.9),
          AppColors.grey900,
          AppColors.secondaryDark.withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0], // ← Length same as colors (3)
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.warning, AppColors.grey200, AppColors.primary],
        stops: const [0.0, 0.5, 1.0], // ← Length same (3)
      );
    }
  }
}

// // lib/core/utils/app_gradients.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class AppGradients {
//   static LinearGradient get dashboardBackground {
//     return LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Color.fromARGB(255, 0, 54, 170),
//         Color.fromARGB(255, 153, 154, 155),
//         Color.fromARGB(255, 251, 251, 252).withOpacity(0.6),
//         Color.fromARGB(255, 255, 196, 0),
//       ],
//       stops: const [0.0, 0.3, 0.7, 1.0],
//     );
//   }

//   static LinearGradient get darkDashboardBackground {
//     return LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Color(0xFF111827),
//         Color(0xFF1E293B),
//         Color(0xFF4C1D95).withOpacity(0.6),
//         Color(0xFF0F172A),
//       ],
//       stops: const [0.0, 0.3, 0.7, 1.0],
//     );
//   }

//   // Amazing combined — auto switch dark/light
//   static LinearGradient dashboard(bool isDark) {
//     return isDark ? darkDashboardBackground : dashboardBackground;
//   }
// }
