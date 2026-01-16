// lib/features/projects/domain/models/project_model.dart

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

// ── Enums ───────────────────────────────────────────────────────────────────
enum ProjectStatus { active, inactive, completed, onHold, cancelled }

enum ProjectPriority { urgent, high, medium, low }

// ── Mapped Project (Employee-Project Mapping) ───────────────────────────────
@freezed
class MappedProject with _$MappedProject {
  const factory MappedProject({
    required String empId,
    required String projectId,
    required String mappingStatus, // 'active', 'inactive', etc.
    required ProjectModel project, // Full project details
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MappedProject;

  factory MappedProject.fromJson(Map<String, dynamic> json) =>
      _$MappedProjectFromJson(json);
}

// ── Main Project Model ──────────────────────────────────────────────────────
@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    // Core identifiers
    required String projectId, // PK
    required String projectName,
    required String orgShortName, // e.g., "NUTANTEK"
    // Details
    String? projectDescription,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? techStack,
    String? mngName, // Project Manager name
    String? mngEmail,
    String? mngContact,

    // Timeline (from dummy_data)
    String? estdStartDate, // ← String as in dummy_data
    String? estdEndDate, // ← String as in dummy_data
    String? estdEffort, // ← String (e.g., "765 Man Days")
    String? estdCost, // ← String (e.g., "₹ 50,000")
    DateTime? assignedDate,
    DateTime? startDate,
    DateTime? endDate,

    // Status & Priority
    @Default(ProjectStatus.active) ProjectStatus status,
    @Default(ProjectPriority.medium) ProjectPriority priority,

    // Progress & Analytics (from DB or computed)
    @Default(0.0) double progress, // 0.0 to 100.0
    @Default(0) int totalTasks,
    @Default(0) int completedTasks,
    @Default(0) int teamSize, // From employee_mapped_projects count
    // Audit
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  // ── Computed & UI Helpers ─────────────────────────────────────────────────

  /// Formatted project duration (using estdStartDate & estdEndDate if available)
  String get durationDisplay {
    if (estdStartDate == null || estdEndDate == null) return 'Not scheduled';
    try {
      final start = DateTime.parse(estdStartDate!);
      final end = DateTime.parse(estdEndDate!);
      final days = end.difference(start).inDays;
      return days > 0 ? '$days days' : 'Ongoing';
    } catch (_) {
      return 'Not scheduled';
    }
  }

  /// Days left until deadline (using estdEndDate)
  int get daysLeft {
    if (estdEndDate == null) return 0;
    try {
      final end = DateTime.parse(estdEndDate!);
      return end.difference(DateTime.now()).inDays;
    } catch (_) {
      return 0;
    }
  }

  String get daysLeftDisplay {
    final days = daysLeft;
    if (days > 30) return '$days days left';
    if (days > 14) return '$days days left (watch)';
    if (days > 7) return '$days days left (urgent)';
    if (days > 0) return '$days days left (critical)';
    if (days == 0) return 'Due today!';
    return 'Overdue by ${-days} day${-days == 1 ? '' : 's'}';
  }

  /// Progress percentage string
  String get progressText => '${progress.toStringAsFixed(0)}%';

  /// Progress color (gradient-friendly)
  Color get progressColor {
    if (progress >= 90) return Colors.green.shade700;
    if (progress >= 70) return Colors.blue.shade600;
    if (progress >= 50) return Colors.orange.shade600;
    if (progress >= 30) return Colors.deepOrange.shade600;
    return Colors.red.shade700;
  }

  /// Status badge color
  Color get statusColor => switch (status) {
    ProjectStatus.active => Colors.green.shade700,
    ProjectStatus.inactive => Colors.grey.shade600,
    ProjectStatus.completed => Colors.blue.shade700,
    ProjectStatus.onHold => Colors.orange.shade700,
    ProjectStatus.cancelled => Colors.red.shade700,
  };

  Color get statusBackground => statusColor.withOpacity(0.12);

  /// Priority badge color + text
  Color get priorityColor => switch (priority) {
    ProjectPriority.urgent => Colors.red.shade700,
    ProjectPriority.high => Colors.orange.shade700,
    ProjectPriority.medium => Colors.blue.shade600,
    ProjectPriority.low => Colors.green.shade600,
  };

  String get priorityText =>
      priority.name[0].toUpperCase() + priority.name.substring(1);

  /// Status icon
  IconData get statusIcon => switch (status) {
    ProjectStatus.active => Icons.play_arrow_rounded,
    ProjectStatus.inactive => Icons.pause_rounded,
    ProjectStatus.completed => Icons.check_circle_rounded,
    ProjectStatus.onHold => Icons.hourglass_empty_rounded,
    ProjectStatus.cancelled => Icons.cancel_rounded,
  };

  /// Quick summary (most used in cards/lists)
  String get quickSummary {
    final taskPercent = totalTasks > 0
        ? (completedTasks / totalTasks * 100).toStringAsFixed(0)
        : '0';
    return '$taskPercent% tasks • $teamSize members • $progressText done';
  }

  /// Formatted dates (using estdStartDate & estdEndDate if available)
  String get startDateDisplay {
    if (estdStartDate == null) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(estdStartDate!));
    } catch (_) {
      return estdStartDate!;
    }
  }

  String get endDateDisplay {
    if (estdEndDate == null) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(estdEndDate!));
    } catch (_) {
      return estdEndDate!;
    }
  }

  /// Is project overdue?
  bool get isOverdue => daysLeft < 0;

  /// Is project near deadline (within 7 days)?
  bool get isCritical => daysLeft > 0 && daysLeft <= 7;
}
// // lib/features/projects/domain/models/project_model.dart
// // FINAL MERGED & UPGRADED VERSION - January 07, 2026
// // ProjectModel now covers both core project data + analytics fields (teamSize, totalTasks, daysLeft, progress, teamMembers)
// // No need for separate ProjectAnalytics - one model for everything
// // Null-safe, role-based helpers, aligned with latest dummy data & table

// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'project_model.freezed.dart';
// part 'project_model.g.dart';

// enum ProjectStatus { active, inactive, completed, onHold, cancelled }

// enum ProjectPriority { urgent, high, medium, low }

// @freezed
// class ProjectModel with _$ProjectModel {
//   const ProjectModel._();

//   const factory ProjectModel({
//     required String projectId,
//     required String orgShortName,
//     required String projectName,
//     String? projectSite,
//     String? clientName,
//     String? clientLocation,
//     String? clientContact,
//     String? mngName,
//     String? mngEmail,
//     String? mngContact,
//     String? projectDescription,
//     String? projectTechstack,
//     String? projectAssignedDate,
//     String? estdStartDate,
//     String? estdEndDate,
//     String? estdEffort,
//     String? estdCost,
//     @Default(ProjectStatus.active) ProjectStatus status,
//     @Default(ProjectPriority.high) ProjectPriority priority,
//     @Default(0.0) double progress, // 0.0 to 100.0
//     @Default(0) int teamSize, // ← From analytics
//     @Default(0) int totalTasks, // ← From analytics
//     @Default(0) int completedTasks, // ← From analytics
//     @Default(0) int daysLeft, // ← From analytics
//     // @Default([]) List<String> teamMemberIds, // empIds
//     // @Default([]) List<String> teamMemberNames, // Names (manager view ke liye)
//     // Replace old teamMemberNames/teamMemberIds
//     @Default([]) List<teamMembers> teamMembers,
//     DateTime? startDate,
//     DateTime? endDate,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _ProjectModel;

//   factory ProjectModel.fromJson(Map<String, dynamic> json) =>
//       _$ProjectModelFromJson(json);

//   // Computed helpers for UI
//   String get displayStatus => status.name.toUpperCase();
//   String get displayPriority => priority.name.toUpperCase();
//   String get progressString => '${progress.toStringAsFixed(1)}%';
//   bool get isActive => status == ProjectStatus.active;
//   String get formattedDaysLeft =>
//       daysLeft > 0 ? '$daysLeft days left' : 'Overdue';
// }

// @freezed
// class MappedProject with _$MappedProject {
//   const MappedProject._();
//   const factory MappedProject({
//     required String empId,
//     required String projectId,
//     required String mappingStatus,
//     required ProjectModel project,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _MappedProject;
//   factory MappedProject.fromJson(Map<String, dynamic> json) =>
//       _$MappedProjectFromJson(json);
// }

// // Extension for extra helpers
// extension ProjectModelExtension on ProjectModel {
//   Color get priorityColor {
//     return switch (priority) {
//       ProjectPriority.urgent => Colors.red,
//       ProjectPriority.high => Colors.orange,
//       ProjectPriority.medium => Colors.yellow,
//       ProjectPriority.low => Colors.green,
//     };
//   }

//   Color get statusColor {
//     return switch (status) {
//       ProjectStatus.active => Colors.green,
//       ProjectStatus.completed => Colors.blue,
//       ProjectStatus.onHold => Colors.orange,
//       ProjectStatus.cancelled => Colors.red,
//       ProjectStatus.inactive => Colors.grey,
//     };
//   }
// }

// // DB Factory (null-safe, fully aligned with latest table + dummy data)
// ProjectModel projectFromDB(Map<String, dynamic> row) {
//   return ProjectModel(
//     projectId: row['project_id'] as String? ?? '',
//     orgShortName: row['org_short_name'] as String? ?? 'NUTANTEK',
//     projectName: row['project_name'] as String? ?? 'Unnamed Project',
//     projectSite: row['project_site'] as String?,
//     clientName: row['client_name'] as String?,
//     clientLocation: row['client_location'] as String?,
//     clientContact: row['client_contact'] as String?,
//     mngName: row['mng_name'] as String?,
//     mngEmail: row['mng_email'] as String?,
//     mngContact: row['mng_contact'] as String?,
//     projectDescription: row['project_description'] as String?,
//     projectTechstack: row['project_techstack'] as String?,
//     projectAssignedDate: row['project_assigned_date'] as String?,
//     estdStartDate: row['estd_start_date'] as String?,
//     estdEndDate: row['estd_end_date'] as String?,
//     estdEffort: row['estd_effort'] as String?,
//     estdCost: row['estd_cost'] as String?,
//     status: _mapProjectStatus(row['status'] as String? ?? 'active'),
//     priority: _mapProjectPriority(row['priority'] as String? ?? 'HIGH'),
//     progress: (row['progress'] as num?)?.toDouble() ?? 0.0,
//     teamSize: row['team_size'] as int? ?? 0,
//     totalTasks: row['total_tasks'] as int? ?? 0,
//     completedTasks: row['completed_tasks'] as int? ?? 0,
//     daysLeft: row['days_left'] as int? ?? 0,
//     // teamMemberIds: [], // Populate from join query
//     // teamMemberNames: [], // Populate from join query
//     startDate: _parseDate(row['start_date'] as String?),
//     endDate: _parseDate(row['end_date'] as String?),
//     createdAt: _parseDate(row['created_at'] as String?),
//     updatedAt: _parseDate(row['updated_at'] as String?),
//   );
// }

// ProjectStatus _mapProjectStatus(String? status) {
//   final lower = (status ?? '').toLowerCase();
//   return switch (lower) {
//     'inactive' => ProjectStatus.inactive,
//     'completed' => ProjectStatus.completed,
//     'onhold' => ProjectStatus.onHold,
//     'cancelled' => ProjectStatus.cancelled,
//     _ => ProjectStatus.active,
//   };
// }

// ProjectPriority _mapProjectPriority(String? priority) {
//   final lower = (priority ?? '').toLowerCase();
//   return switch (lower) {
//     'urgent' => ProjectPriority.urgent,
//     'medium' => ProjectPriority.medium,
//     'low' => ProjectPriority.low,
//     _ => ProjectPriority.high,
//   };
// }

// DateTime? _parseDate(String? dateStr) {
//   if (dateStr == null) return null;
//   try {
//     return DateTime.parse(dateStr);
//   } catch (_) {
//     return null;
//   }
// }
