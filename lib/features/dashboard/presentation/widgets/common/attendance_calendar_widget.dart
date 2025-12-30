// lib/features/dashboard/presentation/widgets/employeewidgets/attendance_calendar_widget.dart
// Upgraded: Uses AttendanceModel (freezed) + role-based
// Real data from DashboardNotifier + loading/error + dark mode
// Current date: December 29, 2025

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AttendanceCalendarWidget extends ConsumerWidget {
  const AttendanceCalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return dashboardAsync.when(
      data: (state) {
        final user = state.user;
        final attendanceRecords =
            state.todayAttendance; // TODO: Real month data from notifier

        return Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.isManagerial == true
                      ? "Team Attendance Calendar"
                      : "My Attendance Calendar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => false, // Optional selection
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: Colors.red.shade600),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final status = _getStatusForDate(day, attendanceRecords);
                      final color = _getMarkerColor(status);

                      return Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final status = _getStatusForDate(day, attendanceRecords);
                      final color = _getMarkerColor(status);

                      return Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _legendItem("Present", Colors.green),
                    _legendItem("Late", Colors.orange),
                    _legendItem("Absent", Colors.red),
                    _legendItem("Leave", Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text("Error loading calendar: $err")),
    );
  }

  String _getStatusForDate(DateTime date, List<AttendanceModel> records) {
    final record = records.firstWhere(
      (r) => isSameDay(r.timestamp, date),
      orElse: () => AttendanceModel(
        attId: '',
        empId: '',
        timestamp: date,
        status: AttendanceStatus.checkIn, // Default absent
      ),
    );

    if (record.status == AttendanceStatus.checkIn) {
      return record.isLate ? 'late' : 'present';
    }
    return 'absent'; // TODO: Integrate leave/holiday from employee_leaves
  }

  Color _getMarkerColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'leave':
        return Colors.blue;
      case 'holiday':
        return Colors.purple;
      case 'absent':
      default:
        return Colors.red;
    }
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// // lib/features/dashboard/presentation/widgets/employeewidgets/attendance_calendar_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class AttendanceCalendarWidget extends StatefulWidget {
//   final List<Map<String, dynamic>> attendanceRecords;
//   final DateTime? focusedMonth; // Optional — default current month

//   const AttendanceCalendarWidget({
//     super.key,
//     required this.attendanceRecords,
//     this.focusedMonth,
//   });

//   @override
//   State<AttendanceCalendarWidget> createState() =>
//       _AttendanceCalendarWidgetState();
// }

// class _AttendanceCalendarWidgetState extends State<AttendanceCalendarWidget> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   late DateTime _focusedDay;
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _focusedDay = DateTime(
//       widget.focusedMonth?.year ?? now.year,
//       widget.focusedMonth?.month ?? now.month,
//       1,
//     );
//     _selectedDay = now;
//   }

//   String _getStatusForDate(DateTime date) {
//     final dateStr = DateFormat('yyyy-MM-dd').format(date);
//     final record = widget.attendanceRecords.firstWhere(
//       (rec) => rec['att_date'] == dateStr,
//       orElse: () => <String, dynamic>{},
//     );

//     if (record.isEmpty) return 'absent';

//     final status = record['att_status'] as String?;
//     final timestamp = record['att_timestamp'] as String?;

//     if (status == 'checkin') {
//       if (timestamp != null) {
//         final time = DateTime.parse(timestamp);
//         final isLate = time.hour > 9 || (time.hour == 9 && time.minute > 15);
//         return isLate ? 'late' : 'present';
//       }
//       return 'present';
//     }
//     return 'absent';
//   }

//   Color _getMarkerColor(String status) {
//     switch (status) {
//       case 'present':
//         return Colors.green;
//       case 'late':
//         return Colors.orange;
//       case 'leave':
//         return Colors.blue;
//       case 'holiday':
//         return Colors.purple;
//       case 'absent':
//       default:
//         return Colors.red;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Card(
//       elevation: 12,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Attendance Calendar",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//             SizedBox(height: 16),

//             TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   setState(() => _calendarFormat = format);
//                 }
//               },
//               onPageChanged: (focusedDay) => _focusedDay = focusedDay,

//               calendarStyle: CalendarStyle(
//                 outsideDaysVisible: false,
//                 weekendTextStyle: TextStyle(color: Colors.red.shade600),
//                 selectedDecoration: BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                 ),
//                 todayDecoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//               ),

//               headerStyle: HeaderStyle(
//                 formatButtonVisible: true,
//                 titleCentered: true,
//                 titleTextStyle: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               calendarBuilders: CalendarBuilders(
//                 defaultBuilder: (context, day, focusedDay) {
//                   final status = _getStatusForDate(day);
//                   final color = _getMarkerColor(status);

//                   return Center(
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 todayBuilder: (context, day, focusedDay) {
//                   final status = _getStatusForDate(day);
//                   final color = _getMarkerColor(status);

//                   return Center(
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: color,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             SizedBox(height: 20),

//             Wrap(
//               spacing: 16,
//               runSpacing: 8,
//               children: [
//                 _legendItem("Present", Colors.green),
//                 _legendItem("Late", Colors.orange),
//                 _legendItem("Absent", Colors.red),
//                 _legendItem("Leave", Colors.blue),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _legendItem(String label, Color color) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         SizedBox(width: 8),
//         Text(label, style: TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }
