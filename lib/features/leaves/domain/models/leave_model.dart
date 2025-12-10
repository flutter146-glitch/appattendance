// lib/features/leaves/domain/models/leave_model.dart
import 'package:flutter/material.dart'; // YE IMPORT ADD KARNA HAI
import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_model.freezed.dart';
part 'leave_model.g.dart';

enum LeaveType {
  casual,
  sick,
  earned,
  maternity,
  paternity,
  compensatory,
  unpaid,
  emergency,
}

enum LeaveStatus { pending, approved, rejected, cancelled, query }

@freezed
class LeaveModel with _$LeaveModel {
  const LeaveModel._();

  const factory LeaveModel({
    required String id,
    required String userId,
    required DateTime fromDate,
    required DateTime toDate,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required TimeOfDay fromTime,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required TimeOfDay toTime,
    required LeaveType leaveType,
    required String notes,
    bool? isHalfDayFrom,
    bool? isHalfDayTo,
    LeaveStatus? status,
    required DateTime appliedDate,
    String? projectName,
    String? managerRemarks,
    String? approvedBy,
    @Default([]) List<String> supportingDocs,
    String? contactNumber,
    String? handoverPersonName,
    String? handoverPersonEmail,
    String? handoverPersonPhone,
    String? handoverPersonPhoto,
    int? totalDays,
  }) = _LeaveModel;

  // Helpers
  bool get isPending => status == LeaveStatus.pending;
  String get duration => '$totalDays days';

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);
}

// YE DO FUNCTIONS BAHAR ADD KAR (file ke end mein)
TimeOfDay _timeOfDayFromString(String time) {
  final parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String _timeOfDayToString(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

@freezed
class LeaveBalance with _$LeaveBalance {
  const factory LeaveBalance({
    required String employeeId,
    required LeaveType leaveType,
    required int totalDays,
    required int usedDays,
    required int year,
  }) = _LeaveBalance;

  factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceFromJson(json);
}
