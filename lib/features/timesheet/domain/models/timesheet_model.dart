// lib/features/timesheet/domain/models/timesheet_model.dart

import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'timesheet_model.freezed.dart';
part 'timesheet_model.g.dart';

// ==============================
// ENUMS (Simple & Practical)
// ==============================

enum TimesheetStatus {
  @JsonValue('draft')
  draft,

  @JsonValue('submitted')
  submitted,

  @JsonValue('approved')
  approved,

  @JsonValue('rejected')
  rejected,
}

enum TaskType {
  @JsonValue('Development')
  development,

  @JsonValue('Testing')
  testing,

  @JsonValue('Design')
  design,

  @JsonValue('Documentation')
  documentation,

  @JsonValue('Meeting')
  meeting,

  @JsonValue('Support')
  support,

  @JsonValue('Training')
  training,

  @JsonValue('Other')
  other,
}

// ==============================
// MAIN TIMESHEET ENTRY MODEL
// ==============================

@freezed
class TimesheetEntry with _$TimesheetEntry {
  const TimesheetEntry._();

  const factory TimesheetEntry({
    required String entryId, // timesheet_entry_id
    required String empId, // emp_id
    required String projectId, // project_id
    required String taskDescription, // task_description
    required TaskType taskType, // task_type
    required DateTime workDate, // work_date
    required double hours, // hours (decimal: 1.5, 2.0, 0.5)
    String? comments, // comments/notes
    required TimesheetStatus status, // status
    String? managerComments, // manager_comments
    DateTime? submittedAt, // submitted_at
    DateTime? approvedAt, // approved_at
    DateTime? createdAt, // created_at
    DateTime? updatedAt, // updated_at
    // Additional context
    String? projectName, // from project_master
    String? empName, // from employee_master
    String? managerId, // manager_id for approval
    String? managerName, // manager name
  }) = _TimesheetEntry;

  factory TimesheetEntry.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEntryFromJson(json);
}

// ==============================
// TIMESHEET (WEEKLY/MONTHLY VIEW)
// ==============================

@freezed
class Timesheet with _$Timesheet {
  const Timesheet._();

  const factory Timesheet({
    required String timesheetId, // Custom ID: TS_YYYYMMDD_EMPID
    required String empId, // emp_id
    required DateTime startDate, // Week/Month start
    required DateTime endDate, // Week/Month end
    required List<TimesheetEntry> entries,
    required double totalHours, // Total hours
    required TimesheetStatus status, // Overall status
    String? comments, // Employee comments
    String? managerComments, // Manager comments
    DateTime? submittedAt, // When submitted
    DateTime? approvedAt, // When approved
    DateTime? createdAt, // created_at
    DateTime? updatedAt, // updated_at
    // Additional info
    String? empName, // Employee name
    String? managerId, // Approving manager
    String? managerName, // Manager name
  }) = _Timesheet;

  factory Timesheet.fromJson(Map<String, dynamic> json) =>
      _$TimesheetFromJson(json);
}

// ==============================
// COMPUTED PROPERTIES EXTENSION
// ==============================

extension TimesheetEntryExtension on TimesheetEntry {
  bool get isDraft => status == TimesheetStatus.draft;
  bool get isSubmitted => status == TimesheetStatus.submitted;
  bool get isApproved => status == TimesheetStatus.approved;
  bool get isRejected => status == TimesheetStatus.rejected;

  bool get canEdit => isDraft;
  bool get canSubmit => isDraft && hours > 0;
  bool get canDelete => isDraft;

  String get statusDisplay {
    switch (status) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Submitted';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
    }
  }

  String get taskTypeDisplay {
    return taskType
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(workDate);
  }

  String get formattedHours {
    final hoursInt = hours.floor();
    final minutes = ((hours - hoursInt) * 60).round();

    if (hoursInt > 0 && minutes > 0) {
      return '${hoursInt}h ${minutes}m';
    } else if (hoursInt > 0) {
      return '${hoursInt}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    }
    return '0h';
  }

  // Check if current user can approve this entry
  bool canApprove(UserModel currentUser) {
    // User can't approve own entry
    if (currentUser.empId == empId) return false;

    // Manager can approve if they're the assigned manager
    if (currentUser.empId == managerId) return true;

    // HR/Admin can approve any
    if (currentUser.role == UserRole.hrManager ||
        currentUser.role == UserRole.admin) {
      return true;
    }

    return false;
  }

  // Check if current user can view this entry
  bool canView(UserModel currentUser) {
    // Can view own entries
    if (currentUser.empId == empId) return true;

    // Manager can view team entries
    if (currentUser.isManagerial && currentUser.empId == managerId) {
      return true;
    }

    // HR/Admin can view all
    if (currentUser.role == UserRole.hrManager ||
        currentUser.role == UserRole.admin) {
      return true;
    }

    return false;
  }
}

extension TimesheetExtension on Timesheet {
  bool get isDraft => status == TimesheetStatus.draft;
  bool get isSubmitted => status == TimesheetStatus.submitted;
  bool get isApproved => status == TimesheetStatus.approved;
  bool get isRejected => status == TimesheetStatus.rejected;

  bool get canEdit => isDraft;
  bool get canSubmit => isDraft && totalHours > 0;
  bool get canApprove => isSubmitted;
  bool get canReject => isSubmitted;

  String get statusDisplay {
    switch (status) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Submitted';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
    }
  }

  String get dateRange {
    final format = DateFormat('dd MMM yyyy');
    return '${format.format(startDate)} - ${format.format(endDate)}';
  }

  // Get billable vs non-billable breakdown (if you add billing later)
  Map<String, double> get projectWiseHours {
    final breakdown = <String, double>{};

    for (final entry in entries) {
      final key = entry.projectName ?? entry.projectId;
      breakdown[key] = (breakdown[key] ?? 0) + entry.hours;
    }

    return breakdown;
  }

  // Get daily hours breakdown
  Map<String, double> get dailyHours {
    final breakdown = <String, double>{};

    for (final entry in entries) {
      final dateKey = DateFormat('dd MMM').format(entry.workDate);
      breakdown[dateKey] = (breakdown[dateKey] ?? 0) + entry.hours;
    }

    return breakdown;
  }
}

// ==============================
// DB FACTORY FUNCTIONS
// ==============================

TimesheetEntry timesheetEntryFromDB(
  Map<String, dynamic> row,
  Map<String, dynamic>? empData,
  Map<String, dynamic>? projectData,
) {
  return TimesheetEntry(
    entryId: row['timesheet_entry_id'] as String,
    empId: row['emp_id'] as String,
    projectId: row['project_id'] as String,
    taskDescription: row['task_description'] as String? ?? '',
    taskType: _mapTaskType(row['task_type'] as String?),
    workDate: DateTime.parse(row['work_date'] as String),
    hours: (row['hours'] as num).toDouble(),
    comments: row['comments'] as String?,
    status: _mapStatus(row['status'] as String),
    managerComments: row['manager_comments'] as String?,
    submittedAt: row['submitted_at'] != null
        ? DateTime.parse(row['submitted_at'] as String)
        : null,
    approvedAt: row['approved_at'] != null
        ? DateTime.parse(row['approved_at'] as String)
        : null,
    createdAt: row['created_at'] != null
        ? DateTime.parse(row['created_at'] as String)
        : null,
    updatedAt: row['updated_at'] != null
        ? DateTime.parse(row['updated_at'] as String)
        : null,
    projectName: projectData?['project_name'] as String?,
    empName: empData?['emp_name'] as String?,
    managerId: row['manager_id'] as String?,
  );
}

Timesheet timesheetFromDB(
  Map<String, dynamic> row,
  List<Map<String, dynamic>> entryRows,
  Map<String, dynamic>? empData,
  Map<String, dynamic>? managerData,
) {
  final entries = <TimesheetEntry>[];

  for (final entryRow in entryRows) {
    entries.add(timesheetEntryFromDB(entryRow, empData, null));
  }

  return Timesheet(
    timesheetId: row['timesheet_id'] as String,
    empId: row['emp_id'] as String,
    startDate: DateTime.parse(row['start_date'] as String),
    endDate: DateTime.parse(row['end_date'] as String),
    entries: entries,
    totalHours: (row['total_hours'] as num).toDouble(),
    status: _mapStatus(row['status'] as String),
    comments: row['comments'] as String?,
    managerComments: row['manager_comments'] as String?,
    submittedAt: row['submitted_at'] != null
        ? DateTime.parse(row['submitted_at'] as String)
        : null,
    approvedAt: row['approved_at'] != null
        ? DateTime.parse(row['approved_at'] as String)
        : null,
    createdAt: row['created_at'] != null
        ? DateTime.parse(row['created_at'] as String)
        : null,
    updatedAt: row['updated_at'] != null
        ? DateTime.parse(row['updated_at'] as String)
        : null,
    empName: empData?['emp_name'] as String?,
    managerId: row['manager_id'] as String?,
    managerName: managerData?['emp_name'] as String?,
  );
}

// Helper functions
TimesheetStatus _mapStatus(String? status) {
  final lower = (status ?? '').toLowerCase();
  if (lower == 'submitted') return TimesheetStatus.submitted;
  if (lower == 'approved') return TimesheetStatus.approved;
  if (lower == 'rejected') return TimesheetStatus.rejected;
  return TimesheetStatus.draft;
}

TaskType _mapTaskType(String? type) {
  final lower = (type ?? '').toLowerCase();
  if (lower.contains('dev')) return TaskType.development;
  if (lower.contains('test')) return TaskType.testing;
  if (lower.contains('design')) return TaskType.design;
  if (lower.contains('doc')) return TaskType.documentation;
  if (lower.contains('meet')) return TaskType.meeting;
  if (lower.contains('support')) return TaskType.support;
  if (lower.contains('train')) return TaskType.training;
  return TaskType.other;
}

// ==============================
// TIMESHEET REQUEST MODELS
// ==============================

@freezed
class TimesheetRequest with _$TimesheetRequest {
  const factory TimesheetRequest({
    required String empId,
    required DateTime startDate,
    required DateTime endDate,
    required List<TimesheetEntryRequest> entries,
    String? comments,
    String? managerId,
  }) = _TimesheetRequest;

  factory TimesheetRequest.fromJson(Map<String, dynamic> json) =>
      _$TimesheetRequestFromJson(json);
}

@freezed
class TimesheetEntryRequest with _$TimesheetEntryRequest {
  const factory TimesheetEntryRequest({
    required String projectId,
    required String taskDescription,
    required TaskType taskType,
    required DateTime workDate,
    required double hours,
    String? comments,
    String? managerId,
  }) = _TimesheetEntryRequest;

  factory TimesheetEntryRequest.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEntryRequestFromJson(json);
}

// ==============================
// TIMESHEET STATS MODELS
// ==============================

@freezed
class TimesheetStats with _$TimesheetStats {
  const factory TimesheetStats({
    @Default(0) int draftCount,
    @Default(0) int submittedCount,
    @Default(0) int approvedCount,
    @Default(0) int rejectedCount,
    @Default(0.0) double totalHoursThisWeek,
    @Default(0.0) double totalHoursThisMonth,
    @Default(0.0) double averageDailyHours,
  }) = _TimesheetStats;

  factory TimesheetStats.fromJson(Map<String, dynamic> json) =>
      _$TimesheetStatsFromJson(json);
}

@freezed
class ManagerTimesheetStats with _$ManagerTimesheetStats {
  const factory ManagerTimesheetStats({
    @Default(0) int teamPending,
    @Default(0) int teamApproved,
    @Default(0) int teamRejected,
    @Default(0) int selfPending,
    @Default(0) int selfApproved,
    @Default(0.0) double teamTotalHours,
  }) = _ManagerTimesheetStats;

  factory ManagerTimesheetStats.fromJson(Map<String, dynamic> json) =>
      _$ManagerTimesheetStatsFromJson(json);
}

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'timesheet_model.freezed.dart';
// part 'timesheet_model.g.dart';

// // ==============================
// // ENUMS
// // ==============================

// /// Timesheet entry status
// enum TimesheetStatus {
//   @JsonValue('draft')
//   draft, // Draft (not submitted)

//   @JsonValue('saved')
//   saved, // Saved but not submitted

//   @JsonValue('submitted')
//   submitted, // Submitted for approval

//   @JsonValue('approved')
//   approved, // Approved by manager

//   @JsonValue('rejected')
//   rejected, // Rejected by manager

//   @JsonValue('query')
//   query, // Query raised by manager

//   @JsonValue('pending_review')
//   pendingReview, // Pending review

//   @JsonValue('partially_approved')
//   partiallyApproved, // Partially approved

//   @JsonValue('auto_approved')
//   autoApproved, // Auto-approved by system

//   @JsonValue('locked')
//   locked, // Locked (cannot be modified)

//   @JsonValue('cancelled')
//   cancelled, // Cancelled by employee
// }

// /// Task type for timesheet entries
// enum TaskType {
//   @JsonValue('development')
//   development, // Development work

//   @JsonValue('testing')
//   testing, // Testing/QA

//   @JsonValue('design')
//   design, // Design work

//   @JsonValue('analysis')
//   analysis, // Analysis/planning

//   @JsonValue('meeting')
//   meeting, // Meetings

//   @JsonValue('documentation')
//   documentation, // Documentation

//   @JsonValue('support')
//   support, // Support/maintenance

//   @JsonValue('training')
//   training, // Training

//   @JsonValue('research')
//   research, // Research

//   @JsonValue('administrative')
//   administrative, // Administrative work

//   @JsonValue('client_communication')
//   clientCommunication, // Client communication

//   @JsonValue('code_review')
//   codeReview, // Code review

//   @JsonValue('deployment')
//   deployment, // Deployment

//   @JsonValue('bug_fixing')
//   bugFixing, // Bug fixing

//   @JsonValue('other')
//   other, // Other tasks
// }

// /// Billing status for timesheet entries
// enum BillingStatus {
//   @JsonValue('billable')
//   billable, // Billable to client

//   @JsonValue('non_billable')
//   nonBillable, // Non-billable (internal)

//   @JsonValue('partially_billable')
//   partiallyBillable, // Partially billable

//   @JsonValue('not_defined')
//   notDefined, // Not defined
// }

// /// Timesheet submission frequency
// enum TimesheetFrequency {
//   @JsonValue('daily')
//   daily, // Daily submission

//   @JsonValue('weekly')
//   weekly, // Weekly submission

//   @JsonValue('bi_weekly')
//   biWeekly, // Bi-weekly submission

//   @JsonValue('monthly')
//   monthly, // Monthly submission

//   @JsonValue('project_based')
//   projectBased, // Project-based submission
// }

// /// Timesheet entry source
// enum TimesheetSource {
//   @JsonValue('manual_entry')
//   manualEntry, // Manually entered

//   @JsonValue('auto_generated')
//   autoGenerated, // Auto-generated from system

//   @JsonValue('imported')
//   imported, // Imported from other system

//   @JsonValue('mobile_app')
//   mobileApp, // From mobile app

//   @JsonValue('api')
//   api, // From API integration
// }

// // ==============================
// // MAIN TIMESHEET ENTRY MODEL
// // ==============================

// @freezed
// class TimesheetEntry with _$TimesheetEntry {
//   const TimesheetEntry._();

//   const factory TimesheetEntry({
//     // ========== IDENTITY FIELDS ==========
//     /// Timesheet entry ID (Primary Key) - Format: TS20251215EMP001001
//     @JsonKey(name: 'timesheet_entry_id') required String entryId,

//     /// Timesheet ID (for grouping entries)
//     @JsonKey(name: 'timesheet_id') required String timesheetId,

//     /// Employee ID
//     @JsonKey(name: 'emp_id') required String employeeId,

//     /// Organization short name
//     @JsonKey(name: 'org_short_name') required String orgShortName,

//     // ========== PROJECT & TASK DETAILS ==========
//     /// Project ID
//     @JsonKey(name: 'project_id') required String projectId,

//     /// Task ID (optional)
//     @JsonKey(name: 'task_id') String? taskId,

//     /// Task name/description
//     @JsonKey(name: 'task_description') required String taskDescription,

//     /// Task type
//     @JsonKey(name: 'task_type')
//     @Default(TaskType.development)
//     TaskType taskType,

//     /// Subtask/activity details
//     @JsonKey(name: 'subtask') String? subtask,

//     /// Task category
//     @JsonKey(name: 'task_category') String? taskCategory,

//     /// Task tags
//     @Default(<String>[]) List<String> taskTags,

//     /// Billing status
//     @JsonKey(name: 'billing_status')
//     @Default(BillingStatus.billable)
//     BillingStatus billingStatus,

//     /// Billing rate per hour
//     @JsonKey(name: 'billing_rate') double? billingRate,

//     /// Billing amount for this entry
//     @JsonKey(name: 'billing_amount') double? billingAmount,

//     // ========== TIME TRACKING ==========
//     /// Date of work
//     @JsonKey(
//       name: 'work_date',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     required DateTime workDate,

//     /// Start time
//     @JsonKey(name: 'start_time', fromJson: _timeFromJson, toJson: _timeToJson)
//     required String startTime,

//     /// End time
//     @JsonKey(name: 'end_time', fromJson: _timeFromJson, toJson: _timeToJson)
//     required String endTime,

//     /// Break duration in minutes
//     @JsonKey(name: 'break_duration_minutes')
//     @Default(0)
//     int breakDurationMinutes,

//     /// Actual worked hours (calculated)
//     @JsonKey(name: 'worked_hours') required double workedHours,

//     /// Overtime hours
//     @JsonKey(name: 'overtime_hours') @Default(0.0) double overtimeHours,

//     /// Productive hours (after subtracting breaks, meetings, etc.)
//     @JsonKey(name: 'productive_hours') double? productiveHours,

//     /// Time tracking method
//     @JsonKey(name: 'tracking_method') String? trackingMethod,

//     /// Timezone of entry
//     @JsonKey(name: 'timezone') String? timezone,

//     // ========== ENTRY DETAILS ==========
//     /// Entry status
//     @JsonKey(name: 'entry_status')
//     @Default(TimesheetStatus.draft)
//     TimesheetStatus status,

//     /// Entry source
//     @JsonKey(name: 'source')
//     @Default(TimesheetSource.manualEntry)
//     TimesheetSource source,

//     /// Detailed description/notes
//     @JsonKey(name: 'description') String? description,

//     /// Deliverables/outputs
//     @JsonKey(name: 'deliverables') String? deliverables,

//     /// Issues/challenges faced
//     @JsonKey(name: 'issues') String? issues,

//     /// Solutions implemented
//     @JsonKey(name: 'solutions') String? solutions,

//     /// Lessons learned
//     @JsonKey(name: 'lessons_learned') String? lessonsLearned,

//     /// Attachment URLs
//     @Default(<TimesheetAttachment>[]) List<TimesheetAttachment> attachments,

//     /// Screenshot/image URLs for proof of work
//     @JsonKey(name: 'screenshot_urls') List<String>? screenshotUrls,

//     // ========== PRODUCTIVITY METRICS ==========
//     /// Productivity score (0-100)
//     @JsonKey(name: 'productivity_score') double? productivityScore,

//     /// Quality score (0-100)
//     @JsonKey(name: 'quality_score') double? qualityScore,

//     /// Complexity level (1-5)
//     @JsonKey(name: 'complexity_level') int? complexityLevel,

//     /// Priority level (1-5)
//     @JsonKey(name: 'priority_level') int? priorityLevel,

//     /// Estimated vs actual hours comparison
//     @JsonKey(name: 'estimation_variance') double? estimationVariance,

//     // ========== APPROVAL & REVIEW ==========
//     /// Manager ID for approval
//     @JsonKey(name: 'manager_id') required String managerId,

//     /// Approved by ID
//     @JsonKey(name: 'approved_by') String? approvedById,

//     /// Approved timestamp
//     @JsonKey(
//       name: 'approved_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? approvedAt,

//     /// Rejected by ID
//     @JsonKey(name: 'rejected_by') String? rejectedById,

//     /// Rejected timestamp
//     @JsonKey(
//       name: 'rejected_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? rejectedAt,

//     /// Query raised by ID
//     @JsonKey(name: 'query_raised_by') String? queryRaisedById,

//     /// Query raised timestamp
//     @JsonKey(
//       name: 'query_raised_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? queryRaisedAt,

//     /// Query comments
//     @JsonKey(name: 'query_comments') String? queryComments,

//     /// Query response
//     @JsonKey(name: 'query_response') String? queryResponse,

//     /// Manager comments
//     @JsonKey(name: 'manager_comments') String? managerComments,

//     /// HR comments
//     @JsonKey(name: 'hr_comments') String? hrComments,

//     /// Review notes
//     @JsonKey(name: 'review_notes') String? reviewNotes,

//     // ========== WORKFLOW & AUDIT ==========
//     /// Workflow stage
//     @JsonKey(name: 'workflow_stage') @Default(1) int workflowStage,

//     /// Total workflow stages
//     @JsonKey(name: 'total_workflow_stages') @Default(2) int totalWorkflowStages,

//     /// Last action timestamp
//     @JsonKey(
//       name: 'last_action_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? lastActionAt,

//     /// Last action by
//     @JsonKey(name: 'last_action_by') String? lastActionBy,

//     /// Last action type
//     @JsonKey(name: 'last_action_type') String? lastActionType,

//     /// Version number for tracking changes
//     @JsonKey(name: 'version') @Default(1) int version,

//     /// Previous version ID (for rollback)
//     @JsonKey(name: 'previous_version_id') String? previousVersionId,

//     /// Change log/audit trail
//     @Default(<String>[]) List<String> changeLog,

//     // ========== TIMESTAMPS ==========
//     /// Entry creation timestamp
//     @JsonKey(
//       name: 'created_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     required DateTime createdAt,

//     /// Entry last update timestamp
//     @JsonKey(
//       name: 'updated_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     required DateTime updatedAt,

//     /// Submitted timestamp
//     @JsonKey(
//       name: 'submitted_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? submittedAt,

//     /// Locked timestamp
//     @JsonKey(
//       name: 'locked_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? lockedAt,

//     /// Sync status for offline mode
//     @JsonKey(name: 'sync_status') @Default(true) bool isSynced,

//     /// Last sync attempt timestamp
//     @JsonKey(
//       name: 'last_sync_at',
//       fromJson: _dateTimeFromJson,
//       toJson: _dateTimeToJson,
//     )
//     DateTime? lastSyncAt,

//     // ========== ADDITIONAL FIELDS ==========
//     /// Client ID (if applicable)
//     @JsonKey(name: 'client_id') String? clientId,

//     /// Department/team
//     @JsonKey(name: 'department') String? department,

//     /// Cost center
//     @JsonKey(name: 'cost_center') String? costCenter,

//     /// Batch ID for bulk operations
//     @JsonKey(name: 'batch_id') String? batchId,

//     /// External reference ID
//     @JsonKey(name: 'external_reference') String? externalReference,

//     /// Custom metadata
//     @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
//   }) = _TimesheetEntry;

//   // ==============================
//   // FACTORY METHODS
//   // ==============================

//   /// Create from JSON (API/DB)
//   factory TimesheetEntry.fromJson(Map<String, dynamic> json) =>
//       _$TimesheetEntryFromJson(json);

//   /// Create a new timesheet entry
//   factory TimesheetEntry.create({
//     required String entryId,
//     required String timesheetId,
//     required String employeeId,
//     required String orgShortName,
//     required String projectId,
//     required String taskDescription,
//     required DateTime workDate,
//     required String startTime,
//     required String endTime,
//     required String managerId,
//     TaskType taskType = TaskType.development,
//     String? taskId,
//     String? subtask,
//     String? description,
//     int breakDurationMinutes = 0,
//     double? billingRate,
//     BillingStatus billingStatus = BillingStatus.billable,
//     List<String> taskTags = const [],
//   }) {
//     final now = DateTime.now();
//     final workedHours = _calculateWorkedHours(
//       startTime,
//       endTime,
//       breakDurationMinutes,
//     );

//     return TimesheetEntry(
//       entryId: entryId,
//       timesheetId: timesheetId,
//       employeeId: employeeId,
//       orgShortName: orgShortName,
//       projectId: projectId,
//       taskDescription: taskDescription,
//       taskType: taskType,
//       taskId: taskId,
//       subtask: subtask,
//       taskTags: taskTags,
//       billingStatus: billingStatus,
//       billingRate: billingRate,
//       workDate: workDate,
//       startTime: startTime,
//       endTime: endTime,
//       breakDurationMinutes: breakDurationMinutes,
//       workedHours: workedHours,
//       description: description,
//       managerId: managerId,
//       status: TimesheetStatus.draft,
//       createdAt: now,
//       updatedAt: now,
//       isSynced: false,
//     );
//   }

//   /// Create from dummy data JSON
//   factory TimesheetEntry.fromDummyJson(Map<String, dynamic> json) {
//     return TimesheetEntry(
//       entryId: json['timesheet_entry_id'] as String? ?? '',
//       timesheetId: json['timesheet_id'] as String? ?? '',
//       employeeId: json['emp_id'] as String,
//       orgShortName: json['org_short_name'] as String? ?? 'NUTANTEK',
//       projectId: json['project_id'] as String,
//       taskDescription: json['task_description'] as String,
//       taskType: TaskTypeExtension.fromString(json['task_type'] as String?),
//       workDate: _parseDateTime(json['work_date'] as String?) ?? DateTime.now(),
//       startTime: json['start_time'] as String? ?? '09:00',
//       endTime: json['end_time'] as String? ?? '18:00',
//       workedHours: (json['worked_hours'] as num?)?.toDouble() ?? 8.0,
//       description: json['description'] as String?,
//       status: TimesheetStatusExtension.fromString(
//         json['entry_status'] as String?,
//       ),
//       managerId: json['manager_id'] as String? ?? '',
//       createdAt:
//           _parseDateTime(json['created_at'] as String?) ?? DateTime.now(),
//       updatedAt:
//           _parseDateTime(json['updated_at'] as String?) ?? DateTime.now(),
//       isSynced: true,
//     );
//   }

//   /// Create from database row
//   factory TimesheetEntry.fromDatabase(Map<String, dynamic> row) {
//     return TimesheetEntry.fromJson(row);
//   }

//   // ==============================
//   // COMPUTED PROPERTIES
//   // ==============================

//   /// Check if entry is draft
//   bool get isDraft => status == TimesheetStatus.draft;

//   /// Check if entry is saved
//   bool get isSaved => status == TimesheetStatus.saved;

//   /// Check if entry is submitted
//   bool get isSubmitted => status == TimesheetStatus.submitted;

//   /// Check if entry is approved
//   bool get isApproved =>
//       status == TimesheetStatus.approved ||
//       status == TimesheetStatus.autoApproved;

//   /// Check if entry is rejected
//   bool get isRejected => status == TimesheetStatus.rejected;

//   /// Check if query is raised
//   bool get isQuery => status == TimesheetStatus.query;

//   /// Check if entry is pending review
//   bool get isPendingReview => status == TimesheetStatus.pendingReview;

//   /// Check if entry is partially approved
//   bool get isPartiallyApproved => status == TimesheetStatus.partiallyApproved;

//   /// Check if entry is locked
//   bool get isLocked => status == TimesheetStatus.locked;

//   /// Check if entry is cancelled
//   bool get isCancelled => status == TimesheetStatus.cancelled;

//   /// Check if entry is editable
//   bool get isEditable => !isLocked && !isApproved && !isCancelled;

//   /// Check if entry is billable
//   bool get isBillable => billingStatus == BillingStatus.billable;

//   /// Check if entry is non-billable
//   bool get isNonBillable => billingStatus == BillingStatus.nonBillable;

//   /// Check if workflow is completed
//   bool get isWorkflowComplete => workflowStage >= totalWorkflowStages;

//   /// Check if workflow is in progress
//   bool get isWorkflowInProgress =>
//       workflowStage > 1 && workflowStage < totalWorkflowStages;

//   /// Check if response to query is pending
//   bool get isQueryResponsePending => isQuery && queryResponse == null;

//   /// Formatted work date
//   String get formattedWorkDate => _formatDate(workDate);

//   /// Day of week
//   String get dayOfWeek {
//     const days = [
//       'Sunday',
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//     ];
//     return days[workDate.weekday % 7];
//   }

//   /// Short day of week
//   String get shortDayOfWeek => dayOfWeek.substring(0, 3);

//   /// Formatted time range
//   String get formattedTimeRange => '$startTime - $endTime';

//   /// Formatted worked hours
//   String get formattedWorkedHours {
//     final hours = workedHours.floor();
//     final minutes = ((workedHours - hours) * 60).round();
//     if (hours > 0 && minutes > 0) {
//       return '${hours}h ${minutes}m';
//     } else if (hours > 0) {
//       return '${hours}h';
//     } else if (minutes > 0) {
//       return '${minutes}m';
//     }
//     return '0h';
//   }

//   /// Formatted productive hours
//   String? get formattedProductiveHours {
//     if (productiveHours == null) return null;
//     final hours = productiveHours!.floor();
//     final minutes = ((productiveHours! - hours) * 60).round();
//     if (hours > 0 && minutes > 0) {
//       return '${hours}h ${minutes}m';
//     } else if (hours > 0) {
//       return '${hours}h';
//     } else if (minutes > 0) {
//       return '${minutes}m';
//     }
//     return '0h';
//   }

//   /// Formatted overtime hours
//   String get formattedOvertimeHours {
//     if (overtimeHours <= 0) return '';
//     final hours = overtimeHours.floor();
//     final minutes = ((overtimeHours - hours) * 60).round();
//     if (hours > 0 && minutes > 0) {
//       return '${hours}h ${minutes}m OT';
//     } else if (hours > 0) {
//       return '${hours}h OT';
//     } else if (minutes > 0) {
//       return '${minutes}m OT';
//     }
//     return '';
//   }

//   /// Calculate billing amount
//   double? get calculatedBillingAmount {
//     if (billingRate == null || !isBillable) return null;
//     return billingRate! * workedHours;
//   }

//   /// Status display name
//   String get statusDisplayName {
//     switch (status) {
//       case TimesheetStatus.draft:
//         return 'Draft';
//       case TimesheetStatus.saved:
//         return 'Saved';
//       case TimesheetStatus.submitted:
//         return 'Submitted';
//       case TimesheetStatus.approved:
//         return 'Approved';
//       case TimesheetStatus.rejected:
//         return 'Rejected';
//       case TimesheetStatus.query:
//         return 'Query Raised';
//       case TimesheetStatus.pendingReview:
//         return 'Pending Review';
//       case TimesheetStatus.partiallyApproved:
//         return 'Partially Approved';
//       case TimesheetStatus.autoApproved:
//         return 'Auto Approved';
//       case TimesheetStatus.locked:
//         return 'Locked';
//       case TimesheetStatus.cancelled:
//         return 'Cancelled';
//     }
//   }

//   /// Task type display name
//   String get taskTypeDisplayName {
//     switch (taskType) {
//       case TaskType.development:
//         return 'Development';
//       case TaskType.testing:
//         return 'Testing';
//       case TaskType.design:
//         return 'Design';
//       case TaskType.analysis:
//         return 'Analysis';
//       case TaskType.meeting:
//         return 'Meeting';
//       case TaskType.documentation:
//         return 'Documentation';
//       case TaskType.support:
//         return 'Support';
//       case TaskType.training:
//         return 'Training';
//       case TaskType.research:
//         return 'Research';
//       case TaskType.administrative:
//         return 'Administrative';
//       case TaskType.clientCommunication:
//         return 'Client Communication';
//       case TaskType.codeReview:
//         return 'Code Review';
//       case TaskType.deployment:
//         return 'Deployment';
//       case TaskType.bugFixing:
//         return 'Bug Fixing';
//       case TaskType.other:
//         return 'Other';
//     }
//   }

//   /// Billing status display name
//   String get billingStatusDisplayName {
//     switch (billingStatus) {
//       case BillingStatus.billable:
//         return 'Billable';
//       case BillingStatus.nonBillable:
//         return 'Non-Billable';
//       case BillingStatus.partiallyBillable:
//         return 'Partially Billable';
//       case BillingStatus.notDefined:
//         return 'Not Defined';
//     }
//   }

//   /// Source display name
//   String get sourceDisplayName {
//     switch (source) {
//       case TimesheetSource.manualEntry:
//         return 'Manual Entry';
//       case TimesheetSource.autoGenerated:
//         return 'Auto Generated';
//       case TimesheetSource.imported:
//         return 'Imported';
//       case TimesheetSource.mobileApp:
//         return 'Mobile App';
//       case TimesheetSource.api:
//         return 'API Integration';
//     }
//   }

//   /// Get status color for UI
//   String get statusColor {
//     switch (status) {
//       case TimesheetStatus.approved:
//       case TimesheetStatus.autoApproved:
//         return '#4CAF50'; // Green
//       case TimesheetStatus.rejected:
//         return '#F44336'; // Red
//       case TimesheetStatus.submitted:
//       case TimesheetStatus.pendingReview:
//         return '#FF9800'; // Orange
//       case TimesheetStatus.query:
//         return '#FFC107'; // Amber
//       case TimesheetStatus.partiallyApproved:
//         return '#2196F3'; // Blue
//       case TimesheetStatus.locked:
//       case TimesheetStatus.cancelled:
//         return '#9E9E9E'; // Grey
//       case TimesheetStatus.draft:
//       case TimesheetStatus.saved:
//       default:
//         return '#607D8B'; // Blue Grey
//     }
//   }

//   /// Get billing status color for UI
//   String get billingStatusColor {
//     switch (billingStatus) {
//       case BillingStatus.billable:
//         return '#4CAF50'; // Green
//       case BillingStatus.nonBillable:
//         return '#F44336'; // Red
//       case BillingStatus.partiallyBillable:
//         return '#FF9800'; // Orange
//       case BillingStatus.notDefined:
//         return '#9E9E9E'; // Grey
//     }
//   }

//   /// Get task type color for UI
//   String get taskTypeColor {
//     switch (taskType) {
//       case TaskType.development:
//         return '#2196F3'; // Blue
//       case TaskType.testing:
//         return '#4CAF50'; // Green
//       case TaskType.design:
//         return '#9C27B0'; // Purple
//       case TaskType.analysis:
//         return '#FF9800'; // Orange
//       case TaskType.meeting:
//         return '#795548'; // Brown
//       case TaskType.documentation:
//         return '#607D8B'; // Blue Grey
//       case TaskType.support:
//         return '#FF5722'; // Deep Orange
//       case TaskType.training:
//         return '#00BCD4'; // Cyan
//       case TaskType.research:
//         return '#E91E63'; // Pink
//       case TaskType.administrative:
//         return '#9E9E9E'; // Grey
//       case TaskType.clientCommunication:
//         return '#3F51B5'; // Indigo
//       case TaskType.codeReview:
//         return '#009688'; // Teal
//       case TaskType.deployment:
//         return '#8BC34A'; // Light Green
//       case TaskType.bugFixing:
//         return '#F44336'; // Red
//       case TaskType.other:
//       default:
//         return '#795548'; // Brown
//     }
//   }

//   /// Calculate productivity percentage
//   double? get productivityPercentage {
//     if (productiveHours == null || workedHours == 0) return null;
//     return (productiveHours! / workedHours) * 100;
//   }

//   /// Check if entry is valid (basic validation)
//   bool get isValid {
//     if (workedHours <= 0) return false;
//     if (taskDescription.isEmpty) return false;
//     if (projectId.isEmpty) return false;

//     final start = _parseTimeToMinutes(startTime);
//     final end = _parseTimeToMinutes(endTime);
//     if (end <= start) return false;

//     return true;
//   }

//   /// Check if entry overlaps with another entry
//   bool overlapsWith(TimesheetEntry other) {
//     if (workDate != other.workDate) return false;

//     final thisStart = _parseTimeToMinutes(startTime);
//     final thisEnd = _parseTimeToMinutes(endTime);
//     final otherStart = _parseTimeToMinutes(other.startTime);
//     final otherEnd = _parseTimeToMinutes(other.endTime);

//     return thisStart < otherEnd && otherStart < thisEnd;
//   }

//   // ==============================
//   // TO JSON METHODS
//   // ==============================

//   /// Convert to JSON for timesheet entry table
//   Map<String, dynamic> toTimesheetEntryJson() {
//     return {
//       'timesheet_entry_id': entryId,
//       'timesheet_id': timesheetId,
//       'emp_id': employeeId,
//       'org_short_name': orgShortName,
//       'project_id': projectId,
//       'task_id': taskId,
//       'task_description': taskDescription,
//       'task_type': _taskTypeToString(taskType),
//       'subtask': subtask,
//       'task_category': taskCategory,
//       'billing_status': _billingStatusToString(billingStatus),
//       'billing_rate': billingRate,
//       'billing_amount': billingAmount ?? calculatedBillingAmount,
//       'work_date': _dateTimeToJson(workDate),
//       'start_time': startTime,
//       'end_time': endTime,
//       'break_duration_minutes': breakDurationMinutes,
//       'worked_hours': workedHours,
//       'overtime_hours': overtimeHours,
//       'productive_hours': productiveHours,
//       'tracking_method': trackingMethod,
//       'timezone': timezone,
//       'entry_status': _timesheetStatusToString(status),
//       'source': _timesheetSourceToString(source),
//       'description': description,
//       'deliverables': deliverables,
//       'issues': issues,
//       'solutions': solutions,
//       'lessons_learned': lessonsLearned,
//       'screenshot_urls': screenshotUrls,
//       'productivity_score': productivityScore,
//       'quality_score': qualityScore,
//       'complexity_level': complexityLevel,
//       'priority_level': priorityLevel,
//       'estimation_variance': estimationVariance,
//       'manager_id': managerId,
//       'approved_by': approvedById,
//       'approved_at': _dateTimeToJson(approvedAt),
//       'rejected_by': rejectedById,
//       'rejected_at': _dateTimeToJson(rejectedAt),
//       'query_raised_by': queryRaisedById,
//       'query_raised_at': _dateTimeToJson(queryRaisedAt),
//       'query_comments': queryComments,
//       'query_response': queryResponse,
//       'manager_comments': managerComments,
//       'hr_comments': hrComments,
//       'review_notes': reviewNotes,
//       'workflow_stage': workflowStage,
//       'total_workflow_stages': totalWorkflowStages,
//       'last_action_at': _dateTimeToJson(lastActionAt),
//       'last_action_by': lastActionBy,
//       'last_action_type': lastActionType,
//       'version': version,
//       'previous_version_id': previousVersionId,
//       'created_at': _dateTimeToJson(createdAt),
//       'updated_at': _dateTimeToJson(updatedAt),
//       'submitted_at': _dateTimeToJson(submittedAt),
//       'locked_at': _dateTimeToJson(lockedAt),
//       'sync_status': isSynced ? 1 : 0,
//       'last_sync_at': _dateTimeToJson(lastSyncAt),
//       'client_id': clientId,
//       'department': department,
//       'cost_center': costCenter,
//       'batch_id': batchId,
//       'external_reference': externalReference,
//     };
//   }

//   /// Convert to safe JSON for API
//   Map<String, dynamic> toSafeJson() {
//     final json = toJson();
//     // Remove sensitive/internal fields
//     json.remove('sync_status');
//     json.remove('last_sync_at');
//     json.remove('batch_id');
//     json.remove('change_log');
//     json.remove('previous_version_id');
//     return json;
//   }

//   /// Convert to display JSON for UI
//   Map<String, dynamic> toDisplayJson() {
//     return {
//       'id': entryId,
//       'timesheetId': timesheetId,
//       'projectId': projectId,
//       'task': taskDescription,
//       'taskType': taskTypeDisplayName,
//       'date': formattedWorkDate,
//       'day': shortDayOfWeek,
//       'timeRange': formattedTimeRange,
//       'hours': formattedWorkedHours,
//       'overtime': formattedOvertimeHours,
//       'status': statusDisplayName,
//       'billingStatus': billingStatusDisplayName,
//       'description': description,
//       'statusColor': statusColor,
//       'taskTypeColor': taskTypeColor,
//       'billingStatusColor': billingStatusColor,
//       'isEditable': isEditable,
//       'isApproved': isApproved,
//       'isRejected': isRejected,
//       'isQuery': isQuery,
//       'attachmentsCount': attachments.length,
//       'hasScreenshots': screenshotUrls?.isNotEmpty ?? false,
//       'productivity': productivityPercentage,
//       'billingAmount': calculatedBillingAmount,
//     };
//   }

//   // ==============================
//   // HELPER METHODS
//   // ==============================

//   /// Submit the timesheet entry
//   TimesheetEntry submit() {
//     return copyWith(
//       status: TimesheetStatus.submitted,
//       submittedAt: DateTime.now(),
//       lastActionAt: DateTime.now(),
//       lastActionBy: employeeId,
//       lastActionType: 'submit',
//       updatedAt: DateTime.now(),
//       workflowStage: 2,
//     );
//   }

//   /// Save as draft
//   TimesheetEntry saveAsDraft() {
//     return copyWith(
//       status: TimesheetStatus.saved,
//       lastActionAt: DateTime.now(),
//       lastActionBy: employeeId,
//       lastActionType: 'save',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Approve the entry
//   TimesheetEntry approve({
//     required String approvedBy,
//     String? comments,
//     bool autoApproved = false,
//   }) {
//     return copyWith(
//       status: autoApproved
//           ? TimesheetStatus.autoApproved
//           : TimesheetStatus.approved,
//       approvedById: approvedBy,
//       approvedAt: DateTime.now(),
//       managerComments: comments ?? managerComments,
//       lastActionAt: DateTime.now(),
//       lastActionBy: approvedBy,
//       lastActionType: 'approve',
//       updatedAt: DateTime.now(),
//       workflowStage: totalWorkflowStages,
//     );
//   }

//   /// Partially approve the entry
//   TimesheetEntry partiallyApprove({
//     required String approvedBy,
//     required String comments,
//     double approvedHours,
//   }) {
//     return copyWith(
//       status: TimesheetStatus.partiallyApproved,
//       approvedById: approvedBy,
//       approvedAt: DateTime.now(),
//       managerComments: comments,
//       productiveHours: approvedHours,
//       lastActionAt: DateTime.now(),
//       lastActionBy: approvedBy,
//       lastActionType: 'partial_approve',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Reject the entry
//   TimesheetEntry reject({
//     required String rejectedBy,
//     required String comments,
//   }) {
//     return copyWith(
//       status: TimesheetStatus.rejected,
//       rejectedById: rejectedBy,
//       rejectedAt: DateTime.now(),
//       managerComments: comments,
//       lastActionAt: DateTime.now(),
//       lastActionBy: rejectedBy,
//       lastActionType: 'reject',
//       updatedAt: DateTime.now(),
//       workflowStage: totalWorkflowStages,
//     );
//   }

//   /// Raise query on the entry
//   TimesheetEntry raiseQuery({
//     required String raisedBy,
//     required String comments,
//   }) {
//     return copyWith(
//       status: TimesheetStatus.query,
//       queryRaisedById: raisedBy,
//       queryRaisedAt: DateTime.now(),
//       queryComments: comments,
//       lastActionAt: DateTime.now(),
//       lastActionBy: raisedBy,
//       lastActionType: 'query',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Respond to query
//   TimesheetEntry respondToQuery({
//     required String response,
//     required String respondedBy,
//   }) {
//     return copyWith(
//       queryResponse: response,
//       status:
//           TimesheetStatus.submitted, // Move back to submitted after response
//       lastActionAt: DateTime.now(),
//       lastActionBy: respondedBy,
//       lastActionType: 'query_response',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Lock the entry (prevent modifications)
//   TimesheetEntry lock() {
//     return copyWith(
//       status: TimesheetStatus.locked,
//       lockedAt: DateTime.now(),
//       lastActionAt: DateTime.now(),
//       lastActionType: 'lock',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Cancel the entry
//   TimesheetEntry cancel({required String cancelledBy, String? comments}) {
//     return copyWith(
//       status: TimesheetStatus.cancelled,
//       managerComments: comments ?? managerComments,
//       lastActionAt: DateTime.now(),
//       lastActionBy: cancelledBy,
//       lastActionType: 'cancel',
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Update workflow stage
//   TimesheetEntry updateWorkflowStage(int stage) {
//     return copyWith(
//       workflowStage: stage,
//       lastActionAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Add attachment
//   TimesheetEntry addAttachment(TimesheetAttachment attachment) {
//     final updatedAttachments = List<TimesheetAttachment>.from(attachments)
//       ..add(attachment);

//     return copyWith(attachments: updatedAttachments, updatedAt: DateTime.now());
//   }

//   /// Add screenshot
//   TimesheetEntry addScreenshot(String screenshotUrl) {
//     final updatedScreenshots = List<String>.from(screenshotUrls ?? [])
//       ..add(screenshotUrl);

//     return copyWith(
//       screenshotUrls: updatedScreenshots,
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Update time details
//   TimesheetEntry updateTime({
//     String? newStartTime,
//     String? newEndTime,
//     int? newBreakMinutes,
//     String? newDescription,
//   }) {
//     final finalStartTime = newStartTime ?? startTime;
//     final finalEndTime = newEndTime ?? endTime;
//     final finalBreakMinutes = newBreakMinutes ?? breakDurationMinutes;

//     final newWorkedHours = _calculateWorkedHours(
//       finalStartTime,
//       finalEndTime,
//       finalBreakMinutes,
//     );

//     return copyWith(
//       startTime: finalStartTime,
//       endTime: finalEndTime,
//       breakDurationMinutes: finalBreakMinutes,
//       workedHours: newWorkedHours,
//       description: newDescription ?? description,
//       updatedAt: DateTime.now(),
//       version: version + 1,
//     );
//   }

//   /// Mark as synced with server
//   TimesheetEntry markAsSynced() {
//     return copyWith(
//       isSynced: true,
//       lastSyncAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Create a copy with incremented version (for editing)
//   TimesheetEntry createNewVersion() {
//     return copyWith(
//       previousVersionId: entryId,
//       version: version + 1,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       status: TimesheetStatus.draft,
//       isSynced: false,
//     );
//   }

//   /// Check if entry can be billed
//   bool canBeBilled() {
//     return isApproved && isBillable && workedHours > 0;
//   }

//   // ==============================
//   // PRIVATE HELPERS
//   // ==============================

//   static DateTime? _parseDateTime(String? date) {
//     if (date == null) return null;
//     try {
//       return DateTime.parse(date);
//     } catch (_) {
//       return null;
//     }
//   }

//   static DateTime? _dateTimeFromJson(String? date) => _parseDateTime(date);

//   static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

//   static String _timeFromJson(String? time) => time ?? '00:00';

//   static String _timeToJson(String time) => time;

//   static String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}/'
//         '${date.month.toString().padLeft(2, '0')}/'
//         '${date.year}';
//   }

//   static double _calculateWorkedHours(
//     String startTime,
//     String endTime,
//     int breakMinutes,
//   ) {
//     try {
//       final start = _parseTimeToMinutes(startTime);
//       final end = _parseTimeToMinutes(endTime);

//       if (end <= start) {
//         // Handle overnight work (e.g., 22:00 to 02:00)
//         final totalMinutes = (24 * 60 - start) + end;
//         return (totalMinutes - breakMinutes) / 60.0;
//       }

//       return (end - start - breakMinutes) / 60.0;
//     } catch (e) {
//       return 0.0;
//     }
//   }

//   static int _parseTimeToMinutes(String time) {
//     final parts = time.split(':');
//     if (parts.length != 2) return 0;

//     final hours = int.tryParse(parts[0]) ?? 0;
//     final minutes = int.tryParse(parts[1]) ?? 0;

//     return hours * 60 + minutes;
//   }

//   static String _timesheetStatusToString(TimesheetStatus status) {
//     return status.name;
//   }

//   static String _taskTypeToString(TaskType type) {
//     return type.name;
//   }

//   static String _billingStatusToString(BillingStatus status) {
//     return status.name;
//   }

//   static String _timesheetSourceToString(TimesheetSource source) {
//     return source.name;
//   }
// }

// // ==============================
// // TIMESHEET (AGGREGATE) MODEL
// // ==============================

// @freezed
// class Timesheet with _$Timesheet {
//   const factory Timesheet({
//     required String timesheetId,
//     required String employeeId,
//     required String orgShortName,
//     required DateTime startDate,
//     required DateTime endDate,
//     required TimesheetFrequency frequency,
//     @Default(<TimesheetEntry>[]) List<TimesheetEntry> entries,

//     // Summary fields
//     @Default(0.0) double totalHours,
//     @Default(0.0) double billableHours,
//     @Default(0.0) double nonBillableHours,
//     @Default(0.0) double overtimeHours,
//     @Default(0.0) double productiveHours,
//     @Default(0.0) double billingAmount,

//     // Status
//     @Default(TimesheetStatus.draft) TimesheetStatus status,
//     String? submittedBy,
//     DateTime? submittedAt,
//     String? approvedBy,
//     DateTime? approvedAt,
//     String? rejectedBy,
//     DateTime? rejectedAt,
//     String? managerComments,

//     // Metadata
//     String? periodName,
//     String? remarks,
//     DateTime? lockedAt,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     @Default(true) bool isSynced,
//     DateTime? lastSyncAt,
//     @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
//   }) = _Timesheet;

//   factory Timesheet.fromJson(Map<String, dynamic> json) =>
//       _$TimesheetFromJson(json);

//   /// Create a new timesheet period
//   factory Timesheet.create({
//     required String timesheetId,
//     required String employeeId,
//     required String orgShortName,
//     required DateTime startDate,
//     required DateTime endDate,
//     required TimesheetFrequency frequency,
//     String? periodName,
//   }) {
//     final now = DateTime.now();

//     return Timesheet(
//       timesheetId: timesheetId,
//       employeeId: employeeId,
//       orgShortName: orgShortName,
//       startDate: startDate,
//       endDate: endDate,
//       frequency: frequency,
//       periodName:
//           periodName ?? _generatePeriodName(startDate, endDate, frequency),
//       status: TimesheetStatus.draft,
//       createdAt: now,
//       updatedAt: now,
//       isSynced: false,
//     );
//   }

//   /// Add entry to timesheet
//   Timesheet addEntry(TimesheetEntry entry) {
//     final updatedEntries = List<TimesheetEntry>.from(entries)..add(entry);
//     return _recalculateSummary(updatedEntries);
//   }

//   /// Remove entry from timesheet
//   Timesheet removeEntry(String entryId) {
//     final updatedEntries = entries.where((e) => e.entryId != entryId).toList();
//     return _recalculateSummary(updatedEntries);
//   }

//   /// Update entry in timesheet
//   Timesheet updateEntry(TimesheetEntry updatedEntry) {
//     final updatedEntries = entries
//         .map((e) => e.entryId == updatedEntry.entryId ? updatedEntry : e)
//         .toList();
//     return _recalculateSummary(updatedEntries);
//   }

//   /// Submit the entire timesheet
//   Timesheet submit() {
//     return copyWith(
//       status: TimesheetStatus.submitted,
//       submittedAt: DateTime.now(),
//       submittedBy: employeeId,
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Approve the timesheet
//   Timesheet approve({required String approvedBy, String? comments}) {
//     return copyWith(
//       status: TimesheetStatus.approved,
//       approvedBy: approvedBy,
//       approvedAt: DateTime.now(),
//       managerComments: comments ?? managerComments,
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Reject the timesheet
//   Timesheet reject({required String rejectedBy, required String comments}) {
//     return copyWith(
//       status: TimesheetStatus.rejected,
//       rejectedBy: rejectedBy,
//       rejectedAt: DateTime.now(),
//       managerComments: comments,
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Lock the timesheet (prevent modifications)
//   Timesheet lock() {
//     return copyWith(
//       status: TimesheetStatus.locked,
//       lockedAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   /// Check if timesheet is complete (all days have entries)
//   bool isComplete() {
//     final totalDays = endDate.difference(startDate).inDays + 1;
//     final uniqueDays = entries.map((e) => e.workDate).toSet().length;
//     return uniqueDays >= totalDays;
//   }

//   /// Get entries for a specific date
//   List<TimesheetEntry> getEntriesForDate(DateTime date) {
//     return entries
//         .where(
//           (e) =>
//               e.workDate.year == date.year &&
//               e.workDate.month == date.month &&
//               e.workDate.day == date.day,
//         )
//         .toList();
//   }

//   /// Get entries for a specific project
//   List<TimesheetEntry> getEntriesForProject(String projectId) {
//     return entries.where((e) => e.projectId == projectId).toList();
//   }

//   /// Get billable entries
//   List<TimesheetEntry> getBillableEntries() {
//     return entries.where((e) => e.isBillable).toList();
//   }

//   /// Get non-billable entries
//   List<TimesheetEntry> getNonBillableEntries() {
//     return entries.where((e) => e.isNonBillable).toList();
//   }

//   /// Get approved entries
//   List<TimesheetEntry> getApprovedEntries() {
//     return entries.where((e) => e.isApproved).toList();
//   }

//   /// Get pending entries
//   List<TimesheetEntry> getPendingEntries() {
//     return entries.where((e) => e.isSubmitted || e.isPendingReview).toList();
//   }

//   // Private helper to recalculate summary
//   Timesheet _recalculateSummary(List<TimesheetEntry> updatedEntries) {
//     double total = 0.0;
//     double billable = 0.0;
//     double nonBillable = 0.0;
//     double overtime = 0.0;
//     double productive = 0.0;
//     double billing = 0.0;

//     for (final entry in updatedEntries) {
//       total += entry.workedHours;
//       overtime += entry.overtimeHours;

//       if (entry.isBillable) {
//         billable += entry.workedHours;
//         billing += (entry.calculatedBillingAmount ?? 0);
//       } else {
//         nonBillable += entry.workedHours;
//       }

//       if (entry.productiveHours != null) {
//         productive += entry.productiveHours!;
//       }
//     }

//     return copyWith(
//       entries: updatedEntries,
//       totalHours: total,
//       billableHours: billable,
//       nonBillableHours: nonBillable,
//       overtimeHours: overtime,
//       productiveHours: productive,
//       billingAmount: billing,
//       updatedAt: DateTime.now(),
//     );
//   }

//   static String _generatePeriodName(
//     DateTime start,
//     DateTime end,
//     TimesheetFrequency frequency,
//   ) {
//     switch (frequency) {
//       case TimesheetFrequency.daily:
//         return 'Day: ${_formatDate(start)}';
//       case TimesheetFrequency.weekly:
//         return 'Week ${start.weekOfYear}, ${start.year}';
//       case TimesheetFrequency.biWeekly:
//         return 'Bi-Week ${start.weekOfYear ~/ 2 + 1}, ${start.year}';
//       case TimesheetFrequency.monthly:
//         return '${_getMonthName(start.month)} ${start.year}';
//       case TimesheetFrequency.projectBased:
//         return 'Project Period';
//     }
//   }

//   static String _getMonthName(int month) {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//     return months[month - 1];
//   }
// }

// // ==============================
// // TIMESHEET ATTACHMENT MODEL
// // ==============================

// @freezed
// class TimesheetAttachment with _$TimesheetAttachment {
//   const factory TimesheetAttachment({
//     required String attachmentId,
//     required String timesheetEntryId,
//     required String fileName,
//     required String fileUrl,
//     required String fileType,
//     required int fileSize,
//     String? description,
//     String? attachmentType,
//     DateTime? uploadedAt,
//     String? uploadedBy,
//     bool? isVerified,
//     String? verificationNotes,
//     DateTime? verifiedAt,
//     String? verifiedBy,
//   }) = _TimesheetAttachment;

//   factory TimesheetAttachment.fromJson(Map<String, dynamic> json) =>
//       _$TimesheetAttachmentFromJson(json);
// }

// // ==============================
// // ENUM EXTENSIONS
// // ==============================

// extension TimesheetStatusExtension on TimesheetStatus {
//   static TimesheetStatus fromString(String? status) {
//     final statusStr = status?.toLowerCase() ?? 'draft';
//     switch (statusStr) {
//       case 'saved':
//         return TimesheetStatus.saved;
//       case 'submitted':
//         return TimesheetStatus.submitted;
//       case 'approved':
//         return TimesheetStatus.approved;
//       case 'rejected':
//         return TimesheetStatus.rejected;
//       case 'query':
//         return TimesheetStatus.query;
//       case 'pending_review':
//         return TimesheetStatus.pendingReview;
//       case 'partially_approved':
//         return TimesheetStatus.partiallyApproved;
//       case 'auto_approved':
//         return TimesheetStatus.autoApproved;
//       case 'locked':
//         return TimesheetStatus.locked;
//       case 'cancelled':
//         return TimesheetStatus.cancelled;
//       case 'draft':
//       default:
//         return TimesheetStatus.draft;
//     }
//   }
// }

// extension TaskTypeExtension on TaskType {
//   static TaskType fromString(String? type) {
//     final typeStr = type?.toLowerCase() ?? 'development';
//     switch (typeStr) {
//       case 'testing':
//         return TaskType.testing;
//       case 'design':
//         return TaskType.design;
//       case 'analysis':
//         return TaskType.analysis;
//       case 'meeting':
//         return TaskType.meeting;
//       case 'documentation':
//         return TaskType.documentation;
//       case 'support':
//         return TaskType.support;
//       case 'training':
//         return TaskType.training;
//       case 'research':
//         return TaskType.research;
//       case 'administrative':
//         return TaskType.administrative;
//       case 'client_communication':
//         return TaskType.clientCommunication;
//       case 'code_review':
//         return TaskType.codeReview;
//       case 'deployment':
//         return TaskType.deployment;
//       case 'bug_fixing':
//         return TaskType.bugFixing;
//       case 'other':
//         return TaskType.other;
//       case 'development':
//       default:
//         return TaskType.development;
//     }
//   }
// }

// extension DateTimeExtension on DateTime {
//   int get weekOfYear {
//     final date = DateTime(year, month, day);
//     final firstDayOfYear = DateTime(year, 1, 1);
//     final daysDiff = date.difference(firstDayOfYear).inDays;
//     return ((daysDiff + firstDayOfYear.weekday - 1) / 7).floor() + 1;
//   }
// }

// // ==============================
// // HELPER FUNCTIONS
// // ==============================

// /// Generate timesheet entry ID
// String generateTimesheetEntryId({
//   required String employeeId,
//   required DateTime date,
//   required int sequence,
// }) {
//   final year = date.year;
//   final month = date.month.toString().padLeft(2, '0');
//   final day = date.day.toString().padLeft(2, '0');
//   final seq = sequence.toString().padLeft(3, '0');
//   return 'TS$year$month$day${employeeId.substring(employeeId.length - 3)}$seq';
// }

// /// Generate timesheet ID
// String generateTimesheetId({
//   required String employeeId,
//   required DateTime startDate,
//   required TimesheetFrequency frequency,
// }) {
//   final year = startDate.year;
//   final month = startDate.month.toString().padLeft(2, '0');
//   final week = startDate.weekOfYear.toString().padLeft(2, '0');

//   switch (frequency) {
//     case TimesheetFrequency.daily:
//       final day = startDate.day.toString().padLeft(2, '0');
//       return 'TS-D-$year$month$day-$employeeId';
//     case TimesheetFrequency.weekly:
//       return 'TS-W-$year$week-$employeeId';
//     case TimesheetFrequency.biWeekly:
//       final biWeek = (startDate.weekOfYear ~/ 2 + 1).toString().padLeft(2, '0');
//       return 'TS-BW-$year$biWeek-$employeeId';
//     case TimesheetFrequency.monthly:
//       return 'TS-M-$year$month-$employeeId';
//     case TimesheetFrequency.projectBased:
//       return 'TS-P-${DateTime.now().millisecondsSinceEpoch}-$employeeId';
//   }
// }

// /// Validate timesheet entry
// String? validateTimesheetEntry({
//   required DateTime workDate,
//   required String startTime,
//   required String endTime,
//   required String taskDescription,
//   required String projectId,
//   int breakMinutes = 0,
// }) {
//   if (taskDescription.isEmpty) {
//     return 'Task description is required';
//   }

//   if (projectId.isEmpty) {
//     return 'Project selection is required';
//   }

//   if (workDate.isAfter(DateTime.now())) {
//     return 'Cannot log time for future dates';
//   }

//   final start = _parseTimeToMinutes(startTime);
//   final end = _parseTimeToMinutes(endTime);

//   if (end <= start && (end - start).abs() > 60) {
//     // Allow small differences but not major ones
//     return 'End time must be after start time';
//   }

//   if (breakMinutes < 0) {
//     return 'Break minutes cannot be negative';
//   }

//   final workedHours = (end - start - breakMinutes) / 60.0;
//   if (workedHours <= 0) {
//     return 'Worked hours must be greater than 0';
//   }

//   if (workedHours > 24) {
//     return 'Cannot log more than 24 hours in a day';
//   }

//   return null;
// }

// /// Calculate total hours for a list of entries
// double calculateTotalHours(List<TimesheetEntry> entries) {
//   return entries.fold(0.0, (sum, entry) => sum + entry.workedHours);
// }

// /// Calculate billable amount for entries
// double calculateBillableAmount(List<TimesheetEntry> entries) {
//   return entries.fold(0.0, (sum, entry) {
//     if (entry.isBillable && entry.calculatedBillingAmount != null) {
//       return sum + entry.calculatedBillingAmount!;
//     }
//     return sum;
//   });
// }

// /// Check for time overlaps in entries
// List<List<TimesheetEntry>> findOverlappingEntries(
//   List<TimesheetEntry> entries,
// ) {
//   final overlaps = <List<TimesheetEntry>>[];
//   final sortedEntries = List<TimesheetEntry>.from(entries)
//     ..sort((a, b) {
//       final dateCompare = a.workDate.compareTo(b.workDate);
//       if (dateCompare != 0) return dateCompare;
//       return _parseTimeToMinutes(
//         a.startTime,
//       ).compareTo(_parseTimeToMinutes(b.startTime));
//     });

//   for (int i = 0; i < sortedEntries.length; i++) {
//     for (int j = i + 1; j < sortedEntries.length; j++) {
//       final a = sortedEntries[i];
//       final b = sortedEntries[j];

//       // Only check same day
//       if (a.workDate != b.workDate) break;

//       if (a.overlapsWith(b)) {
//         overlaps.add([a, b]);
//       }
//     }
//   }

//   return overlaps;
// }

// int _parseTimeToMinutes(String time) {
//   final parts = time.split(':');
//   if (parts.length != 2) return 0;

//   final hours = int.tryParse(parts[0]) ?? 0;
//   final minutes = int.tryParse(parts[1]) ?? 0;

//   return hours * 60 + minutes;
// }
