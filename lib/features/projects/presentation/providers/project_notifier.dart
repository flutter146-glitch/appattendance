// lib/features/projects/presentation/providers/project_notifier.dart
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectNotifier extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  ProjectNotifier() : super(const AsyncLoading()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData([
      ProjectModel(id: "1", name: "Nutantek Attendance App", status: "active"),
      ProjectModel(id: "2", name: "Banking System", status: "planning"),
    ]);
  }
}

final projectProvider =
    StateNotifierProvider<ProjectNotifier, AsyncValue<List<ProjectModel>>>((
      ref,
    ) {
      return ProjectNotifier();
    });
