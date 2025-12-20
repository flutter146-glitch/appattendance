// lib/features/dashboard/presentation/widgets/employeewidgets/attendance_timer_section.dart

import 'dart:async';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AttendanceTimerSection extends StatefulWidget {
  final bool hasCheckedInToday;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const AttendanceTimerSection({
    super.key,
    required this.hasCheckedInToday,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  State<AttendanceTimerSection> createState() => _AttendanceTimerSectionState();
}

class _AttendanceTimerSectionState extends State<AttendanceTimerSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int _workedMinutes = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

    _animController.forward();

    if (widget.hasCheckedInToday) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      setState(() => _workedMinutes++);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _triggerAnimation() {
    _animController.reset();
    _animController.forward();
  }

  double get progress => _workedMinutes / (9 * 60).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final workedHours = _workedMinutes ~/ 60;
    final workedMinutes = _workedMinutes % 60;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.blue.shade700,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Working Hours Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Working Hours',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: progress >= 1.0
                                  ? Colors.green.shade600
                                  : Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$workedHours h $workedMinutes m',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 600),
                            height: 12,
                            width:
                                (MediaQuery.of(context).size.width - 80) *
                                progress,
                            decoration: BoxDecoration(
                              color: progress >= 1.0
                                  ? Colors.green
                                  : Colors.orange.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14,
                              color: progress >= 1.0
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          Text(
                            '9 Hrs',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Check-in / Check-out Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.hasCheckedInToday
                                ? null
                                : () {
                                    _triggerAnimation();
                                    widget.onCheckIn();
                                  },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: widget.hasCheckedInToday
                                    ? Colors.grey.shade600
                                    : Colors.green.shade600,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.hasCheckedInToday
                                        ? Icons.verified_rounded
                                        : Icons.login_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    widget.hasCheckedInToday
                                        ? 'ACTIVE'
                                        : 'CHECK-IN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: !widget.hasCheckedInToday
                                ? null
                                : () {
                                    _triggerAnimation();
                                    widget.onCheckOut();
                                  },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: !widget.hasCheckedInToday
                                    ? Colors.grey.shade600
                                    : Colors.orange.shade600,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'CHECK-OUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// // lib/features/dashboard/presentation/widgets/employeewidgets/attendance_timer_section.dart

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AttendanceTimerSection extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final List<Map<String, dynamic>> attendanceRecords;

//   const AttendanceTimerSection({
//     super.key,
//     required this.userData,
//     required this.attendanceRecords,
//   });

//   @override
//   State<AttendanceTimerSection> createState() => _AttendanceTimerSectionState();
// }

// class _AttendanceTimerSectionState extends State<AttendanceTimerSection>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   String _workedTime = "00:00";
//   Timer? _timer;
//   DateTime? _checkInTime;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//     _controller.forward();

//     _checkTodayStatus();
//   }

//   void _checkTodayStatus() {
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final todayRecord = widget.attendanceRecords.firstWhere(
//       (a) => a['att_date'] == today && a['att_status'] == 'checkin',
//       orElse: () => {},
//     );

//     if (todayRecord.isNotEmpty) {
//       _checkInTime = DateTime.parse(todayRecord['att_timestamp']);
//       _startTimer();
//     }
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       if (_checkInTime != null) {
//         final diff = DateTime.now().difference(_checkInTime!);
//         final hours = diff.inHours.toString().padLeft(2, '0');
//         final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
//         setState(() {
//           _workedTime = "$hours:$minutes";
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final hasCheckedIn = _checkInTime != null;
//     final progress = hasCheckedIn
//         ? (DateTime.now().difference(_checkInTime!).inMinutes / (9 * 60)).clamp(
//             0.0,
//             1.0,
//           )
//         : 0.0;

//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Opacity(
//             opacity: _fadeAnimation.value,
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.grey.shade900 : Colors.blue.shade700,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.black.withOpacity(0.2),
//                     blurRadius: 12,
//                     offset: Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Header
//                   Row(
//                     children: [
//                       Text(
//                         "Present Timer",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: hasCheckedIn
//                               ? Colors.green.shade600
//                               : Colors.orange.shade600,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Text(
//                           hasCheckedIn ? _workedTime : "00:00",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),

//                   // Progress Bar
//                   Stack(
//                     children: [
//                       Container(
//                         height: 12,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                       AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         height: 12,
//                         width:
//                             MediaQuery.of(context).size.width * 0.7 * progress,
//                         decoration: BoxDecoration(
//                           color: hasCheckedIn ? Colors.green : Colors.orange,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Start",
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                       Text(
//                         "${(progress * 100).round()}%",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "9 Hrs",
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 30),

//                   // Check-in / Check-out Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: hasCheckedIn
//                               ? null
//                               : () {
//                                   // Future mein real check-in API
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("Checked In!")),
//                                   );
//                                   setState(() => _checkInTime = DateTime.now());
//                                   _startTimer();
//                                 },
//                           icon: Icon(Icons.login_rounded),
//                           label: Text("CHECK-IN"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: hasCheckedIn
//                                 ? Colors.grey
//                                 : Colors.green,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: !hasCheckedIn
//                               ? null
//                               : () {
//                                   // Future mein real check-out API
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("Checked Out!")),
//                                   );
//                                   setState(() => _checkInTime = null);
//                                   _timer?.cancel();
//                                   _workedTime = "00:00";
//                                 },
//                           icon: Icon(Icons.logout_rounded),
//                           label: Text("CHECK-OUT"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: !hasCheckedIn
//                                 ? Colors.grey
//                                 : Colors.orange,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/employeewidgets/attendance_timer_section.dart

// import 'dart:async';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class AttendanceTimerSection extends StatefulWidget {
//   final bool hasCheckedInToday;
//   final String? checkInTime; // Optional - real time from attendance

//   const AttendanceTimerSection({
//     super.key,
//     required this.hasCheckedInToday,
//     this.checkInTime,
//   });

//   @override
//   State<AttendanceTimerSection> createState() => _AttendanceTimerSectionState();
// }

// class _AttendanceTimerSectionState extends State<AttendanceTimerSection>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   int _workedMinutes = 0; // Real mein attendance timestamp se calculate
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();

//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

//     _animController.forward();

//     // Fake working hours timer (real mein check-in time se calculate)
//     if (widget.hasCheckedInToday) {
//       _startTimer();
//     }
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(minutes: 1), (_) {
//       setState(() => _workedMinutes++);
//     });
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _triggerAnimation() {
//     _animController.reset();
//     _animController.forward();
//   }

//   double get progress => _workedMinutes / (9 * 60).clamp(0.0, 1.0);

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final workedHours = _workedMinutes ~/ 60;
//     final workedMinutes = _workedMinutes % 60;

//     return AnimatedBuilder(
//       animation: _animController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Opacity(
//             opacity: _fadeAnimation.value,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.grey.shade900 : Colors.blue.shade700,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.5)
//                         : Colors.black.withOpacity(0.25),
//                     blurRadius: 15,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//                 border: Border.all(
//                   color: isDark
//                       ? Colors.grey.shade700
//                       : Colors.white.withOpacity(0.15),
//                   width: 1.5,
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Working Hours Progress
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Working Hours',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: progress >= 1.0
//                                   ? Colors.green.shade600
//                                   : Colors.orange.shade600,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               '$workedHours h $workedMinutes m',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Stack(
//                         children: [
//                           Container(
//                             height: 12,
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? Colors.grey.shade700
//                                   : Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 600),
//                             height: 12,
//                             width:
//                                 (MediaQuery.of(context).size.width - 80) *
//                                 progress.clamp(0.0, 1.0),
//                             decoration: BoxDecoration(
//                               color: progress >= 1.0
//                                   ? Colors.green
//                                   : Colors.orange.shade400,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Start',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.white70,
//                             ),
//                           ),
//                           Text(
//                             '${(progress * 100).toStringAsFixed(0)}%',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: progress >= 1.0
//                                   ? Colors.green
//                                   : Colors.orange,
//                             ),
//                           ),
//                           Text(
//                             '9 Hrs',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Check-in / Check-out Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 56,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: widget.hasCheckedInToday
//                                   ? null
//                                   : () {
//                                       _triggerAnimation();
//                                       // TODO: Check-in logic call karna hai (camera + geofence)
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(content: Text("Checked In!")),
//                                       );
//                                     },
//                               borderRadius: BorderRadius.circular(16),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: widget.hasCheckedInToday
//                                       ? (isDark
//                                             ? Colors.grey.shade700
//                                             : Colors.grey.shade400)
//                                       : Colors.green.shade600,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: widget.hasCheckedInToday
//                                         ? (isDark
//                                               ? Colors.grey.shade600
//                                               : Colors.grey.shade300)
//                                         : Colors.white.withOpacity(0.2),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       widget.hasCheckedInToday
//                                           ? Icons.verified_rounded
//                                           : Icons.login_rounded,
//                                       size: 20,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 12),
//                                     Text(
//                                       widget.hasCheckedInToday
//                                           ? 'ACTIVE'
//                                           : 'CHECK-IN',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       Expanded(
//                         child: Container(
//                           height: 56,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: !widget.hasCheckedInToday
//                                   ? null
//                                   : () {
//                                       _triggerAnimation();
//                                       // TODO: Check-out logic call karna hai
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(content: Text("Checked Out!")),
//                                       );
//                                     },
//                               borderRadius: BorderRadius.circular(16),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: !widget.hasCheckedInToday
//                                       ? (isDark
//                                             ? Colors.grey.shade700
//                                             : Colors.grey.shade400)
//                                       : Colors.orange.shade600,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: !widget.hasCheckedInToday
//                                         ? (isDark
//                                               ? Colors.grey.shade600
//                                               : Colors.grey.shade300)
//                                         : Colors.white.withOpacity(0.2),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.logout_rounded,
//                                       size: 20,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 12),
//                                     Text(
//                                       'CHECK-OUT',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
