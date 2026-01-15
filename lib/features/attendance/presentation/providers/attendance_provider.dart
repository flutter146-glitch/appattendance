import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:appattendance/features/attendance/data/services/offline_attendance_service.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Attendance feature ka main provider (sab screens se use hoga)
final attendanceProvider =
    StateNotifierProvider<
      AttendanceNotifier,
      AsyncValue<List<AttendanceModel>>
    >((ref) => AttendanceNotifier(ref));

// Additional providers for better modularity

// Today's attendance only (filtered from main provider)
final todayAttendanceProvider = Provider<List<AttendanceModel>>((ref) {
  final allAttendance = ref.watch(attendanceProvider).value ?? [];
  final today = DateTime.now();
  return allAttendance.where((att) {
    return att.attendanceDate.year == today.year &&
        att.attendanceDate.month == today.month &&
        att.attendanceDate.day == today.day;
  }).toList();
});

// Current user's attendance loading state
final isAttendanceLoadingProvider = Provider<bool>((ref) {
  return ref.watch(attendanceProvider).isLoading;
});

// Offline sync trigger provider (call on app start/online)
final offlineSyncProvider = Provider<void>((ref) {
  // Auto-sync on provider init (app start)
  // ref.read(attendanceProvider.notifier).syncOfflineQueue(ref);
  // Or call manually from splash/dashboard
});
