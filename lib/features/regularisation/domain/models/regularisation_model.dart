// lib/features/regularisation/domain/models/regularisation_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'regularisation_model.freezed.dart';
part 'regularisation_model.g.dart';

enum RegularisationType { checkIn, checkOut, fullDay, halfDay }

enum RegularisationStatus { pending, approved, rejected, cancelled }

@freezed
class RegularisationModel with _$RegularisationModel {
  const RegularisationModel._();

  const factory RegularisationModel({
    required String id,
    required String userId,
    required DateTime date,
    required RegularisationType type,
    required RegularisationStatus status,
    required String reason,
    String? managerRemarks,
    @Default([]) List<String> supportingDocs,
    DateTime? requestedDate,
    DateTime? approvedDate,
  }) = _RegularisationModel;

  // Helpers
  bool get isPending => status == RegularisationStatus.pending;

  factory RegularisationModel.fromJson(Map<String, dynamic> json) =>
      _$RegularisationModelFromJson(json);
}
