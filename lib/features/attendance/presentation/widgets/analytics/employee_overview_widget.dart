// lib/features/attendance/presentation/widgets/analytics/employee_overview_widget.dart
// FINAL VERSION - Real data + Navigation to Details Screen on Tap

import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart'; // ← Yeh import add karo
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class EmployeeOverviewWidget extends ConsumerStatefulWidget {
  const EmployeeOverviewWidget({super.key});

  @override
  ConsumerState<EmployeeOverviewWidget> createState() =>
      _EmployeeOverviewWidgetState();
}

class _EmployeeOverviewWidgetState
    extends ConsumerState<EmployeeOverviewWidget> {
  // Track expanded state per employee (pie chart visible)
  final Map<String, bool> _expandedCards = {};

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(teamMembersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.blue, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Employee Overview - Daily',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${teamAsync.value?.length ?? 0} Employees',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Date
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 16),

          teamAsync.when(
            data: (members) {
              if (members.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      "No team members found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isExpanded = _expandedCards[member.empId] ?? false;

                  // Real pie chart data
                  final present = member.presentCount.toDouble();
                  final late = member.lateCount.toDouble();
                  final absent = member.absentCount.toDouble();
                  final total = present + late + absent;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Column(
                      children: [
                        // Main tappable content
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Navigate to detailed employee screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EmployeeIndividualDetailsScreen(
                                  employee:
                                      member, // Pass the real TeamMember object
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: member.isPresentToday
                                  ? Colors.green
                                  : Colors.red,
                              child: Text(
                                member.avatarInitial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    member.statusBadgeText,
                                    style: TextStyle(
                                      color: member.isPresentToday
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  member.designation ?? "—",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Blue project chips
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: (member.projectNames ?? []).map((
                                    proj,
                                  ) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        proj,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      member.todayCheckInTime,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${member.projectNames?.length ?? 0} Projects • Daily',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Expand/Collapse icon + "View daily" text (pie chart ke liye)
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'View daily',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Expandable Pie Chart (on separate tap/expand)
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const SizedBox(height: 12),
                                const Text(
                                  'DAILY Attendance Distribution',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Real Pie Chart
                                SizedBox(
                                  height: 180,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 40,
                                      sections: [
                                        if (total > 0) ...[
                                          PieChartSectionData(
                                            value: present,
                                            title:
                                                '${(present / total * 100).toStringAsFixed(0)}%',
                                            color: Colors.green,
                                            radius: 60,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: late,
                                            title:
                                                '${(late / total * 100).toStringAsFixed(0)}%',
                                            color: Colors.orange,
                                            radius: 60,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: absent,
                                            title:
                                                '${(absent / total * 100).toStringAsFixed(0)}%',
                                            color: Colors.red,
                                            radius: 60,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ] else
                                          PieChartSectionData(
                                            value: 1,
                                            title: 'No Data',
                                            color: Colors.grey,
                                            radius: 60,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildPieLegend(
                                      Colors.green,
                                      'Present (${present.toInt()})',
                                    ),
                                    const SizedBox(width: 16),
                                    _buildPieLegend(
                                      Colors.orange,
                                      'Late (${late.toInt()})',
                                    ),
                                    const SizedBox(width: 16),
                                    _buildPieLegend(
                                      Colors.red,
                                      'Absent (${absent.toInt()})',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(
                  4,
                  (_) => Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            error: (err, stk) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Error loading team: $err",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

// // lib/features/attendance/presentation/widgets/analytics/employee_overview_widget.dart
// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shimmer/shimmer.dart';

// class EmployeeOverviewWidget extends ConsumerWidget {
//   const EmployeeOverviewWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final teamAsync = ref.watch(teamMembersProvider);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: teamAsync.when(
//         data: (members) {
//           if (members.isEmpty) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(32),
//                 child: Text(
//                   "No team members found",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             );
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: members.length,
//             itemBuilder: (context, index) {
//               final member = members[index];
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(16),
//                   leading: CircleAvatar(
//                     radius: 28,
//                     backgroundColor: member.isPresentToday
//                         ? Colors.green
//                         : Colors.red,
//                     child: Text(
//                       member.avatarInitial,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     member.name,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         member.designation ?? "—",
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "${member.presentCount} Present • ${member.lateCount} Late • ${member.absentCount} Absent",
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   trailing: SizedBox(
//                     width: 80,
//                     height: 80,
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 0,
//                         centerSpaceRadius: 18,
//                         sections: [
//                           PieChartSectionData(
//                             value: member.presentCount.toDouble(),
//                             color: Colors.green,
//                             radius: 18,
//                           ),
//                           PieChartSectionData(
//                             value: member.lateCount.toDouble(),
//                             color: Colors.orange,
//                             radius: 18,
//                           ),
//                           PieChartSectionData(
//                             value: member.absentCount.toDouble(),
//                             color: Colors.red,
//                             radius: 18,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     // Navigate to detailed employee view if needed
//                   },
//                 ),
//               );
//             },
//           );
//         },
//         loading: () => Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Column(
//             children: List.generate(
//               4,
//               (_) => Container(
//                 height: 100,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         error: (err, stk) => Center(child: Text("Error loading team: $err")),
//       ),
//     );
//   }
// }

// // // lib/features/attendance/presentation/widgets/employee_overview_widget.dart
// // // ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Upgraded)
// // // Key Upgrades:
// // // - Removed EmployeeAnalytics completely – now uses real TeamMember model
// // // - Real data from teamMembersProvider (dummy_data compatible)
// // // - Modern dark/light cards with shimmer loading
// // // - Hero animation + smooth navigation to detail screen
// // // - Present indicator (green dot) on avatar
// // // - Status chip with dynamic color (Present/Late/Absent/Leave)
// // // - Quick stats: attendance % + project count
// // // - Accessibility & responsive layout

// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart';
// // import 'package:appattendance/features/team/domain/models/team_member.dart';
// // import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
// // import 'package:appattendance/features/team/presentation/screens/employee_individual_details_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:shimmer/shimmer.dart';

// // class EmployeeOverviewWidget extends ConsumerWidget {
// //   const EmployeeOverviewWidget({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final teamMembersAsync = ref.watch(teamMembersProvider);

// //     return teamMembersAsync.when(
// //       data: (members) {
// //         if (members.isEmpty) {
// //           return const Center(
// //             child: Text(
// //               'No team members found',
// //               style: TextStyle(fontSize: 16, color: Colors.grey),
// //             ),
// //           );
// //         }

// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: Text(
// //                 'Employee Overview (${members.length} Employees)',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: isDark ? Colors.white : Colors.black87,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             ListView.builder(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: members.length,
// //               itemBuilder: (context, index) {
// //                 final member = members[index];

// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 16,
// //                     vertical: 6,
// //                   ),
// //                   child: Hero(
// //                     tag: 'employee_card_${member.empId}',
// //                     child: Card(
// //                       elevation: 4,
// //                       shadowColor: Colors.black.withOpacity(0.2),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(16),
// //                       ),
// //                       color: isDark ? const Color(0xFF1E293B) : Colors.white,
// //                       child: InkWell(
// //                         borderRadius: BorderRadius.circular(16),
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => EmployeeIndividualDetailsScreen(
// //                                 employee: member,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: Row(
// //                             children: [
// //                               // Avatar with online/present indicator
// //                               Stack(
// //                                 children: [
// //                                   CircleAvatar(
// //                                     radius: 32,
// //                                     backgroundColor: Colors.grey[300],
// //                                     backgroundImage:
// //                                         member.profilePhotoUrl != null
// //                                         ? NetworkImage(member.profilePhotoUrl!)
// //                                         : null,
// //                                     child: member.profilePhotoUrl == null
// //                                         ? Text(
// //                                             member.avatarInitial,
// //                                             style: const TextStyle(
// //                                               fontSize: 24,
// //                                               fontWeight: FontWeight.bold,
// //                                             ),
// //                                           )
// //                                         : null,
// //                                   ),
// //                                   if (member.isPresentToday)
// //                                     Positioned(
// //                                       right: 0,
// //                                       bottom: 0,
// //                                       child: Container(
// //                                         width: 16,
// //                                         height: 16,
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.green,
// //                                           shape: BoxShape.circle,
// //                                           border: Border.all(
// //                                             color: Colors.white,
// //                                             width: 2,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                 ],
// //                               ),
// //                               const SizedBox(width: 16),

// //                               // Employee Info
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       member.displayNameWithRole,
// //                                       style: TextStyle(
// //                                         fontSize: 17,
// //                                         fontWeight: FontWeight.bold,
// //                                         color: isDark
// //                                             ? Colors.white
// //                                             : Colors.black87,
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 4),
// //                                     Text(
// //                                       member.email ?? 'No email',
// //                                       style: TextStyle(
// //                                         fontSize: 13,
// //                                         color: isDark
// //                                             ? Colors.white70
// //                                             : Colors.grey[700],
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 6),
// //                                     Text(
// //                                       member.quickStats,
// //                                       style: const TextStyle(
// //                                         fontSize: 13,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: Colors.blue,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),

// //                               // Status Chip
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 12,
// //                                   vertical: 6,
// //                                 ),
// //                                 decoration: BoxDecoration(
// //                                   color: member.statusColor.withOpacity(0.2),
// //                                   borderRadius: BorderRadius.circular(20),
// //                                 ),
// //                                 child: Text(
// //                                   member.statusBadgeText,
// //                                   style: TextStyle(
// //                                     color: member.statusColor,
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 12,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //       loading: () => Column(
// //         children: List.generate(
// //           4,
// //           (_) => Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //             child: Shimmer.fromColors(
// //               baseColor: Colors.grey[300]!,
// //               highlightColor: Colors.grey[100]!,
// //               child: Card(
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16),
// //                 ),
// //                 child: const SizedBox(height: 100),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       error: (e, _) => Center(
// //         child: Column(
// //           children: [
// //             Text(
// //               'Failed to load team members',
// //               style: TextStyle(color: Colors.red.shade700),
// //             ),
// //             TextButton(
// //               onPressed: () => ref.invalidate(teamMembersProvider),
// //               child: const Text('Retry'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// // import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
// // import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class EmployeeOverview extends ConsumerWidget {
// //   const EmployeeOverview({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final analyticsAsync = ref.watch(analyticsProvider);

// //     return analyticsAsync.when(
// //       data: (analytics) {
// //         final employees = analytics.employeeBreakdown;

// //         if (employees.isEmpty) {
// //           return Center(child: Text('No team members found'));
// //         }

// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Employee Overview (${employees.length} Employees)',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 12),
// //             ListView.builder(
// //               shrinkWrap: true,
// //               physics: NeverScrollableScrollPhysics(),
// //               itemCount: employees.length,
// //               itemBuilder: (context, index) {
// //                 final emp = employees[index];
// //                 return Card(
// //                   margin: EdgeInsets.only(bottom: 12),
// //                   elevation: 4,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: InkWell(
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (_) =>
// //                               EmployeeIndividualDetailsScreen(employee: emp),
// //                         ),
// //                       );
// //                     },
// //                     child: Padding(
// //                       padding: EdgeInsets.all(12),
// //                       child: Row(
// //                         children: [
// //                           // Avatar / Photo
// //                           CircleAvatar(
// //                             radius: 30,
// //                             backgroundImage: NetworkImage(
// //                               'https://ui-avatars.com/api/?name=${emp.name}&background=random',
// //                             ),
// //                             child: emp.status == 'Present'
// //                                 ? null
// //                                 : Icon(Icons.error, color: Colors.red),
// //                           ),
// //                           SizedBox(width: 16),

// //                           // Employee Info
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   emp.name,
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                                 SizedBox(height: 4),
// //                                 Text(
// //                                   emp.designation,
// //                                   style: TextStyle(
// //                                     fontSize: 14,
// //                                     color: Colors.grey,
// //                                   ),
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                                 SizedBox(height: 4),
// //                                 Text(
// //                                   'Projects: ${emp.projectCount}',
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Colors.blue,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),

// //                           // Status Chip
// //                           Chip(
// //                             label: Text(
// //                               emp.status,
// //                               style: TextStyle(color: Colors.white),
// //                             ),
// //                             backgroundColor: emp.status == 'Present'
// //                                 ? Colors.green
// //                                 : Colors.red,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //       loading: () => Center(child: CircularProgressIndicator()),
// //       error: (e, s) => Center(child: Text('Error loading employees')),
// //     );
// //   }
// // }
