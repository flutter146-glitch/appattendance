// lib/features/attendance/presentation/widgets/stats_cards_widget.dart
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StatsCardsWidget extends ConsumerWidget {
  const StatsCardsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(analyticsProvider);

    return asyncValue.when(
      data: (analytics) {
        final stats = analytics.teamStats;
        final pct = analytics.teamPercentages;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  'Team',
                  '${stats['team'] ?? 0}',
                  '100%',
                  Colors.blue,
                ),
                _buildStatCard(
                  'Present',
                  '${stats['present'] ?? 0}',
                  pct['present']?.toStringAsFixed(0) ?? '0',
                  Colors.green,
                ),
                _buildStatCard(
                  'Leave',
                  '${stats['leave'] ?? 0}',
                  '10',
                  Colors.blue[700]!,
                ),
                _buildStatCard(
                  'Absent',
                  '${stats['absent'] ?? 0}',
                  pct['absent']?.toStringAsFixed(0) ?? '0',
                  Colors.red,
                ),
                _buildStatCard(
                  'OnTime',
                  '${stats['onTime'] ?? 0}',
                  pct['onTime']?.toStringAsFixed(0) ?? '0',
                  Colors.green[700]!,
                ),
                _buildStatCard(
                  'Late',
                  '${stats['late'] ?? 0}',
                  '10',
                  Colors.orange,
                ),
              ],
            ),
          ],
        );
      },
      loading: () => SizedBox(
        height: 120,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (_) => Container(width: 60, height: 100, color: Colors.white),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String percent,
    Color color,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            percent == '100' ? '100%' : '$percent%',
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class StatisticsCards extends ConsumerWidget {
//   const StatisticsCards({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final analyticsAsync = ref.watch(analyticsProvider);

//     return analyticsAsync.when(
//       data: (analytics) {
//         final stats = analytics.teamStats;
//         final pct = analytics.teamPercentages;

//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _StatCard('Team', '${stats['team']}', Colors.blue),
//             _StatCard(
//               'Present',
//               '${stats['present']} (${pct['present']?.toStringAsFixed(0)}%)',
//               Colors.green,
//             ),
//             _StatCard('Leave', '${stats['leave']}', Colors.blue),
//             _StatCard('Absent', '${stats['absent']}', Colors.red),
//             _StatCard('OnTime', '${stats['onTime']}', Colors.greenAccent),
//             _StatCard('Late', '${stats['late']}', Colors.orange),
//           ],
//         );
//       },
//       loading: () => CircularProgressIndicator(),
//       error: (e, s) => Text('Error'),
//     );
//   }
// }

// Widget _StatCard(String label, String value, Color color) {
//   return Card(
//     color: color.withOpacity(0.1),
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text(label, style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     ),
//   );
// }
