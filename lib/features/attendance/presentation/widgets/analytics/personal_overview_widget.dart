// lib/features/attendance/presentation/widgets/analytics/personal_employee_overview_widget.dart

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalEmployeeOverviewWidget extends ConsumerWidget {
  const PersonalEmployeeOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: analyticsAsync.when(
        data: (analytics) {
          final present = analytics.presentDays;
          final absent = analytics.absentDays;
          final late = analytics.lateDays;
          final leave = analytics.leaveDays;
          final total = present + absent + late + leave;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Your Attendance Breakdown",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: [
                              PieChartSectionData(
                                value: present.toDouble(),
                                title: total > 0
                                    ? '${(present / total * 100).toStringAsFixed(0)}%'
                                    : '',
                                color: Colors.green,
                                radius: 80,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: absent.toDouble(),
                                title: total > 0
                                    ? '${(absent / total * 100).toStringAsFixed(0)}%'
                                    : '',
                                color: Colors.red,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                value: late.toDouble(),
                                title: total > 0
                                    ? '${(late / total * 100).toStringAsFixed(0)}%'
                                    : '',
                                color: Colors.orange,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                value: leave.toDouble(),
                                title: total > 0
                                    ? '${(leave / total * 100).toStringAsFixed(0)}%'
                                    : '',
                                color: Colors.blue,
                                radius: 80,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLegendRow(Colors.green, "Present", present),
                      _buildLegendRow(Colors.red, "Absent", absent),
                      _buildLegendRow(Colors.orange, "Late", late),
                      _buildLegendRow(Colors.blue, "Leave", leave),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quick Stats",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatChip(
                            "Avg Hours",
                            "${analytics.dailyAvgHours.toStringAsFixed(1)}h",
                          ),
                          _buildStatChip(
                            "Pending Leaves",
                            "${analytics.pendingLeaves}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Failed to load personal stats")),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text("$label ($count days)", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
