// lib/features/team/presentation/widgets/recent_attendance_list.dart
// ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Fully Upgraded)
// Key Upgrades:
// - Interactive Filter Chips (All/Present/Absent/Late) with real filtering
// - Shimmer loading placeholder
// - Modern card design with dark/light mode contrast
// - Hero animation ready for detail navigation (if needed later)
// - Better status colors & icons using AttendanceModel helpers
// - Empty state with icon
// - Responsive & accessible layout
// - Smooth list with proper spacing

import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

enum AttendanceFilter { all, present, absent, late }

class RecentAttendanceList extends StatefulWidget {
  final List<AttendanceModel> attendance;

  const RecentAttendanceList({required this.attendance, super.key});

  @override
  State<RecentAttendanceList> createState() => _RecentAttendanceListState();
}

class _RecentAttendanceListState extends State<RecentAttendanceList> {
  AttendanceFilter _selectedFilter = AttendanceFilter.all;

  List<AttendanceModel> get _filteredAttendance {
    switch (_selectedFilter) {
      case AttendanceFilter.all:
        return widget.attendance;
      case AttendanceFilter.present:
        return widget.attendance.where((a) => a.isPresent).toList();
      case AttendanceFilter.absent:
        return widget.attendance
            .where((a) => !a.isPresent && a.leaveType == null)
            .toList();
      case AttendanceFilter.late:
        return widget.attendance.where((a) => a.isLate).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.attendance.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No recent attendance records',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredAttendance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: AttendanceFilter.values.map((filter) {
              final label =
                  filter.name[0].toUpperCase() + filter.name.substring(1);
              final isSelected = _selectedFilter == filter;

              return FilterChip(
                label: Text(label),
                selected: isSelected,
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.blue[900]
                      : isDark
                      ? Colors.white70
                      : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Attendance List
          if (filtered.isEmpty)
            Center(
              child: Text(
                'No records match the selected filter',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final att = filtered[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: isDark ? Colors.grey[850] : Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: att.statusBackground,
                      child: Icon(
                        att.statusIcon,
                        color: att.statusColor,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      att.displayDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          att.quickStatusDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            color: att.isLate ? Colors.orange : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Check-in: ${att.formattedCheckIn}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${att.effectiveWorkedHours.toStringAsFixed(1)}h',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Worked',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Shimmer Loading Version (Optional - for parent widget to use)
class RecentAttendanceListLoading extends StatelessWidget {
  const RecentAttendanceListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          children: List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const SizedBox(height: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
