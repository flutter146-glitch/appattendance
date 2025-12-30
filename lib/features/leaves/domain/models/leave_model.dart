// lib/features/leave/domain/models/leave_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_model.freezed.dart';
part 'leave_model.g.dart';

enum LeaveType {
  @JsonValue('casual')
  casual,
  @JsonValue('sick')
  sick,
  @JsonValue('earned')
  earned,
  @JsonValue('maternity')
  maternity,
  @JsonValue('paternity')
  paternity,
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('other')
  other,
}

enum LeaveStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class LeaveModel with _$LeaveModel {
  const LeaveModel._();

  const factory LeaveModel({
    required String leaveId,
    required String empId,
    required String mgrEmpId,
    required DateTime leaveFromDate,
    required DateTime leaveToDate,
    required LeaveType leaveType,
    String? leaveJustification,
    required LeaveStatus leaveApprovalStatus,
    String? managerComments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);

  // Computed
  int get totalDays => leaveToDate.difference(leaveFromDate).inDays + 1;

  bool get isPending => leaveApprovalStatus == LeaveStatus.pending;
  bool get isApproved => leaveApprovalStatus == LeaveStatus.approved;
  bool get isRejected => leaveApprovalStatus == LeaveStatus.rejected;
  bool get isCancelled => leaveApprovalStatus == LeaveStatus.cancelled;
}

// // lib/features/leave/domain/models/leave_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'leave_model.freezed.dart';
// part 'leave_model.g.dart';

// enum LeaveType { casual, sick, earned, maternity, paternity, unpaid, other }

// enum LeaveStatus { pending, approved, rejected, cancelled }

// @freezed
// class LeaveModel with _$LeaveModel {
//   const LeaveModel._();

//   const factory LeaveModel({
//     required String leaveId,
//     required String empId,
//     required String mgrEmpId,
//     required DateTime leaveFromDate,
//     required DateTime leaveToDate,
//     required LeaveType leaveType,
//     String? leaveJustification,
//     required LeaveStatus leaveApprovalStatus,
//     String? managerComments,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _LeaveModel;

//   factory LeaveModel.fromJson(Map<String, dynamic> json) =>
//       _$LeaveModelFromJson(json);

//   // Computed
//   int get totalDays => leaveToDate.difference(leaveFromDate).inDays + 1;

//   bool get isPending => leaveApprovalStatus == LeaveStatus.pending;
//   bool get isApproved => leaveApprovalStatus == LeaveStatus.approved;
// }

// // lib/features/leaves/domain/models/leave_model.dart
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'leave_model.freezed.dart';
// part 'leave_model.g.dart';

// enum LeaveType {
//   casual,
//   sick,
//   earned,
//   maternity,
//   paternity,
//   compensatory,
//   unpaid,
//   emergency,
// }

// enum LeaveStatus { pending, approved, rejected, cancelled, query }

// @freezed
// class LeaveModel with _$LeaveModel {
//   const LeaveModel._();

//   const factory LeaveModel({
//     required String leaveId, // PK
//     required String empId, // FK → employee_master
//     String? mgrEmpId, // Manager who approves
//     required DateTime leaveFromDate,
//     required DateTime leaveToDate,
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay fromTime,
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay toTime,
//     required LeaveType leaveType,
//     required String justification,
//     required String approvalStatus, // Pending/Approved/Rejected
//     required DateTime appliedDate,
//     String? managerComments,
//     DateTime? updatedAt,
//     bool? isHalfDayFrom,
//     bool? isHalfDayTo,
//     String? projectName,
//     @Default([]) List<String> supportingDocs,
//     String? contactNumber,
//     String? handoverPersonName,
//     String? handoverPersonEmail,
//     String? handoverPersonPhone,
//     String? handoverPersonPhoto,
//     int? totalDays,
//   }) = _LeaveModel;

//   // Helpers
//   bool get isPending => approvalStatus.toLowerCase() == 'pending';
//   bool get isApproved => approvalStatus.toLowerCase() == 'approved';
//   bool get isRejected => approvalStatus.toLowerCase() == 'rejected';
//   String get statusDisplay =>
//       approvalStatus[0].toUpperCase() +
//       approvalStatus.substring(1).toLowerCase();

//   factory LeaveModel.fromJson(Map<String, dynamic> json) =>
//       _$LeaveModelFromJson(json);
// }

// TimeOfDay _timeOfDayFromString(String time) {
//   final parts = time.split(':');
//   return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
// }

// String _timeOfDayToString(TimeOfDay time) {
//   return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
// }

// @freezed
// class LeaveBalance with _$LeaveBalance {
//   const factory LeaveBalance({
//     required String employeeId,
//     required LeaveType leaveType,
//     required int totalDays,
//     required int usedDays,
//     required int year,
//   }) = _LeaveBalance;

//   factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
//       _$LeaveBalanceFromJson(json);
// }

// // lib/features/leaves/domain/models/leave_model.dart
// import 'package:init/init.dart';
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'leave_model.freezed.dart';
// part 'leave_model.g.dart';

// enum LeaveType {
//   casual,
//   sick,
//   earned,
//   maternity,
//   paternity,
//   compensatory,
//   unpaid,
//   emergency,
// }

// enum LeaveStatus { pending, approved, rejected, cancelled, query }

// @freezed
// class LeaveModel with _$LeaveModel {
//   const LeaveModel._();

//   const factory LeaveModel({
//     required String leaveId, // DB: leave_id (primary key)
//     required String empId, // DB: emp_id
//     required String? mgrEmpId, // DB: mgr_emp_id (manager who approves)
//     required DateTime leaveFromDate, // DB: leave_from_date
//     required DateTime leaveToDate, // DB: leave_to_date
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay fromTime,
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay toTime,
//     required LeaveType leaveType, // DB: leave_type
//     required String justification, // DB: leave_justification (reason)
//     required String
//     approvalStatus, // DB: leave_approval_status (Pending/Approved/Rejected)
//     required DateTime appliedDate, // DB: created_at (when applied)
//     String? managerComments, // DB: manager_comments
//     DateTime? updatedAt, // DB: updated_at (last modified)
//     bool? isHalfDayFrom,
//     bool? isHalfDayTo,
//     String? projectName,
//     @Default([]) List<String> supportingDocs,
//     String? contactNumber,
//     String? handoverPersonName,
//     String? handoverPersonEmail,
//     String? handoverPersonPhone,
//     String? handoverPersonPhoto,
//     int? totalDays,
//   }) = _LeaveModel;

//   // Computed properties
//   bool get isPending => approvalStatus.toLowerCase() == 'pending';
//   bool get isApproved => approvalStatus.toLowerCase() == 'approved';
//   bool get isRejected => approvalStatus.toLowerCase() == 'rejected';
//   String get duration => totalDays != null ? '$totalDays days' : 'N/A';
//   String get formattedFromDate =>
//       DateFormat('dd/MM/yyyy').format(leaveFromDate);
//   String get formattedToDate => DateFormat('dd/MM/yyyy').format(leaveToDate);

//   factory LeaveModel.fromJson(Map<String, dynamic> json) =>
//       _$LeaveModelFromJson(json);
// }

// // TimeOfDay JSON converters (required for freezed)
// TimeOfDay _timeOfDayFromString(String time) {
//   final parts = time.split(':');
//   return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
// }

// String _timeOfDayToString(TimeOfDay time) {
//   return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
// }

// // Leave Balance Model (unchanged, but added for completeness)
// @freezed
// class LeaveBalance with _$LeaveBalance {
//   const factory LeaveBalance({
//     required String employeeId,
//     required LeaveType leaveType,
//     required int totalDays,
//     required int usedDays,
//     required int year,
//   }) = _LeaveBalance;

//   factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
//       _$LeaveBalanceFromJson(json);
// }

// // lib/features/leaves/domain/models/leave_model.dart
// import 'package:flutter/material.dart'; // YE IMPORT ADD KARNA HAI
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'leave_model.freezed.dart';
// part 'leave_model.g.dart';

// enum LeaveType {
//   casual,
//   sick,
//   earned,
//   maternity,
//   paternity,
//   compensatory,
//   unpaid,
//   emergency,
// }

// enum LeaveStatus { pending, approved, rejected, cancelled, query }

// @freezed
// class LeaveModel with _$LeaveModel {
//   const LeaveModel._();

//   const factory LeaveModel({
//     required String id,
//     required String userId,
//     required DateTime fromDate,
//     required DateTime toDate,
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay fromTime,
//     @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
//     required TimeOfDay toTime,
//     required LeaveType leaveType,
//     required String notes,
//     bool? isHalfDayFrom,
//     bool? isHalfDayTo,
//     LeaveStatus? status,
//     required DateTime appliedDate,
//     String? projectName,
//     String? managerRemarks,
//     String? approvedBy,
//     @Default([]) List<String> supportingDocs,
//     String? contactNumber,
//     String? handoverPersonName,
//     String? handoverPersonEmail,
//     String? handoverPersonPhone,
//     String? handoverPersonPhoto,
//     int? totalDays,
//   }) = _LeaveModel;

//   // Helpers
//   bool get isPending => status == LeaveStatus.pending;
//   String get duration => '$totalDays days';

//   factory LeaveModel.fromJson(Map<String, dynamic> json) =>
//       _$LeaveModelFromJson(json);
// }

// // YE DO FUNCTIONS BAHAR ADD KAR (file ke end mein)
// TimeOfDay _timeOfDayFromString(String time) {
//   final parts = time.split(':');
//   return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
// }

// String _timeOfDayToString(TimeOfDay time) {
//   return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
// }

// @freezed
// class LeaveBalance with _$LeaveBalance {
//   const factory LeaveBalance({
//     required String employeeId,
//     required LeaveType leaveType,
//     required int totalDays,
//     required int usedDays,
//     required int year,
//   }) = _LeaveBalance;

//   factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
//       _$LeaveBalanceFromJson(json);
// }
