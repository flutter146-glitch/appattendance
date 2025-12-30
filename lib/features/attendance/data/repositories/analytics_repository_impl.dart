// lib/features/analytics/domain/repositories/analytics_repository_impl.dart
import 'package:appattendance/core/database/db_helper.dart';

import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  @override
  Future<AnalyticsModel> getAnalytics({
    required String empId,
    required AnalyticsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await DBHelper.instance.database;

    // Raw attendance records for period
    final records = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND att_timestamp BETWEEN ? AND ?',
      whereArgs: [
        empId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    // TODO: Real pending leaves/regularisations query
    final pendingLeaves = 0;
    final pendingRegularisations = 0;

    return analyticsFromRecords(
      period: period,
      rawRecords: records,
      start: startDate,
      end: endDate,
      pendingLeaves: pendingLeaves,
      pendingRegularisations: pendingRegularisations,
    );
  }

  @override
  Future<AnalyticsModel> getTeamAnalytics({
    required String mgrEmpId,
    required AnalyticsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await DBHelper.instance.database;

    // Get team members
    final teamMembers = await db.query(
      'employee_master',
      where: 'reportingManagerId = ?',
      whereArgs: [mgrEmpId],
    );

    if (teamMembers.isEmpty) {
      return AnalyticsModel(
        period: period,
        startDate: startDate,
        endDate: endDate,
        totalDays: 0,
        presentDays: 0,
        absentDays: 0,
        leaveDays: 0,
        lateDays: 0,
        onTimeDays: 0,
        dailyAvgHours: 0.0,
        monthlyAvgHours: 0.0,
      );
    }

    final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

    // Aggregate team attendance
    final records = await db.query(
      'employee_attendance',
      where:
          'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND att_timestamp BETWEEN ? AND ?',
      whereArgs: [
        ...empIds,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    // TODO: Pending leaves/regularisations for team
    final pendingLeaves = 0;
    final pendingRegularisations = 0;

    return analyticsFromRecords(
      period: period,
      rawRecords: records,
      start: startDate,
      end: endDate,
      pendingLeaves: pendingLeaves,
      pendingRegularisations: pendingRegularisations,
    );
  }
}
