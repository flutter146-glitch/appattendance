// // lib/features/dashboard/presentation/widgets/employeewidgets/attendance_history_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AttendanceHistoryWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> attendanceRecords;

//   const AttendanceHistoryWidget({super.key, required this.attendanceRecords});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Group records by date
//     final Map<String, Map<String, dynamic>> groupedRecords = {};

//     for (var record in attendanceRecords) {
//       final date = record['att_date'] as String;
//       final status = record['att_status'] as String;
//       final timestamp = record['att_timestamp'] as String;

//       if (!groupedRecords.containsKey(date)) {
//         groupedRecords[date] = {
//           'checkIn': null,
//           'checkOut': null,
//           'status': 'absent',
//           'workingHours': '0h 0m',
//         };
//       }

//       final time = DateTime.parse(timestamp);
//       final timeStr = DateFormat('hh:mm a').format(time);

//       if (status == 'checkin') {
//         groupedRecords[date]['checkIn'] = timeStr;
//         groupedRecords[date]['status'] = 'present';

//         // Check late
//         if (time.hour > 9 || (time.hour == 9 && time.minute > 15)) {
//           groupedRecords[date]['status'] = 'late';
//         }
//       } else if (status == 'checkout') {
//         groupedRecords[date]['checkOut'] = timeStr;
//       }

//       // Calculate working hours if both checkin and checkout exist
//       if (groupedRecords[date]['checkIn'] != null &&
//           groupedRecords[date]['checkOut'] != null) {
//         final checkInTime = record['att_status'] == 'checkin'
//             ? time
//             : DateTime.parse(
//                 attendanceRecords.firstWhere(
//                   (r) => r['att_date'] == date && r['att_status'] == 'checkin',
//                 )['att_timestamp'],
//               );
//         final checkOutTime = time;
//         final duration = checkOutTime.difference(checkInTime);
//         final hours = duration.inHours;
//         final minutes = duration.inMinutes.remainder(60);
//         groupedRecords[date]['workingHours'] = '${hours}h ${minutes}m';
//       }
//     }

//     final sortedDates = groupedRecords.keys.toList()
//       ..sort((a, b) => b.compareTo(a));

//     if (sortedDates.isEmpty) {
//       return Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Center(
//             child: Text(
//               "No attendance records yet",
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ),
//         ),
//       );
//     }

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
//               "Attendance History",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//             SizedBox(height: 16),

//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: sortedDates.length,
//               itemBuilder: (context, index) {
//                 final date = sortedDates[index];
//                 final data = groupedRecords[date]!;

//                 final status = data['status'] as String;
//                 Color statusColor;
//                 IconData statusIcon;

//                 switch (status) {
//                   case 'present':
//                     statusColor = Colors.green;
//                     statusIcon = Icons.check_circle;
//                     break;
//                   case 'late':
//                     statusColor = Colors.orange;
//                     statusIcon = Icons.access_time;
//                     break;
//                   case 'leave':
//                     statusColor = Colors.blue;
//                     statusIcon = Icons.beach_access;
//                     break;
//                   case 'absent':
//                   default:
//                     statusColor = Colors.red;
//                     statusIcon = Icons.cancel;
//                 }

//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.grey.shade700.withOpacity(0.3)
//                         : Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: statusColor.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     children: [
//                       // Status Icon
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(statusIcon, color: statusColor, size: 28),
//                       ),

//                       SizedBox(width: 16),

//                       // Date & Details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               DateFormat(
//                                 'EEEE, d MMMM yyyy',
//                               ).format(DateTime.parse(date)),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 if (data['checkIn'] != null)
//                                   _timeChip(
//                                     "In: ${data['checkIn']}",
//                                     Colors.green,
//                                   ),
//                                 SizedBox(width: 12),
//                                 if (data['checkOut'] != null)
//                                   _timeChip(
//                                     "Out: ${data['checkOut']}",
//                                     Colors.orange,
//                                   ),
//                                 Spacer(),
//                                 Text(
//                                   data['workingHours'],
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Status Badge
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: statusColor.withOpacity(0.5),
//                           ),
//                         ),
//                         child: Text(
//                           status.toUpperCase(),
//                           style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _timeChip(String label, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 13,
//           color: color,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }
