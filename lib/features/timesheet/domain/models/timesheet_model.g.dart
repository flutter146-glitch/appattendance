// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimesheetEntryImpl _$$TimesheetEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimesheetEntryImpl(
      entryId: json['entryId'] as String,
      empId: json['empId'] as String,
      projectId: json['projectId'] as String,
      taskDescription: json['taskDescription'] as String,
      taskType: $enumDecode(_$TaskTypeEnumMap, json['taskType']),
      workDate: DateTime.parse(json['workDate'] as String),
      hours: (json['hours'] as num).toDouble(),
      comments: json['comments'] as String?,
      status: $enumDecode(_$TimesheetStatusEnumMap, json['status']),
      managerComments: json['managerComments'] as String?,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      projectName: json['projectName'] as String?,
      empName: json['empName'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
    );

Map<String, dynamic> _$$TimesheetEntryImplToJson(
  _$TimesheetEntryImpl instance,
) => <String, dynamic>{
  'entryId': instance.entryId,
  'empId': instance.empId,
  'projectId': instance.projectId,
  'taskDescription': instance.taskDescription,
  'taskType': _$TaskTypeEnumMap[instance.taskType]!,
  'workDate': instance.workDate.toIso8601String(),
  'hours': instance.hours,
  'comments': instance.comments,
  'status': _$TimesheetStatusEnumMap[instance.status]!,
  'managerComments': instance.managerComments,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'approvedAt': instance.approvedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'projectName': instance.projectName,
  'empName': instance.empName,
  'managerId': instance.managerId,
  'managerName': instance.managerName,
};

const _$TaskTypeEnumMap = {
  TaskType.development: 'Development',
  TaskType.testing: 'Testing',
  TaskType.design: 'Design',
  TaskType.documentation: 'Documentation',
  TaskType.meeting: 'Meeting',
  TaskType.support: 'Support',
  TaskType.training: 'Training',
  TaskType.other: 'Other',
};

const _$TimesheetStatusEnumMap = {
  TimesheetStatus.draft: 'draft',
  TimesheetStatus.submitted: 'submitted',
  TimesheetStatus.approved: 'approved',
  TimesheetStatus.rejected: 'rejected',
};

_$TimesheetImpl _$$TimesheetImplFromJson(Map<String, dynamic> json) =>
    _$TimesheetImpl(
      timesheetId: json['timesheetId'] as String,
      empId: json['empId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => TimesheetEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalHours: (json['totalHours'] as num).toDouble(),
      status: $enumDecode(_$TimesheetStatusEnumMap, json['status']),
      comments: json['comments'] as String?,
      managerComments: json['managerComments'] as String?,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      empName: json['empName'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
    );

Map<String, dynamic> _$$TimesheetImplToJson(_$TimesheetImpl instance) =>
    <String, dynamic>{
      'timesheetId': instance.timesheetId,
      'empId': instance.empId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'entries': instance.entries,
      'totalHours': instance.totalHours,
      'status': _$TimesheetStatusEnumMap[instance.status]!,
      'comments': instance.comments,
      'managerComments': instance.managerComments,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'empName': instance.empName,
      'managerId': instance.managerId,
      'managerName': instance.managerName,
    };

_$TimesheetRequestImpl _$$TimesheetRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TimesheetRequestImpl(
  empId: json['empId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  entries: (json['entries'] as List<dynamic>)
      .map((e) => TimesheetEntryRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  comments: json['comments'] as String?,
  managerId: json['managerId'] as String?,
);

Map<String, dynamic> _$$TimesheetRequestImplToJson(
  _$TimesheetRequestImpl instance,
) => <String, dynamic>{
  'empId': instance.empId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'entries': instance.entries,
  'comments': instance.comments,
  'managerId': instance.managerId,
};

_$TimesheetEntryRequestImpl _$$TimesheetEntryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TimesheetEntryRequestImpl(
  projectId: json['projectId'] as String,
  taskDescription: json['taskDescription'] as String,
  taskType: $enumDecode(_$TaskTypeEnumMap, json['taskType']),
  workDate: DateTime.parse(json['workDate'] as String),
  hours: (json['hours'] as num).toDouble(),
  comments: json['comments'] as String?,
  managerId: json['managerId'] as String?,
);

Map<String, dynamic> _$$TimesheetEntryRequestImplToJson(
  _$TimesheetEntryRequestImpl instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'taskDescription': instance.taskDescription,
  'taskType': _$TaskTypeEnumMap[instance.taskType]!,
  'workDate': instance.workDate.toIso8601String(),
  'hours': instance.hours,
  'comments': instance.comments,
  'managerId': instance.managerId,
};

_$TimesheetStatsImpl _$$TimesheetStatsImplFromJson(
  Map<String, dynamic> json,
) => _$TimesheetStatsImpl(
  draftCount: (json['draftCount'] as num?)?.toInt() ?? 0,
  submittedCount: (json['submittedCount'] as num?)?.toInt() ?? 0,
  approvedCount: (json['approvedCount'] as num?)?.toInt() ?? 0,
  rejectedCount: (json['rejectedCount'] as num?)?.toInt() ?? 0,
  totalHoursThisWeek: (json['totalHoursThisWeek'] as num?)?.toDouble() ?? 0.0,
  totalHoursThisMonth: (json['totalHoursThisMonth'] as num?)?.toDouble() ?? 0.0,
  averageDailyHours: (json['averageDailyHours'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$TimesheetStatsImplToJson(
  _$TimesheetStatsImpl instance,
) => <String, dynamic>{
  'draftCount': instance.draftCount,
  'submittedCount': instance.submittedCount,
  'approvedCount': instance.approvedCount,
  'rejectedCount': instance.rejectedCount,
  'totalHoursThisWeek': instance.totalHoursThisWeek,
  'totalHoursThisMonth': instance.totalHoursThisMonth,
  'averageDailyHours': instance.averageDailyHours,
};

_$ManagerTimesheetStatsImpl _$$ManagerTimesheetStatsImplFromJson(
  Map<String, dynamic> json,
) => _$ManagerTimesheetStatsImpl(
  teamPending: (json['teamPending'] as num?)?.toInt() ?? 0,
  teamApproved: (json['teamApproved'] as num?)?.toInt() ?? 0,
  teamRejected: (json['teamRejected'] as num?)?.toInt() ?? 0,
  selfPending: (json['selfPending'] as num?)?.toInt() ?? 0,
  selfApproved: (json['selfApproved'] as num?)?.toInt() ?? 0,
  teamTotalHours: (json['teamTotalHours'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$ManagerTimesheetStatsImplToJson(
  _$ManagerTimesheetStatsImpl instance,
) => <String, dynamic>{
  'teamPending': instance.teamPending,
  'teamApproved': instance.teamApproved,
  'teamRejected': instance.teamRejected,
  'selfPending': instance.selfPending,
  'selfApproved': instance.selfApproved,
  'teamTotalHours': instance.teamTotalHours,
};
