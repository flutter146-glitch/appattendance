// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regularisation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegularisationModelImpl _$$RegularisationModelImplFromJson(
  Map<String, dynamic> json,
) => _$RegularisationModelImpl(
  regId: json['regId'] as String,
  empId: json['empId'] as String,
  appliedForDate: DateTime.parse(json['appliedForDate'] as String),
  appliedDate: DateTime.parse(json['appliedDate'] as String),
  type: $enumDecode(_$RegularisationTypeEnumMap, json['type']),
  justification: json['justification'] as String,
  status: $enumDecode(_$RegularisationStatusEnumMap, json['status']),
  managerRemarks: json['managerRemarks'] as String?,
  supportingDocs:
      (json['supportingDocs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$RegularisationModelImplToJson(
  _$RegularisationModelImpl instance,
) => <String, dynamic>{
  'regId': instance.regId,
  'empId': instance.empId,
  'appliedForDate': instance.appliedForDate.toIso8601String(),
  'appliedDate': instance.appliedDate.toIso8601String(),
  'type': _$RegularisationTypeEnumMap[instance.type]!,
  'justification': instance.justification,
  'status': _$RegularisationStatusEnumMap[instance.status]!,
  'managerRemarks': instance.managerRemarks,
  'supportingDocs': instance.supportingDocs,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$RegularisationTypeEnumMap = {
  RegularisationType.fullDay: 'fullDay',
  RegularisationType.checkInOnly: 'checkInOnly',
  RegularisationType.checkOutOnly: 'checkOutOnly',
  RegularisationType.halfDay: 'halfDay',
};

const _$RegularisationStatusEnumMap = {
  RegularisationStatus.pending: 'pending',
  RegularisationStatus.approved: 'approved',
  RegularisationStatus.rejected: 'rejected',
  RegularisationStatus.cancelled: 'cancelled',
};
