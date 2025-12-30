// lib/features/dashboard/presentation/providers/dashboard_notifier.dart
// Dashboard State Notifier
// Loads user info, today's attendance, team stats (for manager)
// Uses real DB queries + UserModel + AttendanceModel
// Supports refresh/pull-to-refresh
// Error/loading handled with AsyncValue

import 'package:appattendance/core/api/api_client.dart';
import 'package:appattendance/core/api/api_endpoints.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/services/sync_service.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class DashboardState {
  final UserModel? user;
  final List<AttendanceModel> todayAttendance;
  final Map<String, dynamic> analyticsData;
  final Map<String, double> workingHoursData;
  final int teamSize;
  final int presentToday;
  final int pendingSyncCount;
  final String? welcomeMessage;
  final bool isSyncing;

  DashboardState({
    this.user,
    this.todayAttendance = const [],
    this.analyticsData = const {},
    this.workingHoursData = const {},
    this.teamSize = 0,
    this.presentToday = 0,
    this.pendingSyncCount = 0,
    this.welcomeMessage,
    this.isSyncing = false,
  });

  bool get hasCheckedInToday => todayAttendance.any((a) => a.isCheckIn);
  bool get hasCheckedOutToday => todayAttendance.any((a) => a.isCheckOut);

  DateTime? get checkInTime => todayAttendance
      .where((a) => a.isCheckIn)
      .map((a) => a.timestamp)
      .firstOrNull;

  DateTime? get checkOutTime => todayAttendance
      .where((a) => a.isCheckOut)
      .map((a) => a.timestamp)
      .firstOrNull;

  DashboardState copyWith({
    UserModel? user,
    List<AttendanceModel>? todayAttendance,
    Map<String, dynamic>? analyticsData,
    Map<String, double>? workingHoursData,
    int? teamSize,
    int? presentToday,
    int? pendingSyncCount,
    String? welcomeMessage,
    bool? isSyncing,
  }) {
    return DashboardState(
      user: user ?? this.user,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      analyticsData: analyticsData ?? this.analyticsData,
      workingHoursData: workingHoursData ?? this.workingHoursData,
      teamSize: teamSize ?? this.teamSize,
      presentToday: presentToday ?? this.presentToday,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>(
      (ref) => DashboardNotifier(ref),
);

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardState>> {
  final Ref ref;
  final SyncService _syncService = SyncService();

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

      debugPrint("🔄 Loading dashboard for ${user.empId}");

      // Check if initial sync is needed
      final isInitialSyncDone = await DBHelper.instance.isInitialSyncDone();

      if (!isInitialSyncDone) {
        debugPrint("🔄 Performing initial sync...");
        await _syncService.initialSync(user.empId);
        await DBHelper.instance.markInitialSyncDone();
      }

      // Fetch data from local DB
      final dashboardData = await _loadLocalData(user);

      // Fetch analytics from API (async - won't block UI)
      _fetchAnalyticsData(user.empId);

      state = AsyncData(dashboardData);
    } catch (e, stack) {
      debugPrint("❌ Dashboard load error: $e");
      state = AsyncError(e, stack);
    }
  }

  /// Load data from local SQLite DB
  Future<DashboardState> _loadLocalData(UserModel user) async {
    try {
      final db = await DBHelper.instance.database;
      final today = DateTime.now().toIso8601String().split('T')[0];

      debugPrint("📊 Loading local data for $today");

      // Today's attendance
      final attendanceRows = await db.query(
        'employee_attendance',
        where: 'emp_id = ? AND att_timestamp LIKE ?',
        whereArgs: [user.empId, '$today%'],
        orderBy: 'att_timestamp ASC',
      );

      final todayAttendance = attendanceRows.map(attendanceFromDB).toList();
      debugPrint("📊 Found ${todayAttendance.length} attendance records for today");

      // Pending sync count
      final pendingSyncCount = await DBHelper.instance.getPendingTransactionsCount(user.empId);

      // Team stats (only if managerial)
      int teamSize = 0;
      int presentToday = 0;

      if (user.isManagerial) {
        final teamMembers = await db.query(
          'employee_master',
          where: 'org_short_name = ?',
          whereArgs: [user.orgShortName],
        );

        teamSize = teamMembers.length;
        debugPrint("📊 Team size: $teamSize");

        if (teamSize > 0) {
          final presentQuery = await db.rawQuery(
            '''
            SELECT COUNT(DISTINCT emp_id) as count
            FROM employee_attendance
            WHERE att_timestamp LIKE ?
            AND att_status = 'checkin'
            ''',
            ['$today%'],
          );
          presentToday = presentQuery.first['count'] as int? ?? 0;
          debugPrint("📊 Present today: $presentToday");
        }
      }

      final welcome = user.isManagerial
          ? "Welcome, ${user.shortName}"
          : "Welcome back, ${user.shortName}";

      return DashboardState(
        user: user,
        todayAttendance: todayAttendance,
        teamSize: teamSize,
        presentToday: presentToday,
        pendingSyncCount: pendingSyncCount,
        welcomeMessage: welcome,
        analyticsData: {}, // Will be updated by API call
        workingHoursData: {},
      );
    } catch (e) {
      debugPrint("❌ Error loading local data: $e");
      rethrow;
    }
  }

  /// Fetch analytics data from API (non-blocking)
  Future<void> _fetchAnalyticsData(String empId) async {
    try {
      debugPrint("🔄 Fetching analytics data from API...");

      // Fetch monthly analytics summary
      final analyticsResponse = await ApiClient.get(
        ApiEndpoints.attendanceAnalyticsSummary,
        params: {
          "emp_id": empId,
          "type": "monthly",
        },
      );

      debugPrint("📦 Analytics API response: ${analyticsResponse.toString()}");

      Map<String, dynamic> analyticsData = {};
      if (analyticsResponse['success'] == true && analyticsResponse['data'] != null) {
        analyticsData = analyticsResponse['data'] as Map<String, dynamic>;
      } else {
        // Use defaults if API fails
        analyticsData = {
          'present': 0,
          'leave': 0,
          'absent': 0,
          'on_time': 0,
          'late': 0,
          'total_worked_hrs': 0.0,
        };
      }

      // Calculate working hours
      final workingHoursData = await _calculateWorkingHours(empId, analyticsData);

      // Update state with analytics data
      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(
          analyticsData: analyticsData,
          workingHoursData: workingHoursData,
        ));
      });

      debugPrint("✅ Analytics data updated");
    } catch (e) {
      debugPrint("❌ Failed to fetch analytics: $e");
      // Don't throw - just use default values
      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(
          analyticsData: {
            'present': 0,
            'leave': 0,
            'absent': 0,
            'on_time': 0,
            'late': 0,
            'total_worked_hrs': 0.0,
          },
          workingHoursData: {
            'dailyAvg': 0.0,
            'monthlyAvg': 0.0,
          },
        ));
      });
    }
  }

  /// Calculate working hours averages
  Future<Map<String, double>> _calculateWorkingHours(
      String empId,
      Map<String, dynamic> monthlyData,
      ) async {
    try {
      // Fetch weekly analytics for recent working hours
      final weeklyResponse = await ApiClient.get(
        ApiEndpoints.attendanceAnalyticsSummary,
        params: {
          "emp_id": empId,
          "type": "weekly",
        },
      );

      Map<String, dynamic> weeklyData = {};
      if (weeklyResponse['success'] == true && weeklyResponse['data'] != null) {
        weeklyData = weeklyResponse['data'] as Map<String, dynamic>;
      }

      // Calculate daily average from weekly data
      final totalWorkedHrs = double.tryParse(
          weeklyData['total_worked_hrs']?.toString() ?? '0'
      ) ?? 0.0;

      final workingDays = int.tryParse(
          weeklyData['present']?.toString() ?? '0'
      ) ?? 0;

      final dailyAvg = workingDays > 0 ? totalWorkedHrs / workingDays : 0.0;

      // Calculate monthly average
      final monthlyTotalHrs = (monthlyData['total_worked_hrs'] ?? 0).toDouble();
      final monthlyWorkingDays = (monthlyData['present'] ?? 1).toInt();
      final monthlyAvg = monthlyWorkingDays > 0
          ? monthlyTotalHrs / monthlyWorkingDays
          : 0.0;

      return {
        'dailyAvg': dailyAvg,
        'monthlyAvg': monthlyAvg,
      };
    } catch (e) {
      debugPrint("❌ Failed to calculate working hours: $e");
      return {
        'dailyAvg': 0.0,
        'monthlyAvg': 0.0,
      };
    }
  }

  /// Manual sync triggered by user
  Future<void> refresh() async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) return;

      // Update syncing state
      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(isSyncing: true));
      });

      debugPrint("🔄 Manual sync triggered");

      // Perform sync
      final syncResult = await _syncService.manualSync(user.empId);

      if (syncResult.success) {
        debugPrint("✅ Manual sync completed");

        // Reload dashboard after sync
        await loadDashboard();
      } else {
        debugPrint("⚠️ Manual sync failed: ${syncResult.message}");
        throw Exception(syncResult.message);
      }

      // Reset syncing state
      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(isSyncing: false));
      });
    } catch (e) {
      debugPrint("❌ Refresh failed: $e");

      // Reset syncing state on error
      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(isSyncing: false));
      });

      rethrow;
    }
  }

  /// Check-in
  Future<void> checkIn({
    required double latitude,
    required double longitude,
    String? projectId,
    String? geofenceName,
    String? notes,
  }) async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception('Not logged in');

      debugPrint("🔵 Checking in...");

      final requestBody = {
        "emp_id": user.empId,
        "att_status": "checkin",
        "att_latitude": latitude,
        "att_longitude": longitude,
        "att_timestamp": DateTime.now().toIso8601String(),
        "project_id": projectId,
        "att_geofence_name": geofenceName,
        "att_notes": notes,
        "verification_type": "GPS",
      };

      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        requestBody,
      );

      if (response['success'] == true) {
        debugPrint("✅ Check-in successful");

        // Save to local DB
        final db = await DBHelper.instance.database;
        await db.insert(
          'employee_attendance',
          {
            ...response['data'],
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Reload dashboard
        await loadDashboard();
      } else {
        throw Exception(response['message'] ?? 'Check-in failed');
      }
    } catch (e) {
      debugPrint("❌ Check-in failed: $e");
      rethrow;
    }
  }

  /// Check-out
  Future<void> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception('Not logged in');

      debugPrint("🔴 Checking out...");

      final requestBody = {
        "emp_id": user.empId,
        "att_status": "checkout",
        "att_latitude": latitude,
        "att_longitude": longitude,
        "att_timestamp": DateTime.now().toIso8601String(),
        "att_notes": notes,
        "verification_type": "GPS",
      };

      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        requestBody,
      );

      if (response['success'] == true) {
        debugPrint("✅ Check-out successful");

        // Save to local DB
        final db = await DBHelper.instance.database;
        await db.insert(
          'employee_attendance',
          {
            ...response['data'],
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Reload dashboard
        await loadDashboard();
      } else {
        throw Exception(response['message'] ?? 'Check-out failed');
      }
    } catch (e) {
      debugPrint("❌ Check-out failed: $e");
      rethrow;
    }
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
