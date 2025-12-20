// lib/features/dashboard/presentation/widgets/common/custom_stat_row.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomStatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isGood;

  const CustomStatRow({
    super.key,
    required this.label,
    required this.value,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeBg = isGood
        ? (isDark ? Colors.green.shade900 : Colors.green.shade100)
        : (isDark ? Colors.orange.shade900 : Colors.orange.shade100);

    final badgeText = isGood
        ? (isDark ? Colors.green.shade200 : Colors.green.shade800)
        : (isDark ? Colors.orange.shade200 : Colors.orange.shade800);

    final icon = isGood ? Icons.thumb_up : Icons.warning_amber_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: badgeText),
                SizedBox(width: 8),
                Text(
                  isGood ? 'GOOD' : 'IMPROVE',
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/common/custom_stat_row.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class CustomStatRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isGood;

//   const CustomStatRow({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.isGood,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final badgeColor = isGood
//         ? (isDark ? Colors.green.shade800 : Colors.green.shade100)
//         : (isDark ? Colors.orange.shade800 : Colors.orange.shade100);

//     final textColor = isGood
//         ? (isDark ? Colors.green.shade200 : Colors.green.shade800)
//         : (isDark ? Colors.orange.shade200 : Colors.orange.shade800);

//     final icon = isGood ? Icons.thumb_up : Icons.warning_amber_rounded;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '$label: $value',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: badgeColor,
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: textColor.withOpacity(0.3), width: 1),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 18, color: textColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   isGood ? 'GOOD' : 'IMPROVE',
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
