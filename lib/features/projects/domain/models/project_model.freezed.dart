// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MappedProject _$MappedProjectFromJson(Map<String, dynamic> json) {
  return _MappedProject.fromJson(json);
}

/// @nodoc
mixin _$MappedProject {
  String get empId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get mappingStatus =>
      throw _privateConstructorUsedError; // 'active', 'inactive', etc.
  ProjectModel get project =>
      throw _privateConstructorUsedError; // Full project details
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MappedProject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MappedProjectCopyWith<MappedProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MappedProjectCopyWith<$Res> {
  factory $MappedProjectCopyWith(
    MappedProject value,
    $Res Function(MappedProject) then,
  ) = _$MappedProjectCopyWithImpl<$Res, MappedProject>;
  @useResult
  $Res call({
    String empId,
    String projectId,
    String mappingStatus,
    ProjectModel project,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $ProjectModelCopyWith<$Res> get project;
}

/// @nodoc
class _$MappedProjectCopyWithImpl<$Res, $Val extends MappedProject>
    implements $MappedProjectCopyWith<$Res> {
  _$MappedProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? projectId = null,
    Object? mappingStatus = null,
    Object? project = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            mappingStatus: null == mappingStatus
                ? _value.mappingStatus
                : mappingStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            project: null == project
                ? _value.project
                : project // ignore: cast_nullable_to_non_nullable
                      as ProjectModel,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectModelCopyWith<$Res> get project {
    return $ProjectModelCopyWith<$Res>(_value.project, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MappedProjectImplCopyWith<$Res>
    implements $MappedProjectCopyWith<$Res> {
  factory _$$MappedProjectImplCopyWith(
    _$MappedProjectImpl value,
    $Res Function(_$MappedProjectImpl) then,
  ) = __$$MappedProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String empId,
    String projectId,
    String mappingStatus,
    ProjectModel project,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $ProjectModelCopyWith<$Res> get project;
}

/// @nodoc
class __$$MappedProjectImplCopyWithImpl<$Res>
    extends _$MappedProjectCopyWithImpl<$Res, _$MappedProjectImpl>
    implements _$$MappedProjectImplCopyWith<$Res> {
  __$$MappedProjectImplCopyWithImpl(
    _$MappedProjectImpl _value,
    $Res Function(_$MappedProjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? projectId = null,
    Object? mappingStatus = null,
    Object? project = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MappedProjectImpl(
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        mappingStatus: null == mappingStatus
            ? _value.mappingStatus
            : mappingStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        project: null == project
            ? _value.project
            : project // ignore: cast_nullable_to_non_nullable
                  as ProjectModel,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MappedProjectImpl implements _MappedProject {
  const _$MappedProjectImpl({
    required this.empId,
    required this.projectId,
    required this.mappingStatus,
    required this.project,
    this.createdAt,
    this.updatedAt,
  });

  factory _$MappedProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$MappedProjectImplFromJson(json);

  @override
  final String empId;
  @override
  final String projectId;
  @override
  final String mappingStatus;
  // 'active', 'inactive', etc.
  @override
  final ProjectModel project;
  // Full project details
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MappedProject(empId: $empId, projectId: $projectId, mappingStatus: $mappingStatus, project: $project, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MappedProjectImpl &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.mappingStatus, mappingStatus) ||
                other.mappingStatus == mappingStatus) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    empId,
    projectId,
    mappingStatus,
    project,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MappedProjectImplCopyWith<_$MappedProjectImpl> get copyWith =>
      __$$MappedProjectImplCopyWithImpl<_$MappedProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MappedProjectImplToJson(this);
  }
}

abstract class _MappedProject implements MappedProject {
  const factory _MappedProject({
    required final String empId,
    required final String projectId,
    required final String mappingStatus,
    required final ProjectModel project,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$MappedProjectImpl;

  factory _MappedProject.fromJson(Map<String, dynamic> json) =
      _$MappedProjectImpl.fromJson;

  @override
  String get empId;
  @override
  String get projectId;
  @override
  String get mappingStatus; // 'active', 'inactive', etc.
  @override
  ProjectModel get project; // Full project details
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MappedProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MappedProjectImplCopyWith<_$MappedProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  // Core identifiers
  String get projectId => throw _privateConstructorUsedError; // PK
  String get projectName => throw _privateConstructorUsedError;
  String get orgShortName =>
      throw _privateConstructorUsedError; // e.g., "NUTANTEK"
  // Details
  String? get projectDescription => throw _privateConstructorUsedError;
  String? get projectSite => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get clientLocation => throw _privateConstructorUsedError;
  String? get clientContact => throw _privateConstructorUsedError;
  String? get techStack => throw _privateConstructorUsedError;
  String? get mngName =>
      throw _privateConstructorUsedError; // Project Manager name
  String? get mngEmail => throw _privateConstructorUsedError;
  String? get mngContact =>
      throw _privateConstructorUsedError; // Timeline (from dummy_data)
  String? get estdStartDate =>
      throw _privateConstructorUsedError; // ← String as in dummy_data
  String? get estdEndDate =>
      throw _privateConstructorUsedError; // ← String as in dummy_data
  String? get estdEffort =>
      throw _privateConstructorUsedError; // ← String (e.g., "765 Man Days")
  String? get estdCost =>
      throw _privateConstructorUsedError; // ← String (e.g., "₹ 50,000")
  DateTime? get assignedDate => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate =>
      throw _privateConstructorUsedError; // Status & Priority
  ProjectStatus get status => throw _privateConstructorUsedError;
  ProjectPriority get priority =>
      throw _privateConstructorUsedError; // Progress & Analytics (from DB or computed)
  double get progress => throw _privateConstructorUsedError; // 0.0 to 100.0
  int get totalTasks => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  int get teamSize =>
      throw _privateConstructorUsedError; // From employee_mapped_projects count
  // Audit
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
    ProjectModel value,
    $Res Function(ProjectModel) then,
  ) = _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call({
    String projectId,
    String projectName,
    String orgShortName,
    String? projectDescription,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? techStack,
    String? mngName,
    String? mngEmail,
    String? mngContact,
    String? estdStartDate,
    String? estdEndDate,
    String? estdEffort,
    String? estdCost,
    DateTime? assignedDate,
    DateTime? startDate,
    DateTime? endDate,
    ProjectStatus status,
    ProjectPriority priority,
    double progress,
    int totalTasks,
    int completedTasks,
    int teamSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? projectName = null,
    Object? orgShortName = null,
    Object? projectDescription = freezed,
    Object? projectSite = freezed,
    Object? clientName = freezed,
    Object? clientLocation = freezed,
    Object? clientContact = freezed,
    Object? techStack = freezed,
    Object? mngName = freezed,
    Object? mngEmail = freezed,
    Object? mngContact = freezed,
    Object? estdStartDate = freezed,
    Object? estdEndDate = freezed,
    Object? estdEffort = freezed,
    Object? estdCost = freezed,
    Object? assignedDate = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? priority = null,
    Object? progress = null,
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? teamSize = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
            orgShortName: null == orgShortName
                ? _value.orgShortName
                : orgShortName // ignore: cast_nullable_to_non_nullable
                      as String,
            projectDescription: freezed == projectDescription
                ? _value.projectDescription
                : projectDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectSite: freezed == projectSite
                ? _value.projectSite
                : projectSite // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientName: freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientLocation: freezed == clientLocation
                ? _value.clientLocation
                : clientLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientContact: freezed == clientContact
                ? _value.clientContact
                : clientContact // ignore: cast_nullable_to_non_nullable
                      as String?,
            techStack: freezed == techStack
                ? _value.techStack
                : techStack // ignore: cast_nullable_to_non_nullable
                      as String?,
            mngName: freezed == mngName
                ? _value.mngName
                : mngName // ignore: cast_nullable_to_non_nullable
                      as String?,
            mngEmail: freezed == mngEmail
                ? _value.mngEmail
                : mngEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            mngContact: freezed == mngContact
                ? _value.mngContact
                : mngContact // ignore: cast_nullable_to_non_nullable
                      as String?,
            estdStartDate: freezed == estdStartDate
                ? _value.estdStartDate
                : estdStartDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            estdEndDate: freezed == estdEndDate
                ? _value.estdEndDate
                : estdEndDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            estdEffort: freezed == estdEffort
                ? _value.estdEffort
                : estdEffort // ignore: cast_nullable_to_non_nullable
                      as String?,
            estdCost: freezed == estdCost
                ? _value.estdCost
                : estdCost // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedDate: freezed == assignedDate
                ? _value.assignedDate
                : assignedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ProjectStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as ProjectPriority,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            totalTasks: null == totalTasks
                ? _value.totalTasks
                : totalTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasks: null == completedTasks
                ? _value.completedTasks
                : completedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            teamSize: null == teamSize
                ? _value.teamSize
                : teamSize // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
    _$ProjectModelImpl value,
    $Res Function(_$ProjectModelImpl) then,
  ) = __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectId,
    String projectName,
    String orgShortName,
    String? projectDescription,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? techStack,
    String? mngName,
    String? mngEmail,
    String? mngContact,
    String? estdStartDate,
    String? estdEndDate,
    String? estdEffort,
    String? estdCost,
    DateTime? assignedDate,
    DateTime? startDate,
    DateTime? endDate,
    ProjectStatus status,
    ProjectPriority priority,
    double progress,
    int totalTasks,
    int completedTasks,
    int teamSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
    _$ProjectModelImpl _value,
    $Res Function(_$ProjectModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? projectName = null,
    Object? orgShortName = null,
    Object? projectDescription = freezed,
    Object? projectSite = freezed,
    Object? clientName = freezed,
    Object? clientLocation = freezed,
    Object? clientContact = freezed,
    Object? techStack = freezed,
    Object? mngName = freezed,
    Object? mngEmail = freezed,
    Object? mngContact = freezed,
    Object? estdStartDate = freezed,
    Object? estdEndDate = freezed,
    Object? estdEffort = freezed,
    Object? estdCost = freezed,
    Object? assignedDate = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? priority = null,
    Object? progress = null,
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? teamSize = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ProjectModelImpl(
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
        orgShortName: null == orgShortName
            ? _value.orgShortName
            : orgShortName // ignore: cast_nullable_to_non_nullable
                  as String,
        projectDescription: freezed == projectDescription
            ? _value.projectDescription
            : projectDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectSite: freezed == projectSite
            ? _value.projectSite
            : projectSite // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientName: freezed == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientLocation: freezed == clientLocation
            ? _value.clientLocation
            : clientLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientContact: freezed == clientContact
            ? _value.clientContact
            : clientContact // ignore: cast_nullable_to_non_nullable
                  as String?,
        techStack: freezed == techStack
            ? _value.techStack
            : techStack // ignore: cast_nullable_to_non_nullable
                  as String?,
        mngName: freezed == mngName
            ? _value.mngName
            : mngName // ignore: cast_nullable_to_non_nullable
                  as String?,
        mngEmail: freezed == mngEmail
            ? _value.mngEmail
            : mngEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        mngContact: freezed == mngContact
            ? _value.mngContact
            : mngContact // ignore: cast_nullable_to_non_nullable
                  as String?,
        estdStartDate: freezed == estdStartDate
            ? _value.estdStartDate
            : estdStartDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        estdEndDate: freezed == estdEndDate
            ? _value.estdEndDate
            : estdEndDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        estdEffort: freezed == estdEffort
            ? _value.estdEffort
            : estdEffort // ignore: cast_nullable_to_non_nullable
                  as String?,
        estdCost: freezed == estdCost
            ? _value.estdCost
            : estdCost // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedDate: freezed == assignedDate
            ? _value.assignedDate
            : assignedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ProjectStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as ProjectPriority,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        totalTasks: null == totalTasks
            ? _value.totalTasks
            : totalTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasks: null == completedTasks
            ? _value.completedTasks
            : completedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        teamSize: null == teamSize
            ? _value.teamSize
            : teamSize // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl extends _ProjectModel {
  const _$ProjectModelImpl({
    required this.projectId,
    required this.projectName,
    required this.orgShortName,
    this.projectDescription,
    this.projectSite,
    this.clientName,
    this.clientLocation,
    this.clientContact,
    this.techStack,
    this.mngName,
    this.mngEmail,
    this.mngContact,
    this.estdStartDate,
    this.estdEndDate,
    this.estdEffort,
    this.estdCost,
    this.assignedDate,
    this.startDate,
    this.endDate,
    this.status = ProjectStatus.active,
    this.priority = ProjectPriority.medium,
    this.progress = 0.0,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.teamSize = 0,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  // Core identifiers
  @override
  final String projectId;
  // PK
  @override
  final String projectName;
  @override
  final String orgShortName;
  // e.g., "NUTANTEK"
  // Details
  @override
  final String? projectDescription;
  @override
  final String? projectSite;
  @override
  final String? clientName;
  @override
  final String? clientLocation;
  @override
  final String? clientContact;
  @override
  final String? techStack;
  @override
  final String? mngName;
  // Project Manager name
  @override
  final String? mngEmail;
  @override
  final String? mngContact;
  // Timeline (from dummy_data)
  @override
  final String? estdStartDate;
  // ← String as in dummy_data
  @override
  final String? estdEndDate;
  // ← String as in dummy_data
  @override
  final String? estdEffort;
  // ← String (e.g., "765 Man Days")
  @override
  final String? estdCost;
  // ← String (e.g., "₹ 50,000")
  @override
  final DateTime? assignedDate;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  // Status & Priority
  @override
  @JsonKey()
  final ProjectStatus status;
  @override
  @JsonKey()
  final ProjectPriority priority;
  // Progress & Analytics (from DB or computed)
  @override
  @JsonKey()
  final double progress;
  // 0.0 to 100.0
  @override
  @JsonKey()
  final int totalTasks;
  @override
  @JsonKey()
  final int completedTasks;
  @override
  @JsonKey()
  final int teamSize;
  // From employee_mapped_projects count
  // Audit
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProjectModel(projectId: $projectId, projectName: $projectName, orgShortName: $orgShortName, projectDescription: $projectDescription, projectSite: $projectSite, clientName: $clientName, clientLocation: $clientLocation, clientContact: $clientContact, techStack: $techStack, mngName: $mngName, mngEmail: $mngEmail, mngContact: $mngContact, estdStartDate: $estdStartDate, estdEndDate: $estdEndDate, estdEffort: $estdEffort, estdCost: $estdCost, assignedDate: $assignedDate, startDate: $startDate, endDate: $endDate, status: $status, priority: $priority, progress: $progress, totalTasks: $totalTasks, completedTasks: $completedTasks, teamSize: $teamSize, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.orgShortName, orgShortName) ||
                other.orgShortName == orgShortName) &&
            (identical(other.projectDescription, projectDescription) ||
                other.projectDescription == projectDescription) &&
            (identical(other.projectSite, projectSite) ||
                other.projectSite == projectSite) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientLocation, clientLocation) ||
                other.clientLocation == clientLocation) &&
            (identical(other.clientContact, clientContact) ||
                other.clientContact == clientContact) &&
            (identical(other.techStack, techStack) ||
                other.techStack == techStack) &&
            (identical(other.mngName, mngName) || other.mngName == mngName) &&
            (identical(other.mngEmail, mngEmail) ||
                other.mngEmail == mngEmail) &&
            (identical(other.mngContact, mngContact) ||
                other.mngContact == mngContact) &&
            (identical(other.estdStartDate, estdStartDate) ||
                other.estdStartDate == estdStartDate) &&
            (identical(other.estdEndDate, estdEndDate) ||
                other.estdEndDate == estdEndDate) &&
            (identical(other.estdEffort, estdEffort) ||
                other.estdEffort == estdEffort) &&
            (identical(other.estdCost, estdCost) ||
                other.estdCost == estdCost) &&
            (identical(other.assignedDate, assignedDate) ||
                other.assignedDate == assignedDate) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            (identical(other.teamSize, teamSize) ||
                other.teamSize == teamSize) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    projectId,
    projectName,
    orgShortName,
    projectDescription,
    projectSite,
    clientName,
    clientLocation,
    clientContact,
    techStack,
    mngName,
    mngEmail,
    mngContact,
    estdStartDate,
    estdEndDate,
    estdEffort,
    estdCost,
    assignedDate,
    startDate,
    endDate,
    status,
    priority,
    progress,
    totalTasks,
    completedTasks,
    teamSize,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(this);
  }
}

abstract class _ProjectModel extends ProjectModel {
  const factory _ProjectModel({
    required final String projectId,
    required final String projectName,
    required final String orgShortName,
    final String? projectDescription,
    final String? projectSite,
    final String? clientName,
    final String? clientLocation,
    final String? clientContact,
    final String? techStack,
    final String? mngName,
    final String? mngEmail,
    final String? mngContact,
    final String? estdStartDate,
    final String? estdEndDate,
    final String? estdEffort,
    final String? estdCost,
    final DateTime? assignedDate,
    final DateTime? startDate,
    final DateTime? endDate,
    final ProjectStatus status,
    final ProjectPriority priority,
    final double progress,
    final int totalTasks,
    final int completedTasks,
    final int teamSize,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  // Core identifiers
  @override
  String get projectId; // PK
  @override
  String get projectName;
  @override
  String get orgShortName; // e.g., "NUTANTEK"
  // Details
  @override
  String? get projectDescription;
  @override
  String? get projectSite;
  @override
  String? get clientName;
  @override
  String? get clientLocation;
  @override
  String? get clientContact;
  @override
  String? get techStack;
  @override
  String? get mngName; // Project Manager name
  @override
  String? get mngEmail;
  @override
  String? get mngContact; // Timeline (from dummy_data)
  @override
  String? get estdStartDate; // ← String as in dummy_data
  @override
  String? get estdEndDate; // ← String as in dummy_data
  @override
  String? get estdEffort; // ← String (e.g., "765 Man Days")
  @override
  String? get estdCost; // ← String (e.g., "₹ 50,000")
  @override
  DateTime? get assignedDate;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate; // Status & Priority
  @override
  ProjectStatus get status;
  @override
  ProjectPriority get priority; // Progress & Analytics (from DB or computed)
  @override
  double get progress; // 0.0 to 100.0
  @override
  int get totalTasks;
  @override
  int get completedTasks;
  @override
  int get teamSize; // From employee_mapped_projects count
  // Audit
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
