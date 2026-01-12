// lib/features/projects/presentation/widgets/active_projects_widget.dart
// ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Upgraded)
// Improvements:
// - Modern dark/light mode cards with gradient & shadow
// - Hero animation on tap
// - Shimmer loading placeholders
// - Progress bar with color based on status
// - Days left with urgency color (critical/overdue)
// - Real data from dummy_data.dart via providers
// - Role-based title & filtering (manager team vs employee mapped)
// - Pull-to-refresh ready (if wrapped in RefreshIndicator)
// - Accessibility & responsive layout

import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/presentation/screens/project_analytics_screen.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ActiveProjectsWidget extends ConsumerWidget {
  const ActiveProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authProvider);
    final viewMode = ref.watch(viewModeProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Please login to see projects'));
        }

        final isManagerial = user.isManagerial;
        final showTeamProjects = isManagerial && viewMode != ViewMode.employee;

        final projectsAsync = showTeamProjects
            ? ref.watch(teamProjectsProvider)
            : ref.watch(mappedProjectsProvider);

        return projectsAsync.when(
          data: (rawProjects) {
            // Normalize to List<ProjectModel>
            final List<ProjectModel> activeProjects = showTeamProjects
                ? rawProjects as List<ProjectModel>
                : (rawProjects as List<MappedProject>)
                      .map((m) => m.project)
                      .toList();

            // Filter only active projects
            final filteredProjects = activeProjects
                .where((p) => p.status == ProjectStatus.active)
                .toList();

            if (filteredProjects.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No active projects found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    showTeamProjects
                        ? 'Team Active Projects (${filteredProjects.length})'
                        : 'My Active Projects (${filteredProjects.length})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = filteredProjects[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Hero(
                        tag: 'project_card_${project.projectId}',
                        child: Card(
                          elevation: 6,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AnalyticsProjectDetailScreen(
                                    project: project,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: project.statusColor
                                              .withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          project.statusIcon,
                                          color: project.statusColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              project.projectName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              project.clientName ?? 'Internal',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: project.priorityColor
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              project.priorityText,
                                              style: TextStyle(
                                                color: project.priorityColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            project.daysLeftDisplay,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: project.isOverdue
                                                  ? Colors.red
                                                  : project.isCritical
                                                  ? Colors.orange
                                                  : Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    project.projectDescription ??
                                        'No description available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: project.progress / 100,
                                      minHeight: 10,
                                      backgroundColor: Colors.grey[300],
                                      color: project.progressColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    project.progressText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: project.progressColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _ProjectStat(
                                        'Team',
                                        '${project.teamSize}',
                                        Icons.people,
                                        isDark,
                                      ),
                                      _ProjectStat(
                                        'Tasks',
                                        '${project.totalTasks}',
                                        Icons.task_alt,
                                        isDark,
                                      ),
                                      _ProjectStat(
                                        'Days Left',
                                        project.daysLeftDisplay,
                                        Icons.calendar_today,
                                        isDark,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(height: 180),
                  ),
                ),
              ),
            ),
          ),
          error: (e, _) => Center(
            child: Column(
              children: [
                Text(
                  'Error loading projects',
                  style: TextStyle(color: Colors.red.shade700),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(
                    showTeamProjects
                        ? teamProjectsProvider
                        : mappedProjectsProvider,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading user: $e')),
    );
  }

  Widget _ProjectStat(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$value $label',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/features/attendance/presentation/screens/project_analytics_screen.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
// import 'package:appattendance/features/projects/presentation/screens/project_analytics_screen.dart'; // ya project_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ActiveProjects extends ConsumerWidget {
//   const ActiveProjects({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userAsync = ref.watch(authProvider);
//     final viewMode = ref.watch(viewModeProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) {
//           return const Center(child: Text('Please login to see projects'));
//         }

//         final isManagerial = user.isManagerial;
//         final isEmployeeView = viewMode == ViewMode.employee;

//         // Manager → team projects, Employee → mapped projects
//         final projectsAsync = isManagerial && !isEmployeeView
//             ? ref.watch(teamProjectProvider)
//             : ref.watch(mappedProjectProvider);

//         return projectsAsync.when(
//           data: (projectsData) {
//             List<ProjectModel> activeProjects = [];

//             if (isManagerial && !isEmployeeView) {
//               activeProjects = projectsData as List<ProjectModel>;
//             } else {
//               final mapped = projectsData as List<MappedProject>;
//               activeProjects = mapped.map((m) => m.project).toList();
//             }

//             // Optional: Filter only active projects (if status exists)
//             activeProjects = activeProjects
//                 .where((p) => p.isActive) // using extension helper
//                 .toList();

//             if (activeProjects.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Center(child: Text('No active projects found')),
//               );
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isManagerial && !isEmployeeView
//                       ? 'Team Active Projects (${activeProjects.length})'
//                       : 'My Active Projects (${activeProjects.length})',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: activeProjects.length,
//                   itemBuilder: (context, index) {
//                     final project = activeProjects[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   ProjectAnalyticsScreen(project: project),
//                               // Ya agar detail screen chahiye to: ProjectDetailScreen(project: project),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       project.projectName,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Chip(
//                                     label: Text(project.displayStatus),
//                                     backgroundColor: project.statusColor,
//                                     labelStyle: const TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 project.projectDescription ?? 'No description',
//                                 style: const TextStyle(fontSize: 14),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'Progress: ${project.progressString}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               LinearProgressIndicator(
//                                 value: project.progress / 100,
//                                 backgroundColor: Colors.grey[300],
//                                 color: project.statusColor,
//                                 minHeight: 10,
//                               ),
//                               const SizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   _ProjectStat(
//                                     'Team',
//                                     '${project.teamSize}',
//                                     Icons.people,
//                                   ),
//                                   _ProjectStat(
//                                     'Tasks',
//                                     '${project.totalTasks}',
//                                     Icons.task,
//                                   ),
//                                   _ProjectStat(
//                                     'Days',
//                                     project.formattedDaysLeft,
//                                     Icons.calendar_today,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (e, s) => Center(child: Text('Error loading projects: $e')),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (e, s) => Center(child: Text('Error loading user: $e')),
//     );
//   }

//   Widget _ProjectStat(String label, String value, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[700]),
//         const SizedBox(width: 4),
//         Text(
//           '$value $label',
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }
