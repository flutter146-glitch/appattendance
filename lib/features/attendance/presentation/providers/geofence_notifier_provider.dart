// lib/features/geofence/presentation/providers/geofence_provider.dart
import 'package:appattendance/features/attendance/data/repositories/geofence_repository.dart';
import 'package:appattendance/features/attendance/data/repositories/geofence_repository_impl.dart';
import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geofenceRepositoryProvider = Provider<GeofenceRepository>((ref) {
  return GeofenceRepositoryImpl();
});

final geofenceProvider =
    StateNotifierProvider<GeofenceNotifier, AsyncValue<List<GeofenceModel>>>((
      ref,
    ) {
      return GeofenceNotifier(ref);
    });

class GeofenceNotifier extends StateNotifier<AsyncValue<List<GeofenceModel>>> {
  final Ref ref;

  GeofenceNotifier(this.ref) : super(const AsyncLoading()) {
    loadGeofences();
  }

  Future<void> loadGeofences() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(geofenceRepositoryProvider);
      final geofences = await repo.getActiveGeofences();
      state = AsyncData(geofences);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<bool> checkCurrentLocation(double lat, double lon) async {
    try {
      final repo = ref.read(geofenceRepositoryProvider);
      return await repo.isInsideAnyGeofence(lat, lon);
    } catch (e) {
      return false;
    }
  }
}

// // lib/features/geofence/presentation/providers/geofence_provider.dart
// import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final geofenceProvider =
//     StateNotifierProvider<GeofenceNotifier, AsyncValue<List<GeofenceModel>>>((
//       ref,
//     ) {
//       return GeofenceNotifier(ref);
//     });

// class GeofenceNotifier extends StateNotifier<AsyncValue<List<GeofenceModel>>> {
//   final Ref ref;
//   GeofenceNotifier(this.ref) : super(const AsyncLoading()) {
//     loadGeofences();
//   }

//   Future<void> loadGeofences() async {
//     // DB fetch
//   }

//   // Future<bool> checkCurrentLocation(double lat, double lon) async {
//   //   // Real check using repository
//   // }
// }
