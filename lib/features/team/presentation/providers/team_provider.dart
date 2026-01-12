// lib/features/team/presentation/providers/team_provider.dart
import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/team/data/repository/team_repository.dart';
import 'package:appattendance/features/team/data/repository/team_repository_impl.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return TeamRepositoryImpl(dbHelper);
});

// Main Team Members List Provider (for manager dashboard)
final teamMembersProvider =
    StateNotifierProvider<TeamNotifier, AsyncValue<List<TeamMember>>>((ref) {
      final repo = ref.watch(teamRepositoryProvider);
      final notifier = TeamNotifier(ref, repo);
      notifier.loadTeamMembers(); // Auto-load on creation
      return notifier;
    });

// Single Member Details (family provider - caching ke liye best)
final teamMemberDetailsProvider = FutureProvider.family<TeamMember?, String>((
  ref,
  empId,
) async {
  final repo = ref.watch(teamRepositoryProvider);
  return repo.getTeamMemberDetails(empId);
});

// Search Query State (UI search field ke liye)
final teamSearchQueryProvider = StateProvider<String>((ref) => '');

// Computed: Searched team members (query change pe auto update)
final searchedTeamMembersProvider = Provider<AsyncValue<List<TeamMember>>>((
  ref,
) {
  final query = ref.watch(teamSearchQueryProvider);
  final notifier = ref.watch(teamMembersProvider.notifier);

  // Auto-search on query change
  ref.listen(teamSearchQueryProvider, (_, newQuery) {
    notifier.search(newQuery);
  });

  return ref.watch(teamMembersProvider);
});

final projectTeamMembersProvider =
    FutureProvider.family<List<TeamMember>, String>((ref, projectId) async {
      final repo = ref.watch(teamRepositoryProvider);
      // Query employee_mapped_projects + employee_master for this projectId
      final db = await ref.watch(dbHelperProvider).database;
      final rows = await db.rawQuery(
        '''
      SELECT e.* 
      FROM employee_master e
      JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
      WHERE emp.project_id = ?
    ''',
        [projectId],
      );

      return rows.map((row) => TeamMember.fromJson(row)).toList();
    });

// // lib/features/team/presentation/providers/team_provider.dart
// import 'package:appattendance/core/database/database_provider.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/team/data/repositories/team_repository_impl.dart';
// import 'package:appattendance/features/team/data/repository/team_repository.dart';
// import 'package:appattendance/features/team/data/repository/team_repository_impl.dart';
// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:appattendance/features/team/domain/repositories/team_repository.dart';
// import 'package:appattendance/features/team/presentation/providers/team_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Repository Provider (inject DBHelper)
// final teamRepositoryProvider = Provider<TeamRepository>((ref) {
//   final dbHelper = ref.watch(dbHelperProvider);
//   return TeamRepositoryImpl(dbHelper);
// });

// // Team Members List Provider
// final teamMembersProvider =
//     StateNotifierProvider<TeamNotifier, AsyncValue<List<TeamMember>>>((ref) {
//       final repository = ref.watch(teamRepositoryProvider);
//       return TeamNotifier(ref, repository)..loadTeamMembers();
//     });

// // Single Member Details Provider (family for caching per empId)
// final teamMemberDetailsProvider = FutureProvider.family<TeamMember?, String>((
//   ref,
//   empId,
// ) async {
//   final repository = ref.watch(teamRepositoryProvider);
//   return await repository.getTeamMemberDetails(empId);
// });

// // Search Query Provider (for UI search field)
// final teamSearchQueryProvider = StateProvider<String>((ref) => '');

// // Searched Team Members (computed from main list or via repo)
// final searchedTeamMembersProvider = Provider<AsyncValue<List<TeamMember>>>((
//   ref,
// ) {
//   final query = ref.watch(teamSearchQueryProvider);
//   final notifier = ref.watch(teamMembersProvider.notifier);
//   ref.listen(teamSearchQueryProvider, (_, newQuery) {
//     notifier.search(newQuery);
//   });
//   return ref.watch(teamMembersProvider);
// });
