// lib/features/attendance/presentation/screens/project_detail_screen.dart
// UPGRADED: Full ThemeColors integration + dark/light optimized + screenshot-perfect look

import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';

class AnalyticsProjectDetailScreen extends ConsumerWidget {
  final ProjectModel project;

  const AnalyticsProjectDetailScreen({required this.project, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeColors(context);
    final teamMembersAsync = ref.watch(
      projectTeamMembersProvider(project.projectId),
    );

    return Scaffold(
      backgroundColor: theme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          project.projectName,
          style: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.isDark
                ? [theme.onPrimary, theme.background]
                : [theme.primary, theme.primary.withOpacity(0.3)],
          ),
        ),
        child: SafeArea(
          child: teamMembersAsync.when(
            data: (teamMembers) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Project Description Card
                  Card(
                    color: theme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: theme.isDark ? 1 : 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.projectDescription ??
                                'No description available',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusChip('ACTIVE', theme.success, theme),
                              _buildStatusChip(
                                'HIGH PRIORITY',
                                theme.error,
                                theme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Team Workload Distribution Chart
                  Text(
                    'Team Workload Distribution',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Task allocation across team members',
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: theme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: theme.isDark ? 1 : 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 1,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: theme.divider,
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: theme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        // Real team members initials (dynamic)
                                        if (teamMembers.isEmpty)
                                          return const Text('');
                                        final idx = value.toInt();
                                        if (idx >= 0 &&
                                            idx < teamMembers.length) {
                                          return Text(
                                            teamMembers[idx].avatarInitial,
                                            style: TextStyle(
                                              color: theme.textSecondary,
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: teamMembers.isEmpty
                                        ? const [FlSpot(0, 0)]
                                        : teamMembers.asMap().entries.map((e) {
                                            // Dummy workload - replace with real task count or hours
                                            final workload = e.key * 2.0 + 5.0;
                                            // final Workload = member.assignedTasks?.length.toDouble() ?? (e.key + 5).toDouble();

                                            return FlSpot(
                                              e.key.toDouble(),
                                              workload,
                                            );
                                          }).toList(),
                                    isCurved: true,
                                    color: theme.primary,
                                    barWidth: 4,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: theme.primary.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: teamMembers.map((m) {
                              return _buildLegendChip(
                                '${m.avatarInitial}: ~${(m.attendanceRatePercentage ?? 0).toStringAsFixed(0)} tasks',
                                // '${m.name.split(' ').first}: ${m.assignedTasks?.length ?? 0} tasks'
                                theme.primary,
                                theme,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Team Members List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Team Members',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${teamMembers.length} members',
                          style: TextStyle(color: theme.onPrimary),
                        ),
                        backgroundColor: theme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (teamMembers.isEmpty)
                    Center(
                      child: Text(
                        'No team members assigned',
                        style: TextStyle(color: theme.textSecondary),
                      ),
                    )
                  else
                    Column(
                      children: teamMembers.map((member) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: theme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: theme.isDark ? 1 : 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: theme.primary.withOpacity(0.15),
                              child: Text(
                                member.avatarInitial,
                                style: TextStyle(
                                  color: theme.primary,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              member.name,
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.designation ?? 'Employee',
                                  style: TextStyle(color: theme.textSecondary),
                                ),
                                Text(
                                  member.email ?? 'N/A',
                                  style: TextStyle(
                                    color: theme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: theme.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              );
            },
            loading: () => Shimmer.fromColors(
              baseColor: theme.isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: theme.isDark
                  ? Colors.grey[700]!
                  : Colors.grey[100]!,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _shimmerCard(theme),
                  const SizedBox(height: 24),
                  _shimmerChart(theme),
                  const SizedBox(height: 32),
                  _shimmerCard(theme),
                ],
              ),
            ),
            error: (_, __) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: theme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load project details',
                    style: TextStyle(color: theme.error, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(
                      projectTeamMembersProvider(project.projectId),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: theme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerCard(ThemeColors theme) {
    return Card(
      color: theme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const SizedBox(height: 120),
    );
  }

  Widget _shimmerChart(ThemeColors theme) {
    return Card(
      color: theme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const SizedBox(height: 250),
    );
  }

  Widget _buildStatusChip(String label, Color color, ThemeColors theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLegendChip(String label, Color color, ThemeColors theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
