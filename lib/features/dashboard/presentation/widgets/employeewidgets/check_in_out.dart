// lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:appattendance/features/attendance/presentation/providers/geofence_notifier_provider.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CheckInOutWidget extends ConsumerWidget {
  const CheckInOutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider);
    final geofenceAsync = ref.watch(geofenceProvider);
    final user = ref.watch(authProvider).value;
    final isManagerial = user?.isManagerial ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Real geofence status (dummy location for demo - replace with Geolocator)
    final isInGeofence = geofenceAsync.when(
      data: (geofences) {
        // TODO: Use real location from Geolocator
        const double userLat = 19.0760; // Dummy Mumbai office
        const double userLon = 72.8777;
        return geofences.any((geo) => geo.containsLocation(userLat, userLon));
      },
      loading: () => false,
      error: (_, _) => false,
    );

    return Card(
      elevation: 500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.transparent,
      // color: isDark
      //     ? Colors.grey[900]!.withOpacity(0.85)
      //     : Colors.white.withOpacity(0.85),
      child: attendanceAsync.when(
        data: (records) {
          final today = DateTime.now();
          final todayStr = DateFormat('yyyy-MM-dd').format(today);

          final todayRecords = records.where((r) {
            final dateStr = r.attendanceDate?.toIso8601String().split('T')[0];
            return dateStr == todayStr;
          }).toList();

          final hasCheckedIn = todayRecords.any((r) => r.isCheckIn);
          final hasCheckedOut = todayRecords.any((r) => r.isCheckOut);

          final checkInTime = hasCheckedIn
              ? DateFormat(
                  'hh:mm a',
                ).format(todayRecords.firstWhere((r) => r.isCheckIn).timestamp!)
              : '--:--';

          final checkOutTime = hasCheckedOut
              ? DateFormat('hh:mm a').format(
                  todayRecords.firstWhere((r) => r.isCheckOut).timestamp!,
                )
              : '--:--';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   isManagerial ? 'Team Check Status' : 'My Check Status',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: isDark ? Colors.white70 : AppColors.primary,
              //   ),
              // ),
              // const SizedBox(height: 12),
              if (!isInGeofence)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Outside office geofence - Check-in disabled',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusTile(
                    label: 'Check-In',
                    time: checkInTime,
                    // icon: Icons.login,
                    color: hasCheckedIn ? Colors.green : Colors.grey,
                  ),
                  _StatusTile(
                    label: 'Check-Out',
                    time: checkOutTime,
                    // icon: Icons.logout,
                    color: hasCheckedOut ? Colors.orange : Colors.grey,
                  ),
                ],
              ),

              // if (isManagerial) ...[
              // const SizedBox(height: 2),
              // Text(
              //   'Team Present Today: ${ref.watch(dashboardProvider).value?.presentToday ?? 0}/${ref.watch(dashboardProvider).value?.teamSize ?? 0}',
              //   style: TextStyle(
              //     fontSize: 13,
              //     color: isDark ? Colors.white70 : Colors.black87,
              //   ),
              // ),
              // ],
              // const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    label: hasCheckedIn ? 'Checked In' : 'Check-In',
                    icon: Icons.login,
                    color: Colors.green,
                    isEnabled: !hasCheckedIn && isInGeofence,
                    onPressed: !hasCheckedIn && isInGeofence
                        ? () async {
                            await ref
                                .read(attendanceProvider.notifier)
                                .performCheckIn(
                                  latitude:
                                      19.0760, // TODO: Real from Geolocator
                                  longitude: 72.8777,
                                  verificationType: VerificationType.gps,
                                  geofenceName: 'Office Zone',
                                  projectId: 'P001',
                                  notes: 'Office entry',
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Check-In Successful!'),
                              ),
                            );
                          }
                        : null,
                  ),
                  _ActionButton(
                    label: 'Check-Out',
                    icon: Icons.logout,
                    color: Colors.orange,
                    isEnabled: hasCheckedIn && !hasCheckedOut && isInGeofence,
                    onPressed: hasCheckedIn && !hasCheckedOut && isInGeofence
                        ? () async {
                            await ref
                                .read(attendanceProvider.notifier)
                                .performCheckOut(
                                  latitude: 19.0760,
                                  longitude: 72.8777,
                                  verificationType: VerificationType.gps,
                                  geofenceName: 'Office Zone',
                                  projectId: 'P001',
                                  notes: 'Office exit',
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Check-Out Successful!'),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

// Compact helpers (same as before, but shorter)
class _StatusTile extends StatelessWidget {
  final String label;
  final String time;
  // final IconData icon;
  final Color color;

  const _StatusTile({
    required this.label,
    required this.time,
    // required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon(icon, color: color, size: 24),
        // const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart
// // Real implementation: Calls AttendanceRepository + geofence check + UI feedback

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class CheckInOutWidget extends ConsumerWidget {
//   final bool hasCheckedInToday;
//   final bool isInGeofence;

//   const CheckInOutWidget({
//     super.key,
//     required this.hasCheckedInToday,
//     required this.isInGeofence,
//   });

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
//                 // Check-In time
//                 // Check-In time
//                 _StatusTile(
//                   label: 'Check-In',
//                   time: attendanceState.when(
//                     data: (records) {
//                       final checkInRecord = records.firstWhere(
//                         (r) => r.isCheckIn,
//                         orElse: () => AttendanceModel(
//                           attId: 'dummy',
//                           empId: 'dummy',
//                           timestamp: DateTime.now(),
//                           attendanceDate:
//                               DateTime.now(), // ← Yeh line add kar di
//                           status: AttendanceStatus.checkIn,
//                         ),
//                       );
//                       return checkInRecord.formattedTime;
//                     },
//                     loading: () => '--:--',
//                     error: (_, _) => 'Error',
//                   ),
//                   icon: Icons.login,
//                   color: Colors.green,
//                 ),

//                 // Check-Out time (same fix)
//                 _StatusTile(
//                   label: 'Check-Out',
//                   time: attendanceState.when(
//                     data: (records) {
//                       final checkOutRecord = records.firstWhere(
//                         (r) => r.isCheckOut,
//                         orElse: () => AttendanceModel(
//                           attId: 'dummy',
//                           empId: 'dummy',
//                           timestamp: DateTime.now(),
//                           attendanceDate:
//                               DateTime.now(), // ← Yeh line add kar di
//                           status: AttendanceStatus.checkOut,
//                         ),
//                       );
//                       return checkOutRecord.formattedTime;
//                     },
//                     loading: () => '--:--',
//                     error: (_, _) => 'Error',
//                   ),
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                 ),
//                 // _StatusTile(
//                 //   label: 'Check-In',
//                 //   time: attendanceState.when(
//                 //     data: (records) => records
//                 //         .firstWhere(
//                 //           (r) => r.isCheckIn,
//                 //           orElse: () => AttendanceModel(
//                 //             attId: '',
//                 //             empId: '',
//                 //             timestamp: DateTime.now(),
//                 //             status: AttendanceStatus.checkIn,
//                 //           ),
//                 //         )
//                 //         .formattedTime,
//                 //     loading: () => '--:--',
//                 //     error: (_, _) => 'Error',
//                 //   ),
//                 //   icon: Icons.login,
//                 //   color: Colors.green,
//                 // ),
//                 // _StatusTile(
//                 //   label: 'Check-Out',
//                 //   time: attendanceState.when(
//                 //     data: (records) => records
//                 //         .firstWhere(
//                 //           (r) => r.isCheckOut,
//                 //           orElse: () => AttendanceModel(
//                 //             attId: '',
//                 //             empId: '',
//                 //             timestamp: DateTime.now(),
//                 //             status: AttendanceStatus.checkOut,
//                 //           ),
//                 //         )
//                 //         .formattedTime,
//                 //     loading: () => '--:--',
//                 //     error: (_, _) => 'Error',
//                 //   ),
//                 //   icon: Icons.logout,
//                 //   color: Colors.orange,
//                 // )
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _ActionButton(
//                   label: hasCheckedInToday ? 'Checked In' : 'Check-In',
//                   icon: Icons.login,
//                   color: Colors.green,
//                   isEnabled: !hasCheckedInToday && isInGeofence,
//                   onPressed: !hasCheckedInToday && isInGeofence
//                       ? () async {
//                           await ref
//                               .read(attendanceProvider.notifier)
//                               .performCheckIn(
//                                 latitude:
//                                     19.0760, // Dummy - replace with real location
//                                 longitude: 72.8777,
//                                 verificationType: VerificationType.gps,
//                                 geofenceName: 'Office Zone',
//                                 projectId: 'P001',
//                                 notes: 'Office entry',
//                               );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Check-In Successful!'),
//                             ),
//                           );
//                         }
//                       : null,
//                 ),
//                 _ActionButton(
//                   label: 'Check-Out',
//                   icon: Icons.logout,
//                   color: Colors.orange,
//                   isEnabled: hasCheckedInToday && isInGeofence,
//                   onPressed: hasCheckedInToday && isInGeofence
//                       ? () async {
//                           await ref
//                               .read(attendanceProvider.notifier)
//                               .performCheckOut(
//                                 latitude: 19.0760,
//                                 longitude: 72.8777,
//                                 verificationType: VerificationType.gps,
//                                 geofenceName: 'Office Zone',
//                                 projectId: 'P001',
//                                 notes: 'Office exit',
//                               );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Check-Out Successful!'),
//                             ),
//                           );
//                         }
//                       : null,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Geofence Status when repository properly work
//             //             final isInGeofence = await ref.read(geofenceProvider.notifier).checkCurrentLocation(lat, lon);
//             // if (isInGeofence) {
//             //   // Allow check-in
//             // } else {
//             //   showSnackBar("You are not in office geofence");
//             // }
//             if (!isInGeofence)
//               Text(
//                 'You are not in office geofence. Check-in disabled.',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Helper Widgets
// class _StatusTile extends StatelessWidget {
//   final String label;
//   final String time;
//   final IconData icon;
//   final Color color;

//   const _StatusTile({
//     required this.label,
//     required this.time,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 32),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         Text(
//           time,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color color;
//   final bool isEnabled;
//   final VoidCallback? onPressed;

//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.color,
//     required this.isEnabled,
//     this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: isEnabled ? onPressed : null,
//       icon: Icon(icon, size: 20),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isEnabled ? color : Colors.grey,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }




// // lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart
// // Upgraded: Face Auth on Check-in (December 31, 2025)
// // Biometric only if user enabled, else direct check-in
// // Wow factor: Face verification before check-in success

// import 'package:appattendance/core/services/biometric_service.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
// import 'package:appattendance/features/attendance/presentation/providers/attendance_provider.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class CheckInOutWidget extends ConsumerWidget {
//   const CheckInOutWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(authProvider).value;
//     if (user == null) return const SizedBox.shrink();

//     final attendanceState = ref.watch(attendanceProvider);
//     final attendanceNotifier = ref.read(attendanceProvider.notifier);

//     final biometricService = BiometricService();

//     return attendanceState.when(
//       data: (attendanceList) {
//         // Find today's attendance (latest entry)
//         final todayAttendance = attendanceList.isNotEmpty
//             ? attendanceList.firstWhere(
//                 (a) => DateTimeUtils.isSameDay(a.date, DateTime.now()),
//                 orElse: () => AttendanceModel.empty(),
//               )
//             : AttendanceModel.empty();

//         final isCheckedIn = todayAttendance.checkInTime != null;
//         final isCheckedOut = todayAttendance.checkOutTime != null;

//         return Column(
//           children: [
//             // Current status card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       isCheckedIn
//                           ? (isCheckedOut ? 'Checked Out' : 'Checked In')
//                           : 'Not Checked In',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: isCheckedIn
//                             ? (isCheckedOut ? Colors.orange : Colors.green)
//                             : Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     if (isCheckedIn)
//                       Text(
//                         'At ${DateFormat('hh:mm a').format(todayAttendance.checkInTime!)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Check-in / Check-out Button with Face Auth
//             SizedBox(
//               width: double.infinity,
//               height: 70,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   // Face Auth Check (if enabled)
//                   if (user.biometricEnabled) {
//                     final canUseBiometrics = await biometricService.canCheckBiometrics();
//                     if (canUseBiometrics) {
//                       final authenticated = await biometricService.authenticate(
//                         reason: 'Verify your face to ${isCheckedIn ? 'check out' : 'check in'}',
//                       );

//                       if (!authenticated) {
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Face verification failed. Try again.'),
//                               backgroundColor: Colors.redAccent,
//                             ),
//                           );
//                         }
//                         return; // Stop check-in
//                       }

//                       // Wow factor success animation/message
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Face Verified! ✅'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       }
//                     } else {
//                       // Fallback if no biometrics
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Biometrics not available on this device')),
//                         );
//                       }
//                     }
//                   }

//                   // Proceed with check-in/out
//                   try {
//                     await attendanceNotifier.performCheckInOut(
//                       empId: user.empId,
//                       isCheckIn: !isCheckedIn,
//                       // Add projectId, geoId, etc. from your flow
//                     );
//                   } catch (e) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: $e')),
//                       );
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isCheckedIn ? Colors.orange : Colors.green,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 18),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   elevation: 6,
//                 ),
//                 child: Text(
//                   isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(child: Text('Error: $err')),
//     );
//   }
// }