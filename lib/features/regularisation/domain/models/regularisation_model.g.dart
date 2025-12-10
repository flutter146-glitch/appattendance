// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regularisation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegularisationModelImpl _$$RegularisationModelImplFromJson(
  Map<String, dynamic> json,
) => _$RegularisationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$RegularisationTypeEnumMap, json['type']),
  status: $enumDecode(_$RegularisationStatusEnumMap, json['status']),
  reason: json['reason'] as String,
  managerRemarks: json['managerRemarks'] as String?,
  supportingDocs:
      (json['supportingDocs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  requestedDate: json['requestedDate'] == null
      ? null
      : DateTime.parse(json['requestedDate'] as String),
  approvedDate: json['approvedDate'] == null
      ? null
      : DateTime.parse(json['approvedDate'] as String),
);

Map<String, dynamic> _$$RegularisationModelImplToJson(
  _$RegularisationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'type': _$RegularisationTypeEnumMap[instance.type]!,
  'status': _$RegularisationStatusEnumMap[instance.status]!,
  'reason': instance.reason,
  'managerRemarks': instance.managerRemarks,
  'supportingDocs': instance.supportingDocs,
  'requestedDate': instance.requestedDate?.toIso8601String(),
  'approvedDate': instance.approvedDate?.toIso8601String(),
};

const _$RegularisationTypeEnumMap = {
  RegularisationType.checkIn: 'checkIn',
  RegularisationType.checkOut: 'checkOut',
  RegularisationType.fullDay: 'fullDay',
  RegularisationType.halfDay: 'halfDay',
};

const _$RegularisationStatusEnumMap = {
  RegularisationStatus.pending: 'pending',
  RegularisationStatus.approved: 'approved',
  RegularisationStatus.rejected: 'rejected',
  RegularisationStatus.cancelled: 'cancelled',
};
