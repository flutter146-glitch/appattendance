import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MergedGraphWidget extends ConsumerWidget {
  const MergedGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeColors(context);
    final analyticsAsync = ref.watch(analyticsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: theme.isDark ? 2 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Date badge + Download icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Network Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      // Dynamic date badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.success.withOpacity(
                            theme.isDark ? 0.25 : 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: analyticsAsync.when(
                          data: (analytics) => Text(
                            'DAILY: ${DateFormat('dd MMM yyyy').format(analytics.startDate ?? DateTime.now())}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          loading: () => Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                          error: (_, __) => Text(
                            'Error',
                            style: TextStyle(fontSize: 12, color: theme.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.download_rounded,
                          color: theme.success,
                          size: 22,
                        ),
                        onPressed: () {
                          // TODO: Real export (e.g., save as PNG or CSV)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Graph exported (implement real export)',
                                style: TextStyle(color: theme.onPrimary),
                              ),
                              backgroundColor: theme.success,
                            ),
                          );
                        },
                        tooltip: 'Download Graph',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Graph Area
              SizedBox(
                height: 240,
                child: analyticsAsync.when(
                  data: (analytics) {
                    final labels = analytics.graphLabels;
                    final values =
                        analytics.graphDataRaw['network'] ??
                        List.filled(labels.length, 0.0);

                    if (labels.isEmpty || values.isEmpty) {
                      return Center(
                        child: Text(
                          'No network data available',
                          style: TextStyle(color: theme.textSecondary),
                        ),
                      );
                    }

                    return BarChart(
                      BarChartData(
                        maxY: 5,
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: List.generate(labels.length, (i) {
                          final value = values[i];
                          final mainColor = value >= 4
                              ? theme.success
                              : value >= 3
                              ? theme.warning
                              : theme.error;

                          final accentColor = value >= 4
                              ? theme.success.withOpacity(
                                  0.7,
                                ) // lighter accent in dark mode too
                              : value >= 3
                              ? theme.warning.withOpacity(0.7)
                              : theme.error.withOpacity(0.7);

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                color: mainColor,
                                width: 28,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                rodStackItems: [
                                  BarChartRodStackItem(
                                    value - 0.4,
                                    value,
                                    accentColor,
                                  ),
                                  BarChartRodStackItem(
                                    0,
                                    value - 0.4,
                                    mainColor,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= labels.length)
                                  return const Text('');
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[idx],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: theme.divider, strokeWidth: 1),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    );
                  },
                  loading: () => Shimmer.fromColors(
                    baseColor: theme.isDark
                        ? Colors.grey[800]!
                        : Colors.grey[300]!,
                    highlightColor: theme.isDark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Failed to load network data',
                      style: TextStyle(color: theme.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
