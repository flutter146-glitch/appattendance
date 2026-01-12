// lib/features/team/presentation/screens/team_member_detail_screen.dart
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/team/presentation/widgets/commons/allocated_projects_card.dart';
import 'package:appattendance/features/team/presentation/widgets/commons/attendance_overview_cards.dart';
import 'package:appattendance/features/team/presentation/widgets/commons/recent_attendance_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMemberDetailScreen extends ConsumerWidget {
  final String empId;

  const TeamMemberDetailScreen({required this.empId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(teamMemberDetailsProvider(empId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: memberAsync.when(
        data: (member) {
          if (member == null) {
            return const Center(child: Text('Member not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: member.profilePhotoUrl != null
                            ? NetworkImage(member.profilePhotoUrl!)
                            : null,
                        child: member.profilePhotoUrl == null
                            ? Text(
                                member.avatarInitial,
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.displayNameWithRole,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Emp ID: ${member.empId}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              member.email ?? 'No email',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              member.phone ?? 'No phone',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Joined: ${member.dateOfJoining != null ? DateFormat('dd/MM/yyyy').format(member.dateOfJoining!) : 'N/A'}',
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Attendance Overview Cards (matches screenshot)
                const AttendanceOverviewCards(),

                const SizedBox(height: 24),

                // Allocated Projects
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Allocated Projects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                AllocatedProjectsCard(member: member),

                const SizedBox(height: 24),

                // Recent Attendance
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Recent Attendance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                RecentAttendanceList(
                  attendance: member.recentAttendanceHistory,
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }
}
