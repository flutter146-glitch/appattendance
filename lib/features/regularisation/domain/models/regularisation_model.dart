// lib/features/regularisation/domain/models/regularisation_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

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
    required DateTime appliedForDate, // reg_applied_for_date
    required DateTime appliedDate, // reg_date_applied
    required RegularisationType
    type, // reg_type - Full Day / Check-in Only etc.
    required String justification, // reg_justification
    required RegularisationStatus status, // reg_approval_status
    String? managerRemarks, // manager comments on approve/reject
    @Default([]) List<String> supportingDocs, // future documents
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RegularisationModel;

  // Helpers
  bool get isPending => status == RegularisationStatus.pending;
  bool get isApproved => status == RegularisationStatus.approved;
  bool get isRejected => status == RegularisationStatus.rejected;

  String get displayStatus {
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

  factory RegularisationModel.fromJson(Map<String, dynamic> json) =>
      _$RegularisationModelFromJson(json);
}
