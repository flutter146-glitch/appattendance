import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class EmployeeInfoCard extends StatelessWidget {
  final TeamMember employee;

  const EmployeeInfoCard({required this.employee, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors(context);

    return Card(
      elevation: theme.isDark ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Designation row
            Row(
              children: [
                Icon(
                  Icons.work_outline_rounded,
                  color: theme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  employee.designation ?? 'Employee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Email
            _buildInfoRow(
              icon: Icons.email_outlined,
              value: employee.email ?? 'Not provided',
              iconColor: theme.textSecondary,
              theme: theme,
            ),

            const SizedBox(height: 12),

            // Phone
            _buildInfoRow(
              icon: Icons.phone_outlined,
              value: employee.phone ?? 'Not provided',
              iconColor: theme.textSecondary,
              theme: theme,
            ),

            const SizedBox(height: 12),

            // Status with dot
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: employee.statusColor(theme),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: ${employee.status.name}',
                  style: TextStyle(
                    color: employee.statusColor(theme),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String value,
    required Color iconColor,
    required ThemeColors theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: theme.textPrimary),
          ),
        ),
      ],
    );
  }
}
