// lib/features/regularisation/presentation/screens/manager_regularisation_screen.dart

import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManagerRegularisationScreen extends ConsumerWidget {
  final Map<String, dynamic> user;
  final bool canApproveReject;
  final bool isEmployeeViewMode;

  const ManagerRegularisationScreen({
    super.key,
    required this.user,
    this.canApproveReject = false,
    this.isEmployeeViewMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(regularisationProvider);

    // Data filter based on view mode
    final displayedRequests = isEmployeeViewMode
        ? regState.requests
              .where((r) => r.empId == user['emp_id'])
              .toList() // Manager apna data dekhega
        : regState.requests; // Team data

    // Stats from displayed requests
    final int total = displayedRequests.length;
    final int pending = displayedRequests
        .where((r) => r.status == 'pending')
        .length;
    final int approved = displayedRequests
        .where((r) => r.status == 'approved')
        .length;
    final int rejected = displayedRequests
        .where((r) => r.status == 'rejected')
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEmployeeViewMode
              ? 'My Regularisation Requests'
              : 'Regularisation Requests',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.warning,
      ),

      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.dashboard(isDark)),
        child: Column(
          children: [
            // Monthly Overview — view mode ke hisaab se
            MonthlyOverviewWidget(
              total: total,
              pending: pending,
              approved: approved,
              rejected: rejected,
              isManager: !isEmployeeViewMode,
            ),

            // Filter Bar — sirf Manager view mein
            if (isEmployeeViewMode)
              RegularisationFilterBar(
                selectedFilter: ref.watch(regularisationFilterProvider),
                onFilterChanged: (filter) =>
                    ref.read(regularisationFilterProvider.notifier).state =
                        filter,
                filteredRequests: displayedRequests,
              ),

            // Cards
            Expanded(
              child: displayedRequests.isEmpty
                  ? Center(child: Text("No requests found"))
                  : ListView.builder(
                      itemCount: displayedRequests.length,
                      itemBuilder: (context, index) {
                        final req = displayedRequests[index];
                        return RegularisationRequestCard(
                          request: req,
                          isDark: isDark,
                          showActions:
                              canApproveReject &&
                              !isEmployeeViewMode &&
                              req.status == 'pending',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ManagerRegularisationScreen extends ConsumerWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject;
//   // final String viewingEmpId;
//   final bool isEmployeeViewMode;

//   const ManagerRegularisationScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = false,
//     // required this.viewingEmpId,
//     this.isEmployeeViewMode = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final regState = ref.watch(regularisationProvider);

//     // Filter requests based on view mode
//     final List<RegularisationRequest> displayedRequests = isEmployeeViewMode
//         ? regState.requests.where((r) => r.empId == user['emp_id']).toList()
//         : regState.requests;

//     // Calculate stats from displayed requests
//     final int total = displayedRequests.length;
//     final int pending = displayedRequests
//         .where((r) => r.status == 'pending')
//         .length;
//     final int approved = displayedRequests
//         .where((r) => r.status == 'approved')
//         .length;
//     final int rejected = displayedRequests
//         .where((r) => r.status == 'rejected')
//         .length;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           isEmployeeViewMode
//               ? 'My Regularisation Requests'
//               : 'Regularisation Requests',
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: AppColors.warning,
//       ),
//       body: Container(
//         decoration: BoxDecoration(gradient: AppGradients.dashboard(isDark)),
//         child: regState.isLoading
//             ? Center(child: CircularProgressIndicator())
//             : regState.error.isNotEmpty
//             ? Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(24),
//                   child: Text(
//                     regState.error,
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//             : Column(
//                 children: [
//                   // Monthly Overview — Role-based data
//                   MonthlyOverviewWidget(
//                     total: total,
//                     pending: pending,
//                     approved: approved,
//                     rejected: rejected,
//                     avgShortfall: 0.0, // Future mein attendance se
//                     totalDays: displayedRequests.length,
//                     isManager: !isEmployeeViewMode,
//                   ),

//                   // Filter Bar — Only in Manager view
//                   if (!isEmployeeViewMode)
//                     RegularisationFilterBar(
//                       selectedFilter: ref.watch(regularisationFilterProvider),
//                       onFilterChanged: (filter) {
//                         ref.read(regularisationFilterProvider.notifier).state =
//                             filter;
//                       },
//                       filteredRequests: displayedRequests,
//                     ),

//                   // Request Cards
//                   Expanded(
//                     child: displayedRequests.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.inbox_rounded,
//                                   size: 80,
//                                   color: Colors.grey[400],
//                                 ),
//                                 SizedBox(height: 16),
//                                 Text(
//                                   isEmployeeViewMode
//                                       ? "No regularisation requests"
//                                       : "No regularisation requests found",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             itemCount: displayedRequests.length,
//                             itemBuilder: (context, index) {
//                               final req = displayedRequests[index];
//                               return RegularisationRequestCard(
//                                 request: req,
//                                 isDark: isDark,
//                                 showActions:
//                                     canApproveReject &&
//                                     !isEmployeeViewMode &&
//                                     req.status == 'pending',
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/screens/manager_regularisation_screen.dart

// import 'package:appattendance/core/theme/app_gradients.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
// import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ManagerRegularisationScreen extends ConsumerWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject; // R03, R04 → true; R05, R06, R01 → false
//   final String viewingEmpId;
//   final bool isEmployeeViewMode;

//   const ManagerRegularisationScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = false,
//     required this.viewingEmpId,
//     this.isEmployeeViewMode = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final regState = ref.watch(regularisationProvider);

//     final displayedRequests = isEmployeeViewMode
//         ? regState.requests.where((r) => r.empId == viewingEmpId).toList()
//         : regState.requests; // team data

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Regularisation Requests'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: AppColors.warning,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppGradients.dashboard(
//             Theme.of(context).brightness == Brightness.dark,
//           ),
//         ),
//         child: regState.isLoading
//             ? Center(child: CircularProgressIndicator())
//             : regState.error.isNotEmpty
//             ? Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(24),
//                   child: Text(
//                     regState.error,
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//             : Column(
//                 children: [
//                   // 1. Monthly Overview Widget (Team stats)
//                   MonthlyOverviewWidget(
//                     total: regState.stats.total,
//                     pending: regState.stats.pending,
//                     approved: regState.stats.approved,
//                     rejected: regState.stats.rejected,
//                     isManager: true,
//                   ),

//                   // 2. Filter Bar Widget (Only for Manager view)
//                   RegularisationFilterBar(
//                     selectedFilter: ref.watch(regularisationFilterProvider),
//                     onFilterChanged: (filter) {
//                       ref.read(regularisationFilterProvider.notifier).state =
//                           filter;
//                     },
//                     filteredRequests: regState.requests,
//                   ),

//                   // 3. Request Cards List
//                   Expanded(
//                     child: regState.requests.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.inbox_rounded,
//                                   size: 80,
//                                   color: Colors.grey[400],
//                                 ),
//                                 SizedBox(height: 16),
//                                 Text(
//                                   "No regularisation requests",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             itemCount: regState.requests.length,
//                             itemBuilder: (context, index) {
//                               final req = regState.requests[index];
//                               return RegularisationRequestCard(
//                                 request: req,
//                                 isDark: isDark,
//                                 showActions:
//                                     canApproveReject && req.status == 'pending',
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/screens/manager_regularisation_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class ManagerRegularisationScreen extends ConsumerWidget {
//   final Map<String, dynamic> user;
//   final bool canApproveReject;

//   const ManagerRegularisationScreen({
//     super.key,
//     required this.user,
//     this.canApproveReject = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final regState = ref.watch(regularisationProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Regularisation Requests'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: regState.isLoading
//           ? Center(child: CircularProgressIndicator())
//           : regState.error.isNotEmpty
//           ? Center(
//               child: Text(
//                 regState.error,
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             )
//           : Column(
//               children: [
//                 // Monthly Overview
//                 Container(
//                   margin: EdgeInsets.all(16),
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: isDark ? Colors.grey.shade800 : Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.analytics_rounded,
//                             color: Colors.blue,
//                             size: 24,
//                           ),
//                           SizedBox(width: 12),
//                           Text(
//                             'Monthly Overview',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: isDark ? Colors.white : Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _statItem(
//                             'Total',
//                             regState.stats.total.toString(),
//                             Colors.blue,
//                           ),
//                           _divider(isDark),
//                           _statItem(
//                             'Pending',
//                             regState.stats.pending.toString(),
//                             Colors.orange,
//                           ),
//                           _divider(isDark),
//                           _statItem(
//                             'Approved',
//                             regState.stats.approved.toString(),
//                             Colors.green,
//                           ),
//                           _divider(isDark),
//                           _statItem(
//                             'Rejected',
//                             regState.stats.rejected.toString(),
//                             Colors.red,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Filter Bar
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       _filterChip('All', true, isDark),
//                       SizedBox(width: 8),
//                       _filterChip('Pending', false, isDark),
//                       Spacer(),
//                       _actionButton(
//                         'Export',
//                         Icons.table_chart,
//                         Colors.green,
//                         isDark,
//                       ),
//                       SizedBox(width: 8),
//                       _actionButton(
//                         'Search',
//                         Icons.search,
//                         Colors.blue,
//                         isDark,
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: 16),

//                 // Requests List
//                 Expanded(
//                   child: regState.requests.isEmpty
//                       ? Center(
//                           child: Text(
//                             "No regularisation requests found",
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: regState.requests.length,
//                           itemBuilder: (context, index) {
//                             final req = regState.requests[index];
//                             return _buildRequestCard(req, isDark);
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _statItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         SizedBox(height: 6),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _divider(bool isDark) {
//     return Container(
//       width: 1,
//       height: 50,
//       color: isDark ? Colors.grey[700] : Colors.grey[300],
//     );
//   }

//   Widget _filterChip(String label, bool selected, bool isDark) {
//     return ChoiceChip(
//       label: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
//       selected: selected,
//       onSelected: (_) {},
//       selectedColor: Colors.blue,
//       backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
//       labelStyle: TextStyle(
//         color: selected
//             ? Colors.white
//             : (isDark ? Colors.white70 : Colors.black87),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//     );
//   }

//   Widget _actionButton(String label, IconData icon, Color color, bool isDark) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 20),
//           SizedBox(width: 8),
//           Text(
//             label,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRequestCard(RegularisationRequest req, bool isDark) {
//     final statusColor = req.status == 'pending' ? Colors.orange : Colors.green;

//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 10,
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: statusColor.withOpacity(0.2),
//                   child: Text(
//                     req.empName
//                         .split(' ')
//                         .map((e) => e[0])
//                         .take(2)
//                         .join()
//                         .toUpperCase(),
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         req.empName,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: isDark ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         req.designation,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     req.status.toUpperCase(),
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 20),

//             // Date & Type
//             Row(
//               children: [
//                 Icon(Icons.calendar_month, color: Colors.grey[600]),
//                 SizedBox(width: 8),
//                 Text(
//                   DateFormat('dd/MM/yyyy').format(DateTime.parse(req.forDate)),
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(width: 30),
//                 Icon(Icons.access_time, color: Colors.grey[600]),
//                 SizedBox(width: 8),
//                 Text(req.type, style: TextStyle(fontWeight: FontWeight.w600)),
//               ],
//             ),

//             if (req.checkinTime != null) ...[
//               SizedBox(height: 8),
//               Text(
//                 "Check-in: ${req.checkinTime}",
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             ],

//             if (req.shortfall != null) ...[
//               SizedBox(height: 4),
//               Text(
//                 "Shortfall: ${req.shortfall}",
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],

//             SizedBox(height: 16),

//             // Reason
//             Text(
//               req.justification,
//               style: TextStyle(fontSize: 15, height: 1.5),
//             ),

//             SizedBox(height: 16),

//             // Projects
//             if (req.projectNames.isNotEmpty)
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: req.projectNames.map((project) {
//                   return Chip(
//                     label: Text(project, style: TextStyle(fontSize: 13)),
//                     backgroundColor: Colors.blue.withOpacity(0.1),
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   );
//                 }).toList(),
//               ),

//             // Action Required
//             if (req.status == 'pending')
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.orange.withOpacity(0.5)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.warning_amber_rounded,
//                       color: Colors.orange,
//                       size: 20,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Action Required",
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
