// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMemberImpl _$$TeamMemberImplFromJson(Map<String, dynamic> json) =>
    _$TeamMemberImpl(
      empId: json['empId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      avatarFallbackUrl:
          json['avatarFallbackUrl'] as String? ??
          'https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=',
      department: json['department'] as String?,
      designation: json['designation'] as String?,
      status:
          $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.active,
      dateOfJoining: json['dateOfJoining'] == null
          ? null
          : DateTime.parse(json['dateOfJoining'] as String),
      projectIds:
          (json['projectIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectNames:
          (json['projectNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recentAttendanceHistory:
          (json['recentAttendanceHistory'] as List<dynamic>?)
              ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TeamMemberImplToJson(_$TeamMemberImpl instance) =>
    <String, dynamic>{
      'empId': instance.empId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'avatarFallbackUrl': instance.avatarFallbackUrl,
      'department': instance.department,
      'designation': instance.designation,
      'status': _$UserStatusEnumMap[instance.status]!,
      'dateOfJoining': instance.dateOfJoining?.toIso8601String(),
      'projectIds': instance.projectIds,
      'projectNames': instance.projectNames,
      'recentAttendanceHistory': instance.recentAttendanceHistory,
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
  UserStatus.suspended: 'suspended',
  UserStatus.terminated: 'terminated',
};
