// lib/features/leave/presentation/providers/leave_provider.dart
import 'package:appattendance/features/leaves/data/repository/leave_repository.dart';
import 'package:appattendance/features/leaves/data/repository/leave_repository_impl.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// Repository provider (common)
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImpl();
});
