// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MappedProjectImpl _$$MappedProjectImplFromJson(Map<String, dynamic> json) =>
    _$MappedProjectImpl(
      empId: json['empId'] as String,
      projectId: json['projectId'] as String,
      mappingStatus: json['mappingStatus'] as String,
      project: ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MappedProjectImplToJson(_$MappedProjectImpl instance) =>
    <String, dynamic>{
      'empId': instance.empId,
      'projectId': instance.projectId,
      'mappingStatus': instance.mappingStatus,
      'project': instance.project,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      orgShortName: json['orgShortName'] as String,
      projectDescription: json['projectDescription'] as String?,
      projectSite: json['projectSite'] as String?,
      clientName: json['clientName'] as String?,
      clientLocation: json['clientLocation'] as String?,
      clientContact: json['clientContact'] as String?,
      techStack: json['techStack'] as String?,
      mngName: json['mngName'] as String?,
      mngEmail: json['mngEmail'] as String?,
      mngContact: json['mngContact'] as String?,
      estdStartDate: json['estdStartDate'] as String?,
      estdEndDate: json['estdEndDate'] as String?,
      estdEffort: json['estdEffort'] as String?,
      estdCost: json['estdCost'] as String?,
      assignedDate: json['assignedDate'] == null
          ? null
          : DateTime.parse(json['assignedDate'] as String),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status:
          $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
          ProjectStatus.active,
      priority:
          $enumDecodeNullable(_$ProjectPriorityEnumMap, json['priority']) ??
          ProjectPriority.medium,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      teamSize: (json['teamSize'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'orgShortName': instance.orgShortName,
      'projectDescription': instance.projectDescription,
      'projectSite': instance.projectSite,
      'clientName': instance.clientName,
      'clientLocation': instance.clientLocation,
      'clientContact': instance.clientContact,
      'techStack': instance.techStack,
      'mngName': instance.mngName,
      'mngEmail': instance.mngEmail,
      'mngContact': instance.mngContact,
      'estdStartDate': instance.estdStartDate,
      'estdEndDate': instance.estdEndDate,
      'estdEffort': instance.estdEffort,
      'estdCost': instance.estdCost,
      'assignedDate': instance.assignedDate?.toIso8601String(),
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'priority': _$ProjectPriorityEnumMap[instance.priority]!,
      'progress': instance.progress,
      'totalTasks': instance.totalTasks,
      'completedTasks': instance.completedTasks,
      'teamSize': instance.teamSize,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.inactive: 'inactive',
  ProjectStatus.completed: 'completed',
  ProjectStatus.onHold: 'onHold',
  ProjectStatus.cancelled: 'cancelled',
};

const _$ProjectPriorityEnumMap = {
  ProjectPriority.urgent: 'urgent',
  ProjectPriority.high: 'high',
  ProjectPriority.medium: 'medium',
  ProjectPriority.low: 'low',
};
