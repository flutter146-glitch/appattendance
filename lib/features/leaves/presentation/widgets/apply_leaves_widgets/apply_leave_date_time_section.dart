// lib/features/leaves/presentation/widgets/apply_leave_date_time_section.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplyLeaveDateTimeSection extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final bool isHalfDayFrom;
  final bool isHalfDayTo;
  final VoidCallback onFromDateTap;
  final VoidCallback onToDateTap;
  final VoidCallback onFromTimeTap;
  final VoidCallback onToTimeTap;
  final ValueChanged<bool> onHalfDayFromChanged;
  final ValueChanged<bool> onHalfDayToChanged;

  const ApplyLeaveDateTimeSection({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.isHalfDayFrom,
    required this.isHalfDayTo,
    required this.onFromDateTap,
    required this.onToDateTap,
    required this.onFromTimeTap,
    required this.onToTimeTap,
    required this.onHalfDayFromChanged,
    required this.onHalfDayToChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // From Row: Date + Time + Half Day
        _buildRow(
          context,
          label: 'From',
          date: fromDate,
          time: fromTime,
          onDateTap: onFromDateTap,
          onTimeTap: onFromTimeTap,
          isHalfDay: isHalfDayFrom,
          onHalfDayChanged: onHalfDayFromChanged,
        ),
        const SizedBox(height: 20),

        // To Row: Date + Time + Half Day
        _buildRow(
          context,
          label: 'To',
          date: toDate,
          time: toTime,
          onDateTap: onToDateTap,
          onTimeTap: onToTimeTap,
          isHalfDay: isHalfDayTo,
          onHalfDayChanged: onHalfDayToChanged,
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required bool isHalfDay,
    required ValueChanged<bool> onHalfDayChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),

        // Date + Time Fields
        Row(
          children: [
            Expanded(
              child: _buildField(
                context,
                icon: Icons.calendar_today,
                text: date == null
                    ? 'Select Date'
                    : DateFormat('dd/MM/yyyy').format(date),
                onTap: onDateTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField(
                context,
                icon: Icons.access_time,
                text: time == null ? 'Select Time' : time.format(context),
                onTap: onTimeTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Half Day Switch (compact & aligned)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Half Day',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Switch(
              value: isHalfDay,
              onChanged: onHalfDayChanged,
              activeColor: AppColors.primary,
              inactiveThumbColor: theme.colorScheme.outline,
              inactiveTrackColor: theme.colorScheme.surfaceVariant,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.grey.shade700 : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: text.contains('Select')
                      ? theme.hintColor
                      : theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// // lib/features/leaves/presentation/widgets/apply_leave_date_time_section.dart
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ApplyLeaveDateTimeSection extends StatelessWidget {
//   final DateTime? fromDate;
//   final DateTime? toDate;
//   final TimeOfDay? fromTime;
//   final TimeOfDay? toTime;
//   final bool isHalfDayFrom;
//   final bool isHalfDayTo;
//   final VoidCallback onFromDateTap;
//   final VoidCallback onToDateTap;
//   final VoidCallback onFromTimeTap;
//   final VoidCallback onToTimeTap;
//   final ValueChanged<bool> onHalfDayFromChanged;
//   final ValueChanged<bool> onHalfDayToChanged;

//   const ApplyLeaveDateTimeSection({
//     super.key,
//     required this.fromDate,
//     required this.toDate,
//     required this.fromTime,
//     required this.toTime,
//     required this.isHalfDayFrom,
//     required this.isHalfDayTo,
//     required this.onFromDateTap,
//     required this.onToDateTap,
//     required this.onFromTimeTap,
//     required this.onToTimeTap,
//     required this.onHalfDayFromChanged,
//     required this.onHalfDayToChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDatePicker('From Date', fromDate, onFromDateTap),
//         const SizedBox(height: 16),
//         _buildTimePicker('From Time', fromTime, onFromTimeTap),
//         SwitchListTile(
//           title: const Text('Half Day From'),
//           value: isHalfDayFrom,
//           onChanged: onHalfDayFromChanged,
//         ),
//         const SizedBox(height: 16),
//         _buildDatePicker('To Date', toDate, onToDateTap),
//         const SizedBox(height: 16),
//         _buildTimePicker('To Time', toTime, onToTimeTap),
//         SwitchListTile(
//           title: const Text('Half Day To'),
//           value: isHalfDayTo,
//           onChanged: onHalfDayToChanged,
//         ),
//       ],
//     );
//   }

//   Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: Text(
//           date == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(date),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimePicker(
//     BuildContext buildContext,
//     label,
//     TimeOfDay? time,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: Text(
//           time == null ? 'Select Time' : time.format(buildContext),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
