// lib/features/leaves/presentation/widgets/apply_leave_type_section.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:flutter/material.dart';

class ApplyLeaveTypeSection extends StatelessWidget {
  final LeaveType selectedType;
  final ValueChanged<LeaveType> onTypeChanged;

  const ApplyLeaveTypeSection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Type *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),

        DropdownButtonFormField<LeaveType>(
          value: selectedType,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey.shade700 : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: LeaveType.values.map((type) {
            return DropdownMenuItem<LeaveType>(
              value: type,
              child: Text(
                type.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onTypeChanged(val);
          },
          dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
        ),
      ],
    );
  }
}
