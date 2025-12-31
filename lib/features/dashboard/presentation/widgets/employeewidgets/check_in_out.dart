// lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart
// Real implementation: Calls AttendanceRepository + geofence check + UI feedback

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../attendance/data/services/geofence_service.dart';
import '../../../../attendance/data/services/location_service.dart';

class CheckInOutWidget extends ConsumerWidget {
  final bool hasCheckedInToday;
  final bool isInGeofence;

  const CheckInOutWidget({
    super.key,
    required this.hasCheckedInToday,
    required this.isInGeofence,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Status Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusTile(
                  label: 'Check-In',
                  time: attendanceState.when(
                    data: (records) => records
                        .firstWhere(
                          (r) => r.isCheckIn,
                          orElse: () => AttendanceModel(
                            attId: '',
                            empId: '',
                            timestamp: DateTime.now(),
                            status: AttendanceStatus.checkIn,
                          ),
                        )
                        .formattedTime,
                    loading: () => '--:--',
                    error: (_, __) => 'Error',
                  ),
                  icon: Icons.login,
                  color: Colors.green,
                ),
                _StatusTile(
                  label: 'Check-Out',
                  time: attendanceState.when(
                    data: (records) => records
                        .firstWhere(
                          (r) => r.isCheckOut,
                          orElse: () => AttendanceModel(
                            attId: '',
                            empId: '',
                            timestamp: DateTime.now(),
                            status: AttendanceStatus.checkOut,
                          ),
                        )
                        .formattedTime,
                    loading: () => '--:--',
                    error: (_, __) => 'Error',
                  ),
                  icon: Icons.logout,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: hasCheckedInToday ? 'Checked In' : 'Check-In',
                  icon: Icons.login,
                  color: Colors.green,
                  isEnabled: !hasCheckedInToday && isInGeofence,
                  onPressed: !hasCheckedInToday && isInGeofence
                      ? () async {
                    final position = await LocationService.getCurrentLocation();

                    final geofenceName = GeofenceService.getGeofenceName(
                      position.latitude,
                      position.longitude,
                    );

                    final allowed =
                    GeofenceService.isInAllowedZone(geofenceName);

                    if (!allowed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You are outside allowed location'),
                        ),
                      );
                      return;
                    }

                    await ref
                        .read(attendanceProvider.notifier)
                        .performCheckIn(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      verificationType: VerificationType.gps,
                      geofenceName: geofenceName,
                      projectId: 'AUTO', // later from mapped project
                      notes: geofenceName == 'WFH'
                          ? 'Work from home'
                          : 'Office entry',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check-In Successful')),
                    );
                  }
                      : null,

                ),
                _ActionButton(
                  label: 'Check-Out',
                  icon: Icons.logout,
                  color: Colors.orange,
                  isEnabled: hasCheckedInToday && isInGeofence,
                  onPressed: !hasCheckedInToday && isInGeofence
                      ? () async {
                    final position = await LocationService.getCurrentLocation();

                    final geofenceName = GeofenceService.getGeofenceName(
                      position.latitude,
                      position.longitude,
                    );

                    final allowed =
                    GeofenceService.isInAllowedZone(geofenceName);

                    if (!allowed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You are outside allowed location'),
                        ),
                      );
                      return;
                    }

                    await ref
                        .read(attendanceProvider.notifier)
                        .performCheckOut(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      verificationType: VerificationType.gps,
                      geofenceName: geofenceName,
                      projectId: 'AUTO', // later from mapped project
                      notes: geofenceName == 'WFH'
                          ? 'Work from home'
                          : 'Office entry',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check-In Successful')),
                    );
                  }
                      : null,

                ),
              ],
            ),

            const SizedBox(height: 16),

            // Geofence Status when repository properly work
            //             final isInGeofence = await ref.read(geofenceProvider.notifier).checkCurrentLocation(lat, lon);
            // if (isInGeofence) {
            //   // Allow check-in
            // } else {
            //   showSnackBar("You are not in office geofence");
            // }
            if (!isInGeofence)
              Text(
                'You are not in office geofence. Check-in disabled.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class _StatusTile extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;

  const _StatusTile({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}





//// ye h real geofence kaa connected log:- 
///
///
///// lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart
// Final upgraded version: Real geolocator + geofence check + UI feedback

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
// import 'package:appattendance/features/geofence/presentation/providers/geofence_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';

// class CheckInOutWidget extends ConsumerWidget {
//   const CheckInOutWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final attendanceState = ref.watch(attendanceProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: isDark ? Colors.grey[850] : Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Today\'s Attendance',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Status Display
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _StatusTile(
//                   label: 'Check-In',
//                   time: attendanceState.when(
//                     data: (records) => records
//                         .firstWhere(
//                           (r) => r.isCheckIn,
//                           orElse: () => AttendanceModel(
//                             attId: '',
//                             empId: '',
//                             timestamp: DateTime.now(),
//                             status: AttendanceStatus.checkIn,
//                           ),
//                         )
//                         .formattedTime,
//                     loading: () => '--:--',
//                     error: (_, __) => 'Error',
//                   ),
//                   icon: Icons.login,
//                   color: Colors.green,
//                 ),
//                 _StatusTile(
//                   label: 'Check-Out',
//                   time: attendanceState.when(
//                     data: (records) => records
//                         .firstWhere(
//                           (r) => r.isCheckOut,
//                           orElse: () => AttendanceModel(
//                             attId: '',
//                             empId: '',
//                             timestamp: DateTime.now(),
//                             status: AttendanceStatus.checkOut,
//                           ),
//                         )
//                         .formattedTime,
//                     loading: () => '--:--',
//                     error: (_, __) => 'Error',
//                   ),
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Action Buttons with Real Geofence Check
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _ActionButton(
//                   label: attendanceState.value?.any((r) => r.isCheckIn) ?? false ? 'Checked In' : 'Check-In',
//                   icon: Icons.login,
//                   color: Colors.green,
//                   isEnabled: !(attendanceState.value?.any((r) => r.isCheckIn) ?? false),
//                   onPressed: () => _handleCheckInOut(ref, context, isCheckIn: true),
//                 ),
//                 _ActionButton(
//                   label: 'Check-Out',
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                   isEnabled: attendanceState.value?.any((r) => r.isCheckIn) ?? false,
//                   onPressed: () => _handleCheckInOut(ref, context, isCheckIn: false),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Geofence Status Feedback
//             if (attendanceState.hasError)
//               Text(
//                 'Error loading status',
//                 style: TextStyle(color: Colors.red, fontSize: 12),
//                 textAlign: TextAlign.center,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleCheckInOut(WidgetRef ref, BuildContext context, {required bool isCheckIn}) async {
//     try {
//       // 1. Location services check
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enable location services')),
//         );
//         return;
//       }

//       // 2. Permission check & request
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permission denied')),
//           );
//           return;
//         }
//       }

//       // 3. Get current location
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // 4. Real geofence check
//       final isInside = await ref.read(geofenceProvider.notifier).checkCurrentLocation(
//         position.latitude,
//         position.longitude,
//       );

//       if (!isInside) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('You are not in office geofence')),
//         );
//         return;
//       }

//       // 5. Proceed with check-in/out
//       if (isCheckIn) {
//         await ref.read(attendanceProvider.notifier).performCheckIn(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           verificationType: VerificationType.gps,
//           geofenceName: 'Office Zone', // Can be dynamic from geofence match
//           projectId: 'P001',
//           notes: 'Office entry via geofence',
//         );
//       } else {
//         await ref.read(attendanceProvider.notifier).performCheckOut(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           verificationType: VerificationType.gps,
//           geofenceName: 'Office Zone',
//           projectId: 'P001',
//           notes: 'Office exit via geofence',
//         );
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${isCheckIn ? 'Check-In' : 'Check-Out'} Successful!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
// }

// _StatusTile and _ActionButton same as yours (no change needed)



// lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart
// // Final version: Real geolocator + geofence check + repository call

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
// import 'package:appattendance/features/attendance/presentation/providers/geofence_notifier_provider.dart';
// import 'package:appattendance/features/geofence/presentation/providers/geofence_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';

// class CheckInOutWidget extends ConsumerWidget {
//   const CheckInOutWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final attendanceState = ref.watch(attendanceProvider);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: isDark ? Colors.grey[850] : Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Today\'s Attendance',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Status Display
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _StatusTile(
//                   label: 'Check-In',
//                   time: attendanceState.when(
//                     data: (records) => records
//                         .firstWhere(
//                           (r) => r.isCheckIn,
//                           orElse: () => AttendanceModel(
//                             attId: '',
//                             empId: '',
//                             timestamp: DateTime.now(),
//                             status: AttendanceStatus.checkIn,
//                           ),
//                         )
//                         .formattedTime,
//                     loading: () => '--:--',
//                     error: (_, __) => 'Error',
//                   ),
//                   icon: Icons.login,
//                   color: Colors.green,
//                 ),
//                 _StatusTile(
//                   label: 'Check-Out',
//                   time: attendanceState.when(
//                     data: (records) => records
//                         .firstWhere(
//                           (r) => r.isCheckOut,
//                           orElse: () => AttendanceModel(
//                             attId: '',
//                             empId: '',
//                             timestamp: DateTime.now(),
//                             status: AttendanceStatus.checkOut,
//                           ),
//                         )
//                         .formattedTime,
//                     loading: () => '--:--',
//                     error: (_, __) => 'Error',
//                   ),
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Action Buttons with Real Geofence Check
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _ActionButton(
//                   label: attendanceState.value?.any((r) => r.isCheckIn) ?? false
//                       ? 'Checked In'
//                       : 'Check-In',
//                   icon: Icons.login,
//                   color: Colors.green,
//                   isEnabled:
//                       !(attendanceState.value?.any((r) => r.isCheckIn) ??
//                           false),
//                   onPressed: () =>
//                       _handleCheckAction(ref, context, isCheckIn: true),
//                 ),
//                 _ActionButton(
//                   label: 'Check-Out',
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                   isEnabled:
//                       attendanceState.value?.any((r) => r.isCheckIn) ?? false,
//                   onPressed: () =>
//                       _handleCheckAction(ref, context, isCheckIn: false),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Geofence / Permission Status
//             if (attendanceState.hasError)
//               Text(
//                 'Error loading status',
//                 style: const TextStyle(color: Colors.red, fontSize: 12),
//                 textAlign: TextAlign.center,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleCheckAction(
//     WidgetRef ref,
//     BuildContext context, {
//     required bool isCheckIn,
//   }) async {
//     try {
//       // 1. Location Services Check
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enable location services')),
//         );
//         return;
//       }

//       // 2. Permission Check & Request
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permission denied')),
//           );
//           return;
//         }
//       }

//       // 3. Get Current Location
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // 4. Real Geofence Check
//       final isInside = await ref
//           .read(geofenceProvider.notifier)
//           .checkCurrentLocation(position.latitude, position.longitude);

//       if (!isInside) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('You are not in any office geofence')),
//         );
//         return;
//       }

//       // 5. Proceed with Check-In/Out
//       if (isCheckIn) {
//         await ref
//             .read(attendanceProvider.notifier)
//             .performCheckIn(
//               latitude: position.latitude,
//               longitude: position.longitude,
//               verificationType: VerificationType.gps,
//               geofenceName: 'Office Zone', // Dynamic bana sakte ho
//               projectId: 'P001',
//               notes: 'Office entry via geofence',
//             );
//       } else {
//         await ref
//             .read(attendanceProvider.notifier)
//             .performCheckOut(
//               latitude: position.latitude,
//               longitude: position.longitude,
//               verificationType: VerificationType.gps,
//               geofenceName: 'Office Zone',
//               projectId: 'P001',
//               notes: 'Office exit via geofence',
//             );
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('${isCheckIn ? 'Check-In' : 'Check-Out'} Successful!'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
// }




// // lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class CheckInOutWidget extends StatelessWidget {
//   final bool hasCheckedInToday;
//   final VoidCallback onCheckIn;
//   final VoidCallback onCheckOut;
//   final bool isInGeofence;

//   const CheckInOutWidget({
//     super.key,
//     required this.hasCheckedInToday,
//     required this.onCheckIn,
//     required this.onCheckOut,
//     required this.isInGeofence,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Card(
//       elevation: 200,
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       // color: isDark ? Colors.grey.shade800 : Colors.white,
//       color: Colors.transparent,
//       child: Padding(
//         padding: EdgeInsets.all(5),
//         child: Column(
//           children: [
//             // Geofence Status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   isInGeofence ? Icons.location_on : Icons.location_off,
//                   color: isInGeofence ? AppColors.primaryDark : Colors.red,
//                   size: 28,
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   isInGeofence
//                       ? "You are in range of Nutantek"
//                       : "You Are Not In Range Of Nutantek",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: isInGeofence ? AppColors.primaryDark : Colors.red,
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 5),

//             // Check-in / Check-out Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: isInGeofence && !hasCheckedInToday
//                         ? onCheckIn
//                         : null,
//                     icon: Icon(Icons.login, size: 20),
//                     label: Text(
//                       "CHECK IN",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade600,
//                       foregroundColor: Colors.limeAccent,
//                       padding: EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 6,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: isInGeofence && hasCheckedInToday
//                         ? onCheckOut
//                         : null,
//                     icon: Icon(Icons.logout, size: 20),
//                     label: Text(
//                       "CHECK OUT",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange.shade600,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 6,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
