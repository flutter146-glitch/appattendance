// lib/features/attendance/presentation/providers/attendance_notifier.dart
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceNotifier
    extends StateNotifier<AsyncValue<List<AttendanceModel>>> {
  AttendanceNotifier() : super(const AsyncLoading()) {
    loadTodayAttendance();
  }

  Future<void> loadTodayAttendance() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(_dummyTodayAttendance());
  }

  List<AttendanceModel> _dummyTodayAttendance() => [
    AttendanceModel(
      id: "1",
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: AttendanceType.checkIn,
      latitude: 19.1,
      longitude: 72.8,
      projectName: "Nutantek App",
    ),
  ];

  Future<void> checkIn() async {
    // Add check-in logic
  }

  Future<void> checkOut() async {
    // Add check-out logic
  }
}

final attendanceProvider =
    StateNotifierProvider<
      AttendanceNotifier,
      AsyncValue<List<AttendanceModel>>
    >((ref) {
      return AttendanceNotifier();
    });
