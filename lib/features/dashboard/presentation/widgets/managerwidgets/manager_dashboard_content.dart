// lib/features/dashboard/presentation/widgets/managerwidgets/manager_dashboard_content.dart

import 'dart:async';

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart';
import 'package:appattendance/features/dashboard/presentation/widgets/common/metrics_counter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagerDashboardContent extends StatefulWidget {
  final Map<String, dynamic> data;

  const ManagerDashboardContent({super.key, required this.data});

  @override
  State<ManagerDashboardContent> createState() =>
      _ManagerDashboardContentState();
}

class _ManagerDashboardContentState extends State<ManagerDashboardContent> {
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.data['user'] as Map<String, dynamic>? ?? {};
    final projects = (widget.data['projects'] as List<dynamic>?) ?? [];
    final attendance = (widget.data['attendance'] as List<dynamic>?) ?? [];

    // Real stats
    final totalProjects = projects.length;
    final teamSize = 5; // Real mein employee_master se count
    final todayDate = DateTime.now().toString().substring(
      0,
      10,
    ); // e.g. 2025-12-17
    final presentToday = attendance
        .where((a) => a['att_date'] == todayDate)
        .length;
    final absentToday = teamSize - presentToday;
    final pendingLeaves = widget.data['pending_leaves'] ?? 0;
    final overallPresentPercentage = teamSize > 0
        ? (presentToday / teamSize * 100).round()
        : 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          // Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.blue[800]!, Colors.blue[600]!],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          //   ),
          //   padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          // Row(
          //   children: [
          //     CircleAvatar(
          //       radius: 35,
          //       backgroundColor: Colors.white,
          //       child: Icon(
          //         Icons.person,
          //         size: 50,
          //         color: Colors.blue[700],
          //       ),
          //     ),
          //     SizedBox(width: 16),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          // Text(
          //   "Welcome back,",
          //   style: TextStyle(
          //     color: Colors.white70,
          //     fontSize: 14,
          //   ),
          // ),
          // Text(
          //   user['emp_name'] ?? 'Manager',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(
          //   user['emp_email'] ?? '',
          //   style: TextStyle(
          //     color: Colors.white70,
          //     fontSize: 14,
          //   ),
          // ),
          // Text(
          //   user['emp_id'] ?? '',
          //   style: TextStyle(
          //     color: Colors.white70,
          //     fontSize: 14,
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 12,
          //     vertical: 4,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.white24,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Text(
          //     "MANAGER",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          //               ],
          //             ),
          //           ),
          //           Stack(
          //             children: [
          //               Icon(
          //                 Icons.notifications,
          //                 color: Colors.white,
          //                 size: 30,
          //               ),
          //               Positioned(
          //                 right: 0,
          //                 top: 0,
          //                 child: Container(
          //                   padding: EdgeInsets.all(4),
          //                   decoration: BoxDecoration(
          //                     color: Colors.red,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: Text(
          //                     "3",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 10,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       SizedBox(height: 20),
          //       Center(
          //         child: Card(
          //           elevation: 8,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: Padding(
          //             padding: EdgeInsets.all(20),
          //             child: Column(
          //               children: [
          //                 Text(
          //                   DateFormat(
          //                     'EEEE, d MMMM yyyy',
          //                   ).format(DateTime.now()),
          //                   style: TextStyle(
          //                     fontSize: 18,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text(
          //                   _currentTime,
          //                   style: TextStyle(
          //                     fontSize: 32,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Container(
          //                   padding: EdgeInsets.symmetric(
          //                     horizontal: 16,
          //                     vertical: 8,
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: Colors.green[100],
          //                     borderRadius: BorderRadius.circular(20),
          //                   ),
          //                   child: Text(
          //                     "IT MANAGER",
          //                     style: TextStyle(
          //                       color: Colors.green[800],
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // dashboard_screen.dart ke body mein

          // Metrics Counter — 4 Big Cards
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: MetricsCounter(
          //     projectsCount: totalProjects,
          //     teamSize: teamSize,
          //     presentToday: presentToday,
          //     timesheetPeriod: "Q4 2025",
          //   ),
          // ),

          // SizedBox(height: 40),

          // // Mapped Projects
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Mapped Project",
          //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(height: 15),
          //       SizedBox(
          //         height: 160,
          //         child: projects.isEmpty
          //             ? Center(
          //                 child: Text(
          //                   "No projects assigned",
          //                   style: TextStyle(color: Colors.grey),
          //                 ),
          //               )
          //             : ListView(
          //                 scrollDirection: Axis.horizontal,
          //                 children: projects
          //                     .map(
          //                       (p) => Padding(
          //                         padding: EdgeInsets.only(right: 15),
          //                         child: _projectCard(p),
          //                       ),
          //                     )
          //                     .toList(),
          //               ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 30),

          // Quick Actions
          // SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue[700]),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectCard(Map<String, dynamic> project) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[700]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 12),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.folder, color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "ACT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['project_name'] ?? 'Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  project['client_name'] ?? 'Client',
                  style: TextStyle(color: Colors.white70),
                ),
                Text("3 members", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(icon, size: 44, color: color),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/managerwidgets/manager_dashboard_content.dart

// import 'dart:async';

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/managerwidgets/metrics_counter.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ManagerDashboardContent extends StatefulWidget {
//   final Map<String, dynamic> data;

//   const ManagerDashboardContent({super.key, required this.data});

//   @override
//   State<ManagerDashboardContent> createState() =>
//       _ManagerDashboardContentState();
// }

// class _ManagerDashboardContentState extends State<ManagerDashboardContent> {
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
//     final user = widget.data['user'];
//     final projects = widget.data['projects'] as List<dynamic>;
//     final attendance = widget.data['attendance'] as List<dynamic>;

//     // Fake team stats - real mein team count se aayega
//     final totalProjects = projects.length;
//     final teamSize = 5; // Real mein employee_master se count
//     final presentToday = 2; // Real mein today attendance se
//     final timesheetPeriod = "Q4 2025"; // Real mein calculate karenge
//     final absentToday = 5;
//     final pendingLeaves = widget.data['pending_leaves'] ?? 1;
//     final overallPresentPercentage = teamSize > 0
//         ? (presentToday / teamSize * 100).round()
//         : 0;

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Header
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue[800]!, Colors.blue[600]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 35,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.blue[700],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Welcome back,",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             user['emp_name'],
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             user['emp_email'],
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white24,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               "MANAGER",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Stack(
//                       children: [
//                         Icon(
//                           Icons.notifications,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             padding: EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               "3",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Text(
//                             DateFormat(
//                               'EEEE, d MMMM yyyy',
//                             ).format(DateTime.now()),
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             _currentTime,
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green[100],
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               "LIVE",
//                               style: TextStyle(
//                                 color: Colors.green[800],
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 20),

//           // Stats Row
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children:
//                   [
//                         _statCard("Team", teamSize.toString(), Icons.people),
//                         _statCard(
//                           "Present",
//                           presentToday.toString(),
//                           Icons.check_circle,
//                         ),
//                         _statCard(
//                           "Leaves",
//                           pendingLeaves.toString(),
//                           Icons.beach_access,
//                         ),
//                         _statCard(
//                           "Absent",
//                           absentToday.toString(),
//                           Icons.cancel,
//                         ),
//                         _statCard(
//                           "Overall Present",
//                           "$overallPresentPercentage%",
//                           Icons.trending_up,
//                         ),
//                       ]
//                       .map(
//                         (card) => Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 4),
//                             child: card,
//                           ),
//                         ),
//                       )
//                       .toList(),
//             ),
//           ),

//           SizedBox(height: 40),

//           // Metrics Counter — Yeh sirf Manager ko dikhega
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: MetricsCounter(
//               projectsCount: totalProjects,
//               teamSize: teamSize,
//               presentToday: presentToday,
//               timesheetPeriod: timesheetPeriod,
//             ),
//           ),
//           SizedBox(height: 40),

//           // Mapped Projects
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Mapped Project",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 15),
//                 SizedBox(
//                   height: 160,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: projects
//                         .map(
//                           (p) => Padding(
//                             padding: EdgeInsets.only(right: 15),
//                             child: _projectCard(p),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 20),

//           // Quick Actions
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _actionCard(
//                     "Attendance",
//                     Icons.how_to_reg,
//                     Colors.blue,
//                   ),
//                 ),
//                 SizedBox(width: 15),
//                 Expanded(
//                   child: _actionCard(
//                     "Employees",
//                     Icons.people_alt,
//                     Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   Widget _statCard(String title, String value, IconData icon) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Icon(icon, size: 30, color: Colors.blue[700]),
//             SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue[800],
//               ),
//             ),
//             Text(
//               title,
//               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _bigCard(String value, String title, IconData icon, Color bgColor) {
//     return Card(
//       color: bgColor,
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.black54),
//             SizedBox(height: 15),
//             Text(
//               value,
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _projectCard(Map<String, dynamic> project) {
//     return Container(
//       width: 220,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green[600]!, Colors.green[700]!],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.folder, color: Colors.white),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     "ACT",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   project['project_name'],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   project['client_name'],
//                   style: TextStyle(color: Colors.white70),
//                 ),
//                 Text("3 members", style: TextStyle(color: Colors.white70)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionCard(String title, IconData icon, Color color) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(icon, size: 40, color: color),
//             SizedBox(width: 20),
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
