// lib/features/regularisation/presentation/screens/employee_regularisation_screen.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/screens/apply_regularisation_screen.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/month_filter_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_detail_dialog.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeeRegularisationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  const EmployeeRegularisationScreen({super.key, required this.user});

  @override
  ConsumerState<EmployeeRegularisationScreen> createState() =>
      _EmployeeRegularisationScreenState();
}

class _EmployeeRegularisationScreenState
    extends ConsumerState<EmployeeRegularisationScreen> {
  String _selectedMonth = DateFormat(
    'MMM yyyy',
  ).format(DateTime.now()); // Default current month

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(regularisationProvider);

    final ownRequests = regState.requests
        .where((r) => r.empId == widget.user['emp_id'])
        .toList();

    // Filter by selected month
    final filteredRequests = ownRequests.where((r) {
      final date = DateTime.parse(r.forDate);
      final monthYear = DateFormat('MMM yyyy').format(date);
      return monthYear == _selectedMonth;
    }).toList();

    // // Filter by selected month (no hardcode)
    // final filteredRequests = ownRequests.where((r) {
    //   final date = DateTime.parse(r.forDate);
    //   final monthYear = DateFormat('MMM yyyy').format(date);
    //   return monthYear == _selectedMonth;
    // }).toList();

    final ownStats = RegularisationStats(
      total: filteredRequests.length,
      pending: filteredRequests.where((r) => r.status == 'pending').length,
      approved: filteredRequests.where((r) => r.status == 'approved').length,
      rejected: filteredRequests.where((r) => r.status == 'rejected').length,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('My Regularisation Requests'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => ApplyRegularisationScreen(user: widget.user),
      //     ),
      //   ),
      //   child: Icon(Icons.add),
      //   tooltip: 'Apply Regularisation',
      // ),
      body: Column(
        children: [
          // 1. Month Filter (Upar lagaya)
          MonthFilterWidget(
            selectedMonthYear: _selectedMonth,
            onMonthSelected: (newMonth) {
              setState(() => _selectedMonth = newMonth);
            },
            // availableMonths: future mein API se aayega (e.g. ['Nov 2025', 'Dec 2025'])
          ),

          // 2. Monthly Overview (own stats)
          MonthlyOverviewWidget(
            total: ownStats.total,
            pending: ownStats.pending,
            approved: ownStats.approved,
            rejected: ownStats.rejected,
            avgShortfall: 1.2, // Placeholder - future attendance se
            totalDays: filteredRequests.length,
            isManager: false,
          ),

          // 3. Filter Bar (All/Pending/Approved/Rejected)
          RegularisationFilterBar(
            selectedFilter: ref.watch(regularisationFilterProvider),
            onFilterChanged: (filter) =>
                ref.read(regularisationFilterProvider.notifier).state = filter,
            allRequests:
                filteredRequests, // ← yeh change karo (filteredRequests ko allRequests mein rename ya match karo)
          ),

          // 4. Simplified Cards for Employee
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(
                    child: Text(
                      "No regularisation requests in $_selectedMonth",
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final req = filteredRequests[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => RegularisationDetailDialog(
                              request: req,
                              isManager: false, // Employee view
                            ),
                          );
                        },
                        child: RegularisationRequestCard(
                          request: req,
                          isDark: isDark,
                          isEmployeeView: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// // employee_regularisation_screen.dart

// import 'package:appattendance/core/theme/app_gradients.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EmployeeRegularisationScreen extends ConsumerWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject;

//   const EmployeeRegularisationScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final regState = ref.watch(regularisationProvider);
//     final ownRequests = regState.requests
//         .where((r) => r.empId == user['emp_id'])
//         .toList();

//     final ownStats = RegularisationStats(
//       total: ownRequests.length,
//       pending: ownRequests.where((r) => r.status == 'pending').length,
//       approved: ownRequests.where((r) => r.status == 'approved').length,
//       rejected: ownRequests.where((r) => r.status == 'rejected').length,
//     );
//     double avgShortfall = 1.2;
//     int totalDays = ownRequests.length;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Regularisation Requests'),
//         centerTitle: true,
//         backgroundColor: AppColors.warning,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to Apply Form
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Apply Regularisation',
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppGradients.dashboard(
//             Theme.of(context).brightness == Brightness.dark,
//           ),
//         ),
//         child: Column(
//           children: [
//             // 1. Monthly Overview (Own stats)
//             MonthlyOverviewWidget(
//               total: ownStats.total,
//               pending: ownStats.pending,
//               approved: ownStats.approved,
//               rejected: ownStats.rejected,
//               totalDays: totalDays,
//               avgShortfall: avgShortfall,
//               isManager: false,
//             ),

//             // 2. Filter Bar Widget (Only for Manager view)
//             RegularisationFilterBar(
//               selectedFilter: ref.watch(regularisationFilterProvider),
//               onFilterChanged: (filter) {
//                 ref.read(regularisationFilterProvider.notifier).state = filter;
//               },
//               filteredRequests: regState.requests,
//             ),
//             // 3. Own Request Cards
//             Expanded(
//               child: regState.requests.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.inbox_rounded,
//                             size: 80,
//                             color: Colors.grey[400],
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             "No regularisation requests",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       itemCount: regState.requests.length,
//                       itemBuilder: (context, index) {
//                         final req = regState.requests[index];
//                         return RegularisationRequestCard(
//                           request: req,
//                           isDark: isDark,
//                           showActions:
//                               canApproveReject && req.status == 'pending',
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
