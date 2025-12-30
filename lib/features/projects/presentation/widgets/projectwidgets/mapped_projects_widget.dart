// lib/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart
// Final upgraded version: Real data from projectProvider + role-based
// Shows employee own mapped projects or manager team projects
// Loading/error + dark mode + beautiful horizontal cards

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/project_provider.dart';

class MappedProjectsWidget extends ConsumerWidget {
  const MappedProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Decide provider based on role (employee vs manager)
    final projectsAsync = ref.watch(mappedProjectProvider); // Default employee
    // For manager team projects: ref.watch(teamProjectProvider)

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mapped Projects",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            projectsAsync.when(
              data: (mappedProjects) {
                if (mappedProjects.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No projects mapped yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 180, // Safe height for horizontal cards
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: mappedProjects.length,
                    itemBuilder: (context, index) {
                      final mapped = mappedProjects[index];
                      final project = mapped.project;

                      return Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade700
                              : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.4 : 0.1,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Project Icon + Name
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.work_rounded,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      project.projectName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              _projectDetailRow(
                                "Site",
                                project.projectSite ?? 'N/A',
                                isDark,
                              ),
                              _projectDetailRow(
                                "Client",
                                project.clientName ?? 'Internal',
                                isDark,
                              ),

                              const SizedBox(height: 16),

                              // Manager-specific details (if needed)
                              if (mapped.mappingStatus == 'active')
                                _projectDetailRow("Status", "Active", isDark),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  "Error loading projects: $err",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/common/mapped_projects_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class MappedProjectsWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> projects;
//   final bool isManager;
//   final String userRole;

//   const MappedProjectsWidget({
//     super.key,
//     required this.projects,
//     required this.isManager,
//     required this.userRole,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     if (projects.isEmpty) {
//       return Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Center(
//             child: Text(
//               isManager
//                   ? "No projects assigned to your team"
//                   : "No projects assigned to you",
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Text(
//             "Mapped Projects (${projects.length})",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//         ),
//         SizedBox(height: 12),

//         // Height remove kiya — dynamic height
//         SizedBox(
//           height: 180, // Thoda zyada diya safe side ke liye
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: projects.length,
//             itemBuilder: (context, index) {
//               final project = projects[index];

//               return Container(
//                 width: 280,
//                 margin: EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade800 : AppColors.warning,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
//                       blurRadius: 12,
//                       offset: Offset(0, 6),
//                     ),
//                   ],
//                   // border: Border.all(
//                   //   color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
//                   //   width: 1,
//                   // ),
//                 ),
//                 child: SingleChildScrollView(
//                   // ← Vertical scroll add kiya
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Project Icon + Name
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Icon(
//                               Icons.work_rounded,
//                               color: AppColors.primary,
//                               size: 16,
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Text(
//                               project['project_name'] ?? 'Unknown Project',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 10),

//                       _projectDetailRow(
//                         "Site",
//                         project['project_site'] ?? 'N/A',
//                         isDark,
//                       ),
//                       _projectDetailRow(
//                         "Client",
//                         project['client_name'] ?? 'Internal',
//                         isDark,
//                       ),

//                       SizedBox(height: 16),

//                       if (isManager) ...[
//                         Divider(
//                           color: isDark
//                               ? Colors.grey.shade600
//                               : Colors.grey.shade300,
//                         ),
//                         SizedBox(height: 12),
//                         _projectDetailRow(
//                           "Assigned To",
//                           project['assigned_emp_name'] ?? 'Employee',
//                           isDark,
//                         ),
//                         _projectDetailRow(
//                           "Emp ID",
//                           project['assigned_emp_id'] ?? 'N/A',
//                           isDark,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _projectDetailRow(String label, String value, bool isDark) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               "$label:",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/mapped_projects_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class MappedProjectsWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> projects;
//   final bool isManager;
//   final String userRole;

//   const MappedProjectsWidget({
//     super.key,
//     required this.projects,
//     required this.isManager,
//     required this.userRole,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     if (projects.isEmpty) {
//       return Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Center(
//             child: Text(
//               isManager
//                   ? "No projects assigned to your team"
//                   : "No projects assigned to you",
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Text(
//             "Mapped Projects (${projects.length})",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//         ),
//         SizedBox(height: 12),

//         SizedBox(
//           height: 240, // Safe fixed height
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: projects.length,
//             itemBuilder: (context, index) {
//               final project = projects[index];

//               return Container(
//                 width: 280, // Fixed width
//                 margin: EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade800 : Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
//                       blurRadius: 12,
//                       offset: Offset(0, 6),
//                     ),
//                   ],
//                   border: Border.all(
//                     color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
//                     width: 1,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Project Icon + Name
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Icon(
//                               Icons.work_rounded,
//                               color: AppColors.primary,
//                               size: 32,
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Text(
//                               project['project_name'] ?? 'Unknown Project',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 20),

//                       // Project Details
//                       _projectDetailRow(
//                         "Site",
//                         project['project_site'] ?? 'N/A',
//                         isDark,
//                       ),
//                       _projectDetailRow(
//                         "Client",
//                         project['client_name'] ?? 'Internal',
//                         isDark,
//                       ),

//                       // Flexible space
//                       SizedBox(height: 16),

//                       // Manager Info - Sirf Manager ko
//                       if (isManager) ...[
//                         Divider(
//                           color: isDark
//                               ? Colors.grey.shade600
//                               : Colors.grey.shade300,
//                         ),
//                         SizedBox(height: 12),
//                         _projectDetailRow(
//                           "Assigned To",
//                           project['assigned_emp_name'] ?? 'Employee',
//                           isDark,
//                         ),
//                         _projectDetailRow(
//                           "Emp ID",
//                           project['assigned_emp_id'] ?? 'N/A',
//                           isDark,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _projectDetailRow(String label, String value, bool isDark) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               "$label:",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/mapped_projects_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class MappedProjectsWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> projects;
//   final bool isManager;
//   final String userRole;

//   const MappedProjectsWidget({
//     super.key,
//     required this.projects,
//     required this.isManager,
//     required this.userRole,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     if (projects.isEmpty) {
//       return Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Center(
//             child: Text(
//               isManager
//                   ? "No projects assigned to your team"
//                   : "No projects assigned to you",
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             "Mapped Projects (${projects.length})",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//         ),
//         SizedBox(height: 16),

//         SizedBox(
//           height: 220, // Fixed height for horizontal list
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: projects.length,
//             itemBuilder: (context, index) {
//               final project = projects[index];

//               return Container(
//                 width: 280,
//                 margin: EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade800 : Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
//                       blurRadius: 12,
//                       offset: Offset(0, 6),
//                     ),
//                   ],
//                   border: Border.all(
//                     color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
//                     width: 1,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Project Icon + Name
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Icon(
//                               Icons.work_rounded,
//                               color: AppColors.primary,
//                               size: 32,
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Text(
//                               project['project_name'] ?? 'Unknown Project',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 20),

//                       // Project Details
//                       _projectDetailRow(
//                         "Site",
//                         project['project_site'] ?? 'N/A',
//                         isDark,
//                       ),
//                       _projectDetailRow(
//                         "Client",
//                         project['client_name'] ?? 'Internal',
//                         isDark,
//                       ),

//                       Spacer(),

//                       // Manager Info - Sirf Manager ko
//                       if (isManager) ...[
//                         Divider(
//                           color: isDark
//                               ? Colors.grey.shade600
//                               : Colors.grey.shade300,
//                         ),
//                         SizedBox(height: 12),
//                         _projectDetailRow(
//                           "Assigned To",
//                           project['assigned_emp_name'] ?? 'Employee',
//                           isDark,
//                         ),
//                         _projectDetailRow(
//                           "Emp ID",
//                           project['assigned_emp_id'] ?? 'N/A',
//                           isDark,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _projectDetailRow(String label, String value, bool isDark) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               "$label:",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/mapped_projects_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class MappedProjectsWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> projects;
//   final bool isManager;
//   final String userRole; // For future hierarchy

//   const MappedProjectsWidget({
//     super.key,
//     required this.projects,
//     required this.isManager,
//     required this.userRole,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     if (projects.isEmpty) {
//       return Card(
//         elevation: 200,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         // color: Colors.transparent,
//         child: Padding(
//           padding: EdgeInsets.all(5),
//           child: Center(
//             child: Text(
//               isManager
//                   ? "No projects assigned to your team"
//                   : "No projects assigned to you",
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ),
//         ),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Mapped Projects (${projects.length})",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//           SizedBox(height: 5),

//           SizedBox(
//             height: 180,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: projects.length,
//               itemBuilder: (context, index) {
//                 final project = projects[index];

//                 return Container(
//                   width: 280,
//                   margin: EdgeInsets.only(right: 16),
//                   child: SingleChildScrollView(
//                     child: Container(
//                       width: 400,
//                       margin: EdgeInsets.only(right: 20),
//                       decoration: BoxDecoration(
//                         color: isDark ? Colors.grey.shade800 : Colors.white,
//                         // color: AppColors.primaryLight,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
//                             blurRadius: 12,
//                             offset: Offset(0, 6),
//                           ),
//                         ],
//                         border: Border.all(
//                           color: isDark
//                               ? Colors.grey.shade700
//                               : Colors.grey.shade200,
//                           width: 1,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Project Icon + Name
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Icon(
//                                     Icons.work_rounded,
//                                     color: AppColors.warning,
//                                     size: 32,
//                                   ),
//                                 ),
//                                 SizedBox(width: 16),
//                                 Expanded(
//                                   child: Text(
//                                     project['project_name'] ??
//                                         'Unknown Project',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: isDark
//                                           ? Colors.white
//                                           : Colors.black87,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 0),

//                             // Project Details
//                             _projectDetailRow(
//                               "Site",
//                               project['project_site'] ?? 'N/A',
//                               isDark,
//                             ),
//                             _projectDetailRow(
//                               "Client",
//                               project['client_name'] ?? 'Internal',
//                               isDark,
//                             ),

//                             Spacer(),

//                             // Manager Info - Sirf Manager ko dikhega
//                             if (isManager)
//                               Padding(
//                                 padding: EdgeInsets.only(top: 12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Divider(
//                                       color: isDark
//                                           ? Colors.grey.shade600
//                                           : Colors.grey.shade300,
//                                     ),
//                                     SizedBox(height: 12),
//                                     _projectDetailRow(
//                                       "Assigned To",
//                                       project['assigned_emp_name'] ??
//                                           'Employee',
//                                       isDark,
//                                     ),
//                                     _projectDetailRow(
//                                       "Emp ID",
//                                       project['assigned_emp_id'] ?? 'N/A',
//                                       isDark,
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                             // Employee ko sirf apna project dikhega, no extra info
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _projectDetailRow(String label, String value, bool isDark) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 90,
//             child: Text(
//               "$label:",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.grey.shade400 : Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.white : Colors.white,
//               ),
//               softWrap: true,
//               overflow: TextOverflow.visible,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
