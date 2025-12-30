// lib/features/attendance/domain/models/attendance_model.dart
// Final production-ready AttendanceModel (freezed + Riverpod 2.0)
// Aligned with employee_attendance table from your schema + dummy_data.json
// Includes all columns, null-safe, freezed rules followed
// Computed helpers in extension for UI (isLate, duration, formatted time etc.)

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

// ==============================
// ENUMS (Exact match with table CHECK constraints)
// ==============================

enum DailyAttendanceStatus {
  present,
  absent,
  partialLeave,
  leave,
  shortHalf,
  holiday,
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

// ==============================
// MAIN ATTENDANCE MODEL (Only simple fields - No computed getters here)
// ==============================

@freezed
class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    required String attId, // att_id (PK)
    required String empId, // emp_id (FK)
    required DateTime timestamp, // att_timestamp
    double? latitude, // att_latitude
    double? longitude, // att_longitude
    String? geofenceName, // att_geofence_name
    String? projectId, // project_id (FK)
    String? notes, // att_notes
    required AttendanceStatus status, // att_status
    VerificationType? verificationType, // verification_type
    @Default(false) bool isVerified, // is_verified (0/1 → bool)
    DateTime? createdAt, // created_at
    DateTime? updatedAt, // updated_at
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}

// ==============================
// COMPUTED PROPERTIES & HELPERS (Extension - safe for freezed)
// ==============================

extension AttendanceModelExtension on AttendanceModel {
  bool get isCheckIn => status == AttendanceStatus.checkIn;
  bool get isCheckOut => status == AttendanceStatus.checkOut;

  String get formattedTime => DateFormat('hh:mm a').format(timestamp);
  String get formattedDate => DateFormat('dd MMM yyyy').format(timestamp);

  // Check if late (assuming office start 09:00 - adjust as per org)
  bool get isLate {
    if (!isCheckIn) return false;
    final officeStart = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      9,
      0,
    );
    return timestamp.isAfter(officeStart);
  }

  // Placeholder for duration (checkOut - checkIn) - real pair logic in repository/notifier
  Duration? get duration => null;

  String get statusDisplay => isCheckIn ? 'Check-In' : 'Check-Out';

  String get verificationDisplay {
    switch (verificationType) {
      case VerificationType.faceAuth:
        return 'Face Auth';
      case VerificationType.fingerprint:
        return 'Fingerprint';
      case VerificationType.manual:
        return 'Manual';
      case VerificationType.gps:
        return 'GPS';
      default:
        return 'Unknown';
    }
  }
}

// ==============================
// FACTORY: From DB row (employee_attendance table)
// ==============================

AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
  return AttendanceModel(
    attId: row['att_id'] as String,
    empId: row['emp_id'] as String,
    timestamp: DateTime.parse(row['att_timestamp'] as String),
    latitude: row['att_latitude'] as double?,
    longitude: row['att_longitude'] as double?,
    geofenceName: row['att_geofence_name'] as String?,
    projectId: row['project_id'] as String?,
    notes: row['att_notes'] as String?,
    status: _mapStatus(row['att_status'] as String),
    verificationType: _mapVerification(row['verification_type'] as String?),
    isVerified: (row['is_verified'] as int? ?? 0) == 1,
    createdAt: _parseDate(row['created_at'] as String?),
    updatedAt: _parseDate(row['updated_at'] as String?),
  );
}

// Helpers
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

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    return null;
  }
}




// // lib/features/attendance/domain/models/attendance_model.dart
// // Final production-ready AttendanceModel (freezed + Riverpod 2.0)
// // Aligned with employee_attendance table from your schema + dummy_data.json
// // Includes all columns, null-safe, freezed rules followed
// // Computed helpers in extension for UI (isLate, duration, formatted time etc.)

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:intl/intl.dart';

// part 'attendance_model.freezed.dart';
// part 'attendance_model.g.dart';

// // ==============================
// // ENUMS (Exact match with table CHECK constraints)
// // ==============================

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

// // ==============================
// // MAIN ATTENDANCE MODEL (Only simple fields - No computed getters here)
// // ==============================

// @freezed
// class AttendanceModel with _$AttendanceModel {
//   const AttendanceModel._();

//   const factory AttendanceModel({
//     required String attId, // att_id (PK)
//     required String empId, // emp_id (FK)
//     required DateTime timestamp, // att_timestamp
//     double? latitude, // att_latitude
//     double? longitude, // att_longitude
//     String? geofenceName, // att_geofence_name
//     String? projectId, // project_id (FK)
//     String? notes, // att_notes
//     required AttendanceStatus status, // att_status
//     VerificationType? verificationType, // verification_type
//     @Default(false) bool isVerified, // is_verified (0/1 → bool)
//     DateTime? createdAt, // created_at
//     DateTime? updatedAt, // updated_at
//   }) = _AttendanceModel;

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
//       _$AttendanceModelFromJson(json);
// }

// // ==============================
// // COMPUTED PROPERTIES & HELPERS (Extension - safe for freezed)
// // ==============================

// extension AttendanceModelExtension on AttendanceModel {
//   bool get isCheckIn => status == AttendanceStatus.checkIn;
//   bool get isCheckOut => status == AttendanceStatus.checkOut;

//   String get formattedTime => DateFormat('hh:mm a').format(timestamp);
//   String get formattedDate => DateFormat('dd MMM yyyy').format(timestamp);

//   // Check if late (assuming office start 09:00 - adjust as per org)
//   bool get isLate {
//     if (!isCheckIn) return false;
//     final officeStart = DateTime(
//       timestamp.year,
//       timestamp.month,
//       timestamp.day,
//       9,
//       0,
//     );
//     return timestamp.isAfter(officeStart);
//   }

//   // Placeholder for duration (checkOut - checkIn) - real pair logic in repository/notifier
//   Duration? get duration => null;

//   String get statusDisplay => isCheckIn ? 'Check-In' : 'Check-Out';

//   String get verificationDisplay {
//     switch (verificationType) {
//       case VerificationType.faceAuth:
//         return 'Face Auth';
//       case VerificationType.fingerprint:
//         return 'Fingerprint';
//       case VerificationType.manual:
//         return 'Manual';
//       case VerificationType.gps:
//         return 'GPS';
//       default:
//         return 'Unknown';
//     }
//   }
// }

// // ==============================
// // FACTORY: From DB row (employee_attendance table)
// // ==============================

// AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
//   return AttendanceModel(
//     attId: row['att_id'] as String,
//     empId: row['emp_id'] as String,
//     timestamp: DateTime.parse(row['att_timestamp'] as String),
//     latitude: row['att_latitude'] as double?,
//     longitude: row['att_longitude'] as double?,
//     geofenceName: row['att_geofence_name'] as String?,
//     projectId: row['project_id'] as String?,
//     notes: row['att_notes'] as String?,
//     status: _mapStatus(row['att_status'] as String),
//     verificationType: _mapVerification(row['verification_type'] as String?),
//     isVerified: (row['is_verified'] as int? ?? 0) == 1,
//     createdAt: _parseDate(row['created_at'] as String?),
//     updatedAt: _parseDate(row['updated_at'] as String?),
//   );
// }

// // Helpers
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

// DateTime? _parseDate(String? dateStr) {
//   if (dateStr == null) return null;
//   try {
//     return DateTime.parse(dateStr);
//   } catch (_) {
//     return null;
//   }
// }






// // lib/features/attendance/domain/models/attendance_model.dart
// // Final production-ready AttendanceModel (freezed + Riverpod 2.0)
// // Aligned with employee_attendance table from your schema + dummy_data.json
// // No computed getters in constructor (fixes freezed errors)
// // Computed helpers in extension (isLate, duration, formatted time etc.)

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:intl/intl.dart';

// part 'attendance_model.freezed.dart';
// part 'attendance_model.g.dart';

// // ==============================
// // ENUMS (Exact match with table CHECK constraints)
// // ==============================

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

// // ==============================
// // MAIN ATTENDANCE MODEL (Only simple fields)
// // ==============================

// @freezed
// class AttendanceModel with _$AttendanceModel {
//   const AttendanceModel._();

//   const factory AttendanceModel({
//     required String attId, // att_id (PK)
//     required String empId, // emp_id (FK)
//     required DateTime timestamp, // att_timestamp
//     double? latitude, // att_latitude
//     double? longitude, // att_longitude
//     String? geofenceName, // att_geofence_name
//     String? projectId, // project_id (FK)
//     String? notes, // att_notes
//     required AttendanceStatus status, // att_status
//     VerificationType? verificationType, // verification_type
//     @Default(false) bool isVerified, // is_verified (0/1 → bool)
//     DateTime? createdAt, // created_at
//     DateTime? updatedAt, // updated_at
//   }) = _AttendanceModel;

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
//       _$AttendanceModelFromJson(json);
// }

// // ==============================
// // COMPUTED PROPERTIES & HELPERS (Extension)
// // ==============================

// extension AttendanceModelExtension on AttendanceModel {
//   bool get isCheckIn => status == AttendanceStatus.checkIn;
//   bool get isCheckOut => status == AttendanceStatus.checkOut;

//   String get formattedTime => DateFormat('hh:mm a').format(timestamp);
//   String get formattedDate => DateFormat('dd MMM yyyy').format(timestamp);

//   // Check if late (assuming office start 09:00 - adjust as per org)
//   bool get isLate {
//     if (!isCheckIn) return false;
//     final officeStart = DateTime(
//       timestamp.year,
//       timestamp.month,
//       timestamp.day,
//       9,
//       0,
//     );
//     return timestamp.isAfter(officeStart);
//   }

//   // Placeholder for duration (checkOut - checkIn)
//   Duration? get duration {
//     // In real app, pair checkIn/checkOut from same day
//     return null; // Implement in repository/notifier
//   }

//   String get statusDisplay => isCheckIn ? 'Check-In' : 'Check-Out';

//   String get verificationDisplay {
//     switch (verificationType) {
//       case VerificationType.faceAuth:
//         return 'Face Auth';
//       case VerificationType.fingerprint:
//         return 'Fingerprint';
//       case VerificationType.manual:
//         return 'Manual';
//       case VerificationType.gps:
//         return 'GPS';
//       default:
//         return 'Unknown';
//     }
//   }
// }

// // ==============================
// // FACTORY: From DB row (employee_attendance table)
// // ==============================

// AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
//   return AttendanceModel(
//     attId: row['att_id'] as String,
//     empId: row['emp_id'] as String,
//     timestamp: DateTime.parse(row['att_timestamp'] as String),
//     latitude: row['att_latitude'] as double?,
//     longitude: row['att_longitude'] as double?,
//     geofenceName: row['att_geofence_name'] as String?,
//     projectId: row['project_id'] as String?,
//     notes: row['att_notes'] as String?,
//     status: _mapStatus(row['att_status'] as String),
//     verificationType: _mapVerification(row['verification_type'] as String?),
//     isVerified: (row['is_verified'] as int? ?? 0) == 1,
//     createdAt: _parseDate(row['created_at'] as String?),
//     updatedAt: _parseDate(row['updated_at'] as String?),
//   );
// }

// // Helpers
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

// DateTime? _parseDate(String? dateStr) {
//   if (dateStr == null) return null;
//   try {
//     return DateTime.parse(dateStr);
//   } catch (_) {
//     return null;
//   }
// }




// // lib/features/attendance/domain/models/attendance_model.dart
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'attendance_model.freezed.dart';
// part 'attendance_model.g.dart';

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

// enum AttendanceType { checkIn, checkOut, enter, exit }

// enum AttendanceStatus {
//   present,
//   absent,
//   partialLeave,
//   leave,
//   shortHalf,
//   holiday,
// }

// @freezed
// class AttendanceModel with _$AttendanceModel {
//   const AttendanceModel._();

//   const factory AttendanceModel({
//     required String id,
//     String? userId,
//     required DateTime timestamp,
//     required AttendanceType type,
//     @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
//     GeofenceModel? geofence,
//     required double latitude,
//     required double longitude,
//     String? projectName,
//     String? notes,
//     AttendanceStatus? status,
//   }) = _AttendanceModel;

//   // Helpers
//   bool get isLate =>
//       type == AttendanceType.checkIn && timestamp.hour > 9 ||
//       (timestamp.hour == 9 && timestamp.minute > 15);
//   bool get isHalfDay => status == AttendanceStatus.shortHalf;
//   Duration? getDuration(AttendanceModel? checkout) =>
//       checkout != null ? checkout.timestamp.difference(timestamp) : null;
//   String get code => status?.name[0].toUpperCase() ?? 'P';
//   String get label => status?.name.capitalize() ?? 'Present';
//   Color get color {
//     switch (status) {
//       case AttendanceStatus.present:
//         return AppColors.success;
//       case AttendanceStatus.absent:
//         return AppColors.error;
//       case AttendanceStatus.partialLeave:
//         return Colors.orange;
//       case AttendanceStatus.leave:
//         return Colors.blue;
//       case AttendanceStatus.shortHalf:
//         return Colors.amber;
//       case AttendanceStatus.holiday:
//         return Colors.purple;
//       default:
//         return AppColors.grey500;
//     }
//   }
  

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
//       _$AttendanceModelFromJson(json);
// }



// // YE 2 FUNCTIONS ADD KAR (file ke end mein)
// GeofenceModel? _geofenceFromJson(Map<String, dynamic>? json) {
//   if (json == null) return null;
//   return GeofenceModel.fromJson(json);
// }

// Map<String, dynamic>? _geofenceToJson(GeofenceModel? model) {
//   return model?.toJson();
// }

// extension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }

// @freezed
// class AttendanceStats with _$AttendanceStats {
//   const factory AttendanceStats({
//     required int present,
//     required int absent,
//     required int late,
//     required int leave,
//     required int totalDays,
//     required int attendancePercentage,
//   }) = _AttendanceStats;

//   factory AttendanceStats.fromJson(Map<String, dynamic> json) =>
//       _$AttendanceStatsFromJson(json);
// }


