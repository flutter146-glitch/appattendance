// lib/features/attendance/domain/models/geofence_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_model.freezed.dart'; // YE SAHI HAI
part 'geofence_model.g.dart'; // YE SAHI HAI

enum GeofenceType { home, office, client }

@freezed
class GeofenceModel with _$GeofenceModel {
  const factory GeofenceModel({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double radius,
    required GeofenceType type,
    required bool isActive,
    DateTime? createdAt,
  }) = _GeofenceModel;

  factory GeofenceModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceModelFromJson(json);
}
