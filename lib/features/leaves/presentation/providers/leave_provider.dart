// lib/features/leaves/presentation/providers/leave_provider.dart
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/leave_repository.dart';
import '../../data/repositories/leave_repository_impl.dart';

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
