// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveModelImpl _$$LeaveModelImplFromJson(Map<String, dynamic> json) =>
    _$LeaveModelImpl(
      leaveId: json['leaveId'] as String,
      empId: json['empId'] as String,
      mgrEmpId: json['mgrEmpId'] as String?,
      leaveFromDate: DateTime.parse(json['leaveFromDate'] as String),
      leaveToDate: DateTime.parse(json['leaveToDate'] as String),
      fromTime: _timeOfDayFromString(json['fromTime'] as String),
      toTime: _timeOfDayFromString(json['toTime'] as String),
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      justification: json['justification'] as String,
      approvalStatus: json['approvalStatus'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      managerComments: json['managerComments'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isHalfDayFrom: json['isHalfDayFrom'] as bool?,
      isHalfDayTo: json['isHalfDayTo'] as bool?,
      projectName: json['projectName'] as String?,
      supportingDocs:
          (json['supportingDocs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contactNumber: json['contactNumber'] as String?,
      handoverPersonName: json['handoverPersonName'] as String?,
      handoverPersonEmail: json['handoverPersonEmail'] as String?,
      handoverPersonPhone: json['handoverPersonPhone'] as String?,
      handoverPersonPhoto: json['handoverPersonPhoto'] as String?,
      totalDays: (json['totalDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LeaveModelImplToJson(_$LeaveModelImpl instance) =>
    <String, dynamic>{
      'leaveId': instance.leaveId,
      'empId': instance.empId,
      'mgrEmpId': instance.mgrEmpId,
      'leaveFromDate': instance.leaveFromDate.toIso8601String(),
      'leaveToDate': instance.leaveToDate.toIso8601String(),
      'fromTime': _timeOfDayToString(instance.fromTime),
      'toTime': _timeOfDayToString(instance.toTime),
      'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
      'justification': instance.justification,
      'approvalStatus': instance.approvalStatus,
      'appliedDate': instance.appliedDate.toIso8601String(),
      'managerComments': instance.managerComments,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isHalfDayFrom': instance.isHalfDayFrom,
      'isHalfDayTo': instance.isHalfDayTo,
      'projectName': instance.projectName,
      'supportingDocs': instance.supportingDocs,
      'contactNumber': instance.contactNumber,
      'handoverPersonName': instance.handoverPersonName,
      'handoverPersonEmail': instance.handoverPersonEmail,
      'handoverPersonPhone': instance.handoverPersonPhone,
      'handoverPersonPhoto': instance.handoverPersonPhoto,
      'totalDays': instance.totalDays,
    };

const _$LeaveTypeEnumMap = {
  LeaveType.casual: 'casual',
  LeaveType.sick: 'sick',
  LeaveType.earned: 'earned',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.compensatory: 'compensatory',
  LeaveType.unpaid: 'unpaid',
  LeaveType.emergency: 'emergency',
};

_$LeaveBalanceImpl _$$LeaveBalanceImplFromJson(Map<String, dynamic> json) =>
    _$LeaveBalanceImpl(
      employeeId: json['employeeId'] as String,
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      totalDays: (json['totalDays'] as num).toInt(),
      usedDays: (json['usedDays'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaveBalanceImplToJson(_$LeaveBalanceImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
      'totalDays': instance.totalDays,
      'usedDays': instance.usedDays,
      'year': instance.year,
    };
