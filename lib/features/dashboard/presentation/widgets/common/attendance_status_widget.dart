// lib/features/dashboard/presentation/widgets/common/attendance_status_widget.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceStatusWidget extends ConsumerWidget {
  const AttendanceStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    return dashboardAsync.when(
      data: (state) {
        final todayAttendance = state.todayAttendance ?? [];
        final hasCheckedIn = todayAttendance.any((a) => a.isCheckIn);
        final hasCheckedOut = todayAttendance.any((a) => a.isCheckOut);

        // Get latest check-in / check-out
        final checkInAtt = todayAttendance.firstWhere(
          (a) => a.isCheckIn,
          orElse: () => AttendanceModel(
            attId: '',
            empId: '',
            timestamp: now,
            attendanceDate: now,
            status: AttendanceStatus.checkIn,
          ),
        );

        final checkOutAtt = todayAttendance.firstWhere(
          (a) => a.isCheckOut,
          orElse: () => AttendanceModel(
            attId: '',
            empId: '',
            timestamp: now,
            attendanceDate: now,
            status: AttendanceStatus.checkOut,
          ),
        );

        String status;
        String time;
        Color statusColor;
        IconData icon;

        if (hasCheckedOut) {
          status = 'Checked Out';
          time = checkOutAtt.formattedCheckOut;
          statusColor = Colors.orange.shade700;
          icon = Icons.logout_rounded;
        } else if (hasCheckedIn) {
          status = 'Checked In';
          time = checkInAtt.formattedCheckIn;
          statusColor = Colors.green.shade700;
          icon = Icons.login_rounded;
        } else {
          status = 'Not Checked In';
          time = '';
          statusColor = Colors.grey.shade600;
          icon = Icons.access_time_rounded;
        }

        return Semantics(
          label: 'Attendance Status: $status at $time',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(isDark ? 0.15 : 0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: statusColor.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: statusColor, size: 28),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    if (time.isNotEmpty)
                      Text(
                        "at $time",
                        style: TextStyle(
                          fontSize: 14,
                          color: statusColor.withOpacity(0.85),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 220,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      error: (err, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error loading attendance',
              style: TextStyle(color: Colors.red.shade700),
            ),
            TextButton(
              onPressed: () => ref.invalidate(dashboardProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// // // lib/features/dashboard/presentation/widgets/common/attendance_status_widget.dart
// // Upgraded: Uses AttendanceModel (freezed) from DashboardNotifier
// // Real check-in/out status + time + role-based
// // Loading/error + dark mode + clean UI
// // Current date: December 29, 2025

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class AttendanceStatusWidget extends ConsumerWidget {
//   const AttendanceStatusWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dashboardAsync = ref.watch(dashboardProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return dashboardAsync.when(
//       data: (state) {
//         final todayAttendance = state.todayAttendance;
//         final hasCheckedIn = todayAttendance.any((a) => a.isCheckIn);
//         final hasCheckedOut = todayAttendance.any((a) => a.isCheckOut);

//         final checkInTime = todayAttendance
//             .firstWhere(
//               (a) => a.isCheckIn,
//               orElse: () => AttendanceModel(
//                 attId: '',
//                 empId: '',
//                 timestamp: DateTime.now(),
//                 attendanceDate:
//                     DateTime.now(), // ← REQUIRED FIELD FIX: Add this line
//                 status: AttendanceStatus.checkIn,
//               ),
//             )
//             .formattedTime;

//         final checkOutTime = todayAttendance
//             .firstWhere(
//               (a) => a.isCheckOut,
//               orElse: () => AttendanceModel(
//                 attId: '',
//                 empId: '',
//                 timestamp: DateTime.now(),
//                 attendanceDate:
//                     DateTime.now(), // ← REQUIRED FIELD FIX: Add this line
//                 status: AttendanceStatus.checkOut,
//               ),
//             )
//             .formattedTime;

//         String status;
//         String time;
//         Color statusColor;

//         if (hasCheckedOut) {
//           status = 'Checked Out';
//           time = checkOutTime;
//           statusColor = Colors.orange;
//         } else if (hasCheckedIn) {
//           status = 'Checked In';
//           time = checkInTime;
//           statusColor = Colors.green;
//         } else {
//           status = 'Not Checked In';
//           time = '';
//           statusColor = Colors.grey;
//         }

//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration: BoxDecoration(
//             color: statusColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: statusColor.withOpacity(0.5)),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.access_time_filled, color: statusColor, size: 24),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     status,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: statusColor,
//                     ),
//                   ),
//                   if (time.isNotEmpty)
//                     Text(
//                       "at $time",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: statusColor.withOpacity(0.8),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) =>
//           Center(child: Text("Error loading attendance status: $err")),
//     );
//   }
// }
