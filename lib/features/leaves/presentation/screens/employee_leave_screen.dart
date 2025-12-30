// lib/features/leaves/presentation/screens/employee_leave_screen.dart
// Fully updated: No hardcoded userId, empId dynamically from authProvider (UserModel), secure null checks, production-ready

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/month_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeeLeaveScreen extends ConsumerStatefulWidget {
  const EmployeeLeaveScreen({super.key});

  @override
  ConsumerState<EmployeeLeaveScreen> createState() =>
      _EmployeeLeaveScreenState();
}

class _EmployeeLeaveScreenState extends ConsumerState<EmployeeLeaveScreen> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  LeaveFilter _currentFilter = LeaveFilter.all;

  @override
  void initState() {
    super.initState();
    _loadOwnLeaves();
  }

  Future<void> _loadOwnLeaves() async {
    final authState = ref.read(authProvider);
    final user = authState.user.value;

    if (user == null || user.empId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again')),
        );
      }
      return;
    }

    // Load only own leaves for employee
    ref.read(leaveProvider.notifier).loadLeaves(user.empId!, false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user.value;

    // Security: Redirect or show error if not logged in
    if (user == null || user.empId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please login to view your leaves',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Go to Login'),
              ),
            ],
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

    // Apply month filter
    final filteredByMonth = leaves.where((leave) {
      final monthYear = DateFormat('MMMM yyyy').format(leave.leaveFromDate);
      return monthYear == _selectedMonth;
    }).toList();

    // Apply status filter
    final filteredLeaves = filteredByMonth.where((leave) {
      switch (_currentFilter) {
        case LeaveFilter.pending:
          return leave.isPending;
        case LeaveFilter.approved:
          return leave.isApproved;
        case LeaveFilter.rejected:
          return leave.isRejected;
        case LeaveFilter.team: // Employee can't see team
        case LeaveFilter.all:
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Month Filter (Employee specific)
          MonthFilterWidget(
            selectedMonth: _selectedMonth,
            onMonthChanged: (newMonth) {
              setState(() => _selectedMonth = newMonth);
            },
          ),

          // Filter Bar (All/Pending/Approved/Rejected + Export/Search)
          LeaveFilterBar(
            selectedFilter: _currentFilter,
            onFilterChanged: (filter) {
              setState(() => _currentFilter = filter);
            },
            allRequests: leaves,
            filteredRequests: filteredLeaves,
            isManagerView: false, // Employee view → no "Team" filter
          ),

          // Leave List
          Expanded(
            child: filteredLeaves.isEmpty
                ? const Center(child: Text('No leaves found for this month'))
                : ListView.builder(
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      return LeaveCard(
                        leave: leave,
                        isManagerView: false,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => LeaveDetailDialog(leave: leave),
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

// // lib/features/leaves/presentation/screens/employee_leave_screen.dart
// // Fully updated: No hardcoded userId, empId from authProvider (UserModel), dynamic loading, production-ready

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/month_filter_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class EmployeeLeaveScreen extends ConsumerStatefulWidget {
//   const EmployeeLeaveScreen({super.key});

//   @override
//   ConsumerState<EmployeeLeaveScreen> createState() =>
//       _EmployeeLeaveScreenState();
// }

// class _EmployeeLeaveScreenState extends ConsumerState<EmployeeLeaveScreen> {
//   String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
//   LeaveFilter _currentFilter = LeaveFilter.all;

//   @override
//   void initState() {
//     super.initState();
//     // Get current logged-in user from authProvider
//     final authState = ref.read(authProvider);
//     final user = authState.user.value;

//     if (user == null || user.empId == null) {
//       // Security: No user → show error (or redirect to login)
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Session expired. Please login again')),
//         );
//       });
//       return;
//     }

//     // Load own leaves for the logged-in employee
//     ref.read(leaveProvider.notifier).loadLeaves(user.empId!, false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final user = authState.user.value;

//     // Security check
//     if (user == null || user.empId == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text(
//             'Please login to view your leaves',
//             style: TextStyle(fontSize: 18, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }

//     final leaveState = ref.watch(leaveProvider);

//     if (leaveState.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (leaveState.error != null) {
//       return Scaffold(body: Center(child: Text('Error: ${leaveState.error}')));
//     }

//     final leaves = leaveState.value?.leaves ?? [];

//     // Apply month filter (employee can filter by month)
//     final filteredByMonth = leaves.where((leave) {
//       final monthYear = DateFormat('MMMM yyyy').format(leave.leaveFromDate);
//       return monthYear == _selectedMonth;
//     }).toList();

//     // Apply status filter
//     final filteredLeaves = filteredByMonth.where((leave) {
//       switch (_currentFilter) {
//         case LeaveFilter.pending:
//           return leave.isPending;
//         case LeaveFilter.approved:
//           return leave.isApproved;
//         case LeaveFilter.rejected:
//           return leave.isRejected;
//         case LeaveFilter.team: // Employee can't see team
//         case LeaveFilter.all:
//         default:
//           return true;
//       }
//     }).toList();

//     return Scaffold(
//       body: Column(
//         children: [
//           // Month Filter (Employee specific)
//           MonthFilterWidget(
//             selectedMonth: _selectedMonth,
//             onMonthChanged: (newMonth) {
//               setState(() => _selectedMonth = newMonth);
//             },
//           ),

//           // Filter Bar (with export/search)
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
//                 ? const Center(child: Text('No leaves found for this month'))
//                 : ListView.builder(
//                     itemCount: filteredLeaves.length,
//                     itemBuilder: (context, index) {
//                       final leave = filteredLeaves[index];
//                       return LeaveCard(
//                         leave: leave,
//                         isManagerView: false,
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (_) => LeaveDetailDialog(leave: leave),
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

// // lib/features/leaves/presentation/screens/employee_leave_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/month_filter_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class EmployeeLeaveScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> user;

//   const EmployeeLeaveScreen({super.key, required this.user});

//   @override
//   ConsumerState<EmployeeLeaveScreen> createState() =>
//       _EmployeeLeaveScreenState();
// }

// class _EmployeeLeaveScreenState extends ConsumerState<EmployeeLeaveScreen> {
//   String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
//   LeaveFilter _currentFilter = LeaveFilter.all;

//   @override
//   void initState() {
//     super.initState();
//     // Load own leaves for employee
//     ref.read(leaveProvider.notifier).loadLeaves(widget.user['emp_id'], false);
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

//     // Apply month filter (employee can filter by month)
//     final filteredByMonth = leaves.where((leave) {
//       final monthYear = DateFormat('MMMM yyyy').format(leave.leaveFromDate);
//       return monthYear == _selectedMonth;
//     }).toList();

//     // Apply status filter
//     final filteredLeaves = filteredByMonth.where((leave) {
//       switch (_currentFilter) {
//         case LeaveFilter.pending:
//           return leave.isPending;
//         case LeaveFilter.approved:
//           return leave.isApproved;
//         case LeaveFilter.rejected:
//           return leave.isRejected;
//         case LeaveFilter.team: // Employee can't see team
//         case LeaveFilter.all:
//         default:
//           return true;
//       }
//     }).toList();

//     return Scaffold(
//       body: Column(
//         children: [
//           // Month Filter (Employee specific)
//           MonthFilterWidget(
//             selectedMonth: _selectedMonth,
//             onMonthChanged: (newMonth) {
//               setState(() => _selectedMonth = newMonth);
//             },
//           ),

//           // Filter Bar
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
//                 ? const Center(child: Text('No leaves found for this month'))
//                 : ListView.builder(
//                     itemCount: filteredLeaves.length,
//                     itemBuilder: (context, index) {
//                       final leave = filteredLeaves[index];
//                       return LeaveCard(
//                         leave: leave,
//                         isManagerView: false,
//                         onTap: () {
//                           // Show detail dialog
//                           showDialog(
//                             context: context,
//                             builder: (_) => LeaveDetailDialog(leave: leave),
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
