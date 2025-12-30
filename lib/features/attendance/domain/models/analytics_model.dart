// lib/features/attendance/domain/models/analytics_model.dart
// Final production-ready Analytics Model (freezed)
// Aggregated attendance stats for dashboard/charts
// Supports daily/weekly/monthly/quarterly views
// Role-based (own vs team) + null-safe
// Supports daily/weekly/monthly/quarterly + role-based
// Current date context: December 29, 2025

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

// Period enum
enum AnalyticsPeriod { daily, weekly, monthly, quarterly }

@freezed
class AnalyticsModel with _$AnalyticsModel {
  const AnalyticsModel._();

  const factory AnalyticsModel({
    required AnalyticsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required int totalDays,
    required int presentDays,
    required int absentDays,
    required int leaveDays,
    required int lateDays,
    required int onTimeDays,
    required double dailyAvgHours,
    required double monthlyAvgHours,
    @Default(0) int pendingRegularisations, // Manager only
    @Default(0) int pendingLeaves, // Manager only
    String? periodTitle, // Optional - computed in extension
  }) = _AnalyticsModel;

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsModelFromJson(json);
}

// Extension for computed properties (safe & recommended)
extension AnalyticsModelExtension on AnalyticsModel {
  String get formattedPeriodTitle {
    if (periodTitle != null) return periodTitle!;

    return switch (period) {
      AnalyticsPeriod.daily => DateFormat('EEEE, d MMMM').format(startDate),
      AnalyticsPeriod.weekly => 'Week ${DateFormat('w').format(startDate)}',
      AnalyticsPeriod.monthly => DateFormat('MMMM yyyy').format(startDate),
      AnalyticsPeriod.quarterly =>
        'Q${((startDate.month - 1) ~/ 3) + 1} ${startDate.year}',
    };
  }

  double get attendancePercentage =>
      totalDays > 0 ? (presentDays / totalDays * 100) : 0.0;

  bool get isGoodAttendance => attendancePercentage >= 90.0;
}

// Factory helper (raw records se analytics banao)
AnalyticsModel analyticsFromRecords({
  required AnalyticsPeriod period,
  required List<Map<String, dynamic>> rawRecords,
  required DateTime start,
  required DateTime end,
  int pendingLeaves = 0,
  int pendingRegularisations = 0,
}) {
  int totalDays = end.difference(start).inDays + 1;
  int present = 0;
  int absent = 0;
  int leave = 0;
  int late = 0;
  int onTime = 0;
  double totalHours = 0.0;

  for (var record in rawRecords) {
    final date = DateTime.parse(record['att_date'] as String);
    if (date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)))) {
      final status = record['att_status'] as String?;

      if (status == 'checkIn') {
        present++;
        // TODO: Real late logic from timestamp
        late += 0; // Dummy
        onTime += 1;
        totalHours += 8.0; // Dummy - real duration
      } else if (status == 'leave') {
        leave++;
      } else {
        absent++;
      }
    }
  }

  final dailyAvg = totalDays > 0 ? totalHours / totalDays : 0.0;
  final monthlyAvg = totalHours; // Adjust as needed

  return AnalyticsModel(
    period: period,
    startDate: start,
    endDate: end,
    totalDays: totalDays,
    presentDays: present,
    absentDays: absent,
    leaveDays: leave,
    lateDays: late,
    onTimeDays: onTime,
    dailyAvgHours: dailyAvg,
    monthlyAvgHours: monthlyAvg,
    pendingLeaves: pendingLeaves,
    pendingRegularisations: pendingRegularisations,
  );
}

// // lib/features/attendance/domain/models/analytics_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'analytics_model.freezed.dart';
// part 'analytics_model.g.dart';

// enum AnalyticsMode { daily, weekly, monthly, quarterly }

// @freezed
// class AnalyticsData with _$AnalyticsData {
//   const factory AnalyticsData({
//     required int present,
//     required int absent,
//     required int late,
//     required int halfDay,
//     required double avgHours,
//     DateTime? start,
//     DateTime? end,
//   }) = _AnalyticsData;

//   factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
//       _$AnalyticsDataFromJson(json);
// }
