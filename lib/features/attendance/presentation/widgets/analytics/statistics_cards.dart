import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StatsCardsWidget extends ConsumerWidget {
  const StatsCardsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeColors(context);
    final asyncValue = ref.watch(analyticsProvider);

    return asyncValue.when(
      data: (analytics) {
        final stats = analytics.teamStats;
        final pct = analytics.teamPercentages;

        final teamSize = stats['team'] ?? 0;
        final present = stats['present'] ?? 0;
        final absent = stats['absent'] ?? 0;
        final onTime = stats['onTime'] ?? 0;
        final late = stats['late'] ?? 0;
        final leave = stats['leave'] ?? 0;

        final presentPct = pct['present']?.toStringAsFixed(0) ?? '0';
        final absentPct = pct['absent']?.toStringAsFixed(0) ?? '0';
        final onTimePct = pct['onTime']?.toStringAsFixed(0) ?? '0';
        final latePct = pct['late']?.toStringAsFixed(0) ?? '0';

        Widget _statItem({
          required String label,
          required String value,
          required String? percent,
          required IconData icon,
          required Color iconColor,
        }) {
          return SizedBox(
            width: 88,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(theme.isDark ? 0.30 : 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: iconColor),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.textPrimary,
                  ),
                ),
                if (percent != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: iconColor.withOpacity(0.9),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    color: theme.textSecondary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   'Team Attendance Overview',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //     color: theme.textPrimary,
              //   ),
              // ),
              // const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 380;
                  final spacing = isNarrow ? 16.0 : 24.0;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: isNarrow ? 4 : 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _statItem(
                          label: 'Team',
                          value: teamSize.toString(),
                          percent: null,
                          icon: Icons.people_alt_rounded,
                          iconColor: theme.primary,
                        ),
                        SizedBox(width: spacing),
                        _statItem(
                          label: 'Present',
                          value: present.toString(),
                          percent: presentPct,
                          icon: Icons.check_circle_rounded,
                          iconColor: theme.success,
                        ),
                        SizedBox(width: spacing),
                        _statItem(
                          label: 'Absent',
                          value: absent.toString(),
                          percent: absentPct,
                          icon: Icons.person_off_rounded,
                          iconColor: theme.error,
                        ),
                        SizedBox(width: spacing),
                        _statItem(
                          label: 'On-Time',
                          value: onTime.toString(),
                          percent: onTimePct,
                          icon: Icons.access_time_filled_rounded,
                          iconColor: theme.success,
                        ),
                        SizedBox(width: spacing),
                        _statItem(
                          label: 'Late',
                          value: late.toString(),
                          percent: latePct,
                          icon: Icons.warning_amber_rounded,
                          iconColor: theme.warning,
                        ),
                        SizedBox(width: spacing),
                        _statItem(
                          label: 'Leave',
                          value: leave.toString(),
                          percent: null,
                          icon: Icons.beach_access_rounded,
                          iconColor: theme.info,
                        ),
                      ],
                    ),
                  );
                },
              ),
              // const SizedBox(height: 16),
              Divider(color: theme.divider),
            ],
          ),
        );
      },

      // ──────────────────────────────────────────────────────────────
      // Fixed shimmer – no overflow anymore
      loading: () => SizedBox(
        height: 180,
        child: Shimmer.fromColors(
          baseColor: theme.isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: theme.isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 160, height: 22, color: Colors.white),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        6,
                        (_) => Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 36,
                                height: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 50,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // safety margin
                ],
              ),
            ),
          ),
        ),
      ),

      error: (_, __) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Failed to load team stats',
            style: TextStyle(color: theme.error, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
