// lib/features/team/presentation/widgets/member_card.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback onTap;

  const MemberCard({required this.member, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: member.profilePhotoUrl != null
                    ? NetworkImage(member.profilePhotoUrl!)
                    : null,
                child: member.profilePhotoUrl == null
                    ? Text(member.avatarInitial)
                    : null,
                backgroundColor: Colors.blue[100],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayNameWithRole,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email ?? 'No email',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: member.statusBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member.status.name.toUpperCase(),
                      style: TextStyle(color: member.statusColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.quickStats,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
