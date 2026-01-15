// lib/features/attendance/presentation/widgets/employee_info_card.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class EmployeeInfoCard extends StatelessWidget {
  final TeamMember employee;

  const EmployeeInfoCard({required this.employee, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  employee.designation ?? 'Employee',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, employee.email ?? 'Not provided'),
            _buildInfoRow(Icons.phone, employee.phone ?? 'Not provided'),
            Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Status: ${employee.status.name}',
                  style: TextStyle(
                    color: employee.statusColor,
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

  Widget _buildInfoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
