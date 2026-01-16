import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';

class EmployeeHeaderWidget extends StatelessWidget {
  final TeamMember employee;

  const EmployeeHeaderWidget({required this.employee, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors(context);

    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.isDark
                  ? [theme.onPrimary, theme.surface]
                  : [theme.primary, theme.primary.withOpacity(0.4)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with subtle shadow & border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          theme.isDark ? 0.4 : 0.2,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.surface,
                    child: Text(
                      employee.avatarInitial,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  employee.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.onPrimary,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Designation
                Text(
                  employee.designation ?? 'Employee',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.onPrimary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
