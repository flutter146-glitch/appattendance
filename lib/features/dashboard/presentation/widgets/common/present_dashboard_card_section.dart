// lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart
import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PresentDashboardCardSection extends ConsumerWidget {
  const PresentDashboardCardSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final viewMode = ref.watch(viewModeProvider); // ← Yeh add karo
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ViewMode ke basis pe effective role decide karo
    final effectiveManagerial = viewMode == ViewMode.manager;

    return dashboardAsync.when(
      data: (state) {
        final user = state.user;
        if (user == null) return const SizedBox.shrink();

        // Manager mode toggle ko respect karo (even if user is manager)
        final showManagerView = effectiveManagerial && user.isManagerial;

        // Month stats (current month)
        final now = DateTime.now();
        final monthYear = DateFormat('MMMM yyyy').format(now);
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final nextMonthStart = DateTime(now.year, now.month + 1, 1);

        // Real data from state
        final present = state.presentToday;
        final teamSize = state.teamSize;
        final absent = teamSize - present;

        // TODO: Real pending leaves
        final pendingLeaves = 3;

        // Employee-specific stats
        int onTime = 0;
        int late = 0;
        for (var record in state.todayAttendance) {
          if (record.isCheckIn) {
            if (record.isLate)
              late++;
            else
              onTime++;
          }
        }

        Widget _statItem(String label, String value, IconData icon) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   showManagerView ? "Team Overview" : "My Attendance Summary",
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //     color: isDark ? Colors.white : Colors.black87,
                  //   ),
                  // ),
                  Text(
                    "Today, " + monthYear,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                  if (!showManagerView)
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AttendanceScreen(),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: showManagerView
                    ? [
                        _statItem(
                          "Team",
                          teamSize.toString(),
                          Icons.people_alt_rounded,
                        ),
                        _statItem(
                          "Present",
                          present.toString(),
                          Icons.verified_user_rounded,
                        ),
                        _statItem(
                          "Leaves",
                          pendingLeaves.toString(),
                          Icons.beach_access_rounded,
                        ),
                        _statItem(
                          "Absent",
                          absent.toString(),
                          Icons.person_off_rounded,
                        ),
                        _statItem(
                          "Overall Att. %",
                          "${teamSize > 0 ? (present / teamSize * 100).round() : 0}%",
                          Icons.trending_up_rounded,
                        ),
                      ]
                    : [
                        _statItem(
                          "Total Days",
                          "6",
                          Icons.calendar_today_rounded,
                        ),
                        _statItem(
                          "Present",
                          present.toString(),
                          Icons.check_circle_rounded,
                        ),
                        _statItem(
                          "Absent",
                          absent.toString(),
                          Icons.hourglass_full_rounded,
                        ),
                        _statItem(
                          "On-Time",
                          onTime.toString(),
                          Icons.access_time_rounded,
                        ),
                        _statItem(
                          "Late",
                          late.toString(),
                          Icons.hourglass_full_rounded,
                        ),
                        _statItem("Leave", "0", Icons.beach_access_rounded),
                      ],
              ),
              const SizedBox(height: 16),
              Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error loading stats: $err")),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart
// // Upgraded: Real data from DashboardNotifier + role-based
// // Uses AttendanceModel (isCheckIn, isLate) + UserModel.isManagerial
// // Loading/error + dynamic month stats + privileges safe
// // Current date: December 29, 2025

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/domain/models/user_role.dart';
// import 'package:appattendance/features/auth/domain/models/user_db_mapper.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class PresentDashboardCardSection extends ConsumerWidget {
//   const PresentDashboardCardSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dashboardAsync = ref.watch(dashboardProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return dashboardAsync.when(
//       data: (state) {
//         final user = state.user;
//         if (user == null) return const SizedBox.shrink();

//         final isManagerial = user.isManagerial;
//         final todayAttendance = state.todayAttendance;

//         // Today's status
//         final hasCheckedIn = todayAttendance.any((a) => a.isCheckIn);
//         final hasCheckedOut = todayAttendance.any((a) => a.isCheckOut);

//         // Month stats (current month)
//         final now = DateTime.now();
//         final monthYear = DateFormat('MMMM yyyy').format(now);
//         final currentMonthStart = DateTime(now.year, now.month, 1);
//         final nextMonthStart = DateTime(now.year, now.month + 1, 1);

//         int present = 0;
//         int onTime = 0;
//         int late = 0;
//         int leave = 0; // TODO: Real from employee_leaves

//         for (var record in todayAttendance) {
//           if (record.isCheckIn) {
//             present++;
//             if (record.isLate) {
//               late++;
//             } else {
//               onTime++;
//             }
//           }
//         }

//         final totalDaysInMonth = nextMonthStart
//             .subtract(const Duration(days: 1))
//             .day;
//         final absent = totalDaysInMonth - (present + leave);

//         // Manager extra stats
//         final pendingLeaves = 3; // TODO: Real pending leaves count

//         Widget _statItem(String label, String value, IconData icon) {
//           return Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, size: 28, color: AppColors.primary),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: isDark ? Colors.white70 : Colors.grey[700],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           );
//         }

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     isManagerial ? "Team Overview" : "My Attendance Summary",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? Colors.white : Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     monthYear,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white70 : Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: isManagerial
//                     ? [
//                         _statItem(
//                           "Team",
//                           state.teamSize.toString(),
//                           Icons.people_alt_rounded,
//                         ),
//                         _statItem(
//                           "Present",
//                           state.presentToday.toString(),
//                           Icons.verified_user_rounded,
//                         ),
//                         _statItem(
//                           "Pending Leaves",
//                           pendingLeaves.toString(),
//                           Icons.beach_access_rounded,
//                         ),
//                         _statItem(
//                           "Absent",
//                           (state.teamSize - state.presentToday).toString(),
//                           Icons.person_off_rounded,
//                         ),
//                         _statItem(
//                           "Overall %",
//                           "${(state.presentToday / state.teamSize * 100).round()}%",
//                           Icons.trending_up_rounded,
//                         ),
//                       ]
//                     : [
//                         _statItem(
//                           "Total Days",
//                           totalDaysInMonth.toString(),
//                           Icons.calendar_today_rounded,
//                         ),
//                         _statItem(
//                           "Present",
//                           present.toString(),
//                           Icons.check_circle_rounded,
//                         ),
//                         _statItem(
//                           "Leave",
//                           leave.toString(),
//                           Icons.beach_access_rounded,
//                         ),
//                         _statItem(
//                           "Absent",
//                           absent.toString(),
//                           Icons.cancel_rounded,
//                         ),
//                         _statItem(
//                           "On-Time",
//                           onTime.toString(),
//                           Icons.access_time_rounded,
//                         ),
//                         _statItem(
//                           "Late",
//                           late.toString(),
//                           Icons.hourglass_full_rounded,
//                         ),
//                       ],
//               ),
//               const SizedBox(height: 16),
//               Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) =>
//           Center(child: Text("Error loading dashboard: $err")),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class PresentDashboardCardSection extends StatelessWidget {
//   final Map<String, dynamic>? dashboardData;
//   final bool isManager;

//   const PresentDashboardCardSection({
//     super.key,
//     required this.dashboardData,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Agar data nahi hai to loading dikhao
//     if (dashboardData == null) {
//       return SizedBox(
//         height: 200,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Theme-based colors
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.orange[700];
//     final iconColor = isDark ? Colors.white : AppColors.primary;
//     final circleBgOpacity = isDark ? 0.2 : 0.1;

//     // Current month calculation
//     final now = DateTime.now();
//     final monthYear = DateFormat('MMMM yyyy').format(now);
//     // final attendance = dashboardData?['attendance'] as List<dynamic>? ?? [];

//     final currentMonth = DateTime(now.year, now.month, 1);
//     final nextMonth = DateTime(now.year, now.month + 1, 1);

//     final attendance = dashboardData!['attendance'] as List<dynamic>? ?? [];

//     final monthAttendance = attendance.where((record) {
//       final attDate = DateTime.parse(record['att_date']);
//       return attDate.isAfter(currentMonth.subtract(const Duration(days: 1))) &&
//           attDate.isBefore(nextMonth);
//     }).toList();

//     int present = 0, onTime = 0, late = 0, leave = 0;

//     for (var record in monthAttendance) {
//       if (record['att_status'] == 'checkin') {
//         present++;
//         final timeStr = record['att_timestamp'] as String?;
//         if (timeStr != null) {
//           final hour = int.parse(timeStr.substring(11, 13));
//           final minute = int.parse(timeStr.substring(14, 16));
//           if (hour < 9 || (hour == 9 && minute <= 30)) {
//             onTime++;
//           } else {
//             late++;
//           }
//         }
//       }
//     }

//     final totalDaysInMonth = nextMonth.subtract(const Duration(days: 1)).day;
//     final absent = totalDaysInMonth - (present + leave);

//     // Manager stats — ab safe access
//     final pendingLeaves = dashboardData!['pending_leaves'] as int? ?? 0;

//     // Demo team stats (real mein API/DB se aayega)
//     final teamSize = 12;
//     final presentToday = 9;
//     final absentToday = teamSize - presentToday;
//     final overallPresentPct = teamSize > 0
//         ? (presentToday / teamSize * 100).round()
//         : 0;

//     Widget _statItem(String label, String value, IconData icon) {
//       return Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(circleBgOpacity),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 28, color: iconColor),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(fontSize: 13, color: secondaryTextColor),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       );
//     }

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       // padding: EdgeInsets.all(24),
//       // decoration: BoxDecoration(
//       // color: isDark ? AppColors.grey800 : AppColors.white,
//       // borderRadius: BorderRadius.circular(28),
//       // boxShadow: [
//       //   BoxShadow(
//       //     color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//       //     blurRadius: 16,
//       //     offset: Offset(0, 8),
//       //   ),
//       // ],
//       // ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Expanded(
//               //   child: Text(
//               //     isManager ? "Team Overview" : "My Attendance Summary",
//               //     style: TextStyle(
//               //       fontSize: 20,
//               //       fontWeight: FontWeight.bold,
//               //       color: textColor,
//               //     ),
//               //   ),
//               // ),
//               // Text(
//               //   monthYear,
//               //   style: TextStyle(
//               //     fontSize: 16,
//               //     fontWeight: FontWeight.w600,
//               //     color: textColor.withOpacity(0.8),
//               //   ),
//               // ),
//               if (!isManager) ...[
//                 Text(
//                   monthYear,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: textColor.withOpacity(0.8),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.description_rounded,
//                     color: AppColors.primary,
//                     size: 24,
//                   ),
//                 ),
//               ],
//             ],
//           ),

//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: isManager
//                 ? [
//                     _statItem(
//                       "Team",
//                       teamSize.toString(),
//                       Icons.people_alt_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       presentToday.toString(),
//                       Icons.verified_user_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       pendingLeaves.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absentToday.toString(),
//                       Icons.person_off_rounded,
//                     ),
//                     _statItem(
//                       "Overall Present",
//                       "$overallPresentPct%",
//                       Icons.trending_up_rounded,
//                     ),
//                   ]
//                 : [
//                     _statItem(
//                       "Total Days",
//                       totalDaysInMonth.toString(),
//                       Icons.calendar_today_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       present.toString(),
//                       Icons.check_circle_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       leave.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absent.toString(),
//                       Icons.cancel_rounded,
//                     ),
//                     _statItem(
//                       "On-Time",
//                       onTime.toString(),
//                       Icons.access_time_rounded,
//                     ),
//                     _statItem(
//                       "Late",
//                       late.toString(),
//                       Icons.hourglass_full_rounded,
//                     ),
//                   ],
//           ),
//           SizedBox(height: 16),
//           Divider(color: isDark ? Colors.white24 : Colors.white),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class PresentDashboardCardSection extends StatelessWidget {
//   final Map<String, dynamic>? dashboardData;
//   final bool isManager;

//   const PresentDashboardCardSection({
//     super.key,
//     required this.dashboardData,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Theme-based colors
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.orange[700];
//     final iconColor = isDark ? Colors.white : AppColors.primary;
//     final circleBgOpacity = isDark ? 0.2 : 0.1;

//     // Current month
//     final now = DateTime.now();
//     final currentMonth = DateTime(now.year, now.month, 1);
//     final nextMonth = DateTime(now.year, now.month + 1, 1);

//     if (dashboardData == null) {
//       return SizedBox(
//         height: 200,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     // baaki code same — dashboardData! use kar sakte ho ab
//     final attendance = dashboardData!['attendance'] as List<dynamic>? ?? [];

//     final monthAttendance = attendance.where((a) {
//       final attDate = DateTime.parse(a['att_date']);
//       return attDate.isAfter(currentMonth.subtract(Duration(days: 1))) &&
//           attDate.isBefore(nextMonth);
//     }).toList();

//     int present = 0, leave = 0, absent = 0, onTime = 0, late = 0;

//     for (var record in monthAttendance) {
//       if (record['att_status'] == 'checkin') {
//         present++;
//         final time = record['att_timestamp'] as String?;
//         if (time != null) {
//           final hour = int.parse(time.substring(11, 13));
//           final minute = int.parse(time.substring(14, 16));
//           if (hour < 9 || (hour == 9 && minute <= 30)) {
//             onTime++;
//           } else {
//             late++;
//           }
//         }
//       }
//     }

//     final totalDaysInMonth = nextMonth.subtract(Duration(days: 1)).day;
//     absent = totalDaysInMonth - (present + leave);

//     final teamSize = 5;
//     final presentToday = 2;
//     final pendingLeaves = dashboardData?['pending_leaves'] ?? 0;
//     final absentToday = teamSize - presentToday;
//     final overallPresent = teamSize > 0
//         ? (presentToday / teamSize * 100).round()
//         : 0;

//     // _statItem ab build ke andar hai — context available
//     Widget _statItem(String label, String value, IconData icon) {
//       return Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(circleBgOpacity),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 28, color: iconColor),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(fontSize: 13, color: secondaryTextColor),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       );
//     }

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.grey800 : AppColors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//             blurRadius: 12,
//             offset: Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: isManager
//                 ? [
//                     _statItem(
//                       "Team",
//                       teamSize.toString(),
//                       Icons.people_alt_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       presentToday.toString(),
//                       Icons.verified_user_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       pendingLeaves.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absentToday.toString(),
//                       Icons.person_off_rounded,
//                     ),
//                     _statItem(
//                       "OverAll Present",
//                       "$overallPresent%",
//                       Icons.trending_up_rounded,
//                     ),
//                   ]
//                 : [
//                     _statItem(
//                       "Days",
//                       totalDaysInMonth.toString(),
//                       Icons.calendar_today_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       present.toString(),
//                       Icons.check_circle_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       leave.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absent.toString(),
//                       Icons.cancel_rounded,
//                     ),
//                     _statItem(
//                       "OnTime",
//                       onTime.toString(),
//                       Icons.access_time_rounded,
//                     ),
//                     _statItem(
//                       "Late",
//                       late.toString(),
//                       Icons.hourglass_full_rounded,
//                     ),
//                   ],
//           ),
//           SizedBox(height: 16),
//           Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class PresentDashboardCardSection extends StatelessWidget {
//   final Map<String, dynamic> dashboardData;
//   final bool isManager;

//   const PresentDashboardCardSection({
//     super.key,
//     required this.dashboardData,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Theme-based colors
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.orange[700];
//     final iconColor = isDark ? Colors.white : AppColors.primary;
//     final circleBgOpacity = isDark ? 0.2 : 0.1;

//     // Current month
//     final now = DateTime.now();
//     final currentMonth = DateTime(now.year, now.month, 1);
//     final nextMonth = DateTime(now.year, now.month + 1, 1);

//     final attendance = dashboardData['attendance'] as List<dynamic>? ?? [];

//     final monthAttendance = attendance.where((a) {
//       final attDate = DateTime.parse(a['att_date']);
//       return attDate.isAfter(currentMonth.subtract(Duration(days: 1))) &&
//           attDate.isBefore(nextMonth);
//     }).toList();

//     int present = 0, leave = 0, absent = 0, onTime = 0, late = 0;

//     for (var record in monthAttendance) {
//       if (record['att_status'] == 'checkin') {
//         present++;
//         final time = record['att_timestamp'] as String?;
//         if (time != null) {
//           final hour = int.parse(time.substring(11, 13));
//           final minute = int.parse(time.substring(14, 16));
//           if (hour < 9 || (hour == 9 && minute <= 30)) {
//             onTime++;
//           } else {
//             late++;
//           }
//         }
//       }
//     }

//     final totalDaysInMonth = nextMonth.subtract(Duration(days: 1)).day;
//     absent = totalDaysInMonth - (present + leave);

//     final teamSize = 5;
//     final presentToday = 2;
//     final pendingLeaves = dashboardData['pending_leaves'] ?? 0;
//     final absentToday = teamSize - presentToday;
//     final overallPresent = teamSize > 0
//         ? (presentToday / teamSize * 100).round()
//         : 0;

//     // _statItem ab build ke andar hai — context available
//     Widget _statItem(String label, String value, IconData icon) {
//       return Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(circleBgOpacity),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 28, color: iconColor),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(fontSize: 13, color: secondaryTextColor),
//           ),
//         ],
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: isManager
//                 ? [
//                     _statItem(
//                       "Team",
//                       teamSize.toString(),
//                       Icons.people_alt_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       presentToday.toString(),
//                       Icons.verified_user_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       pendingLeaves.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absentToday.toString(),
//                       Icons.person_off_rounded,
//                     ),
//                     _statItem(
//                       "OverAll Present",
//                       "$overallPresent%",
//                       Icons.trending_up_rounded,
//                     ),
//                   ]
//                 : [
//                     _statItem(
//                       "Days",
//                       totalDaysInMonth.toString(),
//                       Icons.calendar_today_rounded,
//                     ),
//                     _statItem(
//                       "Present",
//                       present.toString(),
//                       Icons.check_circle_rounded,
//                     ),
//                     _statItem(
//                       "Leave",
//                       leave.toString(),
//                       Icons.beach_access_rounded,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absent.toString(),
//                       Icons.cancel_rounded,
//                     ),
//                     _statItem(
//                       "OnTime",
//                       onTime.toString(),
//                       Icons.access_time_rounded,
//                     ),
//                     _statItem(
//                       "Late",
//                       late.toString(),
//                       Icons.hourglass_full_rounded,
//                     ),
//                   ],
//           ),
//           SizedBox(height: 16),
//           Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
//         ],
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class PresentDashboardCardSection extends StatelessWidget {
//   final Map<String, dynamic> dashboardData;
//   final bool isManager;

//   const PresentDashboardCardSection({
//     super.key,
//     required this.dashboardData,
//     required this.isManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Common colors
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.orange;
//     final iconColor = isDark ? Colors.white : AppColors.primary;

//     // Current month
//     final now = DateTime.now();
//     final currentMonth = DateTime(now.year, now.month, 1);
//     final nextMonth = DateTime(now.year, now.month + 1, 1);

//     final attendance = dashboardData['attendance'] as List<dynamic>? ?? [];

//     // Current month ka attendance filter
//     final monthAttendance = attendance.where((a) {
//       final attDate = DateTime.parse(a['att_date']);
//       return attDate.isAfter(currentMonth.subtract(Duration(days: 1))) &&
//           attDate.isBefore(nextMonth);
//     }).toList();

//     int present = 0, leave = 0, absent = 0, onTime = 0, late = 0;

//     for (var record in monthAttendance) {
//       if (record['att_status'] == 'checkin') {
//         present++;
//         // OnTime / Late logic (example: check-in before 9:30 AM = on time)
//         final time = record['att_timestamp'] as String?;
//         if (time != null) {
//           final hour = int.parse(time.substring(11, 13));
//           final minute = int.parse(time.substring(14, 16));
//           if (hour < 9 || (hour == 9 && minute <= 30)) {
//             onTime++;
//           } else {
//             late++;
//           }
//         }
//       }
//     }

//     // For employee - current month days
//     final totalDaysInMonth = nextMonth.subtract(Duration(days: 1)).day;
//     absent = totalDaysInMonth - (present + leave);

//     // For manager - company wide stats (example values, real mein count karna padega)
//     final teamSize = 5;
//     final presentToday = 2;
//     final pendingLeaves = dashboardData['pending_leaves'] ?? 0;
//     final absentToday = teamSize - presentToday;
//     final overallPresent = teamSize > 0
//         ? (presentToday / teamSize * 100).round()
//         : 0;

//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: isManager
//                 ? [
//                     _statItem(
//                       "Team",
//                       teamSize.toString(),
//                       Icons.people_alt_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Present",
//                       presentToday.toString(),
//                       Icons.verified_user_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Leave",
//                       pendingLeaves.toString(),
//                       Icons.beach_access_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absentToday.toString(),
//                       Icons.person_off_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "OverAll Present",
//                       "$overallPresent%",
//                       Icons.trending_up_rounded,
//                       iconColor,
//                     ),
//                   ]
//                 : [
//                     _statItem(
//                       "Days",
//                       totalDaysInMonth.toString(),
//                       Icons.calendar_today_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Present",
//                       present.toString(),
//                       Icons.check_circle_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Leave",
//                       leave.toString(),
//                       Icons.beach_access_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Absent",
//                       absent.toString(),
//                       Icons.cancel_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "OnTime",
//                       onTime.toString(),
//                       Icons.access_time_rounded,
//                       iconColor,
//                     ),
//                     _statItem(
//                       "Late",
//                       late.toString(),
//                       Icons.schedule_rounded,
//                       iconColor,
//                     ),
//                   ],
//           ),
//           SizedBox(height: 16),
//           Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
//         ],
//       ),
//     );
//   }

//   Widget _statItem(String label, String value, IconData icon, Color iconColor) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, size: 28, color: iconColor),
//         ),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 4),
//         Text(label, style: TextStyle(fontSize: 13, color: Colors.orange[700])),
//       ],
//     );
//   }
// }
