// lib/features/leaves/presentation/providers/leave_notifier.dart
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyLeavesNotifier extends StateNotifier<AsyncValue<List<LeaveModel>>> {
  final Ref ref;

  MyLeavesNotifier(this.ref) : super(const AsyncLoading()) {
    loadLeaves();
  }

  Future<void> loadLeaves() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError('Not logged in', StackTrace.current);
        return;
      }

      final repo = ref.read(leaveRepositoryProvider);
      final leaves = await repo.getLeavesByEmployee(user.empId);
      state = AsyncData(leaves);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadLeaves(); // Just reload the data
  }

  Future<void> applyLeave(LeaveModel leave) async {
    try {
      final repo = ref.read(leaveRepositoryProvider);
      await repo.applyLeave(leave);
      await loadLeaves(); // Refresh list
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// Manager ke pending count ke liye alag notifier (dashboard ke liye)
class PendingLeavesNotifier extends StateNotifier<AsyncValue<int>> {
  final Ref ref;

  PendingLeavesNotifier(this.ref) : super(const AsyncLoading()) {
    loadPendingCount();
  }

  Future<void> loadPendingCount() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null || !user.isManagerial) {
        state = const AsyncData(0);
        return;
      }

      final repo = ref.read(leaveRepositoryProvider);
      final count = await repo.getPendingLeavesCount(user.empId);
      state = AsyncData(count);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
