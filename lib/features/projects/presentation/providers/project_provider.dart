// lib/features/projects/presentation/providers/project_provider.dart
// FINAL & BEST PRACTICE VERSION - January 09, 2026
// Features:
// - AutoDispose for memory efficiency
// - Separate providers for employee (mapped) & manager (team) views
// - Single project family provider for detail screens
// - Refresh + error handling + user-friendly messages
// - Debounce on refresh to prevent spam
// - Clear separation of concerns

import 'dart:async';

import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/data/repository/project_repository.dart';
import 'package:appattendance/features/projects/data/repository/project_repository_impl.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Repository Provider ─────────────────────────────────────────────────────
// Injects DBHelper automatically
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return ProjectRepositoryImpl(dbHelper);
});

// ── Employee: Mapped Projects Provider ──────────────────────────────────────
final mappedProjectsProvider =
    StateNotifierProvider.autoDispose<
      MappedProjectsNotifier,
      AsyncValue<List<MappedProject>>
    >((ref) => MappedProjectsNotifier(ref));

class MappedProjectsNotifier
    extends StateNotifier<AsyncValue<List<MappedProject>>> {
  final Ref ref;
  Timer? _debounceTimer;

  MappedProjectsNotifier(this.ref) : super(const AsyncLoading()) {
    loadMappedProjects();
  }

  Future<void> loadMappedProjects() async {
    if (state.isLoading) return; // Prevent duplicate calls

    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError(
          'Please login to view your projects',
          StackTrace.current,
        );
        return;
      }

      final repo = ref.read(projectRepositoryProvider);
      final projects = await repo.getMappedProjects(user.empId);
      state = AsyncData(projects);
    } catch (e, stack) {
      state = AsyncError(
        'Unable to load your assigned projects. Please try again.',
        stack,
      );
    }
  }

  /// Pull-to-refresh / manual refresh with debounce
  Future<void> refresh() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      await loadMappedProjects();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// ── Manager: Team Projects Provider ─────────────────────────────────────────
final teamProjectsProvider =
    StateNotifierProvider.autoDispose<
      TeamProjectsNotifier,
      AsyncValue<List<ProjectModel>>
    >((ref) => TeamProjectsNotifier(ref));

class TeamProjectsNotifier
    extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  final Ref ref;
  Timer? _debounceTimer;

  TeamProjectsNotifier(this.ref) : super(const AsyncLoading()) {
    loadTeamProjects();
  }

  Future<void> loadTeamProjects() async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError(
          'Please login to view team projects',
          StackTrace.current,
        );
        return;
      }

      if (!user.isManagerial) {
        state = const AsyncData(<ProjectModel>[]);
        return;
      }

      final repo = ref.read(projectRepositoryProvider);
      final projects = await repo.getTeamProjects(user.empId);
      state = AsyncData(projects);
    } catch (e, stack) {
      state = AsyncError(
        'Unable to load team projects. Please try again.',
        stack,
      );
    }
  }

  /// Pull-to-refresh with debounce
  Future<void> refresh() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      await loadTeamProjects();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// ── Single Project Details (Family Provider) ────────────────────────────────
// Used in detail screens / when tapping a project card
final projectByIdProvider = FutureProvider.family<ProjectModel?, String>((
  ref,
  projectId,
) async {
  try {
    final repo = ref.read(projectRepositoryProvider);
    return await repo.getProjectById(projectId);
  } catch (e) {
    // Log error silently, return null for UI to handle
    return null;
  }
});

// ── Optional: Combined Provider (Mapped + Team Projects) ────────────────────
// Use this only when you need both in one screen (e.g., dashboard)
// Otherwise keep separate for better performance
final allProjectsProvider = Provider<AsyncValue<List<ProjectModel>>>((ref) {
  final mappedAsync = ref.watch(mappedProjectsProvider);
  final teamAsync = ref.watch(teamProjectsProvider);

  if (mappedAsync.isLoading || teamAsync.isLoading) {
    return const AsyncLoading();
  }

  if (mappedAsync.hasError)
    return AsyncError(mappedAsync.error!, mappedAsync.stackTrace!);
  if (teamAsync.hasError)
    return AsyncError(teamAsync.error!, teamAsync.stackTrace!);

  final mappedProjects =
      mappedAsync.valueOrNull?.map((m) => m.project).toList() ?? [];
  final teamProjects = teamAsync.valueOrNull ?? [];

  // Merge & remove duplicates by projectId
  final all = [...mappedProjects, ...teamProjects];
  final unique = <String, ProjectModel>{};
  for (final p in all) {
    unique[p.projectId] = p;
  }

  return AsyncData(unique.values.toList());
});

// // lib/features/project/presentation/providers/project_provider.dart
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final projectProvider =
//     StateNotifierProvider<ProjectNotifier, AsyncValue<List<MappedProject>>>((
//       ref,
//     ) {
//       return ProjectNotifier(ref);
//     });

// final teamProjectProvider =
//     StateNotifierProvider<ProjectNotifier, AsyncValue<List<ProjectModel>>>((
//       ref,
//     ) {
//       return ProjectNotifier(ref); // Same notifier, different state
//     });
