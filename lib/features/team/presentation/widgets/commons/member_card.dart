// lib/features/team/presentation/widgets/member_card.dart

import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback onTap;

  const MemberCard({required this.member, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: theme.isDark ? 1 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundImage: member.profilePhotoUrl != null
                    ? NetworkImage(member.profilePhotoUrl!)
                    : null,
                child: member.profilePhotoUrl == null
                    ? Text(
                        member.avatarInitial,
                        style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                backgroundColor: theme.primary.withOpacity(0.15),
              ),
              const SizedBox(width: 16),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayNameWithRole,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: theme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email ?? 'No email',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Status badge + quick stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: member.statusColor(theme).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member.statusBadgeText,
                      style: TextStyle(
                        color: member.statusColor(theme),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.quickStats,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                color: theme.textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
