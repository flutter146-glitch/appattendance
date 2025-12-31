// // lib/features/dashboard/presentation/widgets/common/attendance_breakdown_section.dart
// // Upgraded: Real data from DashboardNotifier + role-based
// // Dynamic pie chart + stats + loading/error + dark mode
// // Current date: December 29, 2025
//
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'custom_stat_row.dart';
// enum AttendancePeriod { daily, weekly, monthly, quarterly }
// class AttendanceBreakdownSection extends ConsumerWidget { final AttendancePeriod period;
//   const AttendanceBreakdownSection({super.key, required this.period});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dashboardAsync = ref.watch(dashboardProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return dashboardAsync.when(
//       data: (state) {
//         // Extract stats (from real DB)
//         final filteredAttendance =
//         _filterByPeriod(state.allAttendance, period);
//
// // Unique working days
//         final totalDays = filteredAttendance
//             .map((e) => e['att_timestamp'].toString().substring(0, 10))
//             .toSet()
//             .length;
//
//         final present = filteredAttendance
//             .where((e) => e['att_status'] == 'checkin')
//             .map((e) => e['att_timestamp'].toString().substring(0, 10))
//             .toSet()
//             .length;
//
//         final leave = filteredAttendance
//             .where((e) => e['att_status'] == 'leave')
//             .length;
//
//         final absent = totalDays - present - leave;
//
// // On-time vs late (simple rule)
//         final onTime = filteredAttendance.where((e) {
//           if (e['att_status'] != 'checkin') return false;
//           final time = DateTime.parse(e['att_timestamp']);
//           return time.hour < 10; // before 10 AM
//         }).length;
//
//         final late = present - onTime;
//
//
//
//         return Column(
//           children: [
//             Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               color: Colors.transparent,
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Attendance Breakdown",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       height: 240,
//                       child: PieChart(
//                         PieChartData(
//                           borderData: FlBorderData(show: false),
//                           sectionsSpace: 4,
//                           centerSpaceRadius: 50,
//                           sections: [
//                             _pieSection(present, Colors.green, "Present"),
//                             _pieSection(leave, Colors.orange, "Leave"),
//                             _pieSection(absent, Colors.red, "Absent"),
//                             _pieSection(onTime, Colors.teal, "On Time"),
//                             _pieSection(late, Colors.deepOrange, "Late"),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Wrap(
//                       spacing: 20,
//                       runSpacing: 12,
//                       alignment: WrapAlignment.center,
//                       children: [
//                         _legendItem("Present", present, Colors.green),
//                         _legendItem("Leave", leave, Colors.orange),
//                         _legendItem("Absent", absent, Colors.red),
//                         _legendItem("On Time", onTime, Colors.teal),
//                         _legendItem("Late", late, Colors.deepOrange),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) =>
//           Center(child: Text("Error loading attendance: $err")),
//     );
//   }
//
//
//   PieChartSectionData _pieSection(int value, Color color, String title) {
//     return PieChartSectionData(
//       value: value.toDouble(),
//       color: color,
//       title: value > 0 ? '$value' : '',
//       radius: 60,
//       titleStyle: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     );
//   }
//   List<Map<String, dynamic>> _filterByPeriod(
//       List<Map<String, dynamic>> allAttendance,
//       AttendancePeriod period,
//       ) {
//     final now = DateTime.now();
//
//     return allAttendance.where((att) {
//       final ts = DateTime.parse(att['att_timestamp']);
//
//       switch (period) {
//         case AttendancePeriod.daily:
//           return ts.year == now.year &&
//               ts.month == now.month &&
//               ts.day == now.day;
//
//         case AttendancePeriod.weekly:
//           final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//           return ts.isAfter(startOfWeek);
//
//         case AttendancePeriod.monthly:
//           return ts.year == now.year && ts.month == now.month;
//
//         case AttendancePeriod.quarterly:
//           final quarter = ((now.month - 1) ~/ 3) + 1;
//           final startMonth = (quarter - 1) * 3 + 1;
//           final endMonth = startMonth + 2;
//           return ts.year == now.year &&
//               ts.month >= startMonth &&
//               ts.month <= endMonth;
//       }
//     }).toList();
//   }
//
//   Widget _legendItem(String label, int value, Color color) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "$label: $value",
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }
//
// // import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
//
// // class AttendanceBreakdownSection extends StatelessWidget {
// //   final int present;
// //   final int leave;
// //   final int absent;
// //   final int onTime;
// //   final int late;
// //   final double dailyAvg;
// //   final double monthlyAvg;
//
// //   const AttendanceBreakdownSection({
// //     super.key,
// //     required this.present,
// //     required this.leave,
// //     required this.absent,
// //     required this.onTime,
// //     required this.late,
// //     required this.dailyAvg,
// //     required this.monthlyAvg,
// //   });
//
// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
//
// //     return Column(
// //       children: [
// //         Card(
// //           elevation: 200,
// //           // shape: RoundedRectangleBorder(
// //           //   borderRadius: BorderRadius.circular(28),
// //           // ),
// //           // color: isDark ? Colors.grey.shade800 : Colors.white,
// //           color: Colors.transparent,
// //           child: Padding(
// //             padding: EdgeInsets.all(24),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Text(
// //                 //   "Attendance Breakdown",
// //                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                 // ),
// //                 // SizedBox(height: 5),
// //                 SizedBox(
// //                   height: 240,
// //                   child: PieChart(
// //                     PieChartData(
// //                       borderData: FlBorderData(show: false),
// //                       sectionsSpace: 4,
// //                       centerSpaceRadius: 50,
// //                       sections: [
// //                         _pieSection(present, Colors.green),
// //                         _pieSection(leave, Colors.orange),
// //                         _pieSection(absent, Colors.red),
// //                         _pieSection(onTime, Colors.teal),
// //                         _pieSection(late, Colors.deepOrange),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 5),
// //                 Wrap(
// //                   spacing: 20,
// //                   runSpacing: 12,
// //                   alignment: WrapAlignment.center,
// //                   children: [
// //                     _legendItem("Present", present, Colors.green),
// //                     _legendItem("Leave", leave, Colors.orange),
// //                     _legendItem("Absent", absent, Colors.red),
// //                     _legendItem("OnTime", onTime, Colors.teal),
// //                     _legendItem("Late", late, Colors.deepOrange),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
//
// //         // SizedBox(height: 0),
// //         Card(
// //           elevation: 200,
// //           // shape: RoundedRectangleBorder(
// //           //   borderRadius: BorderRadius.circular(24),
// //           // ),
// //           // color: isDark ? Colors.grey.shade800 : Colors.white,
// //           color: Colors.transparent,
// //           child: Padding(
// //             padding: EdgeInsets.all(24),
// //             child: Column(
// //               children: [
// //                 // Text(
// //                 //   "Working Hours Summary",
// //                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                 // ),
// //                 // SizedBox(height: 5),
// //                 CustomStatRow(
// //                   label: "Daily Avg",
// //                   value: "${dailyAvg.toStringAsFixed(1)} Hrs",
// //                   isGood: dailyAvg >= 9.0,
// //                 ),
// //                 SizedBox(height: 0),
// //                 CustomStatRow(
// //                   label: "Monthly Avg",
// //                   value: "${monthlyAvg.toStringAsFixed(1)} Hrs",
// //                   isGood: monthlyAvg >= 180.0,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
//
// //   PieChartSectionData _pieSection(int value, Color color) {
// //     return PieChartSectionData(
// //       value: value.toDouble(),
// //       color: color,
// //       title: value > 0 ? '$value' : '',
// //       radius: 60,
// //       titleStyle: const TextStyle(
// //         fontSize: 18,
// //         fontWeight: FontWeight.bold,
// //         color: Colors.white,
// //       ),
// //     );
// //   }
//
// //   Widget _legendItem(String label, int value, Color color) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Container(
// //           width: 16,
// //           height: 16,
// //           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
// //         ),
// //         SizedBox(width: 8),
// //         Text(
// //           "$label: $value",
// //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //         ),
// //       ],
// //     );
// //   }
// // }