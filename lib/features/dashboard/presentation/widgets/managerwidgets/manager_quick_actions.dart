// lib/features/dashboard/presentation/widgets/managerwidgets/manager_quick_actions.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/team/presentation/screens/team_member_list_screen.dart.dart';
import 'package:flutter/material.dart';

class ManagerQuickActions extends StatelessWidget {
  final UserModel? user;

  const ManagerQuickActions({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isManagerial = user?.isManagerial ?? false;

    // Only show if managerial role
    if (!isManagerial) return const SizedBox.shrink();

    // Dynamic quick actions based on privileges
    final actions = <Map<String, dynamic>>[];

    // Team Attendance (R03-R08 + R01)
    if (user!.canViewTeamAttendance) {
      actions.add({
        'title': 'Team Attendance',
        'subtitle': '',
        'icon': Icons.assignment_turned_in_rounded,
        'color': Colors.blue,
        'onTap': () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceScreen()),
          );
        },
      });
    }

    // Team Members (R03-R08 + R01)
    if (user!.canViewTeamAttendance) {
      actions.add({
        'title': 'Team Members',
        'subtitle': '',
        'icon': Icons.people_alt_rounded,
        'color': Colors.cyan,
        'onTap': () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TeamMemberListScreen()),
          );
        },
      });
    }

    // Default fallback if no privileges match
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: actions
                .map(
                  (action) => _buildActionCard(
                    title: action['title'] as String,
                    subtitle: action['subtitle'] as String,
                    icon: action['icon'] as IconData,
                    color: action['color'] as Color,
                    onTap: action['onTap'] as VoidCallback,
                    isDark: isDark,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isDark ? 0.9 : 1.0),
            color.withOpacity(isDark ? 0.7 : 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.5 : 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
