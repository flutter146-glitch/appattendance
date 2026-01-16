// lib/features/leaves/domain/models/leave_model.dart
// Final production-ready version (30 Dec 2025)
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

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
  @JsonValue('query')
  query, // Added from privileges table (R01-R08)
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
    String? fromTime, // e.g., "09:00" (HH:mm string)
    String? toTime, // e.g., "18:00" (HH:mm string)
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);

  // Computed Getters (UI-safe, no BuildContext)
  int get totalDays => leaveToDate.difference(leaveFromDate).inDays + 1;

  bool get isPending => leaveApprovalStatus == LeaveStatus.pending;
  bool get isApproved => leaveApprovalStatus == LeaveStatus.approved;
  bool get isRejected => leaveApprovalStatus == LeaveStatus.rejected;
  bool get isCancelled => leaveApprovalStatus == LeaveStatus.cancelled;
  bool get isQuery => leaveApprovalStatus == LeaveStatus.query;

  bool get isManagerActionRequired => isPending || isQuery;

  String get statusDisplay =>
      leaveApprovalStatus.name[0].toUpperCase() +
      leaveApprovalStatus.name.substring(1);

  String get formattedFrom => DateFormat('dd MMM yyyy').format(leaveFromDate);
  String get formattedTo => DateFormat('dd MMM yyyy').format(leaveToDate);

  String get duration => '${totalDays} day${totalDays > 1 ? 's' : ''}';

  String get justificationDisplay =>
      leaveJustification ?? 'No justification provided';

  // Time range (string-based, no context needed)
  String get timeRange {
    if (fromTime == null || toTime == null) return 'Full Day';
    return '$fromTime - $toTime';
  }
}
