// lib/features/leaves/presentation/screens/manager_leave_screen.dart

import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_monthly_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ManagerLeaveScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;
  final bool canApproveReject;

  const ManagerLeaveScreen({
    super.key,
    required this.user,
    this.canApproveReject = true,
  });

  @override
  ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
}

class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
  LeaveFilter _currentFilter = LeaveFilter.pending;
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authAsync = ref.watch(authProvider);
    final leavesAsync = ref.watch(teamLeavesProvider);
    final pendingCountAsync = ref.watch(pendingLeavesCountProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.dashboard(isDark)),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _isRefreshing = true);
            await ref.read(teamLeavesProvider.notifier).refresh();
            setState(() => _isRefreshing = false);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                authAsync.when(
                  data: (user) {
                    if (user == null || !user.isManagerial) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            "Access denied. Manager only.",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return leavesAsync.when(
                      data: (leaves) {
                        // Month filter (optional for manager - can comment if not needed)
                        final filteredByMonth = leaves.where((leave) {
                          if (leave.leaveFromDate == null) return false;
                          try {
                            final monthYear = DateFormat(
                              'MMMM yyyy',
                            ).format(leave.leaveFromDate!);
                            return monthYear == _selectedMonth;
                          } catch (_) {
                            return false;
                          }
                        }).toList();

                        // Status filter
                        final filteredLeaves = filteredByMonth.where((leave) {
                          switch (_currentFilter) {
                            case LeaveFilter.all:
                            case LeaveFilter.team:
                              return true;
                            case LeaveFilter.pending:
                              return leave.isPending;
                            case LeaveFilter.approved:
                              return leave.isApproved;
                            case LeaveFilter.rejected:
                              return leave.isRejected;
                          }
                        }).toList();

                        // Stats from final filtered list
                        final total = filteredLeaves.length;
                        final pending = filteredLeaves
                            .where((l) => l.isPending)
                            .length;
                        final approved = filteredLeaves
                            .where((l) => l.isApproved)
                            .length;
                        final rejected = filteredLeaves
                            .where((l) => l.isRejected)
                            .length;
                        final avgShortfall = 1.2; // TODO: Real calc from DB

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Monthly Overview
                            LeaveMonthlyOverviewWidget(
                              total: total,
                              pending: pending,
                              approved: approved,
                              rejected: rejected,
                              avgShortfall: avgShortfall,
                              totalDays: filteredLeaves.length,
                              isManager: true,
                            ),

                            const SizedBox(height: 24),

                            // Filter Bar
                            const LeaveFilterBar(),

                            const SizedBox(height: 16),

                            // Leave List
                            filteredLeaves.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Text(
                                        'No leaves found for selected month and status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredLeaves.length,
                                    itemBuilder: (context, index) {
                                      final leave = filteredLeaves[index];
                                      return LeaveCard(
                                        leave: leave,
                                        isManagerView: true,
                                        showActions:
                                            widget.canApproveReject &&
                                            leave.isPending,
                                      );
                                    },
                                  ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Error loading leaves: $err',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Auth error: $err',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/features/leaves/presentation/screens/manager_leave_screen.dart
// // FINAL UPGRADED & POLISHED VERSION - January 06, 2026
// // Modern gradient UI, pending leaves count (via MonthlyOverviewWidget), filter bar, leave list
// // Null-safe, role-aware (manager only), real-time data from pendingLeavesProvider
// // Responsive, dark mode, pull-to-refresh, no overflow
// // UI/UX same (layout, colors, components) but enhanced with smoothness

// import 'package:appattendance/core/theme/app_gradients.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_monthly_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class ManagerLeaveScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject;

//   const ManagerLeaveScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = true,
//   });

//   @override
//   ConsumerState<ManagerLeaveScreen> createState() => _ManagerLeaveScreenState();
// }

// class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
//   LeaveFilter _currentFilter = LeaveFilter.pending; // Default for manager
//   bool _isRefreshing = false;
//   String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final authAsync = ref.watch(authProvider);
//     final leavesAsync = ref.watch(teamLeavesProvider);
//     final pendingCountAsync = ref.watch(pendingLeavesCountProvider);

//     return Scaffold(
//       // extendBodyBehindAppBar: true,
//       // appBar: AppBar(
//       //   title: const Text('Team Leave Requests'),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.transparent,
//       //   elevation: 0,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       icon: _isRefreshing
//       //           ? const SizedBox(
//       //               height: 24,
//       //               width: 24,
//       //               child: CircularProgressIndicator(
//       //                 color: Colors.white,
//       //                 strokeWidth: 3,
//       //               ),
//       //             )
//       //           : const Icon(Icons.refresh),
//       //       onPressed: _isRefreshing
//       //           ? null
//       //           : () async {
//       //               setState(() => _isRefreshing = true);
//       //               await ref.read(myLeavesProvider.notifier).refresh();
//       //               setState(() => _isRefreshing = false);
//       //             },
//       //     ),
//       //   ],
//       // ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppGradients.dashboard(
//             Theme.of(context).brightness == Brightness.dark,
//           ),
//         ),
//         child: RefreshIndicator(
//           onRefresh: () async {
//             setState(() => _isRefreshing = true);
//             await ref.read(teamLeavesProvider.notifier).refresh(); // NEW
//             setState(() => _isRefreshing = false);
//           },
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Pending Leaves Count Card (using MonthlyOverviewWidget)
//                   authAsync.when(
//                     data: (user) {
//                       if (user == null || !user.isManagerial) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(32),
//                             child: Text(
//                               "Access denied. Manager only.",
//                               style: TextStyle(fontSize: 18, color: Colors.red),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         );
//                       }

//                       return leavesAsync.when(
//                         data: (leaves) {
//                           // Step 1: Month filter (null-safe)
//                           final filteredByMonth = leaves.where((leave) {
//                             if (leave.leaveFromDate == null) return false;
//                             try {
//                               final monthYear = DateFormat(
//                                 'MMMM yyyy',
//                               ).format(leave.leaveFromDate!);
//                               return monthYear == _selectedMonth;
//                             } catch (_) {
//                               return false;
//                             }
//                           }).toList();

//                           // Step 2: Status filter on top of month-filtered list
//                           final filteredLeaves = filteredByMonth.where((leave) {
//                             switch (_currentFilter) {
//                               case LeaveFilter.all:
//                               case LeaveFilter.team:
//                                 return true;
//                               case LeaveFilter.pending:
//                                 return leave.isPending;
//                               case LeaveFilter.approved:
//                                 return leave.isApproved;
//                               case LeaveFilter.rejected:
//                                 return leave.isRejected;
//                             }
//                           }).toList();

//                           // Step 3: Stats calculated from final filtered list
//                           final total = filteredLeaves.length;
//                           final pending = filteredLeaves
//                               .where((l) => l.isPending)
//                               .length;
//                           final approved = filteredLeaves
//                               .where((l) => l.isApproved)
//                               .length;
//                           final rejected = filteredLeaves
//                               .where((l) => l.isRejected)
//                               .length;
//                           final avgShortfall = 1.2; // TODO: Real calculation

//                           // Rest of your UI (LeaveMonthlyOverviewWidget + LeaveFilterBar + ListView)
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               LeaveMonthlyOverviewWidget(
//                                 total: total,
//                                 pending: pending,
//                                 approved: approved,
//                                 rejected: rejected,
//                                 avgShortfall: avgShortfall,
//                                 totalDays: filteredLeaves.length,
//                                 isManager: true,
//                               ),
//                               const SizedBox(height: 24),
//                               const LeaveFilterBar(),
//                               const SizedBox(height: 16),
//                               filteredLeaves.isEmpty
//                                   ? const Center(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(32),
//                                         child: Text(
//                                           'No leaves found for selected month and status',
//                                         ),
//                                       ),
//                                     )
//                                   : ListView.builder(
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemCount: filteredLeaves.length,
//                                       itemBuilder: (context, index) {
//                                         final leave = filteredLeaves[index];
//                                         return LeaveCard(
//                                           leave: leave,
//                                           isManagerView: true,
//                                           showActions:
//                                               widget.canApproveReject &&
//                                               leave.isPending,
//                                         );
//                                       },
//                                     ),
//                             ],
//                           );
//                         },
//                         loading: () =>
//                             const Center(child: CircularProgressIndicator()),
//                         error: (err, stack) => Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(32),
//                             child: Text(
//                               'Error loading leaves: $err',
//                               style: const TextStyle(color: Colors.red),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     loading: () =>
//                         const Center(child: CircularProgressIndicator()),
//                     error: (err, stack) => Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(32),
//                         child: Text(
//                           'Auth error: $err',
//                           style: const TextStyle(color: Colors.red),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/leaves/presentation/screens/manager_leave_screen.dart
// // Final upgraded version: Riverpod sync + safe user + real pending leaves + approve/reject
// // Dec 30, 2025 - Production-ready, privileges safe, real data from pendingLeavesProvider

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/domain/models/user_role.dart';
// import 'package:appattendance/features/auth/domain/models/user_db_mapper.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_card.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_filter_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ManagerLeaveScreen extends ConsumerStatefulWidget {
//   final bool canApproveReject; // Added parameter

//   const ManagerLeaveScreen({
//     super.key,
//     this.canApproveReject = true, // Default true
//   });

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
//               const LeaveFilterBar(),

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
//                             return LeaveCard(leave: leave, isManagerView: true);
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
