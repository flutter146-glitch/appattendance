// lib/features/geofence/domain/repositories/geofence_repository.dart
import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';

abstract class GeofenceRepository {
  Future<List<GeofenceModel>> getActiveGeofences();
  Future<bool> isInsideAnyGeofence(double latitude, double longitude);

  // Future<void> setGeofence(GeofenceModel geo);

  /// Validate if current location is inside geofence (repo calls location service)
  // Future<bool> isInsideGeofence(double lat, double lon);
}
