// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveModelImpl _$$LeaveModelImplFromJson(Map<String, dynamic> json) =>
    _$LeaveModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: DateTime.parse(json['toDate'] as String),
      fromTime: _timeOfDayFromString(json['fromTime'] as String),
      toTime: _timeOfDayFromString(json['toTime'] as String),
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      notes: json['notes'] as String,
      isHalfDayFrom: json['isHalfDayFrom'] as bool?,
      isHalfDayTo: json['isHalfDayTo'] as bool?,
      status: $enumDecodeNullable(_$LeaveStatusEnumMap, json['status']),
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      projectName: json['projectName'] as String?,
      managerRemarks: json['managerRemarks'] as String?,
      approvedBy: json['approvedBy'] as String?,
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
      'id': instance.id,
      'userId': instance.userId,
      'fromDate': instance.fromDate.toIso8601String(),
      'toDate': instance.toDate.toIso8601String(),
      'fromTime': _timeOfDayToString(instance.fromTime),
      'toTime': _timeOfDayToString(instance.toTime),
      'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
      'notes': instance.notes,
      'isHalfDayFrom': instance.isHalfDayFrom,
      'isHalfDayTo': instance.isHalfDayTo,
      'status': _$LeaveStatusEnumMap[instance.status],
      'appliedDate': instance.appliedDate.toIso8601String(),
      'projectName': instance.projectName,
      'managerRemarks': instance.managerRemarks,
      'approvedBy': instance.approvedBy,
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

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
  LeaveStatus.query: 'query',
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
