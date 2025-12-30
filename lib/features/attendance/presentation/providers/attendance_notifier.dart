// lib/features/attendance/presentation/providers/attendance_notifier.dart
import 'package:appattendance/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceNotifier
    extends StateNotifier<AsyncValue<List<AttendanceModel>>> {
  final Ref ref;

  AttendanceNotifier(this.ref) : super(const AsyncLoading()) {
    loadTodayAttendance();
  }

  Future<void> loadTodayAttendance() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError('Not logged in', StackTrace.current);
        return;
      }

      final repo = ref.read(attendanceRepositoryProvider);
      final attendance = await repo.getTodayAttendance(user.empId);
      state = AsyncData(attendance);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  // Check-in aur Check-out methods (widget se call honge)
  Future<void> performCheckIn({
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception('Not logged in');

      final repo = ref.read(attendanceRepositoryProvider);
      await repo.checkIn(
        empId: user.empId,
        latitude: latitude,
        longitude: longitude,
        verificationType: verificationType,
        geofenceName: geofenceName,
        projectId: projectId,
        notes: notes,
      );

      await loadTodayAttendance(); // Refresh
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> performCheckOut({
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null) throw Exception('Not logged in');

      final repo = ref.read(attendanceRepositoryProvider);
      await repo.checkOut(
        empId: user.empId,
        latitude: latitude,
        longitude: longitude,
        verificationType: verificationType,
        geofenceName: geofenceName,
        projectId: projectId,
        notes: notes,
      );

      await loadTodayAttendance(); // Refresh
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

// // lib/features/attendance/presentation/providers/attendance_notifier.dart
// // Riverpod StateNotifier for Attendance feature
// // Uses UserModel from authProvider (freezed) - no Map access
// // Real-time today's attendance + check-in/out status

// import 'package:appattendance/features/attendance/data/repositories/attendance_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final attendanceProvider =
//     StateNotifierProvider<
//       AttendanceNotifier,
//       AsyncValue<List<AttendanceModel>>
//     >((ref) {
//       return AttendanceNotifier(ref);
//     });

// class AttendanceNotifier
//     extends StateNotifier<AsyncValue<List<AttendanceModel>>> {
//   final Ref ref;

//   AttendanceNotifier(this.ref) : super(const AsyncLoading()) {
//     loadTodayAttendance();
//   }

//   Future<void> loadTodayAttendance() async {
//     state = const AsyncLoading();
//     try {
//       // Yeh sahi hai: authProvider se UserModel? le rahe hain
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError('Not logged in', StackTrace.current);
//         return;
//       }

//       // UserModel ka empId direct access (no Map!)
//       final repo = ref.read(attendanceRepositoryProvider);
//       final attendance = await repo.getTodayAttendance(user.empId);
//       state = AsyncData(attendance);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> performCheckIn({
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) throw Exception('Not logged in');

//       final repo = ref.read(attendanceRepositoryProvider);
//       await repo.checkIn(
//         empId: user.empId, // Yeh sahi hai
//         latitude: latitude,
//         longitude: longitude,
//         verificationType: verificationType,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//       );

//       await loadTodayAttendance(); // Refresh list
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> performCheckOut({
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) throw Exception('Not logged in');

//       final repo = ref.read(attendanceRepositoryProvider);
//       await repo.checkOut(
//         empId: user.empId, // Yeh sahi hai
//         latitude: latitude,
//         longitude: longitude,
//         verificationType: verificationType,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//       );

//       await loadTodayAttendance(); // Refresh
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }
// }

// // lib/features/attendance/presentation/providers/attendance_notifier.dart
// // Riverpod StateNotifier for Attendance feature
// // Manages today's attendance + check-in/out status

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/attendance_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final attendanceProvider =
//     StateNotifierProvider<
//       AttendanceNotifier,
//       AsyncValue<List<AttendanceModel>>
//     >((ref) {
//       return AttendanceNotifier(ref);
//     });

// class AttendanceNotifier
//     extends StateNotifier<AsyncValue<List<AttendanceModel>>> {
//   final Ref ref;

//   AttendanceNotifier(this.ref) : super(const AsyncLoading()) {
//     loadTodayAttendance();
//   }

//   Future<void> loadTodayAttendance() async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError('Not logged in', StackTrace.current);
//         return;
//       }

//       final repo = ref.read(attendanceRepositoryProvider);
//       final attendance = await repo.getTodayAttendance(user.empId);
//       state = AsyncData(attendance);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> performCheckIn({
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) throw Exception('Not logged in');

//       final repo = ref.read(attendanceRepositoryProvider);
//       await repo.checkIn(
//         empId: user.empId,
//         latitude: latitude,
//         longitude: longitude,
//         verificationType: verificationType,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//       );

//       await loadTodayAttendance(); // Refresh list
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> performCheckOut({
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) throw Exception('Not logged in');

//       final repo = ref.read(attendanceRepositoryProvider);
//       await repo.checkOut(
//         empId: user.empId,
//         latitude: latitude,
//         longitude: longitude,
//         verificationType: verificationType,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//       );

//       await loadTodayAttendance(); // Refresh
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }
// }
