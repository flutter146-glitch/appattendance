// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String?,
      site: json['site'] as String?,
      shift: json['shift'] as String?,
      clientName: json['clientName'] as String?,
      clientContact: json['clientContact'] as String?,
      managerName: json['managerName'] as String?,
      managerEmail: json['managerEmail'] as String?,
      managerContact: json['managerContact'] as String?,
      description: json['description'] as String?,
      techStack: json['techStack'] as String?,
      assignedDate: json['assignedDate'] == null
          ? null
          : DateTime.parse(json['assignedDate'] as String),
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'site': instance.site,
      'shift': instance.shift,
      'clientName': instance.clientName,
      'clientContact': instance.clientContact,
      'managerName': instance.managerName,
      'managerEmail': instance.managerEmail,
      'managerContact': instance.managerContact,
      'description': instance.description,
      'techStack': instance.techStack,
      'assignedDate': instance.assignedDate?.toIso8601String(),
    };

_$ProjectAnalyticsImpl _$$ProjectAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$ProjectAnalyticsImpl(
  graphData: (json['graphData'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    ),
  ),
  labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
  totalProjects: (json['totalProjects'] as num).toInt(),
  totalEmployees: (json['totalEmployees'] as num).toInt(),
  statusDistribution: (json['statusDistribution'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  additionalStats: json['additionalStats'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$ProjectAnalyticsImplToJson(
  _$ProjectAnalyticsImpl instance,
) => <String, dynamic>{
  'graphData': instance.graphData,
  'labels': instance.labels,
  'totalProjects': instance.totalProjects,
  'totalEmployees': instance.totalEmployees,
  'statusDistribution': instance.statusDistribution,
  'additionalStats': instance.additionalStats,
};
