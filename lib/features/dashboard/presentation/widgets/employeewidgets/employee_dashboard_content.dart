// // lib/features/dashboard/presentation/widgets/employeewidgets/employee_dashboard_content.dart

// import 'dart:async';

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/custom_stat_row.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/attendance_breakdown_section.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class EmployeeDashboardContent extends StatefulWidget {
//   final Map<String, dynamic> data;

//   const EmployeeDashboardContent({super.key, required this.data});

//   @override
//   State<EmployeeDashboardContent> createState() =>
//       _EmployeeDashboardContentState();
// }

// class _EmployeeDashboardContentState extends State<EmployeeDashboardContent> {
//   String _currentTime = '';
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startClock();
//   }

//   void _startClock() {
//     _updateTime();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
//   }

//   void _updateTime() {
//     final now = DateTime.now();
//     setState(() {
//       _currentTime = DateFormat('HH:mm:ss').format(now);
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final user = widget.data['user'] as Map<String, dynamic>? ?? {};
//     final projects = widget.data['projects'] as List<dynamic>? ?? [];
//     final attendance = widget.data['attendance'] as List<dynamic>? ?? [];

//     final now = DateTime.now();
//     final monthStart = DateTime(now.year, now.month, 1);
//     final monthEnd = DateTime(now.year, now.month + 1, 0);
//     final totalDays = monthEnd.day;

//     int present = 0, onTime = 0, late = 0, leave = 0, absent = 0;

//     for (var rec in attendance) {
//       final dateStr = rec['att_date'] as String;
//       final date = DateTime.parse(dateStr);
//       if (date.isBefore(monthStart) || date.isAfter(monthEnd)) continue;

//       if (rec['att_status'] == 'checkin') {
//         present++;
//         final time = DateTime.parse(rec['att_timestamp']);
//         if (time.hour < 9 || (time.hour == 9 && time.minute <= 15)) {
//           onTime++;
//         } else {
//           late++;
//         }
//       }
//     }

//     absent = totalDays - (present + leave);

//     final hasCheckedInToday = attendance.any(
//       (a) =>
//           a['att_date'] == now.toString().substring(0, 10) &&
//           a['att_status'] == 'checkin',
//     );

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Header Background
//           // Container(
//           //   height: 240,
//           //   decoration: BoxDecoration(
//           //     gradient: LinearGradient(
//           //       colors: [Colors.blue[800]!, Colors.blue[600]!],
//           //       begin: Alignment.topLeft,
//           //       end: Alignment.bottomRight,
//           //     ),
//           //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//           //   ),
//           //   child: SafeArea(
//           //     child: Padding(
//           //       padding: EdgeInsets.all(20),
//           //       child: Column(
//           //         children: [
//           // Profile
//           // Row(
//           //   children: [
//           //     CircleAvatar(
//           //       radius: 40,
//           //       backgroundColor: Colors.white,
//           //       child: Icon(
//           //         Icons.person,
//           //         size: 50,
//           //         color: Colors.blue[700],
//           //       ),
//           //     ),
//           //     SizedBox(width: 16),
//           //     Expanded(
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           Text(
//           //             user['emp_name'] ?? 'Employee',
//           //             style: TextStyle(
//           //               color: Colors.white,
//           //               fontSize: 24,
//           //               fontWeight: FontWeight.bold,
//           //             ),
//           //           ),
//           //           Text(
//           //             user['emp_role'] ?? 'Flutter Developer',
//           //             style: TextStyle(
//           //               color: Colors.white70,
//           //               fontSize: 16,
//           //             ),
//           //           ),
//           //           Text(
//           //             user['emp_department'] ??
//           //                 'App Development dept.',
//           //             style: TextStyle(
//           //               color: Colors.white70,
//           //               fontSize: 14,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ],
//           // ),

//           // SizedBox(height: 30),

//           // // Live Date & Time
//           // Card(
//           //   elevation: 8,
//           //   shape: RoundedRectangleBorder(
//           //     borderRadius: BorderRadius.circular(20),
//           //   ),
//           //   child: Padding(
//           //     padding: EdgeInsets.all(20),
//           //     child: Row(
//           //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //       children: [
//           //         Column(
//           //           crossAxisAlignment: CrossAxisAlignment.start,
//           //           children: [
//           //             Text(
//           //               DateFormat('EEE MMM d yyyy').format(now),
//           //               style: TextStyle(fontSize: 18),
//           //             ),
//           //             Text(
//           //               _currentTime,
//           //               style: TextStyle(
//           //                 fontSize: 28,
//           //                 fontWeight: FontWeight.bold,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //         Container(
//           //           padding: EdgeInsets.symmetric(
//           //             horizontal: 16,
//           //             vertical: 8,
//           //           ),
//           //           decoration: BoxDecoration(
//           //             color: Colors.green[100],
//           //             borderRadius: BorderRadius.circular(20),
//           //           ),
//           //           child: Text(
//           //             "LIVE",
//           //             style: TextStyle(
//           //               color: Colors.green[800],
//           //               fontWeight: FontWeight.bold,
//           //             ),
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),

//           // Check-in Status
//           // Padding(
//           //   padding: EdgeInsets.all(20),
//           //   child: Column(
//           //     children: [
//           //       Text(
//           //         hasCheckedInToday
//           //             ? "You are in range of Nutantek"
//           //             : "You Are Not In Range Of Nutantek",
//           //         style: TextStyle(
//           //           fontSize: 16,
//           //           color: hasCheckedInToday ? Colors.green : Colors.red,
//           //         ),
//           //         textAlign: TextAlign.center,
//           //       ),
//           //       SizedBox(height: 16),
//           //       Row(
//           //         children: [
//           //           Expanded(
//           //             child: ElevatedButton.icon(
//           //               onPressed: hasCheckedInToday ? null : () {},
//           //               icon: Icon(Icons.login),
//           //               label: Text("CHECK IN"),
//           //               style: ElevatedButton.styleFrom(
//           //                 backgroundColor: Colors.grey[600],
//           //                 padding: EdgeInsets.symmetric(vertical: 16),
//           //                 shape: RoundedRectangleBorder(
//           //                   borderRadius: BorderRadius.circular(12),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //           SizedBox(width: 16),
//           //           Expanded(
//           //             child: ElevatedButton.icon(
//           //               onPressed: !hasCheckedInToday ? null : () {},
//           //               icon: Icon(Icons.logout),
//           //               label: Text("CHECK OUT"),
//           //               style: ElevatedButton.styleFrom(
//           //                 backgroundColor: Colors.grey[600],
//           //                 padding: EdgeInsets.symmetric(vertical: 16),
//           //                 shape: RoundedRectangleBorder(
//           //                   borderRadius: BorderRadius.circular(12),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ],
//           //   ),
//           // ),

//           // Monthly Attendance Table
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 20),
//           //   child: Column(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Text(
//           //         "My Attendance - ${DateFormat('MMMM yyyy').format(now)}",
//           //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           //       ),
//           //       SizedBox(height: 16),
//           //       Card(
//           //         elevation: 6,
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(20),
//           //         ),
//           //         child: Padding(
//           //           padding: EdgeInsets.all(20),
//           //           child: Row(
//           //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //             children: [
//           //               _statBox("Days", totalDays.toString(), Colors.grey),
//           //               _statBox("P", present.toString(), Colors.green),
//           //               _statBox("L", leave.toString(), Colors.orange),
//           //               _statBox("A", absent.toString(), Colors.red),
//           //               _statBox("OnTime", onTime.toString(), Colors.teal),
//           //               _statBox("Late", late.toString(), Colors.deepOrange),
//           //             ],
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),

//           // SizedBox(height: 30),

//           // Pie Chart
//           // In EmployeeDashboardContent build method
//           // employee_dashboard_content.dart mein
//           // SizedBox(height: 30),

//           // AttendanceBreakdownSection(
//           //   present: present,
//           //   leave: leave,
//           //   absent: absent,
//           //   onTime: onTime,
//           //   late: late,
//           //   dailyAvg: 9.0,
//           //   monthlyAvg: 63.0,
//           // ),
//           // SizedBox(height: 30),

//           // // Daily & Monthly Avg Hours
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 20),
//           //   child: Card(
//           //     elevation: 10,
//           //     shape: RoundedRectangleBorder(
//           //       borderRadius: BorderRadius.circular(24),
//           //     ),
//           //     child: Padding(
//           //       padding: EdgeInsets.all(24),
//           //       child: Column(
//           //         children: [
//           //           Text(
//           //             "Working Hours Summary",
//           //             style: TextStyle(
//           //               fontSize: 20,
//           //               fontWeight: FontWeight.bold,
//           //             ),
//           //           ),
//           //           SizedBox(height: 20),
//           //           CustomStatRow(
//           //             label: "Daily Avg",
//           //             value: "9.0 Hrs",
//           //             isGood: true,
//           //           ),
//           //           SizedBox(height: 16),
//           //           CustomStatRow(
//           //             label: "Monthly Avg",
//           //             value: "63 Hrs",
//           //             isGood: false,
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // SizedBox(height: 30),

//           // Mapped Projects
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 20),
//           //   child: Column(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Text(
//           //         "Mapped Projects (${projects.length})",
//           //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           //       ),
//           //       SizedBox(height: 16),
//           //       if (projects.isEmpty)
//           //         Card(
//           //           child: Padding(
//           //             padding: EdgeInsets.all(40),
//           //             child: Center(child: Text("No projects assigned")),
//           //           ),
//           //         )
//           //       else
//           //         ...projects.map(
//           //           (p) => Card(
//           //             margin: EdgeInsets.only(bottom: 12),
//           //             child: ListTile(
//           //               leading: CircleAvatar(
//           //                 backgroundColor: Colors.blue,
//           //                 child: Icon(Icons.work, color: Colors.white),
//           //               ),
//           //               title: Text(p['project_name'] ?? 'Project'),
//           //               subtitle: Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 children: [
//           //                   Text(p['project_site'] ?? ''),
//           //                   Text("Shift: ${p['shift'] ?? 'Morning'}"),
//           //                   Text(
//           //                     "Manager: ${p['manager_name'] ?? 'Manager A'}",
//           //                   ),
//           //                   Text(p['manager_email'] ?? 'xyz@nutantek.com'),
//           //                 ],
//           //               ),
//           //               trailing: Icon(Icons.arrow_forward_ios),
//           //             ),
//           //           ),
//           //         ),
//           //     ],
//           //   ),
//           // ),

//           // SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   //   Widget _statBox(String label, String value, Color color) {
//   //     return Column(
//   //       children: [
//   //         Text(
//   //           value,
//   //           style: TextStyle(
//   //             fontSize: 28,
//   //             fontWeight: FontWeight.bold,
//   //             color: color,
//   //           ),
//   //         ),
//   //         SizedBox(height: 4),
//   //         Text(label, style: TextStyle(fontSize: 14)),
//   //       ],
//   //     );
//   //   }
// }

// // // lib/features/dashboard/presentation/widgets/employeewidgets/employee_dashboard_content.dart

// // import 'package:appattendance/features/dashboard/presentation/widgets/employeewidgets/attendance_timer_section.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class EmployeeDashboardContent extends StatelessWidget {
// //   final Map<String, dynamic> data;

// //   const EmployeeDashboardContent({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = data['user'] as Map<String, dynamic>? ?? {};
// //     final projects = (data['projects'] as List<dynamic>?) ?? [];
// //     final attendance = (data['attendance'] as List<dynamic>?) ?? [];
// //     final hasCheckedInToday = data['has_checked_in_today'] as bool? ?? false;

// //     // Current month calculation
// //     final now = DateTime.now();
// //     final currentMonthStart = DateTime(now.year, now.month, 1);
// //     final currentMonthEnd = DateTime(
// //       now.year,
// //       now.month + 1,
// //       0,
// //     ); // last day of month
// //     final totalDaysInMonth = currentMonthEnd.day;

// //     int present = 0, onTime = 0, late = 0, leave = 0, absent = 0;

// //     for (var record in attendance) {
// //       final attDateStr = record['att_date'] as String?;
// //       if (attDateStr == null) continue;

// //       final attDate = DateTime.parse(attDateStr);
// //       if (attDate.isBefore(currentMonthStart) ||
// //           attDate.isAfter(currentMonthEnd))
// //         continue;

// //       if (record['att_status'] == 'checkin') {
// //         present++;

// //         // OnTime vs Late (example: before 9:30 AM = on time)
// //         final timestamp = record['att_timestamp'] as String?;
// //         if (timestamp != null) {
// //           final timePart = timestamp.substring(11, 16); // HH:MM
// //           final hour = int.parse(timePart.split(':')[0]);
// //           final minute = int.parse(timePart.split(':')[1]);

// //           if (hour < 9 || (hour == 9 && minute <= 30)) {
// //             onTime++;
// //           } else {
// //             late++;
// //           }
// //         }
// //       }
// //     }

// //     // Leave and Absent calculation (simplified - real mein leave table se aayega)
// //     leave = 0; // Tu leave table add kar le baad mein
// //     absent = totalDaysInMonth - (present + leave);

// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Greeting
// //           Text(
// //             "Hi, ${user['emp_name'] ?? 'Employee'}!",
// //             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 4),
// //           Text(
// //             "${user['emp_role'] ?? 'Employee'} • ${user['emp_department'] ?? 'Department'}",
// //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //           ),

// //           SizedBox(height: 30),

// //           // Today's Check-in Status
// //           // Card(
// //           //   elevation: 8,
// //           //   shape: RoundedRectangleBorder(
// //           //     borderRadius: BorderRadius.circular(20),
// //           //   ),
// //           //   color: hasCheckedInToday
// //           //       ? Colors.green.shade50
// //           //       : Colors.orange.shade50,
// //           //   child: Padding(
// //           //     padding: EdgeInsets.all(24),
// //           //     child: Row(
// //           //       children: [
// //           //         Icon(
// //           //           hasCheckedInToday
// //           //               ? Icons.check_circle_rounded
// //           //               : Icons.access_time_rounded,
// //           //           size: 60,
// //           //           color: hasCheckedInToday ? Colors.green : Colors.orange,
// //           //         ),
// //           //         SizedBox(width: 20),
// //           //         Expanded(
// //           //           child: Column(
// //           //             crossAxisAlignment: CrossAxisAlignment.start,
// //           //             children: [
// //           //               Text(
// //           //                 hasCheckedInToday
// //           //                     ? "Checked In Today"
// //           //                     : "Not Checked In Yet",
// //           //                 style: TextStyle(
// //           //                   fontSize: 20,
// //           //                   fontWeight: FontWeight.bold,
// //           //                 ),
// //           //               ),
// //           //               SizedBox(height: 8),
// //           //               Text(
// //           //                 hasCheckedInToday
// //           //                     ? "Great! You're on time."
// //           //                     : "Please check in to mark attendance",
// //           //                 style: TextStyle(
// //           //                   fontSize: 16,
// //           //                   color: Colors.grey[700],
// //           //                 ),
// //           //               ),
// //           //             ],
// //           //           ),
// //           //         ),
// //           //       ],
// //           //     ),
// //           //   ),
// //           // ),

// //           // timer section
// //           // AttendanceTimerSection(userData: user, attendanceRecords: attendance),
// //           AttendanceTimerSection(
// //             hasCheckedInToday: hasCheckedInToday,
// //             onCheckIn: () {
// //               // Check-in logic (camera + geofence + insert into employee_attendance)
// //               // Example:
// //               // insertAttendance('checkin');
// //             },
// //             onCheckOut: () {
// //               // Check-out logic
// //               // insertAttendance('checkout');
// //             },
// //           ),
// //           // AttendanceTimerSection(
// //           //   hasCheckedInToday: data['has_checked_in_today'] ?? false,
// //           //   checkInTime: data['attendance'].isNotEmpty
// //           //       ? data['attendance'].first['att_timestamp']
// //           //       : null,
// //           // ),
// //           SizedBox(height: 30),

// //           // Current Month Attendance Summary
// //           Text(
// //             "My Attendance - ${DateFormat('MMMM yyyy').format(now)}",
// //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 15),

// //           // Stats Row
// //           GridView.count(
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             crossAxisCount: 3,
// //             childAspectRatio: 1.2,
// //             mainAxisSpacing: 12,
// //             crossAxisSpacing: 12,
// //             children: [
// //               _statItem(
// //                 "Days",
// //                 totalDaysInMonth.toString(),
// //                 Icons.calendar_today_rounded,
// //                 Colors.blue,
// //               ),
// //               _statItem(
// //                 "Present",
// //                 present.toString(),
// //                 Icons.check_circle_rounded,
// //                 Colors.green,
// //               ),
// //               _statItem(
// //                 "Leave",
// //                 leave.toString(),
// //                 Icons.beach_access_rounded,
// //                 Colors.orange,
// //               ),
// //               _statItem(
// //                 "Absent",
// //                 absent.toString(),
// //                 Icons.cancel_rounded,
// //                 Colors.red,
// //               ),
// //               _statItem(
// //                 "OnTime",
// //                 onTime.toString(),
// //                 Icons.access_time_rounded,
// //                 Colors.teal,
// //               ),
// //               _statItem(
// //                 "Late",
// //                 late.toString(),
// //                 Icons.schedule_rounded,
// //                 Colors.deepOrange,
// //               ),
// //             ],
// //           ),

// //           SizedBox(height: 40),

// //           // Assigned Projects
// //           Text(
// //             "Assigned Projects (${projects.length})",
// //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 15),

// //           if (projects.isEmpty)
// //             Card(
// //               child: Padding(
// //                 padding: EdgeInsets.all(40),
// //                 child: Center(
// //                   child: Text(
// //                     "No projects assigned yet",
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                 ),
// //               ),
// //             )
// //           else
// //             ...projects.map(
// //               (project) => Card(
// //                 margin: EdgeInsets.only(bottom: 12),
// //                 elevation: 6,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16),
// //                 ),
// //                 child: ListTile(
// //                   contentPadding: EdgeInsets.all(16),
// //                   leading: CircleAvatar(
// //                     backgroundColor: Colors.blue,
// //                     child: Icon(Icons.work_outline, color: Colors.white),
// //                   ),
// //                   title: Text(
// //                     project['project_name'] ?? 'Unknown Project',
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                   ),
// //                   subtitle: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(project['project_site'] ?? ''),
// //                       Text("Client: ${project['client_name'] ?? 'Internal'}"),
// //                     ],
// //                   ),
// //                   trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
// //                 ),
// //               ),
// //             ),

// //           SizedBox(height: 100),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _statItem(String label, String value, IconData icon, Color color) {
// //     return Card(
// //       elevation: 6,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, size: 36, color: color),
// //             SizedBox(height: 12),
// //             Text(
// //               value,
// //               style: TextStyle(
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //                 color: color,
// //               ),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               label,
// //               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';

// // class EmployeeDashboardContent extends StatelessWidget {
// //   final Map<String, dynamic> data;

// //   const EmployeeDashboardContent({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = data['user'];
// //     final projects = data['projects'] as List<dynamic>;
// //     final hasCheckedInToday = data['has_checked_in_today'] as bool;

// //     return Padding(
// //       padding: EdgeInsets.all(20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "${user['emp_name']}!",
// //             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// //           ),
// //           Text("${user['emp_role']} • ${user['emp_department']}"),

// //           SizedBox(height: 30),

// //           Card(
// //             color: hasCheckedInToday
// //                 ? Colors.green.shade50
// //                 : Colors.orange.shade50,
// //             child: Padding(
// //               padding: EdgeInsets.all(20),
// //               child: Text(
// //                 hasCheckedInToday ? "Checked In Today" : "Not Checked In",
// //               ),
// //             ),
// //           ),

// //           SizedBox(height: 30),

// //           Text("Projects (${projects.length})"),
// //           ...projects.map(
// //             (p) => Card(
// //               child: ListTile(
// //                 title: Text(p['project_name']),
// //                 subtitle: Text(p['project_site']),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
