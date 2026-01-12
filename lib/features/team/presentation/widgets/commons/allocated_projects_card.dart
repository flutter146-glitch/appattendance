// lib/features/team/presentation/widgets/allocated_projects_card.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class AllocatedProjectsCard extends StatelessWidget {
  final TeamMember member;

  const AllocatedProjectsCard({required this.member, super.key});

  @override
  Widget build(BuildContext context) {
    if (member.projectNames.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'No projects allocated',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allocated Projects (${member.projectNames.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...member.projectNames.map(
            (projectName) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.business_center, color: Colors.blue),
                title: Text(projectName),
                subtitle: const Text('Team: 0 members'), // Can be dynamic later
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
