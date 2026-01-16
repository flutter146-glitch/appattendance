// lib/features/dashboard/presentation/widgets/managerwidgets/metrics_counter.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/domain/models/user_role.dart';
import 'package:appattendance/features/auth/domain/models/user_db_mapper.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MetricsCounter extends ConsumerWidget {
  const MetricsCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return dashboardAsync.when(
      data: (state) {
        final user = state.user;
        if (user == null || !user.isManagerial) {
          return const SizedBox.shrink(); // Employee ke liye hide
        }

        final attendancePercent = state.teamSize > 0
            ? (state.presentToday / state.teamSize * 100)
            : 0.0;

        // Dummy for now - real mein projects DB se aayenge
        final projectsCount =
            5; // TODO: Real query from employee_mapped_projects

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              final childAspectRatio = crossAxisCount == 4 ? 1.6 : 1.4;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMetricCard(
                    title: "PROJECTS",
                    value: projectsCount.toString(),
                    icon: Icons.folder_special_rounded,
                    color: Colors.orange,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: "TEAM",
                    value: state.teamSize.toString(),
                    icon: Icons.groups_rounded,
                    color: Colors.cyan,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: "PRESENT",
                    value: "${attendancePercent.round()}%",
                    subtitle: "${state.presentToday} of ${state.teamSize}",
                    icon: Icons.how_to_reg_rounded,
                    color: Colors.green,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: "TIMESHEET",
                    value: "Pending", // TODO: Real timesheet status
                    icon: Icons.timeline_rounded,
                    color: Colors.purple,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error loading metrics: $err")),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isDark ? 0.25 : 0.15),
            color.withOpacity(isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.4 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: FittedBox(child: Icon(icon, size: 48, color: color)),
            ),
            const SizedBox(height: 8),
            Flexible(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/managerwidgets/metrics_counter.dart

// import 'package:flutter/material.dart';

// class MetricsCounter extends StatelessWidget {
//   final int projectsCount;
//   final int teamSize;
//   final int presentToday;
//   final String timesheetPeriod;

//   const MetricsCounter({
//     super.key,
//     required this.projectsCount,
//     required this.teamSize,
//     required this.presentToday,
//     required this.timesheetPeriod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final double attendancePercent = teamSize > 0
//         ? (presentToday / teamSize * 100)
//         : 0.0;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
//           final childAspectRatio = crossAxisCount == 4 ? 1.6 : 1.4;

//           return GridView.count(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             crossAxisCount: crossAxisCount,
//             childAspectRatio: childAspectRatio,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             children: [
//               _buildMetricCard(
//                 title: "PROJECTS",
//                 value: projectsCount.toString(),
//                 icon: Icons.folder_special_rounded,
//                 color: Colors.orange,
//                 isDark: isDark,
//               ),
//               _buildMetricCard(
//                 title: "TEAM",
//                 value: teamSize.toString(),
//                 icon: Icons.groups_rounded,
//                 color: Colors.cyan,
//                 isDark: isDark,
//               ),
//               _buildMetricCard(
//                 title: "PRESENT",
//                 value: "${attendancePercent.round()}%",
//                 subtitle: "$presentToday of $teamSize",
//                 icon: Icons.how_to_reg_rounded,
//                 color: Colors.green,
//                 isDark: isDark,
//               ),
//               _buildMetricCard(
//                 title: "TIMESHEET",
//                 value: timesheetPeriod,
//                 icon: Icons.timeline_rounded,
//                 color: Colors.purple,
//                 isDark: isDark,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMetricCard({
//     required String title,
//     required String value,
//     String? subtitle,
//     required IconData icon,
//     required Color color,
//     required bool isDark,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             color.withOpacity(isDark ? 0.25 : 0.15),
//             color.withOpacity(isDark ? 0.15 : 0.08),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: color.withOpacity(0.5), width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(isDark ? 0.4 : 0.2),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(2),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Flexible(
//               flex: 2,
//               child: FittedBox(child: Icon(icon, size: 48, color: color)),
//             ),
//             SizedBox(height: 0),

//             Flexible(
//               flex: 3,
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w900,
//                     color: color,
//                   ),
//                 ),
//               ),
//             ),

//             if (subtitle != null)
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isDark ? Colors.white70 : Colors.grey[700],
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),

//             SizedBox(height: 0),

//             Flexible(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w800,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // lib/features/dashboard/presentation/widgets/managerwidgets/metrics_counter.dart

// import 'package:flutter/material.dart';

// class MetricsCounter extends StatelessWidget {
//   final int projectsCount;
//   final int teamSize;
//   final int presentToday;
//   final String timesheetPeriod; // "Q4 2025"

//   const MetricsCounter({
//     super.key,
//     required this.projectsCount,
//     required this.teamSize,
//     required this.presentToday,
//     required this.timesheetPeriod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Calculate attendance percentage
//     final double attendancePercent = teamSize > 0
//         ? (presentToday / teamSize * 100)
//         : 0;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isLandscape =
//             MediaQuery.of(context).orientation == Orientation.landscape;
//         final crossAxisCount = isLandscape ? 4 : 2;
//         final childAspectRatio = isLandscape ? 1.4 : 1.3;

//         return GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: crossAxisCount,
//           childAspectRatio: childAspectRatio,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//           children: [
//             _buildMetricCard(
//               title: "PROJECTS",
//               value: projectsCount.toString(),
//               icon: Icons.folder_rounded,
//               color: Colors.orange,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "TEAM",
//               value: teamSize.toString(),
//               icon: Icons.people_alt_rounded,
//               color: Colors.cyan,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "ATTENDANCE",
//               value: "${attendancePercent.round()}%",
//               icon: Icons.bar_chart_rounded,
//               color: Colors.green,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "TIMESHEET",
//               value: timesheetPeriod,
//               icon: Icons.timeline_rounded,
//               color: Colors.purple,
//               isDark: isDark,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildMetricCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required bool isDark,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: color.withOpacity(isDark ? 0.5 : 0.4),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(isDark ? 0.4 : 0.25),
//             blurRadius: 16,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon in circle
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(isDark ? 0.25 : 0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 48, color: color),
//             ),
//             const SizedBox(height: 20),

//             // Big Value
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 44,
//                 fontWeight: FontWeight.w900,
//                 color: color,
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Title
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
//                 letterSpacing: 1.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/managerwidgets/metrics_counter.dart

// import 'package:flutter/material.dart';

// class MetricsCounter extends StatelessWidget {
//   final int projectsCount;
//   final int teamSize;
//   final int presentToday;
//   final String timesheetPeriod; // "Q4 2025"

//   const MetricsCounter({
//     super.key,
//     required this.projectsCount,
//     required this.teamSize,
//     required this.presentToday,
//     required this.timesheetPeriod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Calculate attendance percentage
//     final double attendancePercent = teamSize > 0
//         ? (presentToday / teamSize * 100)
//         : 0;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isLandscape =
//             MediaQuery.of(context).orientation == Orientation.landscape;
//         final crossAxisCount = isLandscape ? 4 : 2;
//         final childAspectRatio = isLandscape ? 1.3 : 1.4;

//         return GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: crossAxisCount,
//           childAspectRatio: childAspectRatio,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildMetricCard(
//               title: "PROJECTS",
//               value: projectsCount.toString(),
//               icon: Icons.folder_rounded,
//               color: Colors.orange,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "TEAM",
//               value: teamSize.toString(),
//               icon: Icons.people_alt_rounded,
//               color: Colors.cyan,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "ATTENDANCE",
//               value: "${attendancePercent.round()}%",
//               icon: Icons.bar_chart_rounded,
//               color: Colors.green,
//               isDark: isDark,
//             ),
//             _buildMetricCard(
//               title: "TIMESHEET",
//               value: timesheetPeriod,
//               icon: Icons.timeline_rounded,
//               color: Colors.purple,
//               isDark: isDark,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildMetricCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required bool isDark,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDark ? color.withOpacity(0.4) : color.withOpacity(0.3),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(isDark ? 0.3 : 0.2),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(isDark ? 0.2 : 0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 36, color: color),
//             ),
//             const SizedBox(height: 16),

//             // Value
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.w800,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Title
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
