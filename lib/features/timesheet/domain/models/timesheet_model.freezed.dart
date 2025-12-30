// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timesheet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimesheetEntry _$TimesheetEntryFromJson(Map<String, dynamic> json) {
  return _TimesheetEntry.fromJson(json);
}

/// @nodoc
mixin _$TimesheetEntry {
  String get entryId =>
      throw _privateConstructorUsedError; // timesheet_entry_id
  String get empId => throw _privateConstructorUsedError; // emp_id
  String get projectId => throw _privateConstructorUsedError; // project_id
  String get taskDescription =>
      throw _privateConstructorUsedError; // task_description
  TaskType get taskType => throw _privateConstructorUsedError; // task_type
  DateTime get workDate => throw _privateConstructorUsedError; // work_date
  double get hours =>
      throw _privateConstructorUsedError; // hours (decimal: 1.5, 2.0, 0.5)
  String? get comments => throw _privateConstructorUsedError; // comments/notes
  TimesheetStatus get status => throw _privateConstructorUsedError; // status
  String? get managerComments =>
      throw _privateConstructorUsedError; // manager_comments
  DateTime? get submittedAt =>
      throw _privateConstructorUsedError; // submitted_at
  DateTime? get approvedAt => throw _privateConstructorUsedError; // approved_at
  DateTime? get createdAt => throw _privateConstructorUsedError; // created_at
  DateTime? get updatedAt => throw _privateConstructorUsedError; // updated_at
  // Additional context
  String? get projectName =>
      throw _privateConstructorUsedError; // from project_master
  String? get empName =>
      throw _privateConstructorUsedError; // from employee_master
  String? get managerId =>
      throw _privateConstructorUsedError; // manager_id for approval
  String? get managerName => throw _privateConstructorUsedError;

  /// Serializes this TimesheetEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimesheetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimesheetEntryCopyWith<TimesheetEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimesheetEntryCopyWith<$Res> {
  factory $TimesheetEntryCopyWith(
    TimesheetEntry value,
    $Res Function(TimesheetEntry) then,
  ) = _$TimesheetEntryCopyWithImpl<$Res, TimesheetEntry>;
  @useResult
  $Res call({
    String entryId,
    String empId,
    String projectId,
    String taskDescription,
    TaskType taskType,
    DateTime workDate,
    double hours,
    String? comments,
    TimesheetStatus status,
    String? managerComments,
    DateTime? submittedAt,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? projectName,
    String? empName,
    String? managerId,
    String? managerName,
  });
}

/// @nodoc
class _$TimesheetEntryCopyWithImpl<$Res, $Val extends TimesheetEntry>
    implements $TimesheetEntryCopyWith<$Res> {
  _$TimesheetEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimesheetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? empId = null,
    Object? projectId = null,
    Object? taskDescription = null,
    Object? taskType = null,
    Object? workDate = null,
    Object? hours = null,
    Object? comments = freezed,
    Object? status = null,
    Object? managerComments = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? projectName = freezed,
    Object? empName = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
  }) {
    return _then(
      _value.copyWith(
            entryId: null == entryId
                ? _value.entryId
                : entryId // ignore: cast_nullable_to_non_nullable
                      as String,
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            taskDescription: null == taskDescription
                ? _value.taskDescription
                : taskDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            workDate: null == workDate
                ? _value.workDate
                : workDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hours: null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                      as double,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TimesheetStatus,
            managerComments: freezed == managerComments
                ? _value.managerComments
                : managerComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            approvedAt: freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            projectName: freezed == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            empName: freezed == empName
                ? _value.empName
                : empName // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerId: freezed == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerName: freezed == managerName
                ? _value.managerName
                : managerName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimesheetEntryImplCopyWith<$Res>
    implements $TimesheetEntryCopyWith<$Res> {
  factory _$$TimesheetEntryImplCopyWith(
    _$TimesheetEntryImpl value,
    $Res Function(_$TimesheetEntryImpl) then,
  ) = __$$TimesheetEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String entryId,
    String empId,
    String projectId,
    String taskDescription,
    TaskType taskType,
    DateTime workDate,
    double hours,
    String? comments,
    TimesheetStatus status,
    String? managerComments,
    DateTime? submittedAt,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? projectName,
    String? empName,
    String? managerId,
    String? managerName,
  });
}

/// @nodoc
class __$$TimesheetEntryImplCopyWithImpl<$Res>
    extends _$TimesheetEntryCopyWithImpl<$Res, _$TimesheetEntryImpl>
    implements _$$TimesheetEntryImplCopyWith<$Res> {
  __$$TimesheetEntryImplCopyWithImpl(
    _$TimesheetEntryImpl _value,
    $Res Function(_$TimesheetEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimesheetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? empId = null,
    Object? projectId = null,
    Object? taskDescription = null,
    Object? taskType = null,
    Object? workDate = null,
    Object? hours = null,
    Object? comments = freezed,
    Object? status = null,
    Object? managerComments = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? projectName = freezed,
    Object? empName = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
  }) {
    return _then(
      _$TimesheetEntryImpl(
        entryId: null == entryId
            ? _value.entryId
            : entryId // ignore: cast_nullable_to_non_nullable
                  as String,
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        taskDescription: null == taskDescription
            ? _value.taskDescription
            : taskDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        workDate: null == workDate
            ? _value.workDate
            : workDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hours: null == hours
            ? _value.hours
            : hours // ignore: cast_nullable_to_non_nullable
                  as double,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TimesheetStatus,
        managerComments: freezed == managerComments
            ? _value.managerComments
            : managerComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        approvedAt: freezed == approvedAt
            ? _value.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        projectName: freezed == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        empName: freezed == empName
            ? _value.empName
            : empName // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerId: freezed == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerName: freezed == managerName
            ? _value.managerName
            : managerName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimesheetEntryImpl extends _TimesheetEntry {
  const _$TimesheetEntryImpl({
    required this.entryId,
    required this.empId,
    required this.projectId,
    required this.taskDescription,
    required this.taskType,
    required this.workDate,
    required this.hours,
    this.comments,
    required this.status,
    this.managerComments,
    this.submittedAt,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.projectName,
    this.empName,
    this.managerId,
    this.managerName,
  }) : super._();

  factory _$TimesheetEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimesheetEntryImplFromJson(json);

  @override
  final String entryId;
  // timesheet_entry_id
  @override
  final String empId;
  // emp_id
  @override
  final String projectId;
  // project_id
  @override
  final String taskDescription;
  // task_description
  @override
  final TaskType taskType;
  // task_type
  @override
  final DateTime workDate;
  // work_date
  @override
  final double hours;
  // hours (decimal: 1.5, 2.0, 0.5)
  @override
  final String? comments;
  // comments/notes
  @override
  final TimesheetStatus status;
  // status
  @override
  final String? managerComments;
  // manager_comments
  @override
  final DateTime? submittedAt;
  // submitted_at
  @override
  final DateTime? approvedAt;
  // approved_at
  @override
  final DateTime? createdAt;
  // created_at
  @override
  final DateTime? updatedAt;
  // updated_at
  // Additional context
  @override
  final String? projectName;
  // from project_master
  @override
  final String? empName;
  // from employee_master
  @override
  final String? managerId;
  // manager_id for approval
  @override
  final String? managerName;

  @override
  String toString() {
    return 'TimesheetEntry(entryId: $entryId, empId: $empId, projectId: $projectId, taskDescription: $taskDescription, taskType: $taskType, workDate: $workDate, hours: $hours, comments: $comments, status: $status, managerComments: $managerComments, submittedAt: $submittedAt, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt, projectName: $projectName, empName: $empName, managerId: $managerId, managerName: $managerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimesheetEntryImpl &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.taskDescription, taskDescription) ||
                other.taskDescription == taskDescription) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.workDate, workDate) ||
                other.workDate == workDate) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.managerComments, managerComments) ||
                other.managerComments == managerComments) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.empName, empName) || other.empName == empName) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    entryId,
    empId,
    projectId,
    taskDescription,
    taskType,
    workDate,
    hours,
    comments,
    status,
    managerComments,
    submittedAt,
    approvedAt,
    createdAt,
    updatedAt,
    projectName,
    empName,
    managerId,
    managerName,
  );

  /// Create a copy of TimesheetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimesheetEntryImplCopyWith<_$TimesheetEntryImpl> get copyWith =>
      __$$TimesheetEntryImplCopyWithImpl<_$TimesheetEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimesheetEntryImplToJson(this);
  }
}

abstract class _TimesheetEntry extends TimesheetEntry {
  const factory _TimesheetEntry({
    required final String entryId,
    required final String empId,
    required final String projectId,
    required final String taskDescription,
    required final TaskType taskType,
    required final DateTime workDate,
    required final double hours,
    final String? comments,
    required final TimesheetStatus status,
    final String? managerComments,
    final DateTime? submittedAt,
    final DateTime? approvedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? projectName,
    final String? empName,
    final String? managerId,
    final String? managerName,
  }) = _$TimesheetEntryImpl;
  const _TimesheetEntry._() : super._();

  factory _TimesheetEntry.fromJson(Map<String, dynamic> json) =
      _$TimesheetEntryImpl.fromJson;

  @override
  String get entryId; // timesheet_entry_id
  @override
  String get empId; // emp_id
  @override
  String get projectId; // project_id
  @override
  String get taskDescription; // task_description
  @override
  TaskType get taskType; // task_type
  @override
  DateTime get workDate; // work_date
  @override
  double get hours; // hours (decimal: 1.5, 2.0, 0.5)
  @override
  String? get comments; // comments/notes
  @override
  TimesheetStatus get status; // status
  @override
  String? get managerComments; // manager_comments
  @override
  DateTime? get submittedAt; // submitted_at
  @override
  DateTime? get approvedAt; // approved_at
  @override
  DateTime? get createdAt; // created_at
  @override
  DateTime? get updatedAt; // updated_at
  // Additional context
  @override
  String? get projectName; // from project_master
  @override
  String? get empName; // from employee_master
  @override
  String? get managerId; // manager_id for approval
  @override
  String? get managerName;

  /// Create a copy of TimesheetEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimesheetEntryImplCopyWith<_$TimesheetEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Timesheet _$TimesheetFromJson(Map<String, dynamic> json) {
  return _Timesheet.fromJson(json);
}

/// @nodoc
mixin _$Timesheet {
  String get timesheetId =>
      throw _privateConstructorUsedError; // Custom ID: TS_YYYYMMDD_EMPID
  String get empId => throw _privateConstructorUsedError; // emp_id
  DateTime get startDate =>
      throw _privateConstructorUsedError; // Week/Month start
  DateTime get endDate => throw _privateConstructorUsedError; // Week/Month end
  List<TimesheetEntry> get entries => throw _privateConstructorUsedError;
  double get totalHours => throw _privateConstructorUsedError; // Total hours
  TimesheetStatus get status =>
      throw _privateConstructorUsedError; // Overall status
  String? get comments =>
      throw _privateConstructorUsedError; // Employee comments
  String? get managerComments =>
      throw _privateConstructorUsedError; // Manager comments
  DateTime? get submittedAt =>
      throw _privateConstructorUsedError; // When submitted
  DateTime? get approvedAt =>
      throw _privateConstructorUsedError; // When approved
  DateTime? get createdAt => throw _privateConstructorUsedError; // created_at
  DateTime? get updatedAt => throw _privateConstructorUsedError; // updated_at
  // Additional info
  String? get empName => throw _privateConstructorUsedError; // Employee name
  String? get managerId =>
      throw _privateConstructorUsedError; // Approving manager
  String? get managerName => throw _privateConstructorUsedError;

  /// Serializes this Timesheet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Timesheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimesheetCopyWith<Timesheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimesheetCopyWith<$Res> {
  factory $TimesheetCopyWith(Timesheet value, $Res Function(Timesheet) then) =
      _$TimesheetCopyWithImpl<$Res, Timesheet>;
  @useResult
  $Res call({
    String timesheetId,
    String empId,
    DateTime startDate,
    DateTime endDate,
    List<TimesheetEntry> entries,
    double totalHours,
    TimesheetStatus status,
    String? comments,
    String? managerComments,
    DateTime? submittedAt,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? empName,
    String? managerId,
    String? managerName,
  });
}

/// @nodoc
class _$TimesheetCopyWithImpl<$Res, $Val extends Timesheet>
    implements $TimesheetCopyWith<$Res> {
  _$TimesheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Timesheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timesheetId = null,
    Object? empId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? entries = null,
    Object? totalHours = null,
    Object? status = null,
    Object? comments = freezed,
    Object? managerComments = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? empName = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
  }) {
    return _then(
      _value.copyWith(
            timesheetId: null == timesheetId
                ? _value.timesheetId
                : timesheetId // ignore: cast_nullable_to_non_nullable
                      as String,
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<TimesheetEntry>,
            totalHours: null == totalHours
                ? _value.totalHours
                : totalHours // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TimesheetStatus,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerComments: freezed == managerComments
                ? _value.managerComments
                : managerComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            approvedAt: freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            empName: freezed == empName
                ? _value.empName
                : empName // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerId: freezed == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerName: freezed == managerName
                ? _value.managerName
                : managerName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimesheetImplCopyWith<$Res>
    implements $TimesheetCopyWith<$Res> {
  factory _$$TimesheetImplCopyWith(
    _$TimesheetImpl value,
    $Res Function(_$TimesheetImpl) then,
  ) = __$$TimesheetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String timesheetId,
    String empId,
    DateTime startDate,
    DateTime endDate,
    List<TimesheetEntry> entries,
    double totalHours,
    TimesheetStatus status,
    String? comments,
    String? managerComments,
    DateTime? submittedAt,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? empName,
    String? managerId,
    String? managerName,
  });
}

/// @nodoc
class __$$TimesheetImplCopyWithImpl<$Res>
    extends _$TimesheetCopyWithImpl<$Res, _$TimesheetImpl>
    implements _$$TimesheetImplCopyWith<$Res> {
  __$$TimesheetImplCopyWithImpl(
    _$TimesheetImpl _value,
    $Res Function(_$TimesheetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Timesheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timesheetId = null,
    Object? empId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? entries = null,
    Object? totalHours = null,
    Object? status = null,
    Object? comments = freezed,
    Object? managerComments = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? empName = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
  }) {
    return _then(
      _$TimesheetImpl(
        timesheetId: null == timesheetId
            ? _value.timesheetId
            : timesheetId // ignore: cast_nullable_to_non_nullable
                  as String,
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<TimesheetEntry>,
        totalHours: null == totalHours
            ? _value.totalHours
            : totalHours // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TimesheetStatus,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerComments: freezed == managerComments
            ? _value.managerComments
            : managerComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        approvedAt: freezed == approvedAt
            ? _value.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        empName: freezed == empName
            ? _value.empName
            : empName // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerId: freezed == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerName: freezed == managerName
            ? _value.managerName
            : managerName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimesheetImpl extends _Timesheet {
  const _$TimesheetImpl({
    required this.timesheetId,
    required this.empId,
    required this.startDate,
    required this.endDate,
    required final List<TimesheetEntry> entries,
    required this.totalHours,
    required this.status,
    this.comments,
    this.managerComments,
    this.submittedAt,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.empName,
    this.managerId,
    this.managerName,
  }) : _entries = entries,
       super._();

  factory _$TimesheetImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimesheetImplFromJson(json);

  @override
  final String timesheetId;
  // Custom ID: TS_YYYYMMDD_EMPID
  @override
  final String empId;
  // emp_id
  @override
  final DateTime startDate;
  // Week/Month start
  @override
  final DateTime endDate;
  // Week/Month end
  final List<TimesheetEntry> _entries;
  // Week/Month end
  @override
  List<TimesheetEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final double totalHours;
  // Total hours
  @override
  final TimesheetStatus status;
  // Overall status
  @override
  final String? comments;
  // Employee comments
  @override
  final String? managerComments;
  // Manager comments
  @override
  final DateTime? submittedAt;
  // When submitted
  @override
  final DateTime? approvedAt;
  // When approved
  @override
  final DateTime? createdAt;
  // created_at
  @override
  final DateTime? updatedAt;
  // updated_at
  // Additional info
  @override
  final String? empName;
  // Employee name
  @override
  final String? managerId;
  // Approving manager
  @override
  final String? managerName;

  @override
  String toString() {
    return 'Timesheet(timesheetId: $timesheetId, empId: $empId, startDate: $startDate, endDate: $endDate, entries: $entries, totalHours: $totalHours, status: $status, comments: $comments, managerComments: $managerComments, submittedAt: $submittedAt, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt, empName: $empName, managerId: $managerId, managerName: $managerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimesheetImpl &&
            (identical(other.timesheetId, timesheetId) ||
                other.timesheetId == timesheetId) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.managerComments, managerComments) ||
                other.managerComments == managerComments) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.empName, empName) || other.empName == empName) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timesheetId,
    empId,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_entries),
    totalHours,
    status,
    comments,
    managerComments,
    submittedAt,
    approvedAt,
    createdAt,
    updatedAt,
    empName,
    managerId,
    managerName,
  );

  /// Create a copy of Timesheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimesheetImplCopyWith<_$TimesheetImpl> get copyWith =>
      __$$TimesheetImplCopyWithImpl<_$TimesheetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimesheetImplToJson(this);
  }
}

abstract class _Timesheet extends Timesheet {
  const factory _Timesheet({
    required final String timesheetId,
    required final String empId,
    required final DateTime startDate,
    required final DateTime endDate,
    required final List<TimesheetEntry> entries,
    required final double totalHours,
    required final TimesheetStatus status,
    final String? comments,
    final String? managerComments,
    final DateTime? submittedAt,
    final DateTime? approvedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? empName,
    final String? managerId,
    final String? managerName,
  }) = _$TimesheetImpl;
  const _Timesheet._() : super._();

  factory _Timesheet.fromJson(Map<String, dynamic> json) =
      _$TimesheetImpl.fromJson;

  @override
  String get timesheetId; // Custom ID: TS_YYYYMMDD_EMPID
  @override
  String get empId; // emp_id
  @override
  DateTime get startDate; // Week/Month start
  @override
  DateTime get endDate; // Week/Month end
  @override
  List<TimesheetEntry> get entries;
  @override
  double get totalHours; // Total hours
  @override
  TimesheetStatus get status; // Overall status
  @override
  String? get comments; // Employee comments
  @override
  String? get managerComments; // Manager comments
  @override
  DateTime? get submittedAt; // When submitted
  @override
  DateTime? get approvedAt; // When approved
  @override
  DateTime? get createdAt; // created_at
  @override
  DateTime? get updatedAt; // updated_at
  // Additional info
  @override
  String? get empName; // Employee name
  @override
  String? get managerId; // Approving manager
  @override
  String? get managerName;

  /// Create a copy of Timesheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimesheetImplCopyWith<_$TimesheetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimesheetRequest _$TimesheetRequestFromJson(Map<String, dynamic> json) {
  return _TimesheetRequest.fromJson(json);
}

/// @nodoc
mixin _$TimesheetRequest {
  String get empId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<TimesheetEntryRequest> get entries => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;

  /// Serializes this TimesheetRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimesheetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimesheetRequestCopyWith<TimesheetRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimesheetRequestCopyWith<$Res> {
  factory $TimesheetRequestCopyWith(
    TimesheetRequest value,
    $Res Function(TimesheetRequest) then,
  ) = _$TimesheetRequestCopyWithImpl<$Res, TimesheetRequest>;
  @useResult
  $Res call({
    String empId,
    DateTime startDate,
    DateTime endDate,
    List<TimesheetEntryRequest> entries,
    String? comments,
    String? managerId,
  });
}

/// @nodoc
class _$TimesheetRequestCopyWithImpl<$Res, $Val extends TimesheetRequest>
    implements $TimesheetRequestCopyWith<$Res> {
  _$TimesheetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimesheetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? entries = null,
    Object? comments = freezed,
    Object? managerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<TimesheetEntryRequest>,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerId: freezed == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimesheetRequestImplCopyWith<$Res>
    implements $TimesheetRequestCopyWith<$Res> {
  factory _$$TimesheetRequestImplCopyWith(
    _$TimesheetRequestImpl value,
    $Res Function(_$TimesheetRequestImpl) then,
  ) = __$$TimesheetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String empId,
    DateTime startDate,
    DateTime endDate,
    List<TimesheetEntryRequest> entries,
    String? comments,
    String? managerId,
  });
}

/// @nodoc
class __$$TimesheetRequestImplCopyWithImpl<$Res>
    extends _$TimesheetRequestCopyWithImpl<$Res, _$TimesheetRequestImpl>
    implements _$$TimesheetRequestImplCopyWith<$Res> {
  __$$TimesheetRequestImplCopyWithImpl(
    _$TimesheetRequestImpl _value,
    $Res Function(_$TimesheetRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimesheetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? entries = null,
    Object? comments = freezed,
    Object? managerId = freezed,
  }) {
    return _then(
      _$TimesheetRequestImpl(
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<TimesheetEntryRequest>,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerId: freezed == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimesheetRequestImpl implements _TimesheetRequest {
  const _$TimesheetRequestImpl({
    required this.empId,
    required this.startDate,
    required this.endDate,
    required final List<TimesheetEntryRequest> entries,
    this.comments,
    this.managerId,
  }) : _entries = entries;

  factory _$TimesheetRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimesheetRequestImplFromJson(json);

  @override
  final String empId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<TimesheetEntryRequest> _entries;
  @override
  List<TimesheetEntryRequest> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final String? comments;
  @override
  final String? managerId;

  @override
  String toString() {
    return 'TimesheetRequest(empId: $empId, startDate: $startDate, endDate: $endDate, entries: $entries, comments: $comments, managerId: $managerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimesheetRequestImpl &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    empId,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_entries),
    comments,
    managerId,
  );

  /// Create a copy of TimesheetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimesheetRequestImplCopyWith<_$TimesheetRequestImpl> get copyWith =>
      __$$TimesheetRequestImplCopyWithImpl<_$TimesheetRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimesheetRequestImplToJson(this);
  }
}

abstract class _TimesheetRequest implements TimesheetRequest {
  const factory _TimesheetRequest({
    required final String empId,
    required final DateTime startDate,
    required final DateTime endDate,
    required final List<TimesheetEntryRequest> entries,
    final String? comments,
    final String? managerId,
  }) = _$TimesheetRequestImpl;

  factory _TimesheetRequest.fromJson(Map<String, dynamic> json) =
      _$TimesheetRequestImpl.fromJson;

  @override
  String get empId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<TimesheetEntryRequest> get entries;
  @override
  String? get comments;
  @override
  String? get managerId;

  /// Create a copy of TimesheetRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimesheetRequestImplCopyWith<_$TimesheetRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimesheetEntryRequest _$TimesheetEntryRequestFromJson(
  Map<String, dynamic> json,
) {
  return _TimesheetEntryRequest.fromJson(json);
}

/// @nodoc
mixin _$TimesheetEntryRequest {
  String get projectId => throw _privateConstructorUsedError;
  String get taskDescription => throw _privateConstructorUsedError;
  TaskType get taskType => throw _privateConstructorUsedError;
  DateTime get workDate => throw _privateConstructorUsedError;
  double get hours => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;

  /// Serializes this TimesheetEntryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimesheetEntryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimesheetEntryRequestCopyWith<TimesheetEntryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimesheetEntryRequestCopyWith<$Res> {
  factory $TimesheetEntryRequestCopyWith(
    TimesheetEntryRequest value,
    $Res Function(TimesheetEntryRequest) then,
  ) = _$TimesheetEntryRequestCopyWithImpl<$Res, TimesheetEntryRequest>;
  @useResult
  $Res call({
    String projectId,
    String taskDescription,
    TaskType taskType,
    DateTime workDate,
    double hours,
    String? comments,
    String? managerId,
  });
}

/// @nodoc
class _$TimesheetEntryRequestCopyWithImpl<
  $Res,
  $Val extends TimesheetEntryRequest
>
    implements $TimesheetEntryRequestCopyWith<$Res> {
  _$TimesheetEntryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimesheetEntryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? taskDescription = null,
    Object? taskType = null,
    Object? workDate = null,
    Object? hours = null,
    Object? comments = freezed,
    Object? managerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            taskDescription: null == taskDescription
                ? _value.taskDescription
                : taskDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            workDate: null == workDate
                ? _value.workDate
                : workDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hours: null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                      as double,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerId: freezed == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimesheetEntryRequestImplCopyWith<$Res>
    implements $TimesheetEntryRequestCopyWith<$Res> {
  factory _$$TimesheetEntryRequestImplCopyWith(
    _$TimesheetEntryRequestImpl value,
    $Res Function(_$TimesheetEntryRequestImpl) then,
  ) = __$$TimesheetEntryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectId,
    String taskDescription,
    TaskType taskType,
    DateTime workDate,
    double hours,
    String? comments,
    String? managerId,
  });
}

/// @nodoc
class __$$TimesheetEntryRequestImplCopyWithImpl<$Res>
    extends
        _$TimesheetEntryRequestCopyWithImpl<$Res, _$TimesheetEntryRequestImpl>
    implements _$$TimesheetEntryRequestImplCopyWith<$Res> {
  __$$TimesheetEntryRequestImplCopyWithImpl(
    _$TimesheetEntryRequestImpl _value,
    $Res Function(_$TimesheetEntryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimesheetEntryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? taskDescription = null,
    Object? taskType = null,
    Object? workDate = null,
    Object? hours = null,
    Object? comments = freezed,
    Object? managerId = freezed,
  }) {
    return _then(
      _$TimesheetEntryRequestImpl(
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        taskDescription: null == taskDescription
            ? _value.taskDescription
            : taskDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        workDate: null == workDate
            ? _value.workDate
            : workDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hours: null == hours
            ? _value.hours
            : hours // ignore: cast_nullable_to_non_nullable
                  as double,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerId: freezed == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimesheetEntryRequestImpl implements _TimesheetEntryRequest {
  const _$TimesheetEntryRequestImpl({
    required this.projectId,
    required this.taskDescription,
    required this.taskType,
    required this.workDate,
    required this.hours,
    this.comments,
    this.managerId,
  });

  factory _$TimesheetEntryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimesheetEntryRequestImplFromJson(json);

  @override
  final String projectId;
  @override
  final String taskDescription;
  @override
  final TaskType taskType;
  @override
  final DateTime workDate;
  @override
  final double hours;
  @override
  final String? comments;
  @override
  final String? managerId;

  @override
  String toString() {
    return 'TimesheetEntryRequest(projectId: $projectId, taskDescription: $taskDescription, taskType: $taskType, workDate: $workDate, hours: $hours, comments: $comments, managerId: $managerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimesheetEntryRequestImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.taskDescription, taskDescription) ||
                other.taskDescription == taskDescription) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.workDate, workDate) ||
                other.workDate == workDate) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectId,
    taskDescription,
    taskType,
    workDate,
    hours,
    comments,
    managerId,
  );

  /// Create a copy of TimesheetEntryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimesheetEntryRequestImplCopyWith<_$TimesheetEntryRequestImpl>
  get copyWith =>
      __$$TimesheetEntryRequestImplCopyWithImpl<_$TimesheetEntryRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimesheetEntryRequestImplToJson(this);
  }
}

abstract class _TimesheetEntryRequest implements TimesheetEntryRequest {
  const factory _TimesheetEntryRequest({
    required final String projectId,
    required final String taskDescription,
    required final TaskType taskType,
    required final DateTime workDate,
    required final double hours,
    final String? comments,
    final String? managerId,
  }) = _$TimesheetEntryRequestImpl;

  factory _TimesheetEntryRequest.fromJson(Map<String, dynamic> json) =
      _$TimesheetEntryRequestImpl.fromJson;

  @override
  String get projectId;
  @override
  String get taskDescription;
  @override
  TaskType get taskType;
  @override
  DateTime get workDate;
  @override
  double get hours;
  @override
  String? get comments;
  @override
  String? get managerId;

  /// Create a copy of TimesheetEntryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimesheetEntryRequestImplCopyWith<_$TimesheetEntryRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TimesheetStats _$TimesheetStatsFromJson(Map<String, dynamic> json) {
  return _TimesheetStats.fromJson(json);
}

/// @nodoc
mixin _$TimesheetStats {
  int get draftCount => throw _privateConstructorUsedError;
  int get submittedCount => throw _privateConstructorUsedError;
  int get approvedCount => throw _privateConstructorUsedError;
  int get rejectedCount => throw _privateConstructorUsedError;
  double get totalHoursThisWeek => throw _privateConstructorUsedError;
  double get totalHoursThisMonth => throw _privateConstructorUsedError;
  double get averageDailyHours => throw _privateConstructorUsedError;

  /// Serializes this TimesheetStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimesheetStatsCopyWith<TimesheetStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimesheetStatsCopyWith<$Res> {
  factory $TimesheetStatsCopyWith(
    TimesheetStats value,
    $Res Function(TimesheetStats) then,
  ) = _$TimesheetStatsCopyWithImpl<$Res, TimesheetStats>;
  @useResult
  $Res call({
    int draftCount,
    int submittedCount,
    int approvedCount,
    int rejectedCount,
    double totalHoursThisWeek,
    double totalHoursThisMonth,
    double averageDailyHours,
  });
}

/// @nodoc
class _$TimesheetStatsCopyWithImpl<$Res, $Val extends TimesheetStats>
    implements $TimesheetStatsCopyWith<$Res> {
  _$TimesheetStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draftCount = null,
    Object? submittedCount = null,
    Object? approvedCount = null,
    Object? rejectedCount = null,
    Object? totalHoursThisWeek = null,
    Object? totalHoursThisMonth = null,
    Object? averageDailyHours = null,
  }) {
    return _then(
      _value.copyWith(
            draftCount: null == draftCount
                ? _value.draftCount
                : draftCount // ignore: cast_nullable_to_non_nullable
                      as int,
            submittedCount: null == submittedCount
                ? _value.submittedCount
                : submittedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            approvedCount: null == approvedCount
                ? _value.approvedCount
                : approvedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            rejectedCount: null == rejectedCount
                ? _value.rejectedCount
                : rejectedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalHoursThisWeek: null == totalHoursThisWeek
                ? _value.totalHoursThisWeek
                : totalHoursThisWeek // ignore: cast_nullable_to_non_nullable
                      as double,
            totalHoursThisMonth: null == totalHoursThisMonth
                ? _value.totalHoursThisMonth
                : totalHoursThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            averageDailyHours: null == averageDailyHours
                ? _value.averageDailyHours
                : averageDailyHours // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimesheetStatsImplCopyWith<$Res>
    implements $TimesheetStatsCopyWith<$Res> {
  factory _$$TimesheetStatsImplCopyWith(
    _$TimesheetStatsImpl value,
    $Res Function(_$TimesheetStatsImpl) then,
  ) = __$$TimesheetStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int draftCount,
    int submittedCount,
    int approvedCount,
    int rejectedCount,
    double totalHoursThisWeek,
    double totalHoursThisMonth,
    double averageDailyHours,
  });
}

/// @nodoc
class __$$TimesheetStatsImplCopyWithImpl<$Res>
    extends _$TimesheetStatsCopyWithImpl<$Res, _$TimesheetStatsImpl>
    implements _$$TimesheetStatsImplCopyWith<$Res> {
  __$$TimesheetStatsImplCopyWithImpl(
    _$TimesheetStatsImpl _value,
    $Res Function(_$TimesheetStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draftCount = null,
    Object? submittedCount = null,
    Object? approvedCount = null,
    Object? rejectedCount = null,
    Object? totalHoursThisWeek = null,
    Object? totalHoursThisMonth = null,
    Object? averageDailyHours = null,
  }) {
    return _then(
      _$TimesheetStatsImpl(
        draftCount: null == draftCount
            ? _value.draftCount
            : draftCount // ignore: cast_nullable_to_non_nullable
                  as int,
        submittedCount: null == submittedCount
            ? _value.submittedCount
            : submittedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        approvedCount: null == approvedCount
            ? _value.approvedCount
            : approvedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        rejectedCount: null == rejectedCount
            ? _value.rejectedCount
            : rejectedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalHoursThisWeek: null == totalHoursThisWeek
            ? _value.totalHoursThisWeek
            : totalHoursThisWeek // ignore: cast_nullable_to_non_nullable
                  as double,
        totalHoursThisMonth: null == totalHoursThisMonth
            ? _value.totalHoursThisMonth
            : totalHoursThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        averageDailyHours: null == averageDailyHours
            ? _value.averageDailyHours
            : averageDailyHours // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimesheetStatsImpl implements _TimesheetStats {
  const _$TimesheetStatsImpl({
    this.draftCount = 0,
    this.submittedCount = 0,
    this.approvedCount = 0,
    this.rejectedCount = 0,
    this.totalHoursThisWeek = 0.0,
    this.totalHoursThisMonth = 0.0,
    this.averageDailyHours = 0.0,
  });

  factory _$TimesheetStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimesheetStatsImplFromJson(json);

  @override
  @JsonKey()
  final int draftCount;
  @override
  @JsonKey()
  final int submittedCount;
  @override
  @JsonKey()
  final int approvedCount;
  @override
  @JsonKey()
  final int rejectedCount;
  @override
  @JsonKey()
  final double totalHoursThisWeek;
  @override
  @JsonKey()
  final double totalHoursThisMonth;
  @override
  @JsonKey()
  final double averageDailyHours;

  @override
  String toString() {
    return 'TimesheetStats(draftCount: $draftCount, submittedCount: $submittedCount, approvedCount: $approvedCount, rejectedCount: $rejectedCount, totalHoursThisWeek: $totalHoursThisWeek, totalHoursThisMonth: $totalHoursThisMonth, averageDailyHours: $averageDailyHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimesheetStatsImpl &&
            (identical(other.draftCount, draftCount) ||
                other.draftCount == draftCount) &&
            (identical(other.submittedCount, submittedCount) ||
                other.submittedCount == submittedCount) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.rejectedCount, rejectedCount) ||
                other.rejectedCount == rejectedCount) &&
            (identical(other.totalHoursThisWeek, totalHoursThisWeek) ||
                other.totalHoursThisWeek == totalHoursThisWeek) &&
            (identical(other.totalHoursThisMonth, totalHoursThisMonth) ||
                other.totalHoursThisMonth == totalHoursThisMonth) &&
            (identical(other.averageDailyHours, averageDailyHours) ||
                other.averageDailyHours == averageDailyHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    draftCount,
    submittedCount,
    approvedCount,
    rejectedCount,
    totalHoursThisWeek,
    totalHoursThisMonth,
    averageDailyHours,
  );

  /// Create a copy of TimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimesheetStatsImplCopyWith<_$TimesheetStatsImpl> get copyWith =>
      __$$TimesheetStatsImplCopyWithImpl<_$TimesheetStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimesheetStatsImplToJson(this);
  }
}

abstract class _TimesheetStats implements TimesheetStats {
  const factory _TimesheetStats({
    final int draftCount,
    final int submittedCount,
    final int approvedCount,
    final int rejectedCount,
    final double totalHoursThisWeek,
    final double totalHoursThisMonth,
    final double averageDailyHours,
  }) = _$TimesheetStatsImpl;

  factory _TimesheetStats.fromJson(Map<String, dynamic> json) =
      _$TimesheetStatsImpl.fromJson;

  @override
  int get draftCount;
  @override
  int get submittedCount;
  @override
  int get approvedCount;
  @override
  int get rejectedCount;
  @override
  double get totalHoursThisWeek;
  @override
  double get totalHoursThisMonth;
  @override
  double get averageDailyHours;

  /// Create a copy of TimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimesheetStatsImplCopyWith<_$TimesheetStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerTimesheetStats _$ManagerTimesheetStatsFromJson(
  Map<String, dynamic> json,
) {
  return _ManagerTimesheetStats.fromJson(json);
}

/// @nodoc
mixin _$ManagerTimesheetStats {
  int get teamPending => throw _privateConstructorUsedError;
  int get teamApproved => throw _privateConstructorUsedError;
  int get teamRejected => throw _privateConstructorUsedError;
  int get selfPending => throw _privateConstructorUsedError;
  int get selfApproved => throw _privateConstructorUsedError;
  double get teamTotalHours => throw _privateConstructorUsedError;

  /// Serializes this ManagerTimesheetStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerTimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerTimesheetStatsCopyWith<ManagerTimesheetStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerTimesheetStatsCopyWith<$Res> {
  factory $ManagerTimesheetStatsCopyWith(
    ManagerTimesheetStats value,
    $Res Function(ManagerTimesheetStats) then,
  ) = _$ManagerTimesheetStatsCopyWithImpl<$Res, ManagerTimesheetStats>;
  @useResult
  $Res call({
    int teamPending,
    int teamApproved,
    int teamRejected,
    int selfPending,
    int selfApproved,
    double teamTotalHours,
  });
}

/// @nodoc
class _$ManagerTimesheetStatsCopyWithImpl<
  $Res,
  $Val extends ManagerTimesheetStats
>
    implements $ManagerTimesheetStatsCopyWith<$Res> {
  _$ManagerTimesheetStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerTimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamPending = null,
    Object? teamApproved = null,
    Object? teamRejected = null,
    Object? selfPending = null,
    Object? selfApproved = null,
    Object? teamTotalHours = null,
  }) {
    return _then(
      _value.copyWith(
            teamPending: null == teamPending
                ? _value.teamPending
                : teamPending // ignore: cast_nullable_to_non_nullable
                      as int,
            teamApproved: null == teamApproved
                ? _value.teamApproved
                : teamApproved // ignore: cast_nullable_to_non_nullable
                      as int,
            teamRejected: null == teamRejected
                ? _value.teamRejected
                : teamRejected // ignore: cast_nullable_to_non_nullable
                      as int,
            selfPending: null == selfPending
                ? _value.selfPending
                : selfPending // ignore: cast_nullable_to_non_nullable
                      as int,
            selfApproved: null == selfApproved
                ? _value.selfApproved
                : selfApproved // ignore: cast_nullable_to_non_nullable
                      as int,
            teamTotalHours: null == teamTotalHours
                ? _value.teamTotalHours
                : teamTotalHours // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerTimesheetStatsImplCopyWith<$Res>
    implements $ManagerTimesheetStatsCopyWith<$Res> {
  factory _$$ManagerTimesheetStatsImplCopyWith(
    _$ManagerTimesheetStatsImpl value,
    $Res Function(_$ManagerTimesheetStatsImpl) then,
  ) = __$$ManagerTimesheetStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int teamPending,
    int teamApproved,
    int teamRejected,
    int selfPending,
    int selfApproved,
    double teamTotalHours,
  });
}

/// @nodoc
class __$$ManagerTimesheetStatsImplCopyWithImpl<$Res>
    extends
        _$ManagerTimesheetStatsCopyWithImpl<$Res, _$ManagerTimesheetStatsImpl>
    implements _$$ManagerTimesheetStatsImplCopyWith<$Res> {
  __$$ManagerTimesheetStatsImplCopyWithImpl(
    _$ManagerTimesheetStatsImpl _value,
    $Res Function(_$ManagerTimesheetStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerTimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamPending = null,
    Object? teamApproved = null,
    Object? teamRejected = null,
    Object? selfPending = null,
    Object? selfApproved = null,
    Object? teamTotalHours = null,
  }) {
    return _then(
      _$ManagerTimesheetStatsImpl(
        teamPending: null == teamPending
            ? _value.teamPending
            : teamPending // ignore: cast_nullable_to_non_nullable
                  as int,
        teamApproved: null == teamApproved
            ? _value.teamApproved
            : teamApproved // ignore: cast_nullable_to_non_nullable
                  as int,
        teamRejected: null == teamRejected
            ? _value.teamRejected
            : teamRejected // ignore: cast_nullable_to_non_nullable
                  as int,
        selfPending: null == selfPending
            ? _value.selfPending
            : selfPending // ignore: cast_nullable_to_non_nullable
                  as int,
        selfApproved: null == selfApproved
            ? _value.selfApproved
            : selfApproved // ignore: cast_nullable_to_non_nullable
                  as int,
        teamTotalHours: null == teamTotalHours
            ? _value.teamTotalHours
            : teamTotalHours // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerTimesheetStatsImpl implements _ManagerTimesheetStats {
  const _$ManagerTimesheetStatsImpl({
    this.teamPending = 0,
    this.teamApproved = 0,
    this.teamRejected = 0,
    this.selfPending = 0,
    this.selfApproved = 0,
    this.teamTotalHours = 0.0,
  });

  factory _$ManagerTimesheetStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerTimesheetStatsImplFromJson(json);

  @override
  @JsonKey()
  final int teamPending;
  @override
  @JsonKey()
  final int teamApproved;
  @override
  @JsonKey()
  final int teamRejected;
  @override
  @JsonKey()
  final int selfPending;
  @override
  @JsonKey()
  final int selfApproved;
  @override
  @JsonKey()
  final double teamTotalHours;

  @override
  String toString() {
    return 'ManagerTimesheetStats(teamPending: $teamPending, teamApproved: $teamApproved, teamRejected: $teamRejected, selfPending: $selfPending, selfApproved: $selfApproved, teamTotalHours: $teamTotalHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerTimesheetStatsImpl &&
            (identical(other.teamPending, teamPending) ||
                other.teamPending == teamPending) &&
            (identical(other.teamApproved, teamApproved) ||
                other.teamApproved == teamApproved) &&
            (identical(other.teamRejected, teamRejected) ||
                other.teamRejected == teamRejected) &&
            (identical(other.selfPending, selfPending) ||
                other.selfPending == selfPending) &&
            (identical(other.selfApproved, selfApproved) ||
                other.selfApproved == selfApproved) &&
            (identical(other.teamTotalHours, teamTotalHours) ||
                other.teamTotalHours == teamTotalHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    teamPending,
    teamApproved,
    teamRejected,
    selfPending,
    selfApproved,
    teamTotalHours,
  );

  /// Create a copy of ManagerTimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerTimesheetStatsImplCopyWith<_$ManagerTimesheetStatsImpl>
  get copyWith =>
      __$$ManagerTimesheetStatsImplCopyWithImpl<_$ManagerTimesheetStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerTimesheetStatsImplToJson(this);
  }
}

abstract class _ManagerTimesheetStats implements ManagerTimesheetStats {
  const factory _ManagerTimesheetStats({
    final int teamPending,
    final int teamApproved,
    final int teamRejected,
    final int selfPending,
    final int selfApproved,
    final double teamTotalHours,
  }) = _$ManagerTimesheetStatsImpl;

  factory _ManagerTimesheetStats.fromJson(Map<String, dynamic> json) =
      _$ManagerTimesheetStatsImpl.fromJson;

  @override
  int get teamPending;
  @override
  int get teamApproved;
  @override
  int get teamRejected;
  @override
  int get selfPending;
  @override
  int get selfApproved;
  @override
  double get teamTotalHours;

  /// Create a copy of ManagerTimesheetStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerTimesheetStatsImplCopyWith<_$ManagerTimesheetStatsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
