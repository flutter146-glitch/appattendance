// lib/features/dashboard/presentation/providers/dashboard_notifier.dart
// Dashboard State Notifier
// Loads user info, today's attendance, team stats (for manager)
// Uses real DB queries + UserModel + AttendanceModel
// Supports refresh/pull-to-refresh
// Error/loading handled with AsyncValue

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final UserModel? user;
  final List<AttendanceModel> todayAttendance;
  final int teamSize;
  final int presentToday;
  final String? welcomeMessage;

  DashboardState({
    this.user,
    this.todayAttendance = const [],
    this.teamSize = 0,
    this.presentToday = 0,
    this.welcomeMessage,
  });

  bool get hasCheckedInToday => todayAttendance.any((a) => a.isCheckIn);
  bool get hasCheckedOutToday => todayAttendance.any((a) => a.isCheckOut);

  DateTime? get checkInTime => todayAttendance
      .firstWhere(
        (a) => a.isCheckIn,
        orElse: () => AttendanceModel(
          attId: '',
          empId: '',
          timestamp: DateTime.now(),
          status: AttendanceStatus.checkIn,
        ),
      )
      .timestamp;

  DateTime? get checkOutTime => todayAttendance
      .firstWhere(
        (a) => a.isCheckOut,
        orElse: () => AttendanceModel(
          attId: '',
          empId: '',
          timestamp: DateTime.now(),
          status: AttendanceStatus.checkOut,
        ),
      )
      .timestamp;
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>(
      (ref) => DashboardNotifier(ref),
    );

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardState>> {
  final Ref ref;

  DashboardNotifier(this.ref) : super(const AsyncLoading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError('Not logged in', StackTrace.current);
        return;
      }

      final db = await DBHelper.instance.database;
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Today's attendance
      final attendanceRows = await db.query(
        'employee_attendance',
        where: 'emp_id = ? AND DATE(att_timestamp) = ?',
        whereArgs: [user.empId, today],
        orderBy: 'att_timestamp ASC',
      );

      final todayAttendance = attendanceRows.map(attendanceFromDB).toList();

      // Team stats (only if managerial)
      int teamSize = 0;
      int presentToday = 0;

      if (user.isManagerial) {
        final teamMembers = await db.query(
          'employee_master',
          where: 'reportingManagerId = ?',
          whereArgs: [user.empId],
        );

        teamSize = teamMembers.length;

        if (teamSize > 0) {
          final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();
          final presentQuery = await db.rawQuery(
            '''
            SELECT COUNT(DISTINCT emp_id) as count
            FROM employee_attendance
            WHERE DATE(att_timestamp) = ?
            AND att_status = 'checkIn'
            AND emp_id IN (${List.filled(teamSize, '?').join(',')})
            ''',
            [today, ...empIds],
          );
          presentToday = presentQuery.first['count'] as int? ?? 0;
        }
      }

      final welcome = user.isManagerial
          ? "Welcome, ${user.shortName} (Manager)"
          : "Welcome back, ${user.shortName}";

      state = AsyncData(
        DashboardState(
          user: user,
          todayAttendance: todayAttendance,
          teamSize: teamSize,
          presentToday: presentToday,
          welcomeMessage: welcome,
        ),
      );
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  // For pull-to-refresh
  Future<void> refresh() async {
    await loadDashboard();
  }
}

//HOW TO USE NOTIFIER:-

// DashboardScreen ke build mein
// final dashboardAsync = ref.watch(dashboardProvider);

// dashboardAsync.when(
//   data: (state) {
//     return Column(
//       children: [
//         Text(state.welcomeMessage ?? "Loading..."),
//         if (state.hasCheckedInToday)
//           Text("Check-in: ${state.checkInTime?.formattedTime ?? ''}"),
//         if (state.hasCheckedOutToday)
//           Text("Check-out: ${state.checkOutTime?.formattedTime ?? ''}"),
//         if (state.teamSize > 0)
//           Text("Team: ${state.teamSize} members | Present today: ${state.presentToday}"),
//         // CheckInOutWidget yahan add karo
//       ],
//     );
//   },
//   loading: () => const Center(child: CircularProgressIndicator()),
//   error: (err, stack) => Center(child: Text("Error: $err")),
// );

// // RefreshIndicator ke liye
// RefreshIndicator(
//   onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
//   child: YourScrollableContent(),
// );


/*******************************************************************
 * 
 * 
 * 
 *******************************************************************/


// // lib/features/dashboard/presentation/providers/dashboard_notifier.dart
// // Upgraded: Real DB + UserModel + role-based stats
// // Supports employee (check-in/out) + manager (team present count)
// // AsyncValue for loading/error + refresh method
// // Current date: December 29, 2025

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DashboardState {
//   final bool isLoading;
//   final String? message;
//   final DateTime? checkInTime;
//   final DateTime? checkOutTime;
//   final int teamSize;
//   final int presentToday;
//   final String? error;

//   DashboardState({
//     this.isLoading = false,
//     this.message,
//     this.checkInTime,
//     this.checkOutTime,
//     this.teamSize = 0,
//     this.presentToday = 0,
//     this.error,
//   });

//   DashboardState copyWith({
//     bool? isLoading,
//     String? message,
//     DateTime? checkInTime,
//     DateTime? checkOutTime,
//     int? teamSize,
//     int? presentToday,
//     String? error,
//   }) {
//     return DashboardState(
//       isLoading: isLoading ?? this.isLoading,
//       message: message ?? this.message,
//       checkInTime: checkInTime ?? this.checkInTime,
//       checkOutTime: checkOutTime ?? this.checkOutTime,
//       teamSize: teamSize ?? this.teamSize,
//       presentToday: presentToday ?? this.presentToday,
//       error: error ?? this.error,
//     );
//   }
// }

// final dashboardProvider =
//     StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>(
//       (ref) => DashboardNotifier(ref),
//     );

// class DashboardNotifier extends StateNotifier<AsyncValue<DashboardState>> {
//   final Ref ref;

//   DashboardNotifier(this.ref) : super(const AsyncLoading()) {
//     loadDashboard();
//   }

//   Future<void> loadDashboard() async {
//     state = const AsyncLoading();

//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError("Not logged in", StackTrace.current);
//         return;
//       }

//       final db = await DBHelper.instance.database;
//       final today = DateTime.now().toIso8601String().split('T')[0];

//       // Today's check-in/out
//       DateTime? checkInTime;
//       DateTime? checkOutTime;

//       final attendanceRows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND DATE(att_timestamp) = ?',
//         whereArgs: [user.empId, today],
//         orderBy: 'att_timestamp ASC',
//       );

//       if (attendanceRows.isNotEmpty) {
//         for (var row in attendanceRows) {
//           final timestamp = DateTime.parse(row['att_timestamp'] as String);
//           final status = row['att_status'] as String;

//           if (status == 'checkIn') checkInTime = timestamp;
//           if (status == 'checkOut') checkOutTime = timestamp;
//         }
//       }

//       // Team stats (only for managers)
//       int teamSize = 0;
//       int presentToday = 0;

//       if (user.isManagerial) {
//         // Get team members
//         final teamMembers = await db.query(
//           'employee_master',
//           where: 'reportingManagerId = ?',
//           whereArgs: [user.empId],
//         );
//         teamSize = teamMembers.length;

//         if (teamSize > 0) {
//           final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();
//           final presentQuery = await db.rawQuery(
//             '''
//             SELECT COUNT(DISTINCT emp_id) as count
//             FROM employee_attendance
//             WHERE DATE(att_timestamp) = ?
//             AND att_status = 'checkIn'
//             AND emp_id IN (${List.filled(teamSize, '?').join(',')})
//             ''',
//             [today, ...empIds],
//           );
//           presentToday = presentQuery.first['count'] as int? ?? 0;
//         }
//       }

//       state = AsyncData(
//         DashboardState(
//           message: user.isManagerial
//               ? "Welcome, ${user.shortName} (Manager)"
//               : "Welcome back, ${user.shortName}",
//           checkInTime: checkInTime,
//           checkOutTime: checkOutTime,
//           teamSize: teamSize,
//           presentToday: presentToday,
//         ),
//       );
//     } catch (e, stack) {
//       state = AsyncError("Failed to load dashboard: $e", stack);
//     }
//   }

//   // Pull-to-refresh support
//   Future<void> refresh() async {
//     await loadDashboard();
//   }
// }

//HOW TO USE NOTIFIER......

// In DashboardScreen build method
// final dashboardState = ref.watch(dashboardProvider);

// dashboardState.when(
//   data: (state) => Column(
//     children: [
//       Text(state.message ?? "Welcome!"),
//       if (state.checkInTime != null) Text("Check-in: ${state.checkInTime!.formattedTime}"),
//       if (state.checkOutTime != null) Text("Check-out: ${state.checkOutTime!.formattedTime}"),
//       if (state.teamSize > 0)
//         Text("Team Size: ${state.teamSize} | Present Today: ${state.presentToday}"),
//     ],
//   ),
//   loading: () => const Center(child: CircularProgressIndicator()),
//   error: (err, stack) => Center(child: Text("Error: $err")),
// );

// // RefreshIndicator for pull-to-refresh
// RefreshIndicator(
//   onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
//   child: // Your scrollable content
// );

// // lib/features/dashboard/presentation/providers/dashboard_notifier.dart
// import 'package:appattendance/core/providers/role_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DashboardState {
//   final bool isLoading;
//   final String message;
//   final DateTime? checkInTime;
//   final DateTime? checkOutTime;
//   final int teamSize;
//   final int presentToday;

//   DashboardState({
//     this.isLoading = false,
//     this.message = "Welcome back!",
//     this.checkInTime,
//     this.checkOutTime,
//     this.teamSize = 0,
//     this.presentToday = 0,
//   });

//   DashboardState copyWith({
//     bool? isLoading,
//     String? message,
//     DateTime? checkInTime,
//     DateTime? checkOutTime,
//     int? teamSize,
//     int? presentToday,
//   }) {
//     return DashboardState(
//       isLoading: isLoading ?? this.isLoading,
//       message: message ?? this.message,
//       checkInTime: checkInTime ?? this.checkInTime,
//       checkOutTime: checkOutTime ?? this.checkOutTime,
//       teamSize: teamSize ?? this.teamSize,
//       presentToday: presentToday ?? this.presentToday,
//     );
//   }
// }

// class DashboardNotifier extends StateNotifier<AsyncValue<DashboardState>> {
//   DashboardNotifier(this.ref) : super(const AsyncLoading()) {
//     loadDashboard();
//   }

//   final Ref ref;

//   Future<void> loadDashboard() async {
//     state = const AsyncLoading();
//     await Future.delayed(const Duration(seconds: 1));

//     final user = ref.read(roleProvider);
//     if (user == null) {
//       state = AsyncError("Not logged in", StackTrace.current);
//       return;
//     }

//     if (user.isManager) {
//       state = AsyncData(
//         DashboardState(
//           message: "Welcome, ${user.name} (Manager)",
//           teamSize: 12,
//           presentToday: 10,
//         ),
//       );
//     } else {
//       state = AsyncData(
//         DashboardState(
//           message: "Welcome back, ${user.name}",
//           checkInTime: DateTime.now().subtract(const Duration(hours: 8)),
//         ),
//       );
//     }
//   }
// }

// final dashboardProvider =
//     StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>((ref) {
//       return DashboardNotifier(ref);
//     });
