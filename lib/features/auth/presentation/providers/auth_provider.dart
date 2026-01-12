// lib/features/auth/presentation/providers/auth_provider.dart
// Final production-ready version (Dec 30, 2025)
// Uses freezed UserModel + Dio switch + computed privileges (R01-R08)
// Loading/error + real API/local mode

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/data/repositories/auth_repository.dart';
import 'package:appattendance/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dio provider (for real API mode)
// final dioProvider = Provider((ref) => ref.watch(dioClientProvider));

// Repository provider (switch between local & remote)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // final dio = ref.watch(dioProvider);
  // return AuthRepositoryImpl(dio: dio); // Dio null for local, real Dio for API
  return AuthRepositoryImpl();
});

// Main auth state provider
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthNotifier(ref, repository);
    });

// Computed role/privilege providers (no separate file needed)
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value != null;
});

final isManagerialProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.isManagerial ?? false;
});

final userRoleProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.displayRole ?? 'Guest';
});

// Privileges (R01-R08) computed from UserModel extension
final canViewTeamAttendanceProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.canViewTeamAttendance ?? false;
});

final canApproveLeavesProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.canApproveLeaves ?? false;
});

final canApproveRegularisationProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.canApproveRegularisation ?? false;
});

// Computed profile-related providers (no separate file needed)
final userProfileProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).value;
});

final isProfileLoadedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).hasValue &&
      ref.watch(authProvider).value != null;
});

// Example: Update profile (call from widget)
final updateProfileProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, updates) async {
    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) throw Exception('No user logged in');

    final updatedUser = currentUser.copyWith(
      phone: updates['phone'] as String?,
      // emergencyContact: updates['emergency'] as String?,
      // Add more fields as needed (e.g., address, profilePicUrl)
    );

    // Update in DB (current user session)
    await DBHelper.instance.saveCurrentUser(updatedUser.toJson());

    // Update auth state (real-time)
    ref.read(authProvider.notifier).updateUser(updatedUser);
  },
);
