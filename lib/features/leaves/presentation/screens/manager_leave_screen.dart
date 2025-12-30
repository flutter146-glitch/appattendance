// lib/features/leaves/presentation/screens/manager_leave_screen.dart
// Final upgraded version: Riverpod sync + safe user + real pending leaves + approve/reject
// Dec 30, 2025 - Production-ready, privileges safe, real data from pendingLeavesProvider

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManagerLeaveScreen extends ConsumerStatefulWidget {
  final bool canApproveReject; // Added parameter

  const ManagerLeaveScreen({
    super.key,
    this.canApproveReject = true, // Default true
  });

  @override
  ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
}

class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
  LeaveFilter _currentFilter = LeaveFilter.pending; // Default for manager

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final pendingLeavesAsync = ref.watch(pendingLeavesCountProvider);

    return authAsync.when(
      loading: () =>
      const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Auth Error: $err'))),
      data: (user) {
        if (user == null || !user.isManagerial) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Access denied. Manager only.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // Filter Bar (Manager specific)
              const LeaveFilterBar(),

              // Pending Leaves Count (Dashboard-style)
              Padding(
                padding: const EdgeInsets.all(16),
                child: pendingLeavesAsync.when(
                  data: (count) => Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Pending Team Leaves: $count',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                ),
              ),

              // Leave List
              Expanded(
                child: ref
                    .watch(myLeavesProvider)
                    .when(
                  data: (leaves) {
                    // Manager filter logic
                    final filteredLeaves = leaves.where((leave) {
                      switch (_currentFilter) {
                        case LeaveFilter.team:
                          return true; // All team leaves
                        case LeaveFilter.pending:
                          return leave.isPending;
                        case LeaveFilter.approved:
                          return leave.isApproved;
                        case LeaveFilter.rejected:
                          return leave.isRejected;
                        case LeaveFilter.all:
                        default:
                          return true;
                      }
                    }).toList();

                    if (filteredLeaves.isEmpty) {
                      return const Center(child: Text('No leaves found'));
                    }

                    return ListView.builder(
                      itemCount: filteredLeaves.length,
                      itemBuilder: (context, index) {
                        final leave = filteredLeaves[index];
                        return LeaveCard(leave: leave, isManagerView: true);
                      },
                    );
                  },
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text('Error loading leaves: $err')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// // lib/features/leaves/presentation/screens/manager_leave_screen.dart
// // Final upgraded version: Riverpod sync + safe user + real pending leaves + approve/reject
// // Dec 30, 2025 - Production-ready, privileges safe, real data from pendingLeavesProvider

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ManagerLeaveScreen extends ConsumerStatefulWidget {
//   const ManagerLeaveScreen({super.key});

//   @override
//   ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
// }

// class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
//   LeaveFilter _currentFilter = LeaveFilter.pending; // Default for manager

//   @override
//   Widget build(BuildContext context) {
//     final authAsync = ref.watch(authProvider);
//     final pendingLeavesAsync = ref.watch(pendingLeavesCountProvider);

//     return authAsync.when(
//       loading: () =>
//           const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (err, stack) =>
//           Scaffold(body: Center(child: Text('Auth Error: $err'))),
//       data: (user) {
//         if (user == null || !user.isManagerial) {
//           return const Scaffold(
//             body: Center(
//               child: Text(
//                 'Access denied. Manager only.',
//                 style: TextStyle(fontSize: 18, color: Colors.red),
//               ),
//             ),
//           );
//         }

//         return Scaffold(
//           body: Column(
//             children: [
//               // Filter Bar (Manager specific)
//               LeaveFilterBar(),

//               // Pending Leaves Count (Dashboard-style)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: pendingLeavesAsync.when(
//                   data: (count) => Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         'Pending Team Leaves: $count',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   loading: () => const CircularProgressIndicator(),
//                   error: (err, _) => Text('Error: $err'),
//                 ),
//               ),

//               // Leave List
//               Expanded(
//                 child: ref
//                     .watch(myLeavesProvider)
//                     .when(
//                       data: (leaves) {
//                         // Manager filter logic
//                         final filteredLeaves = leaves.where((leave) {
//                           switch (_currentFilter) {
//                             case LeaveFilter.team:
//                               return true; // All team leaves
//                             case LeaveFilter.pending:
//                               return leave.isPending;
//                             case LeaveFilter.approved:
//                               return leave.isApproved;
//                             case LeaveFilter.rejected:
//                               return leave.isRejected;
//                             case LeaveFilter.all:
//                             default:
//                               return true;
//                           }
//                         }).toList();

//                         if (filteredLeaves.isEmpty) {
//                           return const Center(child: Text('No leaves found'));
//                         }

//                         return ListView.builder(
//                           itemCount: filteredLeaves.length,
//                           itemBuilder: (context, index) {
//                             final leave = filteredLeaves[index];
//                             return LeaveCard(
//                               leave: leave,
//                               isManagerView: true,
//                               // onTap: () {
//                               //   showDialog(
//                               //     context: context,
//                               //     builder: (_) => LeaveDetailDialog(
//                               //       leave: leave,
//                               //       isManagerView: true,
//                               //     ),
//                               //   );
//                               // },
//                             );
//                           },
//                         );
//                       },
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                       error: (err, stack) =>
//                           Center(child: Text('Error loading leaves: $err')),
//                     ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // lib/features/leaves/presentation/screens/manager_leave_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ManagerLeaveScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject;
//   final bool isEmployeeViewMode;

//   const ManagerLeaveScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = false,
//     this.isEmployeeViewMode = false,
//   });

//   @override
//   ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
// }

// class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
//   LeaveFilter _currentFilter =
//       LeaveFilter.pending; // Default to pending for manager

//   @override
//   void initState() {
//     super.initState();
//     // Manager loads team pending leaves
//     ref.read(leaveProvider.notifier).loadLeaves(widget.user['emp_id'], true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final leaveState = ref.watch(leaveProvider);

//     if (leaveState.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (leaveState.error != null) {
//       return Scaffold(body: Center(child: Text('Error: ${leaveState.error}')));
//     }

//     final leaves = leaveState.value?.leaves ?? [];

//     // Manager filter logic
//     final filteredLeaves = leaves.where((leave) {
//       switch (_currentFilter) {
//         case LeaveFilter.team:
//           return true; // All team leaves
//         case LeaveFilter.pending:
//           return leave.isPending;
//         case LeaveFilter.approved:
//           return leave.isApproved;
//         case LeaveFilter.rejected:
//           return leave.isRejected;
//         case LeaveFilter.all:
//         default:
//           return true;
//       }
//     }).toList();

//     return Scaffold(
//       body: Column(
//         children: [
//           // Filter Bar for Manager (no month filter)
//           LeaveFilterBar(
//             selectedFilter: _currentFilter,
//             onFilterChanged: (filter) {
//               setState(() => _currentFilter = filter);
//             },
//             allRequests: leaves, // Full list for search
//             filteredRequests: filteredLeaves, // Current visible for export
//           ),

//           // Leave List
//           Expanded(
//             child: filteredLeaves.isEmpty
//                 ? const Center(child: Text('No leaves found'))
//                 : ListView.builder(
//                     itemCount: filteredLeaves.length,
//                     itemBuilder: (context, index) {
//                       final leave = filteredLeaves[index];
//                       return LeaveCard(
//                         leave: leave,
//                         isManagerView: true,
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (_) => LeaveDetailDialog(
//                               leave: leave,
//                               isManager: true,
//                               onUpdateStatus: (status, remarks) {
//                                 // Call notifier to update
//                                 ref
//                                     .read(leaveProvider.notifier)
//                                     .updateLeaveStatus(
//                                       leave.leaveId,
//                                       status == 'approved'
//                                           ? LeaveStatus.approved
//                                           : LeaveStatus.rejected,
//                                       remarks,
//                                       widget.user['emp_id'],
//                                     );
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }