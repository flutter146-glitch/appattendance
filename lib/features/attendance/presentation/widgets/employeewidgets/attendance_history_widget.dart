import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryWidget extends ConsumerWidget {
  final TeamMember employee;

  const AttendanceHistoryWidget({required this.employee, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeColors(context);
    final selectedFilter = ref.watch(_historyFilterProvider);
    final filteredHistory = _filterHistory(
      employee.recentAttendanceHistory,
      selectedFilter,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Recent Attendance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Attendance History',
            style: TextStyle(fontSize: 14, color: theme.textSecondary),
          ),
        ),

        const SizedBox(height: 12),

        // Filter Tabs (All / Present / Absent / Late)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterTab(
                ref,
                'All',
                HistoryFilter.all,
                selectedFilter,
                theme,
              ),
              const SizedBox(width: 8),
              _buildFilterTab(
                ref,
                'Present',
                HistoryFilter.present,
                selectedFilter,
                theme,
              ),
              const SizedBox(width: 8),
              _buildFilterTab(
                ref,
                'Absent',
                HistoryFilter.absent,
                selectedFilter,
                theme,
              ),
              const SizedBox(width: 8),
              _buildFilterTab(
                ref,
                'Late',
                HistoryFilter.late,
                selectedFilter,
                theme,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // History Table
        filteredHistory.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No attendance records found',
                    style: TextStyle(fontSize: 16, color: theme.textSecondary),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final att = filteredHistory[index];
                  final statusColor = att.statusColor;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: theme.divider)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Date + Day
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(att.attendanceDate),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: theme.textPrimary,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEE').format(att.attendanceDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status chip
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: att.statusBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                att.status.name.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          // Check In
                          Expanded(
                            flex: 2,
                            child: Text(
                              att.checkInTime != null
                                  ? DateFormat('HH:mm').format(att.checkInTime!)
                                  : '--:--',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Check Out
                          Expanded(
                            flex: 2,
                            child: Text(
                              att.checkOutTime != null
                                  ? DateFormat(
                                      'HH:mm',
                                    ).format(att.checkOutTime!)
                                  : '--:--',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Hours
                          Expanded(
                            flex: 2,
                            child: Text(
                              att.workedHours != null
                                  ? '${att.workedHours!.toStringAsFixed(1)}h'
                                  : 'N/A',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: att.isPresent
                                    ? theme.success
                                    : att.isLate
                                    ? theme.warning
                                    : theme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildFilterTab(
    WidgetRef ref,
    String label,
    HistoryFilter filter,
    HistoryFilter selected,
    ThemeColors theme,
  ) {
    final isActive = selected == filter;

    return GestureDetector(
      onTap: () => ref.read(_historyFilterProvider.notifier).state = filter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? theme.primary : theme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? theme.onPrimary : theme.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  List<AttendanceModel> _filterHistory(
    List<AttendanceModel> history,
    HistoryFilter filter,
  ) {
    switch (filter) {
      case HistoryFilter.all:
        return history;
      case HistoryFilter.present:
        return history.where((a) => a.isPresent).toList();
      case HistoryFilter.absent:
        return history.where((a) => !a.isPresent && !a.isLate).toList();
      case HistoryFilter.late:
        return history.where((a) => a.isLate).toList();
    }
  }
}

// Local filter provider (can be moved to global if needed)
final _historyFilterProvider = StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.all,
);

enum HistoryFilter { all, present, absent, late }
