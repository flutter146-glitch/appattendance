// lib/features/dashboard/presentation/widgets/managerwidgets/manager_quick_actions.dart
// Upgraded: Dynamic actions based on UserModel privileges (R01-R08)
// Uses extension helpers (canViewTeamAttendance, canApproveLeaves etc.)
// Null-safe, role-based, beautiful gradient cards
// Current date: December 29, 2025

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

// // lib/features/dashboard/presentation/widgets/managerwidgets/manager_quick_actions.dart

// import 'package:flutter/material.dart';

// class ManagerQuickActions extends StatelessWidget {
//   final VoidCallback onAttendanceTap;
//   final VoidCallback onEmployeesTap;

//   const ManagerQuickActions({
//     super.key,
//     required this.onAttendanceTap,
//     required this.onEmployeesTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     Widget _buildActionCard({
//       required String title,
//       required String subtitle,
//       required IconData icon,
//       required Color color,
//       required VoidCallback onTap,
//     }) {
//       return Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               color.withOpacity(isDark ? 0.9 : 1.0),
//               color.withOpacity(isDark ? 0.7 : 0.8),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(isDark ? 0.5 : 0.3),
//               blurRadius: 16,
//               offset: Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           child: InkWell(
//             onTap: onTap, // ← Direct onTap pass kiya
//             borderRadius: BorderRadius.circular(20),
//             child: Padding(
//               padding: EdgeInsets.all(5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Icon(icon, color: Colors.white, size: 16),
//                   ),

//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(height: 0),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white.withOpacity(0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   "Quick Actions",
//           //   style: TextStyle(
//           //     fontSize: 20,
//           //     fontWeight: FontWeight.bold,
//           //     color: isDark ? Colors.white : Colors.black87,
//           //   ),
//           // ),
//           // SizedBox(height: 5),
//           Divider(color: isDark ? Colors.white24 : Colors.white),
//           GridView.count(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.6,
//             children: [
//               _buildActionCard(
//                 title: "Team Attendance",
//                 subtitle: "",
//                 icon: Icons.assignment_turned_in_rounded,
//                 color: isDark ? Colors.blue.shade700 : Colors.blue.shade600,
//                 onTap: onAttendanceTap,
//               ),
//               _buildActionCard(
//                 title: "Team Members",
//                 subtitle: "",
//                 icon: Icons.people_alt_rounded,
//                 color: isDark ? Colors.orange.shade700 : Colors.orange.shade600,
//                 onTap: onEmployeesTap,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/managerwidgets/manager_quick_actions.dart

// import 'package:flutter/material.dart';

// class ManagerQuickActions extends StatelessWidget {
//   final VoidCallback onAttendanceTap;
//   final VoidCallback onEmployeesTap;

//   const ManagerQuickActions({
//     super.key,
//     required this.onAttendanceTap,
//     required this.onEmployeesTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Quick Actions",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//           SizedBox(height: 16),

//           GridView.count(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.6,
//             children: [
//               _buildActionCard(
//                 title: "Team Attendance",
//                 subtitle: "View & approve attendance",
//                 icon: Icons.assignment_turned_in_rounded,
//                 color: isDark ? Colors.blue.shade700 : Colors.blue.shade600,
//                 onTap: onAttendanceTap,
//               ),
//               _buildActionCard(
//                 title: "Team Members",
//                 subtitle: "Manage employees & roles",
//                 icon: Icons.people_alt_rounded,
//                 color: isDark ? Colors.orange.shade700 : Colors.orange.shade600,
//                 onTap: onEmployeesTap,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCard({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             color.withOpacity(isDark ? 0.9 : 1.0),
//             color.withOpacity(isDark ? 0.7 : 0.8),
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(isDark ? 0.5 : 0.3),
//             blurRadius: 16,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(20),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Icon(icon, color: Colors.white, size: 32),
//                 ),

//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.white.withOpacity(0.9),
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
