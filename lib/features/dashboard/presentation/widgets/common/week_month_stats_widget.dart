// // lib/features/dashboard/presentation/widgets/employeewidgets/week_month_stats_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/date_time_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class WeekMonthStatsWidget extends ConsumerWidget {
//   const WeekMonthStatsWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dashboardAsync = ref.watch(dashboardProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return dashboardAsync.when(
//       data: (state) {
//         // Real data from notifier/DB
//         final present = 22;
//         final leave = 2;
//         final absent = 6;
//         final onTime = 18;
//         final late = 4;
//         final dailyAvg = 8.5;
//         final monthlyAvg = 180.0;
//         final weeklyAvg = 40.0;

//         return Card(
//           elevation: 10,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//           color: isDark ? Colors.grey.shade800 : Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Weekly & Monthly Stats",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 CustomStatRow(
//                   label: "Weekly Avg Hours",
//                   value: "${weeklyAvg.toStringAsFixed(1)} Hrs",
//                   isGood: weeklyAvg >= 40.0,
//                 ),
//                 CustomStatRow(
//                   label: "Monthly Avg Hours",
//                   value: "${monthlyAvg.toStringAsFixed(1)} Hrs",
//                   isGood: monthlyAvg >= 180.0,
//                 ),
//                 CustomStatRow(
//                   label: "Daily Avg Hours",
//                   value: "${dailyAvg.toStringAsFixed(1)} Hrs",
//                   isGood: dailyAvg >= 8.0,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(child: Text("Error: $err")),
//     );
//   }
// }
