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
  attendanceDate: DateTime.parse(json['attendanceDate'] as String),
  timestamp: DateTime.parse(json['timestamp'] as String),
  checkInTime: json['checkInTime'] == null
      ? null
      : DateTime.parse(json['checkInTime'] as String),
  checkOutTime: json['checkOutTime'] == null
      ? null
      : DateTime.parse(json['checkOutTime'] as String),
  workedHours: (json['workedHours'] as num?)?.toDouble(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  geofenceName: json['geofenceName'] as String?,
  verificationType: $enumDecodeNullable(
    _$VerificationTypeEnumMap,
    json['verificationType'],
  ),
  isVerified: json['isVerified'] as bool? ?? false,
  projectId: json['projectId'] as String?,
  notes: json['notes'] as String?,
  leaveType: json['leaveType'] as String?,
  status:
      $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']) ??
      AttendanceStatus.checkIn,
  dailyStatus:
      $enumDecodeNullable(
        _$DailyAttendanceStatusEnumMap,
        json['dailyStatus'],
      ) ??
      DailyAttendanceStatus.present,
  photoProofPath: json['photoProofPath'] as String?,
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
  'attendanceDate': instance.attendanceDate.toIso8601String(),
  'timestamp': instance.timestamp.toIso8601String(),
  'checkInTime': instance.checkInTime?.toIso8601String(),
  'checkOutTime': instance.checkOutTime?.toIso8601String(),
  'workedHours': instance.workedHours,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'geofenceName': instance.geofenceName,
  'verificationType': _$VerificationTypeEnumMap[instance.verificationType],
  'isVerified': instance.isVerified,
  'projectId': instance.projectId,
  'notes': instance.notes,
  'leaveType': instance.leaveType,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'dailyStatus': _$DailyAttendanceStatusEnumMap[instance.dailyStatus]!,
  'photoProofPath': instance.photoProofPath,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$VerificationTypeEnumMap = {
  VerificationType.faceAuth: 'faceauth',
  VerificationType.fingerprint: 'fingerprint',
  VerificationType.manual: 'manual',
  VerificationType.gps: 'gps',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.checkIn: 'checkIn',
  AttendanceStatus.checkOut: 'checkOut',
};

const _$DailyAttendanceStatusEnumMap = {
  DailyAttendanceStatus.present: 'present',
  DailyAttendanceStatus.absent: 'absent',
  DailyAttendanceStatus.partialLeave: 'partialLeave',
  DailyAttendanceStatus.leave: 'leave',
  DailyAttendanceStatus.shortHalf: 'shortHalf',
  DailyAttendanceStatus.holiday: 'holiday',
  DailyAttendanceStatus.weekend: 'weekend',
};
