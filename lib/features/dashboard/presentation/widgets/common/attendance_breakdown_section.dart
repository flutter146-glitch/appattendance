// lib/features/dashboard/presentation/widgets/common/attendance_breakdown_section.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceBreakdownSection extends ConsumerWidget {
  const AttendanceBreakdownSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return dashboardAsync.when(
      data: (state) {
        // Extract stats (from real DB)
        final todayAttendance = state.todayAttendance;
        final present = todayAttendance.where((a) => a.isCheckIn).length;
        final leave = 2; // TODO: Real leave count from employee_leaves
        final absent =
            5 - present; // Dummy calculation - real mein total days - present
        final late = todayAttendance.where((a) => a.isLate).length;
        final onTime = present - late;

        final dailyAvg = 8.5; // TODO: Real calc from attendance duration
        final monthlyAvg = 180.0; // TODO: Real monthly average

        return Column(
          children: [
            Card(
              elevation: 500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance Breakdown",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 4,
                          centerSpaceRadius: 50,
                          sections: [
                            _pieSection(present, Colors.green, "Present"),
                            _pieSection(leave, Colors.orange, "Leave"),
                            _pieSection(absent, Colors.red, "Absent"),
                            _pieSection(onTime, Colors.teal, "On Time"),
                            _pieSection(late, Colors.deepOrange, "Late"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _legendItem("Present", present, Colors.green),
                        _legendItem("Leave", leave, Colors.orange),
                        _legendItem("Absent", absent, Colors.red),
                        _legendItem("On Time", onTime, Colors.teal),
                        _legendItem("Late", late, Colors.deepOrange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      "Working Hours Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomStatRow(
                      label: "Daily Avg",
                      value: "${dailyAvg.toStringAsFixed(1)} Hrs",
                      isGood: dailyAvg >= 9.0,
                    ),
                    const SizedBox(height: 12),
                    CustomStatRow(
                      label: "Monthly Avg",
                      value: "${monthlyAvg.toStringAsFixed(1)} Hrs",
                      isGood: monthlyAvg >= 180.0,
                    ),
                  ],
                ),
              ),
            ),
            // CustomStatRow(String label, int value, Color color),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text("Error loading attendance: $err")),
    );
  }

  PieChartSectionData _pieSection(int value, Color color, String title) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: value > 0 ? '$value' : '',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _legendItem(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          "$label: $value",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Widget CustomStatRow(String label, int value, Color color) {
  //   return Row(
  //     children: [
  //       Icon(Icons.circle, color: color, size: 12),
  //       SizedBox(width: 8),
  //       Text('$label: $value'),
  //     ],
  //   );
  // }
}

// import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class AttendanceBreakdownSection extends StatelessWidget {
//   final int present;
//   final int leave;
//   final int absent;
//   final int onTime;
//   final int late;
//   final double dailyAvg;
//   final double monthlyAvg;

//   const AttendanceBreakdownSection({
//     super.key,
//     required this.present,
//     required this.leave,
//     required this.absent,
//     required this.onTime,
//     required this.late,
//     required this.dailyAvg,
//     required this.monthlyAvg,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       children: [
//         Card(
//           elevation: 200,
//           // shape: RoundedRectangleBorder(
//           //   borderRadius: BorderRadius.circular(28),
//           // ),
//           // color: isDark ? Colors.grey.shade800 : Colors.white,
//           color: Colors.transparent,
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text(
//                 //   "Attendance Breakdown",
//                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 // ),
//                 // SizedBox(height: 5),
//                 SizedBox(
//                   height: 240,
//                   child: PieChart(
//                     PieChartData(
//                       borderData: FlBorderData(show: false),
//                       sectionsSpace: 4,
//                       centerSpaceRadius: 50,
//                       sections: [
//                         _pieSection(present, Colors.green),
//                         _pieSection(leave, Colors.orange),
//                         _pieSection(absent, Colors.red),
//                         _pieSection(onTime, Colors.teal),
//                         _pieSection(late, Colors.deepOrange),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Wrap(
//                   spacing: 20,
//                   runSpacing: 12,
//                   alignment: WrapAlignment.center,
//                   children: [
//                     _legendItem("Present", present, Colors.green),
//                     _legendItem("Leave", leave, Colors.orange),
//                     _legendItem("Absent", absent, Colors.red),
//                     _legendItem("OnTime", onTime, Colors.teal),
//                     _legendItem("Late", late, Colors.deepOrange),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // SizedBox(height: 0),
//         Card(
//           elevation: 200,
//           // shape: RoundedRectangleBorder(
//           //   borderRadius: BorderRadius.circular(24),
//           // ),
//           // color: isDark ? Colors.grey.shade800 : Colors.white,
//           color: Colors.transparent,
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 // Text(
//                 //   "Working Hours Summary",
//                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 // ),
//                 // SizedBox(height: 5),
//                 CustomStatRow(
//                   label: "Daily Avg",
//                   value: "${dailyAvg.toStringAsFixed(1)} Hrs",
//                   isGood: dailyAvg >= 9.0,
//                 ),
//                 SizedBox(height: 0),
//                 CustomStatRow(
//                   label: "Monthly Avg",
//                   value: "${monthlyAvg.toStringAsFixed(1)} Hrs",
//                   isGood: monthlyAvg >= 180.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   PieChartSectionData _pieSection(int value, Color color) {
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

//   Widget _legendItem(String label, int value, Color color) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         SizedBox(width: 8),
//         Text(
//           "$label: $value",
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }
