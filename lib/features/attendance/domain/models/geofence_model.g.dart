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
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      address: json['address'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GeofenceModelImplToJson(_$GeofenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
      'isActive': instance.isActive,
      'address': instance.address,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
