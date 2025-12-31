// lib/features/dashboard/data/dashboard_repository.dart
import 'package:flutter/cupertino.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/services/sync_service.dart';
import 'package:sqflite/sqflite.dart';

class DashboardRepository {
  final _syncService = SyncService();
  final _db = DBHelper.instance;

  /// 🔥 Fetch Weekly/Monthly/Quarterly Analytics Summary
  Future<Map<String, dynamic>> fetchAnalyticsSummary({
    required String empId,
    required String type, // 'weekly', 'monthly', 'quarterly'
  }) async {
    try {
      final res = await ApiClient.get(
        ApiEndpoints.attendanceAnalyticsSummary,
        params: {
          "emp_id": empId,
          "type": type,
        },
      );

      debugPrint("✅ Analytics summary fetched: ${res['data']}");
      return res['data'] ?? {};
    } catch (e) {
      debugPrint("❌ Failed to fetch analytics summary: $e");

      // Return default values on error
      return {
        'present': 0,
        'leave': 0,
        'absent': 0,
        'on_time': 0,
        'late': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeeProjects(String empId) async {
    final db = await DBHelper.instance.database;

    return await db.rawQuery('''
    SELECT pm.*
    FROM project_master pm
    JOIN employee_mapped_projects emp
      ON pm.project_id = emp.project_id
    WHERE emp.emp_id = ?
  ''', [empId]);
  }


  /// 🔥 Fetch Daily Analytics
  Future<Map<String, dynamic>> fetchDailyAnalytics({
    required String empId,
    required String date,
  }) async {
    try {
      final res = await ApiClient.get(
        ApiEndpoints.attendanceAnalyticsDaily,
        params: {
          "emp_id": empId,
          "date": date,
        },
      );

      debugPrint("✅ Daily analytics fetched: ${res['data']}");
      return res['data'] ?? {};
    } catch (e) {
      debugPrint("❌ Failed to fetch daily analytics: $e");

      // Return default values on error
      return {
        'worked_hrs': 0.0,
        'shortfall_hrs': 0.0,
        'first_checkin': null,
        'last_checkout': null,
      };
    }
  }

  /// 🔥 Calculate Working Hours Averages
  Future<Map<String, double>> calculateWorkingHours({
    required String empId,
  }) async {
    try {
      // Fetch weekly analytics for recent working hours
      final weeklyData = await fetchAnalyticsSummary(
        empId: empId,
        type: 'weekly',
      );

      // Fetch monthly analytics
      final monthlyData = await fetchAnalyticsSummary(
        empId: empId,
        type: 'monthly',
      );

      // Calculate daily average from weekly data
      final totalWorkedHrs = weeklyData['total_worked_hrs'] ?? 0.0;
      final workingDays = weeklyData['present'] ?? 1;
      final dailyAvg = workingDays > 0 ? totalWorkedHrs / workingDays : 0.0;

      // Calculate monthly average
      final monthlyTotalHrs = monthlyData['total_worked_hrs'] ?? 0.0;
      final monthlyWorkingDays = monthlyData['present'] ?? 1;
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

  /// 🔥 Manual Sync - Call this from refresh button
  /// 🔥 Manual Sync - SAFE (DO NOT THROW)
  Future<void> manualSync(String empId) async {
    final result = await _syncService.manualSync(empId);

    if (!result.success) {
      debugPrint("⚠️ Sync failed but keeping offline data: ${result.message}");
      // DO NOT throw
    }
  }


  /// Fetch Attendance Summary (with offline fallback)
  Future<Map<String, dynamic>> fetchSummary({
    required String empId,
    required String type,
    required String date,
  }) async {
    // Try offline first
    final offline = await _db.getAttendanceSummaryOffline(
      empId,
      type,
      date,
      date,
    );

    if (offline != null) {
      debugPrint("✅ Using cached summary");
      return offline;
    }

    // Fetch from API if not cached
    try {
      final res = await ApiClient.get(
        ApiEndpoints.attendanceSummary,
        params: {
          "emp_id": empId,
          "type": type,
          "date": date,
        },
      );

      final summary = res['data'];

      // Cache it
      await _db.saveAttendanceSummary({
        'emp_id': empId,
        'type': type,
        'start_date': date,
        'end_date': date,
        ...summary,
      });

      return summary;
    } catch (e) {
      debugPrint("❌ Failed to fetch summary: $e");
      rethrow;
    }
  }

  /// Get dashboard data from local DB (after sync)
  Future<Map<String, dynamic>> getLocalDashboardData(String empId) async {
    final db = await _db.database;

    final employee = await db.query(
      'employee_master',
      where: 'emp_id = ?',
      whereArgs: [empId],
    );

    final attendance = await db.query(
      'employee_attendance',
      where: 'emp_id = ?',
      whereArgs: [empId],
      orderBy: 'att_date DESC',
    );

    final mappedProjects = await db.query(
      'employee_mapped_projects',
      where: 'emp_id = ? AND mapping_status = ?',
      whereArgs: [empId, 'active'],
    );

    // Get project details
    final projectIds = mappedProjects
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

    final regularization = await db.query(
      'employee_regularization',
      where: 'emp_id = ?',
      whereArgs: [empId],
      orderBy: 'reg_date_applied DESC',
    );

    return {
      'employee': employee.isNotEmpty ? employee.first : null,
      'attendance': attendance,
      'projects': projects,
      'regularization': regularization,
    };
  }

  /// Check-in API call
  Future<void> checkIn({
    required String empId,
    required double latitude,
    required double longitude,
    String? projectId,
    String? notes,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        {
          "emp_id": empId,
          "att_status": "checkin",
          "att_latitude": latitude,
          "att_longitude": longitude,
          "att_project_id": projectId,
          "att_notes": notes,
          "att_timestamp": DateTime.now().toIso8601String(),
        },
      );

      debugPrint("✅ Check-in successful: $response");

      // Save to local DB
      final db = await _db.database;
      await db.insert(
        'employee_attendance',
        response['data'],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("❌ Check-in failed: $e");
      rethrow;
    }
  }

  /// Check-out API call
  Future<void> checkOut({
    required String empId,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        {
          "emp_id": empId,
          "att_status": "checkout",
          "att_latitude": latitude,
          "att_longitude": longitude,
          "att_notes": notes,
          "att_timestamp": DateTime.now().toIso8601String(),
        },
      );

      debugPrint("✅ Check-out successful: $response");

      // Save to local DB
      final db = await _db.database;
      await db.insert(
        'employee_attendance',
        response['data'],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("❌ Check-out failed: $e");
      rethrow;
    }
  }

  /// Submit regularization request
  Future<void> submitRegularization(Map<String, dynamic> regData) async {
    try {
      final response = await ApiClient.post(
        "http://192.168.0.112:3000/api/v1/regularization",
        regData,
      );

      debugPrint("✅ Regularization submitted: $response");

      // Save to local DB
      final db = await _db.database;
      await db.insert(
        'employee_regularization',
        response['data'],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("❌ Regularization failed: $e");
      rethrow;
    }
  }
}