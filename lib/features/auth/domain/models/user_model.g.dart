// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      empId: json['empId'] as String,
      orgShortName: json['orgShortName'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      department: json['department'] as String?,
      designation: json['designation'] as String?,
      joiningDate: json['joiningDate'] == null
          ? null
          : DateTime.parse(json['joiningDate'] as String),
      status:
          $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.active,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      assignedProjectIds:
          (json['assignedProjectIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectNames:
          (json['projectNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      shiftId: json['shiftId'] as String?,
      reportingManagerId: json['reportingManagerId'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'empId': instance.empId,
      'orgShortName': instance.orgShortName,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'department': instance.department,
      'designation': instance.designation,
      'joiningDate': instance.joiningDate?.toIso8601String(),
      'status': _$UserStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'assignedProjectIds': instance.assignedProjectIds,
      'projectNames': instance.projectNames,
      'shiftId': instance.shiftId,
      'reportingManagerId': instance.reportingManagerId,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'Admin',
  UserRole.employee: 'Employee',
  UserRole.projectManager: 'Project Manager',
  UserRole.srManager: 'Sr. Manager',
  UserRole.operationsManager: 'Operations Manager',
  UserRole.hrManager: 'HR Manager',
  UserRole.financeManager: 'Finance Manager',
  UserRole.manager: 'Manager',
  UserRole.unknown: 'Unknown',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
  UserStatus.suspended: 'suspended',
  UserStatus.terminated: 'terminated',
};
