// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      taskId: json['taskId'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      taskName: json['taskName'] as String,
      type: json['type'] as String,
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      estEndDate: DateTime.parse(json['estEndDate'] as String),
      actualEndDate: json['actualEndDate'] == null
          ? null
          : DateTime.parse(json['actualEndDate'] as String),
      estEffortHrs: (json['estEffortHrs'] as num).toDouble(),
      actualEffortHrs: (json['actualEffortHrs'] as num?)?.toDouble(),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      description: json['description'] as String,
      deliverables: json['deliverables'] as String?,
      taskHistory: json['taskHistory'] as String?,
      managerComments: json['managerComments'] as String?,
      notes: json['notes'] as String?,
      billable: json['billable'] as bool,
      attachedFiles:
          (json['attachedFiles'] as List<dynamic>?)
              ?.map((e) => AttachedFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'taskName': instance.taskName,
      'type': instance.type,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'estEndDate': instance.estEndDate.toIso8601String(),
      'actualEndDate': instance.actualEndDate?.toIso8601String(),
      'estEffortHrs': instance.estEffortHrs,
      'actualEffortHrs': instance.actualEffortHrs,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'description': instance.description,
      'deliverables': instance.deliverables,
      'taskHistory': instance.taskHistory,
      'managerComments': instance.managerComments,
      'notes': instance.notes,
      'billable': instance.billable,
      'attachedFiles': instance.attachedFiles,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.urgent: 'urgent',
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.normal: 'normal',
};

const _$TaskStatusEnumMap = {
  TaskStatus.assigned: 'assigned',
  TaskStatus.resolved: 'resolved',
  TaskStatus.closed: 'closed',
  TaskStatus.pending: 'pending',
  TaskStatus.open: 'open',
};

_$AttachedFileImpl _$$AttachedFileImplFromJson(Map<String, dynamic> json) =>
    _$AttachedFileImpl(
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
    );

Map<String, dynamic> _$$AttachedFileImplToJson(_$AttachedFileImpl instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'fileType': instance.fileType,
    };
