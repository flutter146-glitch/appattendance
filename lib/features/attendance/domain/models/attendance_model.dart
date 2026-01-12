// lib/features/attendance/domain/models/attendance_model.dart
// ULTIMATE & PRODUCTION-READY Version - January 09, 2026
// Stronger: Bulletproof null-safety, UI-ready helpers, more computed fields,
//           better extensibility, sections for readability
// Fully compatible with your dummy_data & DB structure

import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

// ── Enums (unchanged & perfect) ─────────────────────────────────────────────
enum DailyAttendanceStatus {
  present,
  absent,
  partialLeave,
  leave,
  shortHalf,
  holiday,
  weekend,
}

enum AttendanceStatus {
  @JsonValue('checkIn')
  checkIn,

  @JsonValue('checkOut')
  checkOut,
}

enum VerificationType {
  @JsonValue('faceauth')
  faceAuth,

  @JsonValue('fingerprint')
  fingerprint,

  @JsonValue('manual')
  manual,

  @JsonValue('gps')
  gps,
}

// ── Main Model ──────────────────────────────────────────────────────────────
@freezed
class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    // Core identifiers
    required String attId, // PK
    required String empId, // FK
    // Timestamps (both required for daily logic)
    required DateTime attendanceDate, // att_date (daily grouping)
    required DateTime timestamp, // att_timestamp (full record time)
    // Check-in / Check-out
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? workedHours,

    // Location & Verification
    double? latitude,
    double? longitude,
    String? geofenceName,
    VerificationType? verificationType,
    @Default(false) bool isVerified,

    // Project & Notes
    String? projectId,
    String? notes,

    // Leave & Status
    String? leaveType, // 'casual', 'sick', 'earned', etc.
    @Default(AttendanceStatus.checkIn) AttendanceStatus status,
    @Default(DailyAttendanceStatus.present) DailyAttendanceStatus dailyStatus,

    // Proof & Audit
    String? photoProofPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}

// ── Extensions: UI + Business Helpers ───────────────────────────────────────
extension AttendanceModelExtension on AttendanceModel {
  // Basic status checks
  bool get isCheckIn => status == AttendanceStatus.checkIn;
  bool get isCheckOut => status == AttendanceStatus.checkOut;
  double? get workedHours {
    if (checkInTime == null || checkOutTime == null) return null;
    final duration = checkOutTime!.difference(checkInTime!);
    return duration.inMinutes / 60.0; // hours as double
  }
  // Formatted display

  String get formattedDate => DateFormat('dd MMM yyyy').format(attendanceDate);
  String get formattedDay => DateFormat('EEE').format(attendanceDate);
  String get displayDate => '$formattedDate ($formattedDay)';

  String get formattedCheckIn => checkInTime != null
      ? DateFormat('hh:mm a').format(checkInTime!)
      : '--:--';

  String get formattedCheckOut => checkOutTime != null
      ? DateFormat('hh:mm a').format(checkOutTime!)
      : '--:--';

  // Duration & Hours
  Duration? get duration {
    if (checkInTime == null || checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime!);
  }

  double get effectiveWorkedHours {
    if (duration == null) return 0.0;
    return duration!.inMinutes / 60.0;
  }

  String get todayCheckInTime {
    final today = DateTime.now();
    if (!attendanceDate.isSameDate(today)) return '--:--';
    return checkInTime != null
        ? DateFormat('hh:mm a').format(checkInTime!)
        : '--:--';
  }

  /// Is this record from today?
  bool get isToday {
    final today = DateTime.now();
    return attendanceDate.isSameDate(today);
  }

  bool get isLateToday {
    if (!isToday || checkInTime == null) return false;
    final officeStart = DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
      9,
      0,
    );
    return checkInTime!.isAfter(officeStart);
  }

  String get statusBadgeText {
    if (isToday) {
      if (dailyStatus == DailyAttendanceStatus.absent) return 'Absent';
      if (isLateToday) return 'Late';
      return 'Present';
    }
    return dailyStatus.name[0].toUpperCase() + dailyStatus.name.substring(1);
  }

  // Late check-in logic (configurable office start time)
  bool get isLate {
    if (!isCheckIn || checkInTime == null) return false;
    final officeStart = DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
      9, // ← Future mein config se aayega
      0,
    );
    return checkInTime!.isAfter(officeStart);
  }

  // Present status (no leave, checked-in, not absent)
  bool get isPresent =>
      dailyStatus == DailyAttendanceStatus.present ||
      (isCheckIn && leaveType == null && !isLate);

  bool get hasPhotoProof =>
      photoProofPath != null && photoProofPath!.isNotEmpty;

  // UI Helpers (ready for list tiles, chips, badges)
  Color get statusColor => switch (dailyStatus) {
    DailyAttendanceStatus.present => Colors.green.shade700,
    DailyAttendanceStatus.absent => Colors.red.shade700,
    DailyAttendanceStatus.leave => Colors.orange.shade700,
    DailyAttendanceStatus.partialLeave => Colors.purple.shade600,
    DailyAttendanceStatus.shortHalf => Colors.amber.shade700,
    DailyAttendanceStatus.holiday => Colors.blueGrey.shade600,
    DailyAttendanceStatus.weekend => Colors.grey.shade500,
    _ => Colors.blueGrey,
  };

  Color get statusBackground => statusColor.withOpacity(0.15);

  IconData get statusIcon => switch (dailyStatus) {
    DailyAttendanceStatus.present => Icons.check_circle,
    DailyAttendanceStatus.absent => Icons.cancel,
    DailyAttendanceStatus.leave => Icons.beach_access,
    DailyAttendanceStatus.partialLeave => Icons.hourglass_bottom,
    DailyAttendanceStatus.shortHalf => Icons.timelapse,
    DailyAttendanceStatus.holiday => Icons.celebration,
    DailyAttendanceStatus.weekend => Icons.weekend,
    _ => Icons.help_outline,
  };

  String get quickStatusDisplay {
    if (isPresent) {
      return 'Present • ${effectiveWorkedHours.toStringAsFixed(1)}h';
    } else if (leaveType != null) {
      return 'Leave ($leaveType)';
    } else {
      return dailyStatus.name[0].toUpperCase() + dailyStatus.name.substring(1);
    }
  }

  String get verificationDisplay {
    if (verificationType == null) return 'Unknown';
    return switch (verificationType!) {
      VerificationType.faceAuth => 'Face Auth',
      VerificationType.fingerprint => 'Fingerprint',
      VerificationType.manual => 'Manual',
      VerificationType.gps => 'GPS',
    };
  }
}

// ── DB Factory (updated with all new fields) ────────────────────────────────
AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
  return AttendanceModel(
    attId: row['att_id'] as String,
    empId: row['emp_id'] as String,
    timestamp: DateTime.parse(row['att_timestamp'] as String),
    attendanceDate: DateTime.parse(row['att_date'] as String),
    checkInTime: _parseDateTime(row['check_in_time'] as String?),
    checkOutTime: _parseDateTime(row['check_out_time'] as String?),
    latitude: row['att_latitude'] as double?,
    longitude: row['att_longitude'] as double?,
    geofenceName: row['att_geofence_name'] as String?,
    projectId: row['project_id'] as String?,
    notes: row['att_notes'] as String?,
    status: _mapStatus(row['att_status'] as String),
    verificationType: _mapVerification(row['verification_type'] as String?),
    isVerified: (row['is_verified'] as int? ?? 0) == 1,
    leaveType: row['leave_type'] as String?,
    photoProofPath: row['photo_proof_path'] as String?,
    dailyStatus: _mapDailyStatus(row['daily_status'] as String? ?? 'present'),
    createdAt: _parseDateTime(row['created_at'] as String?),
    updatedAt: _parseDateTime(row['updated_at'] as String?),
  );
}

// ── Helper Functions ────────────────────────────────────────────────────────
AttendanceStatus _mapStatus(String status) {
  return status == 'checkOut'
      ? AttendanceStatus.checkOut
      : AttendanceStatus.checkIn;
}

VerificationType? _mapVerification(String? type) {
  switch (type?.toLowerCase()) {
    case 'faceauth':
      return VerificationType.faceAuth;
    case 'fingerprint':
      return VerificationType.fingerprint;
    case 'manual':
      return VerificationType.manual;
    case 'gps':
      return VerificationType.gps;
    default:
      return null;
  }
}

DailyAttendanceStatus _mapDailyStatus(String status) {
  return DailyAttendanceStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => DailyAttendanceStatus.present,
  );
}

DateTime? _parseDateTime(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    return null;
  }
}

// // lib/features/attendance/domain/models/attendance_model.dart
// // ULTIMATE & PRODUCTION-READY Version - January 09, 2026
// // Stronger: Bulletproof null-safety, UI-ready helpers, more computed fields,
// //           better extensibility, sections for readability
// // Fully compatible with your dummy_data & DB structure

// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:intl/intl.dart';

// part 'attendance_model.freezed.dart';
// part 'attendance_model.g.dart';

// // ── Enums (unchanged & perfect) ─────────────────────────────────────────────
// enum DailyAttendanceStatus {
//   present,
//   absent,
//   partialLeave,
//   leave,
//   shortHalf,
//   holiday,
//   weekend,
// }

// enum AttendanceStatus {
//   @JsonValue('checkIn')
//   checkIn,

//   @JsonValue('checkOut')
//   checkOut,
// }

// enum VerificationType {
//   @JsonValue('faceauth')
//   faceAuth,

//   @JsonValue('fingerprint')
//   fingerprint,

//   @JsonValue('manual')
//   manual,

//   @JsonValue('gps')
//   gps,
// }

// // ── Main Model ──────────────────────────────────────────────────────────────
// @freezed
// class AttendanceModel with _$AttendanceModel {
//   const AttendanceModel._();

//   const factory AttendanceModel({
//     // Core identifiers
//     required String attId, // PK
//     required String empId, // FK
//     // Timestamps (both required for daily logic)
//     required DateTime attendanceDate, // att_date (daily grouping)
//     required DateTime timestamp, // att_timestamp (full record time)
//     // Check-in / Check-out
//     DateTime? checkInTime,
//     DateTime? checkOutTime,

//     // Location & Verification
//     double? latitude,
//     double? longitude,
//     String? geofenceName,
//     VerificationType? verificationType,
//     @Default(false) bool isVerified,

//     // Project & Notes
//     String? projectId,
//     String? notes,

//     // Leave & Status
//     String? leaveType, // 'casual', 'sick', 'earned', etc.
//     @Default(AttendanceStatus.checkIn) AttendanceStatus status,
//     @Default(DailyAttendanceStatus.present) DailyAttendanceStatus dailyStatus,

//     // Proof & Audit
//     String? photoProofPath,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _AttendanceModel;

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
//       _$AttendanceModelFromJson(json);
// }

// // ── Extensions: UI + Business Helpers ───────────────────────────────────────
// extension AttendanceModelExtension on AttendanceModel {
//   // Basic status checks
//   bool get isCheckIn => status == AttendanceStatus.checkIn;
//   bool get isCheckOut => status == AttendanceStatus.checkOut;

//   // Formatted display
//   String get formattedDate => DateFormat('dd MMM yyyy').format(attendanceDate);
//   String get formattedDay => DateFormat('EEE').format(attendanceDate);
//   String get displayDate => '$formattedDate ($formattedDay)';

//   String get formattedCheckIn => checkInTime != null
//       ? DateFormat('hh:mm a').format(checkInTime!)
//       : '--:--';

//   String get formattedCheckOut => checkOutTime != null
//       ? DateFormat('hh:mm a').format(checkOutTime!)
//       : '--:--';

//   // Duration & Hours
//   Duration? get duration {
//     if (checkInTime == null || checkOutTime == null) return null;
//     return checkOutTime!.difference(checkInTime!);
//   }

//   double get effectiveWorkedHours {
//     if (duration == null) return 0.0;
//     return duration!.inMinutes / 60.0;
//   }

//   // Late check-in logic (configurable office start time)
//   bool get isLate {
//     if (!isCheckIn || checkInTime == null) return false;
//     final officeStart = DateTime(
//       attendanceDate.year,
//       attendanceDate.month,
//       attendanceDate.day,
//       9, // ← Future mein config se aayega
//       0,
//     );
//     return checkInTime!.isAfter(officeStart);
//   }

//   // Present status (no leave, checked-in, not absent)
//   bool get isPresent =>
//       dailyStatus == DailyAttendanceStatus.present ||
//       (isCheckIn && leaveType == null && !isLate);

//   bool get hasPhotoProof =>
//       photoProofPath != null && photoProofPath!.isNotEmpty;

//   // UI Helpers (ready for list tiles, chips, badges)
//   Color get statusColor => switch (dailyStatus) {
//     DailyAttendanceStatus.present => Colors.green.shade700,
//     DailyAttendanceStatus.absent => Colors.red.shade700,
//     DailyAttendanceStatus.leave => Colors.orange.shade700,
//     DailyAttendanceStatus.partialLeave => Colors.purple.shade600,
//     DailyAttendanceStatus.shortHalf => Colors.amber.shade700,
//     DailyAttendanceStatus.holiday => Colors.blueGrey.shade600,
//     DailyAttendanceStatus.weekend => Colors.grey.shade500,
//     _ => Colors.blueGrey,
//   };

//   Color get statusBackground => statusColor.withOpacity(0.15);

//   IconData get statusIcon => switch (dailyStatus) {
//     DailyAttendanceStatus.present => Icons.check_circle,
//     DailyAttendanceStatus.absent => Icons.cancel,
//     DailyAttendanceStatus.leave => Icons.beach_access,
//     DailyAttendanceStatus.partialLeave => Icons.hourglass_bottom,
//     DailyAttendanceStatus.shortHalf => Icons.timelapse,
//     DailyAttendanceStatus.holiday => Icons.celebration,
//     DailyAttendanceStatus.weekend => Icons.weekend,
//     _ => Icons.help_outline,
//   };

//   String get quickStatusDisplay {
//     if (isPresent) {
//       return 'Present • ${effectiveWorkedHours.toStringAsFixed(1)}h';
//     } else if (leaveType != null) {
//       return 'Leave ($leaveType)';
//     } else {
//       return dailyStatus.name[0].toUpperCase() + dailyStatus.name.substring(1);
//     }
//   }

//   String get verificationDisplay {
//     if (verificationType == null) return 'Unknown';
//     return switch (verificationType!) {
//       VerificationType.faceAuth => 'Face Auth',
//       VerificationType.fingerprint => 'Fingerprint',
//       VerificationType.manual => 'Manual',
//       VerificationType.gps => 'GPS',
//     };
//   }
// }

// // ── DB Factory (updated with all new fields) ────────────────────────────────
// AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
//   return AttendanceModel(
//     attId: row['att_id'] as String,
//     empId: row['emp_id'] as String,
//     timestamp: DateTime.parse(row['att_timestamp'] as String),
//     attendanceDate: DateTime.parse(row['att_date'] as String),
//     checkInTime: _parseDateTime(row['check_in_time'] as String?),
//     checkOutTime: _parseDateTime(row['check_out_time'] as String?),
//     latitude: row['att_latitude'] as double?,
//     longitude: row['att_longitude'] as double?,
//     geofenceName: row['att_geofence_name'] as String?,
//     projectId: row['project_id'] as String?,
//     notes: row['att_notes'] as String?,
//     status: _mapStatus(row['att_status'] as String),
//     verificationType: _mapVerification(row['verification_type'] as String?),
//     isVerified: (row['is_verified'] as int? ?? 0) == 1,
//     leaveType: row['leave_type'] as String?,
//     photoProofPath: row['photo_proof_path'] as String?,
//     dailyStatus: _mapDailyStatus(row['daily_status'] as String? ?? 'present'),
//     createdAt: _parseDateTime(row['created_at'] as String?),
//     updatedAt: _parseDateTime(row['updated_at'] as String?),
//   );
// }

// // ── Helper Functions ────────────────────────────────────────────────────────
// AttendanceStatus _mapStatus(String status) {
//   return status == 'checkOut'
//       ? AttendanceStatus.checkOut
//       : AttendanceStatus.checkIn;
// }

// VerificationType? _mapVerification(String? type) {
//   switch (type?.toLowerCase()) {
//     case 'faceauth':
//       return VerificationType.faceAuth;
//     case 'fingerprint':
//       return VerificationType.fingerprint;
//     case 'manual':
//       return VerificationType.manual;
//     case 'gps':
//       return VerificationType.gps;
//     default:
//       return null;
//   }
// }

// DailyAttendanceStatus _mapDailyStatus(String status) {
//   return DailyAttendanceStatus.values.firstWhere(
//     (e) => e.name == status,
//     orElse: () => DailyAttendanceStatus.present,
//   );
// }

// DateTime? _parseDateTime(String? dateStr) {
//   if (dateStr == null || dateStr.isEmpty) return null;
//   try {
//     return DateTime.parse(dateStr);
//   } catch (_) {
//     return null;
//   }
// }
