// lib/features/project/presentation/providers/project_provider.dart
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/projects/presentation/providers/project_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Employee ke mapped projects (with project details)
final mappedProjectProvider =
    StateNotifierProvider<
      MappedProjectNotifier,
      AsyncValue<List<MappedProject>>
    >((ref) {
      return MappedProjectNotifier(ref);
    });

// 2. Manager ke team projects (unique projects)
final teamProjectProvider =
    StateNotifierProvider<TeamProjectNotifier, AsyncValue<List<ProjectModel>>>((
      ref,
    ) {
      return TeamProjectNotifier(ref);
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
