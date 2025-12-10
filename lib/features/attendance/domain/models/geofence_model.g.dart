// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeofenceModelImpl _$$GeofenceModelImplFromJson(Map<String, dynamic> json) =>
    _$GeofenceModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      type: $enumDecode(_$GeofenceTypeEnumMap, json['type']),
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GeofenceModelImplToJson(_$GeofenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'type': _$GeofenceTypeEnumMap[instance.type]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$GeofenceTypeEnumMap = {
  GeofenceType.home: 'home',
  GeofenceType.office: 'office',
  GeofenceType.client: 'client',
};
