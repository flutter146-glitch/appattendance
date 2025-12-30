// lib/features/attendance/domain/repositories/attendance_repository.dart
// Interface for Attendance feature - defines contract for data operations
// Supports employee check-in/out + manager team view (privileges R01-R08)

import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';

abstract class AttendanceRepository {
  /// Check-in with location & verification
  Future<void> checkIn({
    required String empId,
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
  });

  /// Check-out
  Future<void> checkOut({
    required String empId,
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
  });

  /// Get today's attendance records for user
  Future<List<AttendanceModel>> getTodayAttendance(String empId);

  /// Get attendance history in date range (for reports)
  Future<List<AttendanceModel>> getHistory(
    String empId,
    DateTime start,
    DateTime end,
  );

  /// Get team attendance on specific date (for manager only)
  Future<List<AttendanceModel>> getTeamAttendance(
    String mgrEmpId,
    DateTime date,
  );
}

// // lib/features/attendance/domain/repositories/attendance_repository.dart

// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
// import 'package:latlong2/latlong.dart';

// abstract class AttendanceRepository {
//   // Core Attendance
//   Future<AttendanceModel> checkIn({
//     required String empId,
//     required LatLng location,
//     String? projectId,
//     String? notes,
//     VerificationType verificationType,
//   });

//   Future<AttendanceModel> checkOut({
//     required String empId,
//     required LatLng location,
//     String? projectId,
//     String? notes,
//     VerificationType verificationType,
//   });

//   // Attendance Queries
//   Future<AttendanceModel?> getTodayAttendance(String empId);
//   Future<List<AttendanceModel>> getAttendanceHistory({
//     required String empId,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? projectId,
//   });

//   Future<List<AttendanceModel>> getRecentAttendance(
//     String empId, {
//     int limit = 10,
//   });

//   // Geofence
//   Future<List<GeofenceModel>> getAvailableGeofences(String empId);
//   Future<GeofenceModel?> getNearestGeofence(LatLng location);
//   Future<bool> validateGeofence(String projectId, LatLng location);

//   // Analytics
//   Future<AnalyticsData> getPersonalAnalytics({
//     required String empId,
//     required AnalyticsMode mode,
//     DateTime? customStart,
//     DateTime? customEnd,
//   });

//   Future<AnalyticsData> getTeamAnalytics({
//     required String managerEmpId,
//     AnalyticsMode mode,
//     String? departmentFilter,
//     String? teamMemberFilter,
//   });

//   // Stats
//   Future<Map<String, dynamic>> getMonthlySummary(String empId, DateTime month);
//   Future<Map<String, dynamic>> getAttendanceStats(String empId);

//   // Regularization (for later integration)
//   Future<bool> applyRegularization({
//     required String empId,
//     required DateTime forDate,
//     required String justification,
//     required String checkInTime,
//     required String checkOutTime,
//   });
// }
