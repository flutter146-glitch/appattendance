// lib/features/dashboard/presentation/widgets/common/attendance_status_widget.dart

import 'package:flutter/material.dart';

class AttendanceStatusWidget extends StatelessWidget {
  final String status; // "Checked In", "Checked Out", "Not Checked In"
  final String time; // "09:15 AM"
  final Color statusColor;

  const AttendanceStatusWidget({
    super.key,
    required this.status,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_filled, color: statusColor, size: 24),
          SizedBox(width: 12),
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
  }
}
