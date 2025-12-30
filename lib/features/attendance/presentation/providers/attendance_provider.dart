// lib/features/attendance/presentation/providers/attendance_provider.dart
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/attendance_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Attendance feature ka main provider (sab screens se use hoga)
final attendanceProvider =
    StateNotifierProvider<
      AttendanceNotifier,
      AsyncValue<List<AttendanceModel>>
    >((ref) => AttendanceNotifier(ref));
