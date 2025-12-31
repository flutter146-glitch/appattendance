// lib/features/dashboard/presentation/providers/dashboard_notifier.dart
// Dashboard State Notifier
// Loads user info, today's attendance, team stats (for manager)
// Uses real DB queries + UserModel + AttendanceModel
// Supports refresh/pull-to-refresh
// Error/loading handled with AsyncValue

// lib/features/dashboard/presentation/providers/dashboard_notifier.dart

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
  final List<Map<String, dynamic>> allAttendance;
  final List<Map<String, dynamic>> allProjects;
  final List<Map<String, dynamic>> allRegularization;

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
    this.allAttendance = const [],
    this.allProjects = const [],
    this.allRegularization = const [],
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
    List<Map<String, dynamic>>? allAttendance,
    List<Map<String, dynamic>>? allProjects,
    List<Map<String, dynamic>>? allRegularization,
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
      allAttendance: allAttendance ?? this.allAttendance,
      allProjects: allProjects ?? this.allProjects,
      allRegularization: allRegularization ?? this.allRegularization,
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
  List<Map<String, dynamic>> projects = [];
  bool isLoadingProjects = false;

  DashboardNotifier(this.ref) : super(const AsyncLoading()) {
    loadDashboard();
  }


  Future<void> loadDashboard() async {
    try {
      state = const AsyncLoading();

      // ✅ Wait for auth to be ready
      final authState = ref.read(authProvider);

      // If authProvider is still loading, wait for it
      if (authState.isLoading) {
        debugPrint("⏳ Waiting for auth to load...");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final user = ref.read(authProvider).value;

      if (user == null) {
        debugPrint("❌ User is null - checking DB for current user");

        // ✅ Try to get user from DB
        final currentUser = await DBHelper.instance.getCurrentUser();

        if (currentUser == null) {
          state = AsyncError("Unable to refresh data", StackTrace.current);
          return;
        }

        debugPrint("✅ Found user in DB: ${currentUser['emp_id']}");

        // Create UserModel from DB data
        final userModel = UserModel(
          empId: currentUser['emp_id'],
          name: currentUser['emp_name'],
          email: currentUser['emp_email'],
          role: currentUser['emp_role'],
          department: currentUser['emp_department'],
          orgShortName: currentUser['org_short_name'],
          status: currentUser['emp_status'],
        );

        // Load dashboard with DB user
        await _loadDashboardData(userModel);
        return;
      }

      debugPrint("🔄 Loading dashboard for ${user.empId}");

      await _loadDashboardData(user);

    } catch (e, stack) {
      debugPrint("❌ Dashboard load error: $e");
      state = AsyncError(e, stack);
    }
  }

  Future<void> _loadDashboardData(UserModel user) async {
    // Check if initial sync is needed
    final isInitialSyncDone = await DBHelper.instance.isInitialSyncDone();

    if (!isInitialSyncDone) {
      debugPrint("🔄 Performing initial sync...");

      try {
        await _syncService.initialSync(user.empId);
        await DBHelper.instance.markInitialSyncDone();
        debugPrint("✅ Initial sync completed");
      } catch (e) {
        debugPrint("⚠️ Initial sync failed, will use cached data: $e");
        // Continue with cached data even if sync fails
      }
    }

    // Fetch data from local DB
    final dashboardData = await _loadLocalData(user);

    // Fetch analytics from API (async - won't block UI)
    _fetchAnalyticsData(user.empId);

    state = AsyncData(dashboardData);
  }

  /// Load data from local SQLite DB
  Future<DashboardState> _loadLocalData(UserModel user) async {
    try {
      final db = await DBHelper.instance.database;
      final today = DateTime.now().toIso8601String().split('T')[0];

      debugPrint("📊 Loading local data for $today");

      // Today's attendance - use LIKE on att_timestamp
      final attendanceRows = await db.query(
        'employee_attendance',
        where: 'emp_id = ? AND att_timestamp LIKE ?',
        whereArgs: [user.empId, '$today%'],
        orderBy: 'att_timestamp ASC',
      );

      final todayAttendance = attendanceRows.map(attendanceFromDB).toList();
      debugPrint("📊 Found ${todayAttendance.length} attendance records for today");

      // Get ALL attendance records for the current month
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final monthStart = '${firstDayOfMonth.toString().substring(0, 10)} 00:00:00';

      final allMonthAttendance = await db.query(
        'employee_attendance',
        where: 'emp_id = ? AND att_timestamp >= ?',
        whereArgs: [user.empId, monthStart],
        orderBy: 'att_timestamp DESC',
        limit: 50, // Limit to last 50 records
      );

      debugPrint("📊 Found ${allMonthAttendance.length} attendance records this month");

      // Get ALL mapped projects
      // Get ALL mapped projects
      final mappedProjectsRows = await db.query(
        'employee_mapped_projects',
        where: 'emp_id = ? AND mapping_status = ?',
        whereArgs: [user.empId, 'active'],
      );

      final projectIds = mappedProjectsRows
          .map((m) => m['project_id'] as String)
          .toList();

      List<Map<String, dynamic>> projects = [];
      if (projectIds.isNotEmpty) {
        projects = await db.query(
          'project_master',
          where: 'project_id IN (${List.filled(projectIds.length, '?').join(',')})',
          whereArgs: projectIds,
        );
      }


      debugPrint("📊 Found ${projects.length} mapped projects");

      // Get ALL regularization requests
      final regularizationRows = await db.query(
        'employee_regularization',
        where: 'emp_id = ?',
        whereArgs: [user.empId],
        orderBy: 'reg_date_applied DESC',
        limit: 20, // Limit to last 20 records
      );

      debugPrint("📊 Found ${regularizationRows.length} regularization requests");

      // Pending sync count
      final pendingSyncCount = await DBHelper.instance.getPendingTransactionsCount(user.empId);
      debugPrint("📊 Pending sync count: $pendingSyncCount");

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
        analyticsData: {},
        workingHoursData: {},
        allAttendance: allMonthAttendance,
        allProjects: projects,
        allRegularization: regularizationRows,
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
        analyticsData = {
          'present': 0,
          'leave': 0,
          'absent': 0,
          'on_time': 0,
          'late': 0,
          'total_worked_hrs': 0.0,
        };
      }

      final workingHoursData = await _calculateWorkingHours(empId, analyticsData);

      state.whenData((currentState) {
        state = AsyncData(currentState.copyWith(
          analyticsData: analyticsData,
          workingHoursData: workingHoursData,
        ));
      });

      debugPrint("✅ Analytics data updated");
    } catch (e) {
      debugPrint("❌ Failed to fetch analytics: $e");

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

  Future<Map<String, double>> _calculateWorkingHours(
      String empId,
      Map<String, dynamic> monthlyData,
      ) async {
    try {
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

      final totalWorkedHrs = double.tryParse(
          weeklyData['total_worked_hrs']?.toString() ?? '0'
      ) ?? 0.0;

      final workingDays = int.tryParse(
          weeklyData['present']?.toString() ?? '0'
      ) ?? 0;

      final dailyAvg = workingDays > 0 ? totalWorkedHrs / workingDays : 0.0;

      final monthlyTotalHrs =
          double.tryParse(monthlyData['total_worked_hrs']?.toString() ?? '0') ?? 0.0;

      final monthlyWorkingDays =
          int.tryParse(monthlyData['present']?.toString() ?? '0') ?? 0;

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

  Future<void> refresh() async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        // Try DB fallback
        final currentUser = await DBHelper.instance.getCurrentUser();
        if (currentUser == null) return;

        final userModel = UserModel(
          empId: currentUser['emp_id'],
          name: currentUser['emp_name'],
          email: currentUser['emp_email'],
          role: currentUser['emp_role'],
          department: currentUser['emp_department'],
          orgShortName: currentUser['org_short_name'],
          status: currentUser['emp_status'],
        );

        await _performRefresh(userModel);
        return;
      }

      await _performRefresh(user);

    } catch (e) {
      debugPrint("❌ Refresh failed: $e");
      rethrow;
    }
  }

  Future<void> _performRefresh(UserModel user) async {
    state.whenData((currentState) {
      state = AsyncData(currentState.copyWith(isSyncing: true));
    });

    debugPrint("🔄 Manual sync triggered");

    final syncResult = await _syncService.manualSync(user.empId);

    if (syncResult.success) {
      debugPrint("✅ Manual sync completed");
      await loadDashboard();
    } else {
      debugPrint("⚠️ Sync failed: ${syncResult.message}");
      // ❗ DO NOT THROW
    }

    state.whenData((currentState) {
      state = AsyncData(currentState.copyWith(isSyncing: false));
    });
  }


  Future<void> checkIn({
    required double latitude,
    required double longitude,
    String? projectId,
    String? geofenceName,
    String? notes,
  }) async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception("Unable to refresh data");

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

        final db = await DBHelper.instance.database;
        await db.insert(
          'employee_attendance',
          {
            ...response['data'],
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await loadDashboard();
      } else {
        throw Exception(response['message'] ?? 'Check-in failed');
      }
    } catch (e) {
      debugPrint("❌ Check-in failed: $e");
      rethrow;
    }
  }

  Future<void> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception("Unable to refresh data");

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

        final db = await DBHelper.instance.database;
        await db.insert(
          'employee_attendance',
          {
            ...response['data'],
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

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
