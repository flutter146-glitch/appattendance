// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveModelImpl _$$LeaveModelImplFromJson(Map<String, dynamic> json) =>
    _$LeaveModelImpl(
      leaveId: json['leaveId'] as String,
      empId: json['empId'] as String,
      mgrEmpId: json['mgrEmpId'] as String,
      leaveFromDate: DateTime.parse(json['leaveFromDate'] as String),
      leaveToDate: DateTime.parse(json['leaveToDate'] as String),
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      leaveJustification: json['leaveJustification'] as String?,
      leaveApprovalStatus: $enumDecode(
        _$LeaveStatusEnumMap,
        json['leaveApprovalStatus'],
      ),
      managerComments: json['managerComments'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LeaveModelImplToJson(
  _$LeaveModelImpl instance,
) => <String, dynamic>{
  'leaveId': instance.leaveId,
  'empId': instance.empId,
  'mgrEmpId': instance.mgrEmpId,
  'leaveFromDate': instance.leaveFromDate.toIso8601String(),
  'leaveToDate': instance.leaveToDate.toIso8601String(),
  'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
  'leaveJustification': instance.leaveJustification,
  'leaveApprovalStatus': _$LeaveStatusEnumMap[instance.leaveApprovalStatus]!,
  'managerComments': instance.managerComments,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$LeaveTypeEnumMap = {
  LeaveType.casual: 'casual',
  LeaveType.sick: 'sick',
  LeaveType.earned: 'earned',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.unpaid: 'unpaid',
  LeaveType.other: 'other',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
};
