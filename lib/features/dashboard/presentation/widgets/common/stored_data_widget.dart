// lib/features/dashboard/presentation/widgets/common/stored_data_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoredDataWidget extends StatelessWidget {
  final List<Map<String, dynamic>> allAttendance;
  final List<Map<String, dynamic>> allProjects;
  final List<Map<String, dynamic>> allRegularization;

  const StoredDataWidget({
    super.key,
    required this.allAttendance,
    required this.allProjects,
    required this.allRegularization,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Projects Section
        _buildSection(
          title: '🏢 Mapped Projects (${allProjects.length})',
          child: allProjects.isEmpty
              ? _buildEmptyState('No projects found')
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allProjects.length,
            itemBuilder: (context, index) {
              final project = allProjects[index];
              return _buildProjectCard(project);
            },
          ),
        ),

        const SizedBox(height: 20),
        // Attendance Records Section
        _buildSection(
          title: '📅 Attendance Records (${allAttendance.length})',
          child: allAttendance.isEmpty
              ? _buildEmptyState('No attendance records found')
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allAttendance.length > 10 ? 10 : allAttendance.length,
            itemBuilder: (context, index) {
              final att = allAttendance[index];
              return _buildAttendanceCard(att);
            },
          ),
        ),

        const SizedBox(height: 20),

        // Regularization Section
        _buildSection(
          title: '📝 Regularization Requests (${allRegularization.length})',
          child: allRegularization.isEmpty
              ? _buildEmptyState('No regularization requests')
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allRegularization.length > 5 ? 5 : allRegularization.length,
            itemBuilder: (context, index) {
              final reg = allRegularization[index];
              return _buildRegularizationCard(reg);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> att) {
    final timestamp = att['att_timestamp'] as String?;
    final status = att['att_status'] as String?;
    final isSynced = att['is_synced'] == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          status == 'checkin' ? Icons.login : Icons.logout,
          color: status == 'checkin' ? Colors.green : Colors.red,
        ),
        title: Text(
          status?.toUpperCase() ?? 'UNKNOWN',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          timestamp != null
              ? DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(timestamp))
              : 'No timestamp',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSynced ? Icons.cloud_done : Icons.cloud_off,
              color: isSynced ? Colors.green : Colors.orange,
              size: 20,
            ),
            Text(
              isSynced ? 'Synced' : 'Pending',
              style: TextStyle(
                fontSize: 10,
                color: isSynced ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final projectName = project['project_name'] as String?;
    final clientName = project['client_name'] as String?;
    final techStack = project['project_techstack'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.work, color: Colors.blue),
        title: Text(
          projectName ?? 'Unknown Project',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (clientName != null) Text('Client: $clientName'),
            if (techStack != null) Text('Tech: $techStack'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildRegularizationCard(Map<String, dynamic> reg) {
    final regType = reg['reg_type'] as String?;
    final appliedForDate = reg['reg_applied_for_date'] as String?;
    final status = reg['reg_approval_status'] as String?;
    final isSynced = reg['is_synced'] == 1;

    Color statusColor;
    switch (status?.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.edit_calendar, color: statusColor),
        title: Text(
          regType?.toUpperCase() ?? 'REGULARIZATION',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          appliedForDate != null
              ? 'For: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(appliedForDate))}'
              : 'No date',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status?.toUpperCase() ?? 'PENDING',
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              isSynced ? Icons.cloud_done : Icons.cloud_off,
              color: isSynced ? Colors.green : Colors.orange,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}