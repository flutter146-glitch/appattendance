// lib/features/dashboard/presentation/providers/dashboard_notifier.dart
import 'package:appattendance/core/providers/role_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final bool isLoading;
  final String message;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int teamSize;
  final int presentToday;

  DashboardState({
    this.isLoading = false,
    this.message = "Welcome back!",
    this.checkInTime,
    this.checkOutTime,
    this.teamSize = 0,
    this.presentToday = 0,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? message,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? teamSize,
    int? presentToday,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      teamSize: teamSize ?? this.teamSize,
      presentToday: presentToday ?? this.presentToday,
    );
  }
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardState>> {
  DashboardNotifier(this.ref) : super(const AsyncLoading()) {
    loadDashboard();
  }

  final Ref ref;

  Future<void> loadDashboard() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));

    final user = ref.read(roleProvider);
    if (user == null) {
      state = AsyncError("Not logged in", StackTrace.current);
      return;
    }

    if (user.isManager) {
      state = AsyncData(
        DashboardState(
          message: "Welcome, ${user.name} (Manager)",
          teamSize: 12,
          presentToday: 10,
        ),
      );
    } else {
      state = AsyncData(
        DashboardState(
          message: "Welcome back, ${user.name}",
          checkInTime: DateTime.now().subtract(const Duration(hours: 8)),
        ),
      );
    }
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>((ref) {
      return DashboardNotifier(ref);
    });
