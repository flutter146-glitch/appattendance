// lib/features/projects/presentation/providers/project_notifier.dart

import 'dart:async';

import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/data/repository/project_repository.dart';
import 'package:appattendance/features/projects/data/repository/project_repository_impl.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Providers ────────────────────────────────────────────────────────────────

// Repository (unchanged - good)
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return ProjectRepositoryImpl(dbHelper);
});

// ── Employee: Mapped Projects (autoDispose + refresh support) ───────────────
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
        'Unable to load assigned projects. Please try again.',
        stack,
      );
    }
  }

  // Pull-to-refresh / manual refresh with debounce (prevents spam)
  Future<void> refresh() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await loadMappedProjects();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// ── Manager: Team Projects (autoDispose + family-ready) ─────────────────────
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

  // Pull-to-refresh with debounce
  Future<void> refresh() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await loadTeamProjects();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// ── Single Project by ID (Family provider - used in detail screen) ──────────
final projectByIdProvider = FutureProvider.family<ProjectModel?, String>((
  ref,
  projectId,
) async {
  try {
    final repo = ref.read(projectRepositoryProvider);
    return await repo.getProjectById(projectId);
  } catch (e) {
    // Optional: Log error or show toast from caller
    return null;
  }
});

// ── Optional: Combined Provider (if you want both mapped + team in one place) ──
// (Use only if needed - otherwise keep separate for performance)
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

// // lib/features/project/presentation/providers/project_notifier.dart
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/projects/data/repository/project_repository.dart';
// import 'package:appattendance/features/projects/data/repository/project_repository_impl.dart';

// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Notifier for Mapped Projects (Employee)
// class MappedProjectNotifier
//     extends StateNotifier<AsyncValue<List<MappedProject>>> {
//   final Ref ref;

//   MappedProjectNotifier(this.ref) : super(const AsyncLoading()) {
//     loadMappedProjects();
//   }

//   Future<void> loadMappedProjects() async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError('Not logged in', StackTrace.current);
//         return;
//       }

//       final repo = ref.read(projectRepositoryProvider);
//       final projects = await repo.getMappedProjects(user.empId);
//       state = AsyncData(projects);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }
// }

// // Notifier for Team Projects (Manager)
// class TeamProjectNotifier
//     extends StateNotifier<AsyncValue<List<ProjectModel>>> {
//   final Ref ref;

//   TeamProjectNotifier(this.ref) : super(const AsyncLoading()) {
//     loadTeamProjects();
//   }

//   Future<void> loadTeamProjects() async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null || !user.isManagerial) {
//         state = AsyncData(<ProjectModel>[]);
//         return;
//       }

//       final repo = ref.read(projectRepositoryProvider);
//       final projects = await repo.getTeamProjects(user.empId);
//       state = AsyncData(projects);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }
// }

// // Repository provider
// final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
//   return ProjectRepositoryImpl();
// });

// // lib/features/project/presentation/providers/project_notifier.dart
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/projects/data/services/repository/project_repository.dart';
// import 'package:appattendance/features/projects/data/services/repository/project_repository_impl.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProjectNotifier extends StateNotifier<AsyncValue<List<MappedProject>>> {
//   final Ref ref;

//   ProjectNotifier(this.ref) : super(const AsyncLoading()) {
//     loadMappedProjects();
//   }

//   Future<void> loadMappedProjects() async {
//     state = const AsyncLoading();
//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError('Not logged in', StackTrace.current);
//         return;
//       }

//       final repo = ref.read(projectRepositoryProvider);
//       final projects = await repo.getMappedProjects(user.empId);
//       state = AsyncData(projects);
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   // Team projects (for manager)
//   Future<void> loadTeamProjects() async {
//     // Similar logic using getTeamProjects
//   }
// }

// // Repository provider
// final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
//   return ProjectRepositoryImpl();
// });
