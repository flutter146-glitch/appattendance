// lib/features/team/domain/models/team_member.dart
// ULTIMATE & MOST COMPLETE VERSION - January 09, 2026 (Fully Upgraded)
// Key Upgrades:
// - All missing getters added (isPresentToday, todayCheckInTime, isLateToday, statusBadgeText)
// - Safe fallback for AttendanceModel required params
// - Rich UI helpers: attendanceRate, quickStats, lastActivityDisplay
// - Dark/light mode ready colors
// - Better null-safety & realistic defaults
// - Fully compatible with dummy_data.dart (emp_name → name, emp_email, emp_phone, designation, emp_status)
// - Ready for team list, detail screen, analytics

import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'team_member.freezed.dart';
part 'team_member.g.dart';

@freezed
class TeamMember with _$TeamMember {
  const TeamMember._();

  const factory TeamMember({
    // Core identification
    required String empId,
    required String name, // from emp_name
    // Contact & profile
    String? email, // from emp_email
    String? phone, // from emp_phone
    String? profilePhotoUrl,
    @Default('https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=')
    String avatarFallbackUrl,

    // Professional details
    String? department,
    String? designation,
    @Default(UserStatus.active) UserStatus status, // from emp_status

    DateTime? dateOfJoining, // from emp_joining_date
    // Relationships
    @Default([]) List<String> projectIds,
    @Default([]) List<String> projectNames,

    // Attendance history (last 30 days or so)
    @Default([]) List<AttendanceModel> recentAttendanceHistory,

    // Optional analytics
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? attendanceRatePercentage,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  // ── Computed UI & Business Helpers ───────────────────────────────────────

  /// Avatar initial (first letter of name)
  String get avatarInitial =>
      name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  /// Full name with designation (for list tiles)
  String get displayNameWithRole =>
      designation != null && designation!.trim().isNotEmpty
      ? '$name . $designation'
      : name;

  /// Quick stats for team list (attendance % + project count)
  String get quickStats =>
      '${attendanceRatePercentage?.toStringAsFixed(0) ?? 0}% • ${projectNames.length} project${projectNames.length == 1 ? '' : 's'}';

  /// Calculated attendance rate from recent history
  double get attendanceRate {
    if (recentAttendanceHistory.isEmpty) return 0.0;
    final presentCount = recentAttendanceHistory
        .where((a) => a.isPresent)
        .length;
    return (presentCount / recentAttendanceHistory.length) * 100;
  }

  /// Last activity (human readable)
  String get lastActivityDisplay {
    if (recentAttendanceHistory.isEmpty) return 'No activity';
    final latest = recentAttendanceHistory.first;
    final diff = DateTime.now().difference(latest.attendanceDate);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('dd MMM yyyy').format(latest.attendanceDate);
  }

  /// Status color (dark/light friendly)
  Color get statusColor => switch (status) {
    UserStatus.active => Colors.green.shade700,
    UserStatus.inactive => Colors.grey.shade600,
    UserStatus.suspended => Colors.deepPurple.shade600,
    UserStatus.terminated => Colors.red.shade800,
    _ => Colors.blueGrey.shade600,
  };

  Color get statusBackground => statusColor.withOpacity(0.15);

  /// Is employee present today?
  bool get isPresentToday {
    final today = DateTime.now();
    return recentAttendanceHistory.any(
      (a) =>
          a.attendanceDate.year == today.year &&
          a.attendanceDate.month == today.month &&
          a.attendanceDate.day == today.day &&
          a.isPresent,
    );
  }

  /// Today's check-in time
  String get todayCheckInTime {
    final today = DateTime.now();
    final todayAtt = recentAttendanceHistory.firstWhere(
      (a) => a.attendanceDate.isSameDate(today) && a.checkInTime != null,
      orElse: () => AttendanceModel(
        attId: 'fallback_today_${empId}',
        empId: empId,
        attendanceDate: today,
        timestamp: today,
        status: AttendanceStatus.checkIn,
        dailyStatus: DailyAttendanceStatus.absent,
      ),
    );

    if (todayAtt.checkInTime == null) return '--:--';
    return DateFormat('hh:mm a').format(todayAtt.checkInTime!);
  }

  /// Is employee late today?
  bool get isLateToday {
    final today = DateTime.now();
    final todayAtt = recentAttendanceHistory.firstWhere(
      (a) => a.attendanceDate.isSameDate(today),
      orElse: () => AttendanceModel(
        attId: 'fallback_today_${empId}',
        empId: empId,
        attendanceDate: today,
        timestamp: today,
        status: AttendanceStatus.checkIn,
        dailyStatus: DailyAttendanceStatus.absent,
      ),
    );
    return todayAtt.isLate;
  }

  /// Dynamic status badge text (Present/Late/Absent/On Leave)
  String get statusBadgeText {
    if (isPresentToday) {
      return isLateToday ? 'Late' : 'Present';
    }
    if (status == UserStatus.terminated) return 'terminated';
    if (status == UserStatus.suspended) return 'suspended';
    if (status == UserStatus.inactive) return 'Inactive';
    return 'Absent';
  }

  /// Average daily hours (only present days)
  double get avgDailyHours {
    final presentDays = recentAttendanceHistory.where(
      (a) => a.isPresent && a.workedHours != null,
    );
    if (presentDays.isEmpty) return 0.0;
    final total = presentDays.fold<double>(
      0.0,
      (sum, a) => sum + a.workedHours!,
    );
    return total / presentDays.length;
  }
}

// ── DateTime Helper Extension ───────────────────────────────────────────────
extension DateTimeX on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

// // lib/features/team/domain/models/team_model.dart
// // FINAL Refined Version (31 Dec 2025) - Manager View + Screenshots Compatible
// // Fixed: Class name consistent, status as enum, computed helpers, projects list
// // No hardcoding - All from DB joins (user + attendance + projects)

// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'team_model.freezed.dart';
// part 'team_model.g.dart';

// @freezed
// class TeamMemberAnalytics with _$TeamMemberAnalytics {
//   const TeamMemberAnalytics._();

//   const factory TeamMemberAnalytics({
//     required String empId, // emp_id (PK)
//     required String name,
//     String? designation,
//     String? email,
//     String? phone,
//     @Default(UserStatus.active) UserStatus status, // From user_model enum
//     String? profilePhoto, // Profile photo or generated
//     DateTime? joinDate,
//     String? department,
//     @Default([]) List<String> assignedProjects, // Project names/IDs
//     @Default([])
//     @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
//     List<AttendanceModel>
//     attendanceHistory, // Filtered history (e.g., current month)
//   }) = _TeamMemberAnalytics;

//   factory TeamMemberAnalytics.fromJson(Map<String, dynamic> json) =>
//       _$TeamMemberAnalyticsFromJson(json);

//   // Computed helpers for UI (manager cards)
//   String get shortName => name.split(' ').first;
//   String get displayStatus =>
//       status == UserStatus.active ? 'Active' : status.name.toUpperCase();
//   Color get statusColor {
//     return switch (status) {
//       UserStatus.active => Colors.green,
//       UserStatus.inactive => Colors.grey,
//       UserStatus.suspended => Colors.orange,
//       UserStatus.terminated => Colors.red,
//     };
//   }

//   String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : '?';
//   String get avatarFallback =>
//       profilePhoto ??
//       'https://ui-avatars.com/api/?name=${Uri.encodeComponent(shortName)}&background=random';

//   // Attendance stats (computed from history)
//   int get presentCount => attendanceHistory.where((a) => a.isPresent).length;
//   int get lateCount => attendanceHistory.where((a) => a.isLate).length;
//   int get absentCount => attendanceHistory
//       .where((a) => !a.isPresent && a.leaveType == null)
//       .length;
//   double get attendancePercentage {
//     if (attendanceHistory.isEmpty) return 0.0;
//     return (presentCount / attendanceHistory.length) * 100;
//   }

//   String get attendanceSummary =>
//       '${presentCount} Present • ${lateCount} Late • ${absentCount} Absent';
// }

// // JSON Helpers (unchanged - perfect)
// List<AttendanceModel> _attendanceListFromJson(List<dynamic>? list) {
//   if (list == null) return [];
//   return list
//       .map((item) => AttendanceModel.fromJson(item as Map<String, dynamic>))
//       .toList();
// }

// List<Map<String, dynamic>> _attendanceListToJson(List<AttendanceModel> list) {
//   return list.map((item) => item.toJson()).toList();
// }
