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

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  String get projectId => throw _privateConstructorUsedError; // PK
  String get orgShortName => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  String? get projectSite => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get clientLocation => throw _privateConstructorUsedError;
  String? get clientContact => throw _privateConstructorUsedError;
  String? get mngName => throw _privateConstructorUsedError;
  String? get mngEmail => throw _privateConstructorUsedError;
  String? get mngContact => throw _privateConstructorUsedError;
  String? get projectDescription => throw _privateConstructorUsedError;
  String? get projectTechstack => throw _privateConstructorUsedError;
  String? get projectAssignedDate => throw _privateConstructorUsedError;
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
    String orgShortName,
    String projectName,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? mngName,
    String? mngEmail,
    String? mngContact,
    String? projectDescription,
    String? projectTechstack,
    String? projectAssignedDate,
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
    Object? orgShortName = null,
    Object? projectName = null,
    Object? projectSite = freezed,
    Object? clientName = freezed,
    Object? clientLocation = freezed,
    Object? clientContact = freezed,
    Object? mngName = freezed,
    Object? mngEmail = freezed,
    Object? mngContact = freezed,
    Object? projectDescription = freezed,
    Object? projectTechstack = freezed,
    Object? projectAssignedDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            orgShortName: null == orgShortName
                ? _value.orgShortName
                : orgShortName // ignore: cast_nullable_to_non_nullable
                      as String,
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
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
            projectDescription: freezed == projectDescription
                ? _value.projectDescription
                : projectDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectTechstack: freezed == projectTechstack
                ? _value.projectTechstack
                : projectTechstack // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectAssignedDate: freezed == projectAssignedDate
                ? _value.projectAssignedDate
                : projectAssignedDate // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String orgShortName,
    String projectName,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? mngName,
    String? mngEmail,
    String? mngContact,
    String? projectDescription,
    String? projectTechstack,
    String? projectAssignedDate,
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
    Object? orgShortName = null,
    Object? projectName = null,
    Object? projectSite = freezed,
    Object? clientName = freezed,
    Object? clientLocation = freezed,
    Object? clientContact = freezed,
    Object? mngName = freezed,
    Object? mngEmail = freezed,
    Object? mngContact = freezed,
    Object? projectDescription = freezed,
    Object? projectTechstack = freezed,
    Object? projectAssignedDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ProjectModelImpl(
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        orgShortName: null == orgShortName
            ? _value.orgShortName
            : orgShortName // ignore: cast_nullable_to_non_nullable
                  as String,
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
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
        projectDescription: freezed == projectDescription
            ? _value.projectDescription
            : projectDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectTechstack: freezed == projectTechstack
            ? _value.projectTechstack
            : projectTechstack // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectAssignedDate: freezed == projectAssignedDate
            ? _value.projectAssignedDate
            : projectAssignedDate // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    required this.orgShortName,
    required this.projectName,
    this.projectSite,
    this.clientName,
    this.clientLocation,
    this.clientContact,
    this.mngName,
    this.mngEmail,
    this.mngContact,
    this.projectDescription,
    this.projectTechstack,
    this.projectAssignedDate,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  final String projectId;
  // PK
  @override
  final String orgShortName;
  @override
  final String projectName;
  @override
  final String? projectSite;
  @override
  final String? clientName;
  @override
  final String? clientLocation;
  @override
  final String? clientContact;
  @override
  final String? mngName;
  @override
  final String? mngEmail;
  @override
  final String? mngContact;
  @override
  final String? projectDescription;
  @override
  final String? projectTechstack;
  @override
  final String? projectAssignedDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProjectModel(projectId: $projectId, orgShortName: $orgShortName, projectName: $projectName, projectSite: $projectSite, clientName: $clientName, clientLocation: $clientLocation, clientContact: $clientContact, mngName: $mngName, mngEmail: $mngEmail, mngContact: $mngContact, projectDescription: $projectDescription, projectTechstack: $projectTechstack, projectAssignedDate: $projectAssignedDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.orgShortName, orgShortName) ||
                other.orgShortName == orgShortName) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.projectSite, projectSite) ||
                other.projectSite == projectSite) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientLocation, clientLocation) ||
                other.clientLocation == clientLocation) &&
            (identical(other.clientContact, clientContact) ||
                other.clientContact == clientContact) &&
            (identical(other.mngName, mngName) || other.mngName == mngName) &&
            (identical(other.mngEmail, mngEmail) ||
                other.mngEmail == mngEmail) &&
            (identical(other.mngContact, mngContact) ||
                other.mngContact == mngContact) &&
            (identical(other.projectDescription, projectDescription) ||
                other.projectDescription == projectDescription) &&
            (identical(other.projectTechstack, projectTechstack) ||
                other.projectTechstack == projectTechstack) &&
            (identical(other.projectAssignedDate, projectAssignedDate) ||
                other.projectAssignedDate == projectAssignedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectId,
    orgShortName,
    projectName,
    projectSite,
    clientName,
    clientLocation,
    clientContact,
    mngName,
    mngEmail,
    mngContact,
    projectDescription,
    projectTechstack,
    projectAssignedDate,
    createdAt,
    updatedAt,
  );

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
    required final String orgShortName,
    required final String projectName,
    final String? projectSite,
    final String? clientName,
    final String? clientLocation,
    final String? clientContact,
    final String? mngName,
    final String? mngEmail,
    final String? mngContact,
    final String? projectDescription,
    final String? projectTechstack,
    final String? projectAssignedDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  String get projectId; // PK
  @override
  String get orgShortName;
  @override
  String get projectName;
  @override
  String? get projectSite;
  @override
  String? get clientName;
  @override
  String? get clientLocation;
  @override
  String? get clientContact;
  @override
  String? get mngName;
  @override
  String? get mngEmail;
  @override
  String? get mngContact;
  @override
  String? get projectDescription;
  @override
  String? get projectTechstack;
  @override
  String? get projectAssignedDate;
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

MappedProject _$MappedProjectFromJson(Map<String, dynamic> json) {
  return _MappedProject.fromJson(json);
}

/// @nodoc
mixin _$MappedProject {
  String get empId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get mappingStatus =>
      throw _privateConstructorUsedError; // 'active' / 'deactive'
  ProjectModel get project => throw _privateConstructorUsedError;
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
class _$MappedProjectImpl extends _MappedProject {
  const _$MappedProjectImpl({
    required this.empId,
    required this.projectId,
    required this.mappingStatus,
    required this.project,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$MappedProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$MappedProjectImplFromJson(json);

  @override
  final String empId;
  @override
  final String projectId;
  @override
  final String mappingStatus;
  // 'active' / 'deactive'
  @override
  final ProjectModel project;
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

abstract class _MappedProject extends MappedProject {
  const factory _MappedProject({
    required final String empId,
    required final String projectId,
    required final String mappingStatus,
    required final ProjectModel project,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$MappedProjectImpl;
  const _MappedProject._() : super._();

  factory _MappedProject.fromJson(Map<String, dynamic> json) =
      _$MappedProjectImpl.fromJson;

  @override
  String get empId;
  @override
  String get projectId;
  @override
  String get mappingStatus; // 'active' / 'deactive'
  @override
  ProjectModel get project;
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
