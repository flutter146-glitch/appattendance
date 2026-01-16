// lib/features/regularisation/domain/models/regularisation_model.dart

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'regularisation_model.freezed.dart';
part 'regularisation_model.g.dart';

enum RegularisationType { fullDay, checkInOnly, checkOutOnly, halfDay }

enum RegularisationStatus { pending, approved, rejected, cancelled }

@freezed
class RegularisationModel with _$RegularisationModel {
  const RegularisationModel._();

  const factory RegularisationModel({
    required String regId, // reg_id
    required String empId, // emp_id
    required DateTime appliedForDate, // reg_applied_for_date (main date)
    required DateTime appliedDate, // reg_date_applied (application date)
    required RegularisationType type,
    required String justification,
    required RegularisationStatus status,
    String? managerRemarks,
    @Default([]) List<String> supportingDocs,
    // NEW: Time range for half-day/full-day regularisation
    String? fromTime, // e.g., "09:00" (HH:mm string)
    String? toTime, // e.g., "18:00" (HH:mm string)
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RegularisationModel;

  factory RegularisationModel.fromJson(Map<String, dynamic> json) =>
      _$RegularisationModelFromJson(json);

  // Computed Getters (UI-safe)
  int get totalDays =>
      appliedForDate.difference(appliedForDate).inDays + 1; // For multi-day

  bool get isPending => status == RegularisationStatus.pending;
  bool get isApproved => status == RegularisationStatus.approved;
  bool get isRejected => status == RegularisationStatus.rejected;
  bool get isCancelled => status == RegularisationStatus.cancelled;

  // NEW: Half-day check
  bool get isHalfDay =>
      type == RegularisationType.halfDay ||
      (fromTime != null && toTime != null);

  // NEW: Overdue (pending aur appliedForDate past)
  bool get isOverdue => isPending && appliedForDate.isBefore(DateTime.now());

  String get statusDisplay {
    switch (status) {
      case RegularisationStatus.pending:
        return 'Pending';
      case RegularisationStatus.approved:
        return 'Approved';
      case RegularisationStatus.rejected:
        return 'Rejected';
      case RegularisationStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayType {
    switch (type) {
      case RegularisationType.fullDay:
        return 'Full Day';
      case RegularisationType.checkInOnly:
        return 'Check-in Only';
      case RegularisationType.checkOutOnly:
        return 'Check-out Only';
      case RegularisationType.halfDay:
        return 'Half Day';
    }
  }

  // NEW: Status color for UI
  Color get statusColor {
    switch (status) {
      case RegularisationStatus.pending:
        return Colors.orange;
      case RegularisationStatus.approved:
        return Colors.green;
      case RegularisationStatus.rejected:
        return Colors.red;
      case RegularisationStatus.cancelled:
        return Colors.grey;
    }
  }

  // Duration display
  String get durationDisplay =>
      isHalfDay ? 'Half Day' : '${totalDays} day${totalDays > 1 ? 's' : ''}';

  String get timeRange {
    if (fromTime == null || toTime == null) return 'Full Day';
    return '$fromTime - $toTime';
  }

  String get formattedAppliedForDate =>
      DateFormat('dd MMM yyyy').format(appliedForDate);
  String get formattedAppliedDate =>
      DateFormat('dd MMM yyyy').format(appliedDate);
}

// // lib/features/regularisation/domain/models/regularisation_model.dart

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'regularisation_model.freezed.dart';
// part 'regularisation_model.g.dart';

// enum RegularisationType { fullDay, checkInOnly, checkOutOnly, halfDay }

// enum RegularisationStatus { pending, approved, rejected, cancelled }

// @freezed
// class RegularisationModel with _$RegularisationModel {
//   const RegularisationModel._();

//   const factory RegularisationModel({
//     required String regId, // reg_id
//     required String empId, // emp_id
//     required DateTime appliedForDate, // reg_applied_for_date
//     required DateTime appliedDate, // reg_date_applied
//     required RegularisationType
//     type, // reg_type - Full Day / Check-in Only etc.
//     required String justification, // reg_justification
//     required RegularisationStatus status, // reg_approval_status
//     String? managerRemarks, // manager comments on approve/reject
//     @Default([]) List<String> supportingDocs, // future documents
//     required DateTime createdAt,
//     required DateTime updatedAt,
//   }) = _RegularisationModel;

//   // Helpers
//   bool get isPending => status == RegularisationStatus.pending;
//   bool get isApproved => status == RegularisationStatus.approved;
//   bool get isRejected => status == RegularisationStatus.rejected;

//   String get displayStatus {
//     switch (status) {
//       case RegularisationStatus.pending:
//         return 'Pending';
//       case RegularisationStatus.approved:
//         return 'Approved';
//       case RegularisationStatus.rejected:
//         return 'Rejected';
//       case RegularisationStatus.cancelled:
//         return 'Cancelled';
//     }
//   }

//   String get displayType {
//     switch (type) {
//       case RegularisationType.fullDay:
//         return 'Full Day';
//       case RegularisationType.checkInOnly:
//         return 'Check-in Only';
//       case RegularisationType.checkOutOnly:
//         return 'Check-out Only';
//       case RegularisationType.halfDay:
//         return 'Half Day';
//     }
//   }

//   factory RegularisationModel.fromJson(Map<String, dynamic> json) =>
//       _$RegularisationModelFromJson(json);
// }
