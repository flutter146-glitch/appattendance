// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String get taskId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  String get taskName => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  DateTime get estEndDate => throw _privateConstructorUsedError;
  DateTime? get actualEndDate => throw _privateConstructorUsedError;
  double get estEffortHrs => throw _privateConstructorUsedError;
  double? get actualEffortHrs => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get deliverables => throw _privateConstructorUsedError;
  String? get taskHistory => throw _privateConstructorUsedError;
  String? get managerComments => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get billable => throw _privateConstructorUsedError;
  List<AttachedFile> get attachedFiles => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call({
    String taskId,
    String projectId,
    String projectName,
    String taskName,
    String type,
    TaskPriority priority,
    DateTime estEndDate,
    DateTime? actualEndDate,
    double estEffortHrs,
    double? actualEffortHrs,
    TaskStatus status,
    String description,
    String? deliverables,
    String? taskHistory,
    String? managerComments,
    String? notes,
    bool billable,
    List<AttachedFile> attachedFiles,
  });
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? projectId = null,
    Object? projectName = null,
    Object? taskName = null,
    Object? type = null,
    Object? priority = null,
    Object? estEndDate = null,
    Object? actualEndDate = freezed,
    Object? estEffortHrs = null,
    Object? actualEffortHrs = freezed,
    Object? status = null,
    Object? description = null,
    Object? deliverables = freezed,
    Object? taskHistory = freezed,
    Object? managerComments = freezed,
    Object? notes = freezed,
    Object? billable = null,
    Object? attachedFiles = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
            taskName: null == taskName
                ? _value.taskName
                : taskName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            estEndDate: null == estEndDate
                ? _value.estEndDate
                : estEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            actualEndDate: freezed == actualEndDate
                ? _value.actualEndDate
                : actualEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estEffortHrs: null == estEffortHrs
                ? _value.estEffortHrs
                : estEffortHrs // ignore: cast_nullable_to_non_nullable
                      as double,
            actualEffortHrs: freezed == actualEffortHrs
                ? _value.actualEffortHrs
                : actualEffortHrs // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            deliverables: freezed == deliverables
                ? _value.deliverables
                : deliverables // ignore: cast_nullable_to_non_nullable
                      as String?,
            taskHistory: freezed == taskHistory
                ? _value.taskHistory
                : taskHistory // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerComments: freezed == managerComments
                ? _value.managerComments
                : managerComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            billable: null == billable
                ? _value.billable
                : billable // ignore: cast_nullable_to_non_nullable
                      as bool,
            attachedFiles: null == attachedFiles
                ? _value.attachedFiles
                : attachedFiles // ignore: cast_nullable_to_non_nullable
                      as List<AttachedFile>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
    _$TaskModelImpl value,
    $Res Function(_$TaskModelImpl) then,
  ) = __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String taskId,
    String projectId,
    String projectName,
    String taskName,
    String type,
    TaskPriority priority,
    DateTime estEndDate,
    DateTime? actualEndDate,
    double estEffortHrs,
    double? actualEffortHrs,
    TaskStatus status,
    String description,
    String? deliverables,
    String? taskHistory,
    String? managerComments,
    String? notes,
    bool billable,
    List<AttachedFile> attachedFiles,
  });
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
    _$TaskModelImpl _value,
    $Res Function(_$TaskModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? projectId = null,
    Object? projectName = null,
    Object? taskName = null,
    Object? type = null,
    Object? priority = null,
    Object? estEndDate = null,
    Object? actualEndDate = freezed,
    Object? estEffortHrs = null,
    Object? actualEffortHrs = freezed,
    Object? status = null,
    Object? description = null,
    Object? deliverables = freezed,
    Object? taskHistory = freezed,
    Object? managerComments = freezed,
    Object? notes = freezed,
    Object? billable = null,
    Object? attachedFiles = null,
  }) {
    return _then(
      _$TaskModelImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
        taskName: null == taskName
            ? _value.taskName
            : taskName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        estEndDate: null == estEndDate
            ? _value.estEndDate
            : estEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        actualEndDate: freezed == actualEndDate
            ? _value.actualEndDate
            : actualEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estEffortHrs: null == estEffortHrs
            ? _value.estEffortHrs
            : estEffortHrs // ignore: cast_nullable_to_non_nullable
                  as double,
        actualEffortHrs: freezed == actualEffortHrs
            ? _value.actualEffortHrs
            : actualEffortHrs // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        deliverables: freezed == deliverables
            ? _value.deliverables
            : deliverables // ignore: cast_nullable_to_non_nullable
                  as String?,
        taskHistory: freezed == taskHistory
            ? _value.taskHistory
            : taskHistory // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerComments: freezed == managerComments
            ? _value.managerComments
            : managerComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        billable: null == billable
            ? _value.billable
            : billable // ignore: cast_nullable_to_non_nullable
                  as bool,
        attachedFiles: null == attachedFiles
            ? _value._attachedFiles
            : attachedFiles // ignore: cast_nullable_to_non_nullable
                  as List<AttachedFile>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl implements _TaskModel {
  const _$TaskModelImpl({
    required this.taskId,
    required this.projectId,
    required this.projectName,
    required this.taskName,
    required this.type,
    required this.priority,
    required this.estEndDate,
    this.actualEndDate,
    required this.estEffortHrs,
    this.actualEffortHrs,
    required this.status,
    required this.description,
    this.deliverables,
    this.taskHistory,
    this.managerComments,
    this.notes,
    required this.billable,
    final List<AttachedFile> attachedFiles = const [],
  }) : _attachedFiles = attachedFiles;

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String taskId;
  @override
  final String projectId;
  @override
  final String projectName;
  @override
  final String taskName;
  @override
  final String type;
  @override
  final TaskPriority priority;
  @override
  final DateTime estEndDate;
  @override
  final DateTime? actualEndDate;
  @override
  final double estEffortHrs;
  @override
  final double? actualEffortHrs;
  @override
  final TaskStatus status;
  @override
  final String description;
  @override
  final String? deliverables;
  @override
  final String? taskHistory;
  @override
  final String? managerComments;
  @override
  final String? notes;
  @override
  final bool billable;
  final List<AttachedFile> _attachedFiles;
  @override
  @JsonKey()
  List<AttachedFile> get attachedFiles {
    if (_attachedFiles is EqualUnmodifiableListView) return _attachedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachedFiles);
  }

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, projectId: $projectId, projectName: $projectName, taskName: $taskName, type: $type, priority: $priority, estEndDate: $estEndDate, actualEndDate: $actualEndDate, estEffortHrs: $estEffortHrs, actualEffortHrs: $actualEffortHrs, status: $status, description: $description, deliverables: $deliverables, taskHistory: $taskHistory, managerComments: $managerComments, notes: $notes, billable: $billable, attachedFiles: $attachedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.estEndDate, estEndDate) ||
                other.estEndDate == estEndDate) &&
            (identical(other.actualEndDate, actualEndDate) ||
                other.actualEndDate == actualEndDate) &&
            (identical(other.estEffortHrs, estEffortHrs) ||
                other.estEffortHrs == estEffortHrs) &&
            (identical(other.actualEffortHrs, actualEffortHrs) ||
                other.actualEffortHrs == actualEffortHrs) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deliverables, deliverables) ||
                other.deliverables == deliverables) &&
            (identical(other.taskHistory, taskHistory) ||
                other.taskHistory == taskHistory) &&
            (identical(other.managerComments, managerComments) ||
                other.managerComments == managerComments) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.billable, billable) ||
                other.billable == billable) &&
            const DeepCollectionEquality().equals(
              other._attachedFiles,
              _attachedFiles,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    projectId,
    projectName,
    taskName,
    type,
    priority,
    estEndDate,
    actualEndDate,
    estEffortHrs,
    actualEffortHrs,
    status,
    description,
    deliverables,
    taskHistory,
    managerComments,
    notes,
    billable,
    const DeepCollectionEquality().hash(_attachedFiles),
  );

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(this);
  }
}

abstract class _TaskModel implements TaskModel {
  const factory _TaskModel({
    required final String taskId,
    required final String projectId,
    required final String projectName,
    required final String taskName,
    required final String type,
    required final TaskPriority priority,
    required final DateTime estEndDate,
    final DateTime? actualEndDate,
    required final double estEffortHrs,
    final double? actualEffortHrs,
    required final TaskStatus status,
    required final String description,
    final String? deliverables,
    final String? taskHistory,
    final String? managerComments,
    final String? notes,
    required final bool billable,
    final List<AttachedFile> attachedFiles,
  }) = _$TaskModelImpl;

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String get taskId;
  @override
  String get projectId;
  @override
  String get projectName;
  @override
  String get taskName;
  @override
  String get type;
  @override
  TaskPriority get priority;
  @override
  DateTime get estEndDate;
  @override
  DateTime? get actualEndDate;
  @override
  double get estEffortHrs;
  @override
  double? get actualEffortHrs;
  @override
  TaskStatus get status;
  @override
  String get description;
  @override
  String? get deliverables;
  @override
  String? get taskHistory;
  @override
  String? get managerComments;
  @override
  String? get notes;
  @override
  bool get billable;
  @override
  List<AttachedFile> get attachedFiles;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttachedFile _$AttachedFileFromJson(Map<String, dynamic> json) {
  return _AttachedFile.fromJson(json);
}

/// @nodoc
mixin _$AttachedFile {
  String get fileName => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  String get fileType => throw _privateConstructorUsedError;

  /// Serializes this AttachedFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttachedFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachedFileCopyWith<AttachedFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachedFileCopyWith<$Res> {
  factory $AttachedFileCopyWith(
    AttachedFile value,
    $Res Function(AttachedFile) then,
  ) = _$AttachedFileCopyWithImpl<$Res, AttachedFile>;
  @useResult
  $Res call({String fileName, String filePath, String fileType});
}

/// @nodoc
class _$AttachedFileCopyWithImpl<$Res, $Val extends AttachedFile>
    implements $AttachedFileCopyWith<$Res> {
  _$AttachedFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttachedFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? filePath = null,
    Object? fileType = null,
  }) {
    return _then(
      _value.copyWith(
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            fileType: null == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttachedFileImplCopyWith<$Res>
    implements $AttachedFileCopyWith<$Res> {
  factory _$$AttachedFileImplCopyWith(
    _$AttachedFileImpl value,
    $Res Function(_$AttachedFileImpl) then,
  ) = __$$AttachedFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fileName, String filePath, String fileType});
}

/// @nodoc
class __$$AttachedFileImplCopyWithImpl<$Res>
    extends _$AttachedFileCopyWithImpl<$Res, _$AttachedFileImpl>
    implements _$$AttachedFileImplCopyWith<$Res> {
  __$$AttachedFileImplCopyWithImpl(
    _$AttachedFileImpl _value,
    $Res Function(_$AttachedFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttachedFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? filePath = null,
    Object? fileType = null,
  }) {
    return _then(
      _$AttachedFileImpl(
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        fileType: null == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachedFileImpl implements _AttachedFile {
  const _$AttachedFileImpl({
    required this.fileName,
    required this.filePath,
    required this.fileType,
  });

  factory _$AttachedFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachedFileImplFromJson(json);

  @override
  final String fileName;
  @override
  final String filePath;
  @override
  final String fileType;

  @override
  String toString() {
    return 'AttachedFile(fileName: $fileName, filePath: $filePath, fileType: $fileType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachedFileImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, filePath, fileType);

  /// Create a copy of AttachedFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachedFileImplCopyWith<_$AttachedFileImpl> get copyWith =>
      __$$AttachedFileImplCopyWithImpl<_$AttachedFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachedFileImplToJson(this);
  }
}

abstract class _AttachedFile implements AttachedFile {
  const factory _AttachedFile({
    required final String fileName,
    required final String filePath,
    required final String fileType,
  }) = _$AttachedFileImpl;

  factory _AttachedFile.fromJson(Map<String, dynamic> json) =
      _$AttachedFileImpl.fromJson;

  @override
  String get fileName;
  @override
  String get filePath;
  @override
  String get fileType;

  /// Create a copy of AttachedFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachedFileImplCopyWith<_$AttachedFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
