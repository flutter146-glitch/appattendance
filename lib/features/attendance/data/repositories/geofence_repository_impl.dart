// lib/features/geofence/data/repositories/geofence_repository_impl.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/attendance/data/repositories/geofence_repository.dart';
import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
import 'package:geolocator/geolocator.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  @override
  Future<List<GeofenceModel>> getActiveGeofences() async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'geofence_master', // Assume table exists or create it
      where: 'is_active = ?',
      whereArgs: [1],
    );

    return rows
        .map(
          (row) => GeofenceModel(
            id: row['id'] as String,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radiusMeters: row['radius_meters'] as double,
            isActive: (row['is_active'] as int) == 1,
            address: row['address'] as String?,
            createdAt: DateTime.parse(row['created_at'] as String),
            updatedAt: DateTime.parse(row['updated_at'] as String),
          ),
        )
        .toList();
  }

  @override
  Future<bool> isInsideAnyGeofence(double latitude, double longitude) async {
    final geofences = await getActiveGeofences();
    for (var geo in geofences) {
      if (geo.containsLocation(latitude, longitude)) {
        return true;
      }
    }
    return false;
  }
}
