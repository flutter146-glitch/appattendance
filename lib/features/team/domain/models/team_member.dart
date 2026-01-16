// lib/features/team/domain/models/team_member.dart

import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'team_member.freezed.dart';
part 'team_member.g.dart';

enum MemberStatusFilter { all, active, inactive }

@freezed
class TeamMember with _$TeamMember {
  const TeamMember._();

  const factory TeamMember({
    // Core identification
    required String empId,
    required String name,
    // Contact & profile
    String? email,
    String? phone,
    String? profilePhotoUrl,
    @Default('https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=')
    String avatarFallbackUrl,

    // Professional details
    String? department,
    String? designation,
    @Default(UserStatus.active) UserStatus status,

    DateTime? dateOfJoining,
    // Relationships
    @Default([]) List<String> projectIds,
    @Default([]) List<String> projectNames,

    // Attendance history (last 30 days or so)
    @Default([]) List<AttendanceModel> recentAttendanceHistory,

    // Optional analytics (from server or computed)
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? attendanceRatePercentage,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  // ── Cached today attendance (performance optimization) ───────────────────
  AttendanceModel? get _todayAttendance {
    final today = DateTime.now();
    try {
      return recentAttendanceHistory.firstWhere(
        (a) =>
            a.attendanceDate.year == today.year &&
            a.attendanceDate.month == today.month &&
            a.attendanceDate.day == today.day,
      );
    } catch (_) {
      return null;
    }
  }

  // ── BONUS: Filter attendance for any period (daily/weekly/monthly) ────────
  List<AttendanceModel> attendanceInPeriod(DateTime start, DateTime end) {
    return recentAttendanceHistory.where((a) {
      // Inclusive: include start and end day
      return !a.attendanceDate.isBefore(start) &&
          !a.attendanceDate.isAfter(end);
    }).toList();
  }

  // ── Core attendance counts & percentages (full history) ──────────────────

  int get presentCount =>
      recentAttendanceHistory.where((a) => a.isPresent).length;

  int get lateCount => recentAttendanceHistory.where((a) => a.isLate).length;

  int get absentCount => recentAttendanceHistory
      .where((a) => !a.isPresent && a.leaveType == null)
      .length;

  double get totalAttendance =>
      (presentCount + lateCount + absentCount).toDouble();

  double get presentPercentage =>
      totalAttendance > 0 ? (presentCount / totalAttendance) * 100 : 0.0;

  double get latePercentage =>
      totalAttendance > 0 ? (lateCount / totalAttendance) * 100 : 0.0;

  double get absentPercentage =>
      totalAttendance > 0 ? (absentCount / totalAttendance) * 100 : 0.0;

  // ── Today-specific (optimized with cache) ────────────────────────────────

  bool get isPresentToday => _todayAttendance?.isPresent ?? false;

  bool get isLateToday => _todayAttendance?.isLate ?? false;

  String get todayCheckInTime {
    final time = _todayAttendance?.checkInTime;
    return time != null ? DateFormat('hh:mm a').format(time) : '--:--';
  }

  // ── Status & Badge (dynamic & theme-aware) ───────────────────────────────

  String get statusBadgeText {
    if (isPresentToday) {
      return isLateToday ? 'Late' : 'Present';
    }
    switch (status) {
      case UserStatus.terminated:
        return 'Terminated';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.inactive:
        return 'Inactive';
      default:
        return 'Absent';
    }
  }

  Color statusColor(ThemeColors theme) {
    if (isPresentToday) {
      return isLateToday ? theme.warning : theme.success;
    }
    return theme.error;
  }

  // ── UI Helpers ───────────────────────────────────────────────────────────

  String get avatarInitial =>
      name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  String get displayNameWithRole =>
      designation != null && designation!.trim().isNotEmpty
      ? '$name • $designation'
      : name;

  String get quickStats =>
      '${attendanceRatePercentage?.toStringAsFixed(0) ?? 0}% • ${projectNames.length} project${projectNames.length == 1 ? '' : 's'}';

  double get attendanceRate {
    if (recentAttendanceHistory.isEmpty) return 0.0;
    return (presentCount / recentAttendanceHistory.length) * 100;
  }

  String get lastActivityDisplay {
    if (recentAttendanceHistory.isEmpty) return 'No activity';
    final latest = recentAttendanceHistory.first;
    final diff = DateTime.now().difference(latest.attendanceDate);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('dd MMM yyyy').format(latest.attendanceDate);
  }
}

// ── DateTime Extension ─────────────────────────────────────────────────────
extension DateTimeX on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isBeforeOrEqual(DateTime other) => isBefore(other) || isSameDate(other);

  bool isAfterOrEqual(DateTime other) => isAfter(other) || isSameDate(other);
}
