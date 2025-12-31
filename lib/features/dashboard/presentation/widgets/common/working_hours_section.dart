// lib/features/dashboard/presentation/widgets/common/working_hours_section.dart
import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
import 'package:flutter/material.dart';

class WorkingHoursSection extends StatelessWidget {
  final double dailyAvg;
  final double monthlyAvg;

  const WorkingHoursSection({
    super.key,
    required this.dailyAvg,
    required this.monthlyAvg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 8,
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
    );
  }
}