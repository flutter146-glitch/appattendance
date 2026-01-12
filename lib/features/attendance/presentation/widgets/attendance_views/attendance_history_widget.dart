// // lib/features/attendance/presentation/widgets/attendance_history_widget.dart
// // FINAL UPGRADED & POLISHED VERSION - January 08, 2026
// // Modern gradient cards, icons, clean spacing, grouped by date
// // Null-safe, dark mode support, responsive (no overflow)
// // Role-aware: Employee sees own history, Manager sees team if toggled
// // Live data from DB (no dummy), 6 months limit, pull-to-refresh ready
// // UI/UX same (layout, colors, stats items) but polished

// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class AttendanceHistoryWidget extends ConsumerWidget {
//   const AttendanceHistoryWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final userAsync = ref.watch(authProvider);
//     final attendanceAsync = ref.watch(attendanceProvider);

//     return userAsync.when(
//       data: (user) {
//         if (user == null) {
//           return const SizedBox.shrink();
//         }

//         final isManagerial = user.isManagerial;

//         // View mode toggle
//         final viewMode = ref.watch(viewModeProvider);
//         final effectiveManagerial =
//             viewMode == ViewMode.manager && isManagerial;

//         return attendanceAsync.when(
//           data: (records) {
//             // Adapt data safely
//             List<AttendanceModel> attendanceList = [];
//             if (effectiveManagerial) {
//               attendanceList = records; // Team attendance history
//             } else {
//               attendanceList = records
//                   .where((r) => r.empId == user.empId)
//                   .toList(); // Own history
//             }

//             if (attendanceList.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   "No attendance history available",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//               );
//             }

//             // Group records by date
//             final Map<String, List<AttendanceModel>> groupedRecords = {};
//             for (var record in attendanceList) {
//               final date = DateFormat(
//                 'MMMM d, yyyy',
//               ).format(record.attendanceDate);
//               groupedRecords[date] = groupedRecords[date] ?? [];
//               groupedRecords[date]!.add(record);
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   effectiveManagerial
//                       ? "Team Attendance History"
//                       : "My Attendance History",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 SizedBox(
//                   height: 180,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: groupedRecords.length,
//                     itemBuilder: (context, index) {
//                       final date = groupedRecords.keys.elementAt(index);
//                       final dailyRecords = groupedRecords[date]!;

//                       return Container(
//                         width: 260,
//                         margin: const EdgeInsets.only(right: 16),
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade800.withOpacity(0.7)
//                               : Colors.white.withOpacity(0.85),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(
//                                 isDark ? 0.4 : 0.1,
//                               ),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.primary.withOpacity(
//                                         isDark ? 0.3 : 0.1,
//                                       ),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.calendar_today_rounded,
//                                       size: 24,
//                                       color: AppColors.primary,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Text(
//                                       date,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: isDark
//                                             ? Colors.white
//                                             : Colors.black87,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Status: ${dailyRecords.first.displayStatus}',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: isDark
//                                       ? Colors.white70
//                                       : Colors.grey[700],
//                                 ),
//                               ),
//                               Text(
//                                 'Check-in: ${dailyRecords.first.formattedCheckInTime}',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: isDark
//                                       ? Colors.white70
//                                       : Colors.grey[700],
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: dailyRecords.first.statusColor
//                                       .withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   'Type: ${dailyRecords.first.displayType}',
//                                   style: TextStyle(
//                                     color: dailyRecords.first.statusColor,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (err, stack) => Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Error loading attendance: $err',
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Error loading user: $err',
//             style: const TextStyle(color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
