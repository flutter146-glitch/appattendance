// lib/features/geofence/domain/models/geofence_model.dart

import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_model.freezed.dart';
part 'geofence_model.g.dart';

@freezed
class GeofenceModel with _$GeofenceModel {
  const GeofenceModel._();

  const factory GeofenceModel({
    required String id, // e.g., "OFFICE_MAIN" or UUID
    required String name, // "Main Office", "Client Site A"
    required double latitude,
    required double longitude,
    required double radiusMeters, // e.g., 100.0
    @Default(true) bool isActive,
    String? address, // Optional description
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GeofenceModel;

  factory GeofenceModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceModelFromJson(json);

  // Helper: Check if point is inside this geofence (using Haversine)
  bool containsLocation(double lat, double lon) {
    const double earthRadius = 6371000; // meters

    double dLat = _deg2rad(lat - latitude);
    double dLon = _deg2rad(lon - longitude);

    double a =
        sin(dLat / 2) * sin(dLat / 2) + // ← sin() static call
        cos(_deg2rad(latitude)) *
            cos(_deg2rad(lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance <= radiusMeters;
  }

  static double _deg2rad(double deg) => deg * (pi / 180);
}

/**************
 * 
 * 
 * 
 * 
 * 
 *****************/

// // lib/features/geofence/domain/models/geofence_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'geofence_model.freezed.dart';
// part 'geofence_model.g.dart';

// @freezed
// class GeofenceModel with _$GeofenceModel {
//   const GeofenceModel._();

//   const factory GeofenceModel({
//     required String id,
//     required String name, // e.g., "Main Office", "Client Site"
//     required double latitude,
//     required double longitude,
//     required double radiusMeters, // e.g., 100 meters
//     @Default(true) bool isActive,
//     String? address, // Optional
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _GeofenceModel;

//   factory GeofenceModel.fromJson(Map<String, dynamic> json) =>
//       _$GeofenceModelFromJson(json);

//   // Computed: Distance in meters from given point
//   double distanceTo(double lat, double lon) {
//     // Haversine formula (real mein implement karo)
//     return 0.0; // Placeholder - geolocator se real calc
//   }

//   bool isInside(double lat, double lon) {
//     return distanceTo(lat, lon) <= radiusMeters;
//   }
// }

// // lib/features/attendance/domain/models/geofence_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'geofence_model.freezed.dart'; // YE SAHI HAI
// part 'geofence_model.g.dart'; // YE SAHI HAI

// enum GeofenceType { home, office, client }

// @freezed
// class GeofenceModel with _$GeofenceModel {
//   const factory GeofenceModel({
//     required String id,
//     required String name,
//     required double latitude,
//     required double longitude,
//     required double radius,
//     required GeofenceType type,
//     required bool isActive,
//     DateTime? createdAt,
//   }) = _GeofenceModel;

//   factory GeofenceModel.fromJson(Map<String, dynamic> json) =>
//       _$GeofenceModelFromJson(json);
// }
