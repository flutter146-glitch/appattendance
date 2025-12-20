import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AttendanceBreakdownSection extends StatelessWidget {
  final int present;
  final int leave;
  final int absent;
  final int onTime;
  final int late;
  final double dailyAvg;
  final double monthlyAvg;

  const AttendanceBreakdownSection({
    super.key,
    required this.present,
    required this.leave,
    required this.absent,
    required this.onTime,
    required this.late,
    required this.dailyAvg,
    required this.monthlyAvg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Card(
          elevation: 200,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(28),
          // ),
          // color: isDark ? Colors.grey.shade800 : Colors.white,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Attendance Breakdown",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 5),
                SizedBox(
                  height: 240,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: [
                        _pieSection(present, Colors.green),
                        _pieSection(leave, Colors.orange),
                        _pieSection(absent, Colors.red),
                        _pieSection(onTime, Colors.teal),
                        _pieSection(late, Colors.deepOrange),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 20,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _legendItem("Present", present, Colors.green),
                    _legendItem("Leave", leave, Colors.orange),
                    _legendItem("Absent", absent, Colors.red),
                    _legendItem("OnTime", onTime, Colors.teal),
                    _legendItem("Late", late, Colors.deepOrange),
                  ],
                ),
              ],
            ),
          ),
        ),

        // SizedBox(height: 0),
        Card(
          elevation: 200,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(24),
          // ),
          // color: isDark ? Colors.grey.shade800 : Colors.white,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Text(
                //   "Working Hours Summary",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 5),
                CustomStatRow(
                  label: "Daily Avg",
                  value: "${dailyAvg.toStringAsFixed(1)} Hrs",
                  isGood: dailyAvg >= 9.0,
                ),
                SizedBox(height: 0),
                CustomStatRow(
                  label: "Monthly Avg",
                  value: "${monthlyAvg.toStringAsFixed(1)} Hrs",
                  isGood: monthlyAvg >= 180.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PieChartSectionData _pieSection(int value, Color color) {
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
        SizedBox(width: 8),
        Text(
          "$label: $value",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
