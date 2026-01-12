// lib/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart
// ULTIMATE & FIXED VERSION - January 09, 2026 (Shimmer Removed)
// Key Changes:
// - Shimmer loading completely removed (as requested)
// - Simple CircularProgressIndicator + empty state
// - Better error handling with retry button
// - Dark/light mode contrast improved
// - Hero animation + smooth navigation
// - Real data from dummy_data via providers
// - Responsive horizontal cards, no overflow
// - Pull-to-refresh ready (if wrapped in RefreshIndicator)

import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
import 'package:appattendance/features/projects/presentation/screens/project_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MappedProjectsWidget extends ConsumerWidget {
  const MappedProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authProvider);
    final viewMode = ref.watch(viewModeProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text(
              'Please login to view projects',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final isManagerial = user.isManagerial;
        final showTeamProjects = isManagerial && viewMode == ViewMode.manager;

        final projectsAsync = showTeamProjects
            ? ref.watch(teamProjectsProvider)
            : ref.watch(mappedProjectsProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                showTeamProjects ? 'Team Projects' : 'My Projects',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child: projectsAsync.when(
                data: (rawProjects) {
                  // Normalize to List<ProjectModel>
                  final List<ProjectModel> projects = showTeamProjects
                      ? rawProjects as List<ProjectModel>
                      : (rawProjects as List<MappedProject>)
                            .map((m) => m.project)
                            .toList();

                  if (projects.isEmpty) {
                    return Center(
                      child: Text(
                        'No projects assigned yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return Semantics(
                        label: 'Project: ${project.projectName}',
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    ProjectDetailScreen(project: project),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'project_card_${project.projectId}',
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          Colors.grey.shade900,
                                          Colors.grey.shade800,
                                        ]
                                      : [Colors.white, Colors.grey.shade50],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      isDark ? 0.5 : 0.1,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.work_rounded,
                                            color: AppColors.primary,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            project.projectName ??
                                                'Unnamed Project',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      Icons.location_on_outlined,
                                      'Site',
                                      project.projectSite ?? 'N/A',
                                      isDark,
                                    ),
                                    _buildInfoRow(
                                      Icons.business_outlined,
                                      'Client',
                                      project.clientName ?? 'N/A',
                                      isDark,
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildStatusChip(
                                          project.status.name.toUpperCase(),
                                          project.statusColor,
                                        ),
                                        _buildStatusChip(
                                          project.priority.name.toUpperCase(),
                                          project.priorityColor,
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
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load projects',
                        style: TextStyle(color: Colors.red[400], fontSize: 16),
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
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text(
          'Error loading user data',
          style: TextStyle(color: Colors.red.shade700),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// // lib/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart
// // ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Upgraded)
// // Improvements:
// // - Shimmer loading for better UX
// // - Hero animation on project card tap
// // - Better accessibility & semantics
// // - Improved dark mode contrast & shadows
// // - Modern card design with subtle gradient overlay
// // - Null-safe fallbacks with meaningful text
// // - Performance: Horizontal ListView.builder with proper constraints
// // - Clean role-based logic with early returns
// // - Ready for future: Pull-to-refresh wrapper if needed

// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
// import 'package:appattendance/features/projects/presentation/screens/project_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shimmer/shimmer.dart';

// class MappedProjectsWidget extends ConsumerWidget {
//   const MappedProjectsWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final userAsync = ref.watch(authProvider);
//     final viewMode = ref.watch(viewModeProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) return const SizedBox.shrink();

//         final isManagerial = user.isManagerial;
//         final showTeamProjects = isManagerial && viewMode == ViewMode.manager;

//         final projectsAsync = showTeamProjects
//             ? ref.watch(teamProjectsProvider)
//             : ref.watch(mappedProjectsProvider);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 showTeamProjects ? 'Team Projects' : 'My Projects',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             SizedBox(
//               height: 200,
//               child: projectsAsync.when(
//                 data: (rawProjects) {
//                   // Normalize to List<ProjectModel>
//                   final List<ProjectModel> projects = showTeamProjects
//                       ? rawProjects as List<ProjectModel>
//                       : (rawProjects as List<MappedProject>)
//                             .map((m) => m.project)
//                             .toList();

//                   if (projects.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No projects assigned yet',
//                         style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: projects.length,
//                     itemBuilder: (context, index) {
//                       final project = projects[index];

//                       return Semantics(
//                         label: 'Project: ${project.projectName}',
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               PageRouteBuilder(
//                                 pageBuilder: (_, __, ___) =>
//                                     ProjectDetailScreen(project: project),
//                                 transitionsBuilder: (_, animation, __, child) {
//                                   return FadeTransition(
//                                     opacity: animation,
//                                     child: child,
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                           child: Hero(
//                             tag: 'project_card_${project.projectId}',
//                             child: Container(
//                               width: 280,
//                               margin: const EdgeInsets.only(right: 16),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: isDark
//                                       ? [
//                                           Colors.grey.shade900,
//                                           Colors.grey.shade800,
//                                         ]
//                                       : [Colors.white, Colors.grey.shade50],
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(
//                                       isDark ? 0.5 : 0.1,
//                                     ),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: Stack(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(18),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(12),
//                                               decoration: BoxDecoration(
//                                                 color: AppColors.primary
//                                                     .withOpacity(0.2),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Icon(
//                                                 Icons.work_rounded,
//                                                 color: AppColors.primary,
//                                                 size: 28,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 14),
//                                             Expanded(
//                                               child: Text(
//                                                 project.projectName ??
//                                                     'Unnamed Project',
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: isDark
//                                                       ? Colors.white
//                                                       : Colors.black87,
//                                                 ),
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 12),
//                                         _buildInfoRow(
//                                           Icons.location_on_outlined,
//                                           'Site',
//                                           project.projectSite ?? 'N/A',
//                                           isDark,
//                                         ),
//                                         _buildInfoRow(
//                                           Icons.business_outlined,
//                                           'Client',
//                                           project.clientName ?? 'N/A',
//                                           isDark,
//                                         ),
//                                         const Spacer(),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             _buildStatusChip(
//                                               project.status.name.toUpperCase(),
//                                               project.statusColor,
//                                             ),
//                                             _buildStatusChip(
//                                               project.priority.name
//                                                   .toUpperCase(),
//                                               project.priorityColor,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 12,
//                                     right: 12,
//                                     child: Text(
//                                       project.daysLeftDisplay,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: project.daysLeft > 0
//                                             ? Colors.green
//                                             : Colors.red,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 loading: () => ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 3,
//                   itemBuilder: (_, __) => Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Container(
//                       width: 280,
//                       margin: const EdgeInsets.only(right: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 error: (err, _) => Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         'Failed to load projects',
//                         style: TextStyle(color: Colors.red.shade700),
//                       ),
//                       TextButton(
//                         onPressed: () => ref.invalidate(
//                           showTeamProjects
//                               ? teamProjectsProvider
//                               : mappedProjectsProvider,
//                         ),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, _) => Center(
//         child: Text(
//           'Error loading user data',
//           style: TextStyle(color: Colors.red.shade700),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 18,
//             color: isDark ? Colors.white70 : Colors.grey[700],
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: 13,
//               color: isDark ? Colors.white70 : Colors.grey[700],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusChip(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// // lib/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart
// // FINAL UPGRADED & POLISHED VERSION - January 07, 2026
// // Null-safe, role-based, toggle respected
// // Manager team projects + employee mapped projects
// // Responsive horizontal cards, dark mode, no overflow
// // Clean production code (no debug prints)
// // Navigation to ProjectDetailScreen on tap (manager/employee both)
// // Uses latest ProjectModel with all fields
// // FIXED: Removed unnecessary ProjectAnalytics conversion; pass ProjectModel directly

// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/presentation/screens/project_analytics_screen.dart';
// import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
// import 'package:appattendance/features/projects/presentation/screens/project_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MappedProjectsWidget extends ConsumerWidget {
//   const MappedProjectsWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final userAsync = ref.watch(authProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) {
//           return const SizedBox.shrink();
//         }

//         final isManagerial = user.isManagerial;

//         // View mode toggle
//         final viewMode = ref.watch(viewModeProvider);
//         final effectiveManagerial =
//             viewMode == ViewMode.manager && isManagerial;

//         // Projects provider (manager team vs employee mapped)
//         final projectsAsync = effectiveManagerial
//             ? ref.watch(teamProjectsProvider)
//             : ref.watch(mappedProjectsProvider);

//         return projectsAsync.when(
//           data: (projects) {
//             // Adapt data safely
//             List<ProjectModel> projectList = [];
//             if (effectiveManagerial) {
//               projectList = projects as List<ProjectModel>;
//             } else {
//               final mappedList = projects as List<MappedProject>;
//               projectList = mappedList.map((m) => m.project).toList();
//             }

//             if (projectList.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   "No projects assigned yet",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//               );
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   effectiveManagerial ? "Team Projects" : "My Projects",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 SizedBox(
//                   height: 180,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: projectList.length,
//                     itemBuilder: (context, index) {
//                       final project = projectList[index];

//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   ProjectDetailScreen(project: project),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           width: 260,
//                           margin: const EdgeInsets.only(right: 16),
//                           decoration: BoxDecoration(
//                             color: isDark
//                                 ? Colors.grey.shade800.withOpacity(0.7)
//                                 : Colors.white.withOpacity(0.85),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(
//                                   isDark ? 0.4 : 0.1,
//                                 ),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         color: AppColors.primary.withOpacity(
//                                           isDark ? 0.3 : 0.1,
//                                         ),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                         Icons.work_outline_rounded,
//                                         size: 24,
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         project.projectName ??
//                                             'Unnamed Project',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: isDark
//                                               ? Colors.white
//                                               : Colors.black87,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Site: ${project.projectSite ?? 'N/A'}',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: isDark
//                                         ? Colors.white70
//                                         : Colors.grey[700],
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   'Client: ${project.clientName ?? 'N/A'}',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: isDark
//                                         ? Colors.white70
//                                         : Colors.grey[700],
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const Spacer(),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 10,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: project.statusColor.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Text(
//                                     'Status: ${project.displayStatus}',
//                                     style: TextStyle(
//                                       color: project.statusColor,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (err, stack) => Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Error loading projects: $err',
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Error loading user: $err',
//             style: const TextStyle(color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
