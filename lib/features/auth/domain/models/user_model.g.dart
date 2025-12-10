// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      department: json['department'] as String,
      employeeId: json['employeeId'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      token: json['token'] as String?,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      mpinSet: json['mpinSet'] as bool? ?? false,
      projects: json['projects'] as List<dynamic>? ?? const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'department': instance.department,
      'employeeId': instance.employeeId,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'token': instance.token,
      'biometricEnabled': instance.biometricEnabled,
      'mpinSet': instance.mpinSet,
      'projects': instance.projects,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.employee: 'employee',
  UserRole.manager: 'manager',
  UserRole.admin: 'admin',
};
