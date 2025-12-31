// lib/features/project/presentation/providers/project_notifier.dart
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/data/services/repository/project_repository.dart';
import 'package:appattendance/features/projects/data/services/repository/project_repository_impl.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier for Mapped Projects (Employee)
class MappedProjectNotifier
    extends StateNotifier<AsyncValue<List<MappedProject>>> {
  final Ref ref;

  MappedProjectNotifier(this.ref) : super(const AsyncLoading()) {
    loadMappedProjects();
  }

  Future<void> loadMappedProjects() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError('Not logged in', StackTrace.current);
        return;
      }

      final repo = ref.read(projectRepositoryProvider);
      final projects = await repo.getMappedProjects(user.empId);
      state = AsyncData(projects);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

// Notifier for Team Projects (Manager)
class TeamProjectNotifier
    extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  final Ref ref;

  TeamProjectNotifier(this.ref) : super(const AsyncLoading()) {
    loadTeamProjects();
  }

  Future<void> loadTeamProjects() async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authProvider).value;
      if (user == null || !user.isManagerial) {
        state = AsyncData(<ProjectModel>[]);
        return;
      }

      final repo = ref.read(projectRepositoryProvider);
      final projects = await repo.getTeamProjects(user.empId);
      state = AsyncData(projects);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

// Repository provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl();
});





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
