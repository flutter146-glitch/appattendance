// lib/features/attendance/presentation/widgets/employee_overview_widget.dart
// ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Upgraded)
// Key Upgrades:
// - Removed EmployeeAnalytics completely – now uses real TeamMember model
// - Real data from teamMembersProvider (dummy_data compatible)
// - Modern dark/light cards with shimmer loading
// - Hero animation + smooth navigation to detail screen
// - Present indicator (green dot) on avatar
// - Status chip with dynamic color (Present/Late/Absent/Leave)
// - Quick stats: attendance % + project count
// - Accessibility & responsive layout

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/team/presentation/screens/employee_individual_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeOverviewWidget extends ConsumerWidget {
  const EmployeeOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamMembersAsync = ref.watch(teamMembersProvider);

    return teamMembersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(
            child: Text(
              'No team members found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Employee Overview (${members.length} Employees)',
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
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Hero(
                    tag: 'employee_card_${member.empId}',
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeIndividualDetailsScreen(
                                employee: member,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Avatar with online/present indicator
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        member.profilePhotoUrl != null
                                        ? NetworkImage(member.profilePhotoUrl!)
                                        : null,
                                    child: member.profilePhotoUrl == null
                                        ? Text(
                                            member.avatarInitial,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (member.isPresentToday)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),

                              // Employee Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.displayNameWithRole,
                                      style: TextStyle(
                                        fontSize: 17,
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
                                      member.email ?? 'No email',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey[700],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      member.quickStats,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: member.statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  member.statusBadgeText,
                                  style: TextStyle(
                                    color: member.statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
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
          4,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const SizedBox(height: 100),
              ),
            ),
          ),
        ),
      ),
      error: (e, _) => Center(
        child: Column(
          children: [
            Text(
              'Failed to load team members',
              style: TextStyle(color: Colors.red.shade700),
            ),
            TextButton(
              onPressed: () => ref.invalidate(teamMembersProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
// import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EmployeeOverview extends ConsumerWidget {
//   const EmployeeOverview({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final analyticsAsync = ref.watch(analyticsProvider);

//     return analyticsAsync.when(
//       data: (analytics) {
//         final employees = analytics.employeeBreakdown;

//         if (employees.isEmpty) {
//           return Center(child: Text('No team members found'));
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Employee Overview (${employees.length} Employees)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 12),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: employees.length,
//               itemBuilder: (context, index) {
//                 final emp = employees[index];
//                 return Card(
//                   margin: EdgeInsets.only(bottom: 12),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               EmployeeIndividualDetailsScreen(employee: emp),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Row(
//                         children: [
//                           // Avatar / Photo
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: NetworkImage(
//                               'https://ui-avatars.com/api/?name=${emp.name}&background=random',
//                             ),
//                             child: emp.status == 'Present'
//                                 ? null
//                                 : Icon(Icons.error, color: Colors.red),
//                           ),
//                           SizedBox(width: 16),

//                           // Employee Info
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   emp.name,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   emp.designation,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   'Projects: ${emp.projectCount}',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Status Chip
//                           Chip(
//                             label: Text(
//                               emp.status,
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             backgroundColor: emp.status == 'Present'
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//       loading: () => Center(child: CircularProgressIndicator()),
//       error: (e, s) => Center(child: Text('Error loading employees')),
//     );
//   }
// }
