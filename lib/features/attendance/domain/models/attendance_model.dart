// lib/features/attendance/domain/models/attendance_model.dart
// FINAL Recommended Version (31 Dec 2025) - Polished & Error-Free
// Added: attendanceDate, checkInTime, checkOutTime, leaveType (for leave status)
// All previous features preserved + computed isPresent

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

// Enums (unchanged - perfect)
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

@freezed
class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    required String attId, // att_id (PK)
    required String empId, // emp_id (FK)
    required DateTime timestamp, // att_timestamp
    required DateTime
    attendanceDate, // NEW: att_date (separate for daily grouping)
    DateTime? checkInTime, // NEW: check_in_time (for accurate late/duration)
    DateTime? checkOutTime, // NEW: check_out_time
    double? latitude,
    double? longitude,
    String? geofenceName,
    String? projectId,
    String? notes,
    required AttendanceStatus status,
    VerificationType? verificationType,
    @Default(false) bool isVerified,
    String? leaveType, // NEW: 'casual', 'sick', null if no leave
    String? photoProofPath, // Optional future field
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}

extension AttendanceModelExtension on AttendanceModel {
  bool get isCheckIn => status == AttendanceStatus.checkIn;
  bool get isCheckOut => status == AttendanceStatus.checkOut;

  String get formattedTime => DateFormat('hh:mm a').format(timestamp);
  String get formattedDate => DateFormat('dd MMM yyyy').format(attendanceDate);

  // Late check (office start 09:00 - future config se change kar sakte hain)
  bool get isLate {
    if (!isCheckIn || checkInTime == null) return false;
    final officeStart = DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
      9,
      0,
    );
    return checkInTime!.isAfter(officeStart);
  }

  // Duration (checkOut - checkIn)
  Duration? get duration {
    if (checkInTime == null || checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime!);
  }

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

  // NEW: Computed present status (no leave, checked-in, not late)
  bool get isPresent => isCheckIn && !isLate && leaveType == null;

  bool get hasPhotoProof =>
      photoProofPath != null && photoProofPath!.isNotEmpty;
  // Break duration (if added in future)
  double get breakHours => 0.0; // TODO: Implement when break fields added
}

// Factory from DB row (updated with new fields)
AttendanceModel attendanceFromDB(Map<String, dynamic> row) {
  return AttendanceModel(
    attId: row['att_id'] as String,
    empId: row['emp_id'] as String,
    timestamp: DateTime.parse(row['att_timestamp'] as String),
    attendanceDate: DateTime.parse(
      row['att_date'] as String,
    ), // NEW - add this column in DB
    checkInTime: _parseDate(row['check_in_time'] as String?), // NEW
    checkOutTime: _parseDate(row['check_out_time'] as String?), // NEW
    latitude: row['att_latitude'] as double?,
    longitude: row['att_longitude'] as double?,
    geofenceName: row['att_geofence_name'] as String?,
    projectId: row['project_id'] as String?,
    notes: row['att_notes'] as String?,
    status: _mapStatus(row['att_status'] as String),
    verificationType: _mapVerification(row['verification_type'] as String?),
    isVerified: (row['is_verified'] as int? ?? 0) == 1,
    leaveType: row['leave_type'] as String?, // NEW
    photoProofPath: row['photo_proof_path'] as String?,
    createdAt: _parseDate(row['created_at'] as String?),
    updatedAt: _parseDate(row['updated_at'] as String?),
  );
}

// Helpers (unchanged)
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
