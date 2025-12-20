// lib/features/regularisation/presentation/widgets/monthly_overview_widget.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyOverviewWidget extends StatelessWidget {
  final int total;
  final int pending;
  final int approved;
  final int rejected;
  final double avgShortfall; // in hours (e.g. 1.5)
  final int totalDays; // working days with regularisation
  final bool isManager;

  const MonthlyOverviewWidget({
    super.key,
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
    this.avgShortfall = 0.0,
    this.totalDays = 0,
    required this.isManager,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentMonthYear = DateFormat('MMMM yyyy').format(DateTime.now());

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //   color: isDark ? Colors.grey.shade800 : Colors.white,
      //   borderRadius: BorderRadius.circular(24),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
      //       blurRadius: 20,
      //       offset: Offset(0, 10),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      currentMonthYear,
                      // '$currentMonthYear • ${isManager ? 'Team' : 'My'} Regularisation',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 7),

          // Role-based Stats
          if (isManager)
            // Manager View: Total, Pending, Approved, Rejected
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    total.toString(),
                    Colors.blue,
                    isDark,
                  ),
                ),
                _buildVerticalDivider(isDark),
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    pending.toString(),
                    Colors.orange,
                    isDark,
                  ),
                ),
                _buildVerticalDivider(isDark),
                Expanded(
                  child: _buildStatItem(
                    'Approved',
                    approved.toString(),
                    Colors.green,
                    isDark,
                  ),
                ),
                _buildVerticalDivider(isDark),
                Expanded(
                  child: _buildStatItem(
                    'Rejected',
                    rejected.toString(),
                    Colors.red,
                    isDark,
                  ),
                ),
              ],
            )
          else
            // Employee View: Avg Shortfall, Total Days, Total Requests, Pending, Approved, Rejected
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Avg Shortfall',
                        '${avgShortfall.toStringAsFixed(1)}h',
                        Colors.red,
                        isDark,
                      ),
                    ),
                    _buildVerticalDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        'Total Days',
                        totalDays.toString(),
                        Colors.purple,
                        isDark,
                      ),
                    ),
                    _buildVerticalDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        'Applied',
                        total.toString(),
                        Colors.blue,
                        isDark,
                      ),
                    ),
                    _buildVerticalDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        'Pending',
                        pending.toString(),
                        Colors.orange,
                        isDark,
                      ),
                    ),
                    _buildVerticalDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        'Approved',
                        approved.toString(),
                        Colors.green,
                        isDark,
                      ),
                    ),
                    _buildVerticalDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        'Rejected',
                        rejected.toString(),
                        Colors.red,
                        isDark,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 16),
                // Divider(color: isDark ? Colors.white24 : Colors.white),

                // SizedBox(height: 20),
                // Row(
                //   children: [
                //     Expanded(
                //       child: _buildStatItem(
                //         'Pending',
                //         pending.toString(),
                //         Colors.orange,
                //         isDark,
                //       ),
                //     ),
                //     _buildVerticalDivider(isDark),
                //     Expanded(
                //       child: _buildStatItem(
                //         'Approved',
                //         approved.toString(),
                //         Colors.green,
                //         isDark,
                //       ),
                //     ),
                //     _buildVerticalDivider(isDark),
                //     Expanded(
                //       child: _buildStatItem(
                //         'Rejected',
                //         rejected.toString(),
                //         Colors.red,
                //         isDark,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 2,
      height: 60,
      color: isDark ? Colors.grey[700] : Colors.grey[300],
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}

// // lib/features/regularisation/presentation/widgets/monthly_overview_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MonthlyOverviewWidget extends StatelessWidget {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;
//   final bool isManager;

//   const MonthlyOverviewWidget({
//     super.key,
//     required this.total,
//     required this.pending,
//     required this.approved,
//     required this.rejected,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final currentMonthYear = DateFormat('MMMM yyyy').format(DateTime.now());

//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         // color: Colors.transparent,
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header - Same
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.calendar_month_rounded,
//                   color: AppColors.primary,
//                   size: 16,
//                 ),
//               ),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Monthly Overview',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       // currentMonthYear,
//                       '$currentMonthYear • ${isManager ? 'Team' : 'My'} Regularisation Requests',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 5),

//           // Stats Row — Fixed with Expanded + FittedBox
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   'Total',
//                   total.toString(),
//                   Colors.blue,
//                   isDark,
//                 ),
//               ),
//               _buildVerticalDivider(isDark),
//               Expanded(
//                 child: _buildStatItem(
//                   'Pending',
//                   pending.toString(),
//                   Colors.red,
//                   isDark,
//                 ),
//               ),
//               _buildVerticalDivider(isDark),
//               Expanded(
//                 child: _buildStatItem(
//                   'Approved',
//                   approved.toString(),
//                   Colors.green,
//                   isDark,
//                 ),
//               ),
//               _buildVerticalDivider(isDark),
//               Expanded(
//                 child: _buildStatItem(
//                   'Rejected',
//                   rejected.toString(),
//                   Colors.orangeAccent,
//                   isDark,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value, Color color, bool isDark) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w900,
//               color: color,
//               letterSpacing: 0.1,
//             ),
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: isDark ? Colors.grey[400] : Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider(bool isDark) {
//     return Container(
//       width: 2,
//       height: 70,
//       color: isDark ? Colors.grey[700] : Colors.grey[300],
//       margin: EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/monthly_overview_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MonthlyOverviewWidget extends StatelessWidget {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;
//   final bool isManager;

//   const MonthlyOverviewWidget({
//     super.key,
//     required this.total,
//     required this.pending,
//     required this.approved,
//     required this.rejected,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final currentMonthYear = DateFormat(
//       'MMMM yyyy',
//     ).format(DateTime.now()); // e.g. "December 2025"

//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.calendar_month_rounded,
//                   color: AppColors.primary,
//                   size: 32,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Monthly Overview',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       '$currentMonthYear • ${isManager ? 'Team' : 'My'} Regularisation Requests',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 28),

//           // Stats Row — Exactly like screenshot
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildStatItem(
//                 label: 'Total',
//                 value: total.toString(),
//                 color: Colors.blue,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Pending',
//                 value: pending.toString(),
//                 color: Colors.orange,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Approved',
//                 value: approved.toString(),
//                 color: Colors.green,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Rejected',
//                 value: rejected.toString(),
//                 color: Colors.red,
//                 isDark: isDark,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required String label,
//     required String value,
//     required Color color,
//     required bool isDark,
//   }) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 36,
//             fontWeight: FontWeight.w900,
//             color: color,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: isDark ? Colors.grey[400] : Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider(bool isDark) {
//     return Container(
//       width: 2,
//       height: 80,
//       color: isDark ? Colors.grey[700] : Colors.grey[300],
//       margin: EdgeInsets.symmetric(horizontal: 12),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/monthly_overview_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class MonthlyOverviewWidget extends StatelessWidget {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;
//   final bool isManager;

//   const MonthlyOverviewWidget({
//     super.key,
//     required this.total,
//     required this.pending,
//     required this.approved,
//     required this.rejected,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
//             blurRadius: 16,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.analytics_rounded,
//                   color: AppColors.primary,
//                   size: 28,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Text(
//                 'Monthly Overview',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 24),

//           // Stats Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildStatItem(
//                 label: 'Total',
//                 value: total.toString(),
//                 color: Colors.blue,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Pending',
//                 value: pending.toString(),
//                 color: Colors.orange,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Approved',
//                 value: approved.toString(),
//                 color: Colors.green,
//                 isDark: isDark,
//               ),
//               _buildVerticalDivider(isDark),
//               _buildStatItem(
//                 label: 'Rejected',
//                 value: rejected.toString(),
//                 color: Colors.red,
//                 isDark: isDark,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required String label,
//     required String value,
//     required Color color,
//     required bool isDark,
//   }) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w900,
//             color: color,
//             letterSpacing: 1.2,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.grey[400] : Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider(bool isDark) {
//     return Container(
//       width: 1.5,
//       height: 60,
//       color: isDark ? Colors.grey[700] : Colors.grey[300],
//     );
//   }
// }
