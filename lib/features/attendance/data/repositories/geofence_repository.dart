// lib/features/geofence/domain/repositories/geofence_repository.dart
import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';

abstract class GeofenceRepository {
  Future<List<GeofenceModel>> getActiveGeofences();
  Future<bool> isInsideAnyGeofence(double latitude, double longitude);
}

// // lib/features/geofence/domain/repositories/geofence_repository.dart
// import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';

// abstract class GeofenceRepository {
//   Future<List<GeofenceModel>> getAllGeofences();
//   Future<bool> isInsideAnyGeofence(double lat, double lon);
// }

// // Impl (SQLite + geolocator for distance)
// // class GeofenceRepositoryImpl implements GeofenceRepository {
// //   // ... DB query for geofences
// //   // Use geolocator.distanceBetween() for real check
// // }
