// lib/features/team/presentation/providers/team_notifier.dart
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/team/data/repository/team_repository.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamNotifier extends StateNotifier<AsyncValue<List<TeamMember>>> {
  final Ref ref;
  final TeamRepository _repository;

  TeamNotifier(this.ref, this._repository) : super(const AsyncLoading());

  Future<void> loadTeamMembers() async {
    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null || !user.isManagerial) {
        state = AsyncError('Manager access required', StackTrace.current);
        return;
      }

      final members = await _repository.getTeamMembers(user.empId);
      state = AsyncData(members);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() => loadTeamMembers();

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      return refresh();
    }

    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null) return;

      final results = await _repository.searchTeamMembers(user.empId, query);
      state = AsyncData(results);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<TeamMember?> getMemberDetails(String empId, {int days = 30}) async {
    try {
      return await _repository.getTeamMemberDetails(empId, recentDays: days);
    } catch (_) {
      return null;
    }
  }
}

// // lib/features/team/presentation/providers/team_notifier.dart
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:appattendance/features/team/domain/repositories/team_repository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TeamNotifier extends StateNotifier<AsyncValue<List<TeamMember>>> {
//   final Ref ref;
//   final TeamRepository repository;

//   TeamNotifier(this.ref, this.repository) : super(const AsyncLoading());

//   Future<void> loadTeamMembers() async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null || !user.isManagerial) {
//         state = AsyncError('Not authorized or not a manager', StackTrace.current);
//         return;
//       }
//       final members = await repository.getTeamMembers(user.empId);
//       state = AsyncData(members);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> refresh() async {
//     await loadTeamMembers();
//   }

//   Future<void> search(String query) async {
//     if (query.isEmpty) {
//       await refresh();
//       return;
//     }
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError('Not logged in', StackTrace.current);
//         return;
//       }
//       final results = await repository.searchTeamMembers(user.empId, query);
//       state = AsyncData(results);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<TeamMember?> getMemberDetails(String empId, {int days = 30}) async {
//     return await repository.getTeamMemberDetails(empId, days: days);
//   }
// }
