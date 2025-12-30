// // lib/features/dashboard/presentation/widgets/common/attendance_status_widget.dart
// Upgraded: Uses AttendanceModel (freezed) from DashboardNotifier
// Real check-in/out status + time + role-based
// Loading/error + dark mode + clean UI
// Current date: December 29, 2025

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AttendanceStatusWidget extends ConsumerWidget {
  const AttendanceStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return dashboardAsync.when(
      data: (state) {
        final todayAttendance = state.todayAttendance;
        final hasCheckedIn = todayAttendance.any((a) => a.isCheckIn);
        final hasCheckedOut = todayAttendance.any((a) => a.isCheckOut);

        final checkInTime = todayAttendance
            .firstWhere(
              (a) => a.isCheckIn,
              orElse: () => AttendanceModel(
                attId: '',
                empId: '',
                timestamp: DateTime.now(),
                status: AttendanceStatus.checkIn,
              ),
            )
            .formattedTime;

        final checkOutTime = todayAttendance
            .firstWhere(
              (a) => a.isCheckOut,
              orElse: () => AttendanceModel(
                attId: '',
                empId: '',
                timestamp: DateTime.now(),
                status: AttendanceStatus.checkOut,
              ),
            )
            .formattedTime;

        String status;
        String time;
        Color statusColor;

        if (hasCheckedOut) {
          status = 'Checked Out';
          time = checkOutTime;
          statusColor = Colors.orange;
        } else if (hasCheckedIn) {
          status = 'Checked In';
          time = checkInTime;
          statusColor = Colors.green;
        } else {
          status = 'Not Checked In';
          time = '';
          statusColor = Colors.grey;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time_filled, color: statusColor, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (time.isNotEmpty)
                    Text(
                      "at $time",
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text("Error loading attendance status: $err")),
    );
  }
}
