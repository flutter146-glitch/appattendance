// lib/features/attendance/domain/models/attendance_model.dart
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

enum AttendanceType { checkIn, checkOut, enter, exit }

enum AttendanceStatus {
  present,
  absent,
  partialLeave,
  leave,
  shortHalf,
  holiday,
}

@freezed
class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    required String id,
    String? userId,
    required DateTime timestamp,
    required AttendanceType type,
    @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
    GeofenceModel? geofence,
    required double latitude,
    required double longitude,
    String? projectName,
    String? notes,
    AttendanceStatus? status,
  }) = _AttendanceModel;

  // Helpers
  bool get isLate =>
      type == AttendanceType.checkIn && timestamp.hour > 9 ||
      (timestamp.hour == 9 && timestamp.minute > 15);
  bool get isHalfDay => status == AttendanceStatus.shortHalf;
  Duration? getDuration(AttendanceModel? checkout) =>
      checkout != null ? checkout.timestamp.difference(timestamp) : null;
  String get code => status?.name[0].toUpperCase() ?? 'P';
  String get label => status?.name.capitalize() ?? 'Present';
  Color get color {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.partialLeave:
        return Colors.orange;
      case AttendanceStatus.leave:
        return Colors.blue;
      case AttendanceStatus.shortHalf:
        return Colors.amber;
      case AttendanceStatus.holiday:
        return Colors.purple;
      default:
        return AppColors.grey500;
    }
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}

// YE 2 FUNCTIONS ADD KAR (file ke end mein)
GeofenceModel? _geofenceFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return GeofenceModel.fromJson(json);
}

Map<String, dynamic>? _geofenceToJson(GeofenceModel? model) {
  return model?.toJson();
}

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

@freezed
class AttendanceStats with _$AttendanceStats {
  const factory AttendanceStats({
    required int present,
    required int absent,
    required int late,
    required int leave,
    required int totalDays,
    required int attendancePercentage,
  }) = _AttendanceStats;

  factory AttendanceStats.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatsFromJson(json);
}
