// lib/features/leaves/presentation/providers/leave_provider.dart
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/data/repositories/leave_repository.dart';
import 'package:appattendance/features/leaves/data/repositories/leave_repository_impl.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum for filters (if not in leave_model.dart, yahan daal do ya import karo)
enum LeaveFilter { all, team, pending, approved, rejected }

// 1. Employee ke apne saare leaves
final myLeavesProvider =
    StateNotifierProvider<MyLeavesNotifier, AsyncValue<List<LeaveModel>>>((
      ref,
    ) {
      return MyLeavesNotifier(ref);
    });

// 2. Manager ke pending leaves count (dashboard ke liye)
final pendingLeavesCountProvider =
    StateNotifierProvider<PendingLeavesNotifier, AsyncValue<int>>((ref) {
      return PendingLeavesNotifier(ref);
    });

// 3. Manager ke pending leaves list (new)
final pendingLeavesListProvider =
    StateNotifierProvider<
      PendingLeavesListNotifier,
      AsyncValue<List<LeaveModel>>
    >((ref) {
      return PendingLeavesListNotifier(ref);
    });

class PendingLeavesListNotifier
    extends StateNotifier<AsyncValue<List<LeaveModel>>> {
  final Ref ref;

  PendingLeavesListNotifier(this.ref) : super(const AsyncLoading()) {
    loadPendingLeaves();
  }

  Future<void> loadPendingLeaves() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null || !user.isManagerial) {
        state = const AsyncData([]);
        return;
      }

      final repo = ref.read(leaveRepositoryProvider);
      final leaves = await repo.getPendingLeavesForManager(user.empId);
      state = AsyncData(leaves);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadPendingLeaves();
  }
}

// 4. Manager ke ALL team leaves (pending + approved + rejected + cancelled)
final teamLeavesProvider =
    StateNotifierProvider<TeamLeavesNotifier, AsyncValue<List<LeaveModel>>>((
      ref,
    ) {
      return TeamLeavesNotifier(ref);
    });

class TeamLeavesNotifier extends StateNotifier<AsyncValue<List<LeaveModel>>> {
  final Ref ref;

  TeamLeavesNotifier(this.ref) : super(const AsyncLoading()) {
    loadTeamLeaves();
  }

  Future<void> loadTeamLeaves() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null || !user.isManagerial) {
        state = const AsyncData([]);
        return;
      }

      final repo = ref.read(leaveRepositoryProvider);
      final leaves = await repo.getAllLeavesForManager(
        user.empId,
      ); // ← Yeh method abhi banana padega
      state = AsyncData(leaves);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadTeamLeaves();
  }
}

// Filter provider (for state management)
final leaveFilterProvider =
    StateNotifierProvider<LeaveFilterNotifier, LeaveFilter>((ref) {
      return LeaveFilterNotifier();
    });

// Repository provider (common)
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImpl();
});

// Filter Notifier
class LeaveFilterNotifier extends StateNotifier<LeaveFilter> {
  LeaveFilterNotifier() : super(LeaveFilter.all);
}

// // lib/features/leave/presentation/providers/leave_provider.dart
// import 'package:appattendance/features/leaves/data/repository/leave_repository.dart';
// import 'package:appattendance/features/leaves/data/repository/leave_repository_impl.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // 1. Employee ke apne saare leaves
// final myLeavesProvider =
//     StateNotifierProvider<MyLeavesNotifier, AsyncValue<List<LeaveModel>>>((
//       ref,
//     ) {
//       return MyLeavesNotifier(ref);
//     });

// // 2. Manager ke pending leaves count (dashboard ke liye)
// final pendingLeavesCountProvider =
//     StateNotifierProvider<PendingLeavesNotifier, AsyncValue<int>>((ref) {
//       return PendingLeavesNotifier(ref);
//     });

// // Repository provider (common)
// final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
//   return LeaveRepositoryImpl();
// });

// // Filter provider (for state management)
// final leaveFilterProvider =
//     StateNotifierProvider<LeaveFilterNotifier, LeaveFilter>((ref) {
//       return LeaveFilterNotifier();
//     });

// class LeaveFilterNotifier extends StateNotifier<LeaveFilter> {
//   LeaveFilterNotifier() : super(LeaveFilter.all);
// }
