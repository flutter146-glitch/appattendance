// lib/features/leaves/presentation/widgets/apply_leave_notes_section.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ApplyLeaveNotesSection extends StatelessWidget {
  final TextEditingController controller;

  const ApplyLeaveNotesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason / Notes *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          maxLines: 5,
          minLines: 4,
          decoration: InputDecoration(
            hintText: 'Explain your leave reason in detail...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
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
          style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Reason is required';
            }
            if (value.trim().length < 20) {
              return 'Please provide more details (min 20 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }
}
