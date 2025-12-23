// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceModelImpl _$$AttendanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
  type: $enumDecode(_$AttendanceTypeEnumMap, json['type']),
  geofence: _geofenceFromJson(json['geofence'] as Map<String, dynamic>?),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  projectName: json['projectName'] as String?,
  notes: json['notes'] as String?,
  status: $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']),
);

Map<String, dynamic> _$$AttendanceModelImplToJson(
  _$AttendanceModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'timestamp': instance.timestamp.toIso8601String(),
  'type': _$AttendanceTypeEnumMap[instance.type]!,
  'geofence': _geofenceToJson(instance.geofence),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'projectName': instance.projectName,
  'notes': instance.notes,
  'status': _$AttendanceStatusEnumMap[instance.status],
};

const _$AttendanceTypeEnumMap = {
  AttendanceType.checkIn: 'checkIn',
  AttendanceType.checkOut: 'checkOut',
  AttendanceType.enter: 'enter',
  AttendanceType.exit: 'exit',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.partialLeave: 'partialLeave',
  AttendanceStatus.leave: 'leave',
  AttendanceStatus.shortHalf: 'shortHalf',
  AttendanceStatus.holiday: 'holiday',
};

_$AttendanceStatsImpl _$$AttendanceStatsImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceStatsImpl(
  present: (json['present'] as num).toInt(),
  absent: (json['absent'] as num).toInt(),
  late: (json['late'] as num).toInt(),
  leave: (json['leave'] as num).toInt(),
  totalDays: (json['totalDays'] as num).toInt(),
  attendancePercentage: (json['attendancePercentage'] as num).toInt(),
);

Map<String, dynamic> _$$AttendanceStatsImplToJson(
  _$AttendanceStatsImpl instance,
) => <String, dynamic>{
  'present': instance.present,
  'absent': instance.absent,
  'late': instance.late,
  'leave': instance.leave,
  'totalDays': instance.totalDays,
  'attendancePercentage': instance.attendancePercentage,
};
