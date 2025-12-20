// lib/features/dashboard/presentation/widgets/common/attendance_period_stats_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AttendancePeriod { daily, weekly, monthly, quarterly }

class AttendancePeriodStatsWidget extends StatelessWidget {
  final AttendancePeriod period;
  final int totalDays;
  final int present;
  final int leave;
  final int absent;
  final int onTime;
  final int late;

  const AttendancePeriodStatsWidget({
    super.key,
    required this.period,
    required this.totalDays,
    required this.present,
    required this.leave,
    required this.absent,
    required this.onTime,
    required this.late,
  });

  String get periodTitle {
    switch (period) {
      case AttendancePeriod.daily:
        return "Today's Attendance";
      case AttendancePeriod.weekly:
        return "This Week's Attendance";
      case AttendancePeriod.monthly:
        return "My Attendance - ${DateFormat('MMMM yyyy').format(DateTime.now())}";
      case AttendancePeriod.quarterly:
        final now = DateTime.now();
        final quarter = ((now.month - 1) ~/ 3) + 1;
        return "Q$quarter ${now.year} Attendance";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              periodTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem("Days", totalDays.toString(), Colors.blueGrey),
                _statItem("P", present.toString(), Colors.green),
                _statItem("L", leave.toString(), Colors.orange),
                _statItem("A", absent.toString(), Colors.red),
                _statItem("OnTime", onTime.toString(), Colors.teal),
                _statItem("Late", late.toString(), Colors.deepOrange),
              ],
            ),

            SizedBox(height: 20),

            // Attendance Percentage (only for week/month/quarter)
            if (period != AttendancePeriod.daily)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: (present / totalDays * 100) >= 90
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${(present / totalDays * 100).toStringAsFixed(1)}% Attendance",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (present / totalDays * 100) >= 90
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
