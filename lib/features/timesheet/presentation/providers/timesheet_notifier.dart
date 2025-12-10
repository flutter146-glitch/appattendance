// lib/features/timesheet/presentation/providers/timesheet_notifier.dart
import 'package:appattendance/features/projects/domain/models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timesheetProvider =
    StateNotifierProvider<TimesheetNotifier, AsyncValue<List<TaskModel>>>((
      ref,
    ) {
      return TimesheetNotifier();
    });

class TimesheetNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  TimesheetNotifier() : super(const AsyncLoading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    await Future.delayed(const Duration(milliseconds: 800));
    state = AsyncData([
      TaskModel(
        taskId: "T001",
        projectId: "P001",
        projectName: "Nutantek App",
        taskName: "Fix Login Bug",
        type: "Bug Fix",
        priority: TaskPriority.urgent,
        estEndDate: DateTime.now().add(const Duration(days: 2)),
        estEffortHrs: 4,
        status: TaskStatus.open,
        description: "Login crashing on Android 14",
        billable: true,
      ),
    ]);
  }
}
