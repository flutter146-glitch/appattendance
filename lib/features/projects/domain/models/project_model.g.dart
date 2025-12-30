// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      projectId: json['projectId'] as String,
      orgShortName: json['orgShortName'] as String,
      projectName: json['projectName'] as String,
      projectSite: json['projectSite'] as String?,
      clientName: json['clientName'] as String?,
      clientLocation: json['clientLocation'] as String?,
      clientContact: json['clientContact'] as String?,
      mngName: json['mngName'] as String?,
      mngEmail: json['mngEmail'] as String?,
      mngContact: json['mngContact'] as String?,
      projectDescription: json['projectDescription'] as String?,
      projectTechstack: json['projectTechstack'] as String?,
      projectAssignedDate: json['projectAssignedDate'] as String?,
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
      'orgShortName': instance.orgShortName,
      'projectName': instance.projectName,
      'projectSite': instance.projectSite,
      'clientName': instance.clientName,
      'clientLocation': instance.clientLocation,
      'clientContact': instance.clientContact,
      'mngName': instance.mngName,
      'mngEmail': instance.mngEmail,
      'mngContact': instance.mngContact,
      'projectDescription': instance.projectDescription,
      'projectTechstack': instance.projectTechstack,
      'projectAssignedDate': instance.projectAssignedDate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

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
