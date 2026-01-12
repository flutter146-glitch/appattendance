// lib/features/attendance/data/repositories/attendance_analytics_repository.dart
// UPGRADED & FUTURE-PROOF VERSION - January 09, 2026
// Improvements:
// - Full DartDoc documentation
// - Optional parameters for flexibility (filtering, pagination)
// - Role-based comments & error contract
// - Stream support placeholder (for real-time analytics)
// - Clear separation for employee vs manager analytics
// - Easy to switch to API implementation

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';

/// Repository contract for fetching attendance analytics data.
/// Supports both employee personal stats and manager team aggregate stats.
///
/// All methods return [Future] and throw exceptions on failure.
/// Implementations must handle caching, offline, and API/DB switching.
abstract class AttendanceAnalyticsRepository {
  /// Fetches analytics data for the given period and user.
  ///
  /// - [empId]: Employee ID (personal analytics) or Manager ID (team analytics)
  /// - [period]: Time range for aggregation (daily/weekly/monthly/quarterly)
  /// - [includeTeamBreakdown]: If true, includes per-employee stats (manager only)
  /// - [limit]: Optional limit for breakdown records (performance)
  ///
  /// Returns [AnalyticsModel] with aggregated stats, percentages, graph data,
  /// and insights. Throws exception on failure.
  Future<AnalyticsModel> getAnalytics({
    required AnalyticsPeriod period,
    required String empId,
    bool includeTeamBreakdown = false, // Set true for manager team view
    int? limit, // Optional: limit breakdown records
  });

  /// Optional: Stream version for real-time updates (e.g., live dashboard)
  ///
  /// Listen to this for live changes in attendance stats.
  /// Useful for manager dashboard with auto-refresh.
  ///
  /// Not required for basic implementation - uncomment when needed.
  /*
  Stream<AnalyticsModel> watchAnalytics({
    required AnalyticsPeriod period,
    required String empId,
  });
  */

  /// Optional: Clear any cached analytics data
  /// Call this on logout or data refresh
  Future<void> clearCache();
}

// lib/features/attendance/data/repositories/attendance_analytics_repository.dart
// Abstract Repository - Defines contract for analytics data fetching
// // Future-proof for API switch (just change impl)

// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';

// abstract class AttendanceAnalyticsRepository {
//   Future<AnalyticsModel> getAnalytics({
//     required AnalyticsPeriod period,
//     required String empId, // Employee or Manager ID
//   });
// }

// // lib/features/analytics/domain/repositories/analytics_repository.dart
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';

// abstract class AnalyticsRepository {
//   /// Period ke hisaab se aggregated analytics fetch karta hai
//   Future<AnalyticsModel> getAnalytics({
//     required String empId,
//     required AnalyticsPeriod period,
//     required DateTime startDate,
//     required DateTime endDate,
//   });

//   /// Manager ke liye team analytics (team members ke saare stats)
//   Future<AnalyticsModel> getTeamAnalytics({
//     required String mgrEmpId,
//     required AnalyticsPeriod period,
//     required DateTime startDate,
//     required DateTime endDate,
//   });
// }
