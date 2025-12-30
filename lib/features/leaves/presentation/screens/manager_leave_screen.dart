// lib/features/leaves/presentation/screens/manager_leave_screen.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManagerLeaveScreen extends ConsumerStatefulWidget {
  const ManagerLeaveScreen({super.key});

  @override
  ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
}

class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
  LeaveFilter _currentFilter =
      LeaveFilter.pending; // Default to pending for manager

  @override
  void initState() {
    super.initState();
    // Get current logged-in user from authProvider
    final authState = ref.read(authProvider);
    final user = authState.user.value;

    if (user == null || user.empId == null) {
      // Security: If no user, show error (or redirect to login)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again')),
        );
      });
      return;
    }

    // Manager loads team pending leaves
    ref.read(leaveProvider.notifier).loadLeaves(user.empId!, true);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user.value;

    // Security: If no user or no empId, show error screen
    if (user == null || user.empId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please login to view team leaves',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final leaveState = ref.watch(leaveProvider);

    if (leaveState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (leaveState.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${leaveState.error}')));
    }

    final leaves = leaveState.value?.leaves ?? [];

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

    return Scaffold(
      body: Column(
        children: [
          // Filter Bar for Manager (no month filter)
          LeaveFilterBar(
            selectedFilter: _currentFilter,
            onFilterChanged: (filter) =>
                setState(() => _currentFilter = filter),
            allRequests: leaves,
            filteredRequests: filteredLeaves,
            isManagerView: true, // Manager → 'Team' filter dikhega
          ),

          // Leave List
          Expanded(
            child: filteredLeaves.isEmpty
                ? const Center(child: Text('No leaves found'))
                : ListView.builder(
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      return LeaveCard(
                        leave: leave,
                        isManagerView: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => LeaveDetailDialog(
                              leave: leave,
                              isManager: true,
                              onUpdateStatus: (status, remarks) {
                                // Call notifier to update (use user.empId from auth)
                                ref
                                    .read(leaveProvider.notifier)
                                    .updateLeaveStatus(
                                      leave.leaveId,
                                      status == 'approved'
                                          ? LeaveStatus.approved
                                          : LeaveStatus.rejected,
                                      remarks,
                                      user.empId!, // Dynamic from UserModel
                                    );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

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
