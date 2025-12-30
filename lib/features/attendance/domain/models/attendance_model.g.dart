// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceModelImpl _$$AttendanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceModelImpl(
  attId: json['attId'] as String,
  empId: json['empId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  geofenceName: json['geofenceName'] as String?,
  projectId: json['projectId'] as String?,
  notes: json['notes'] as String?,
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  verificationType: $enumDecodeNullable(
    _$VerificationTypeEnumMap,
    json['verificationType'],
  ),
  isVerified: json['isVerified'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AttendanceModelImplToJson(
  _$AttendanceModelImpl instance,
) => <String, dynamic>{
  'attId': instance.attId,
  'empId': instance.empId,
  'timestamp': instance.timestamp.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'geofenceName': instance.geofenceName,
  'projectId': instance.projectId,
  'notes': instance.notes,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'verificationType': _$VerificationTypeEnumMap[instance.verificationType],
  'isVerified': instance.isVerified,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.checkIn: 'checkIn',
  AttendanceStatus.checkOut: 'checkOut',
};

const _$VerificationTypeEnumMap = {
  VerificationType.faceAuth: 'faceauth',
  VerificationType.fingerprint: 'fingerprint',
  VerificationType.manual: 'manual',
  VerificationType.gps: 'gps',
};
