// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get empId => throw _privateConstructorUsedError;
  String get orgShortName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get designation => throw _privateConstructorUsedError;
  DateTime? get joiningDate => throw _privateConstructorUsedError;
  UserStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String> get assignedProjectIds => throw _privateConstructorUsedError;
  List<String> get projectNames => throw _privateConstructorUsedError;
  String? get shiftId => throw _privateConstructorUsedError;
  String? get reportingManagerId => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String empId,
    String orgShortName,
    String name,
    String email,
    String? phone,
    UserRole role,
    String? department,
    String? designation,
    DateTime? joiningDate,
    UserStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String> assignedProjectIds,
    List<String> projectNames,
    String? shiftId,
    String? reportingManagerId,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? orgShortName = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? role = null,
    Object? department = freezed,
    Object? designation = freezed,
    Object? joiningDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? assignedProjectIds = null,
    Object? projectNames = null,
    Object? shiftId = freezed,
    Object? reportingManagerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            orgShortName: null == orgShortName
                ? _value.orgShortName
                : orgShortName // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            department: freezed == department
                ? _value.department
                : department // ignore: cast_nullable_to_non_nullable
                      as String?,
            designation: freezed == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String?,
            joiningDate: freezed == joiningDate
                ? _value.joiningDate
                : joiningDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as UserStatus,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedProjectIds: null == assignedProjectIds
                ? _value.assignedProjectIds
                : assignedProjectIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            projectNames: null == projectNames
                ? _value.projectNames
                : projectNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            shiftId: freezed == shiftId
                ? _value.shiftId
                : shiftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportingManagerId: freezed == reportingManagerId
                ? _value.reportingManagerId
                : reportingManagerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String empId,
    String orgShortName,
    String name,
    String email,
    String? phone,
    UserRole role,
    String? department,
    String? designation,
    DateTime? joiningDate,
    UserStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String> assignedProjectIds,
    List<String> projectNames,
    String? shiftId,
    String? reportingManagerId,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? orgShortName = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? role = null,
    Object? department = freezed,
    Object? designation = freezed,
    Object? joiningDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? assignedProjectIds = null,
    Object? projectNames = null,
    Object? shiftId = freezed,
    Object? reportingManagerId = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        orgShortName: null == orgShortName
            ? _value.orgShortName
            : orgShortName // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        department: freezed == department
            ? _value.department
            : department // ignore: cast_nullable_to_non_nullable
                  as String?,
        designation: freezed == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String?,
        joiningDate: freezed == joiningDate
            ? _value.joiningDate
            : joiningDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as UserStatus,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedProjectIds: null == assignedProjectIds
            ? _value._assignedProjectIds
            : assignedProjectIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        projectNames: null == projectNames
            ? _value._projectNames
            : projectNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        shiftId: freezed == shiftId
            ? _value.shiftId
            : shiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportingManagerId: freezed == reportingManagerId
            ? _value.reportingManagerId
            : reportingManagerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.empId,
    required this.orgShortName,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.department,
    this.designation,
    this.joiningDate,
    this.status = UserStatus.active,
    this.createdAt,
    this.updatedAt,
    final List<String> assignedProjectIds = const [],
    final List<String> projectNames = const [],
    this.shiftId,
    this.reportingManagerId,
  }) : _assignedProjectIds = assignedProjectIds,
       _projectNames = projectNames,
       super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String empId;
  @override
  final String orgShortName;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final UserRole role;
  @override
  final String? department;
  @override
  final String? designation;
  @override
  final DateTime? joiningDate;
  @override
  @JsonKey()
  final UserStatus status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final List<String> _assignedProjectIds;
  @override
  @JsonKey()
  List<String> get assignedProjectIds {
    if (_assignedProjectIds is EqualUnmodifiableListView)
      return _assignedProjectIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedProjectIds);
  }

  final List<String> _projectNames;
  @override
  @JsonKey()
  List<String> get projectNames {
    if (_projectNames is EqualUnmodifiableListView) return _projectNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectNames);
  }

  @override
  final String? shiftId;
  @override
  final String? reportingManagerId;

  @override
  String toString() {
    return 'UserModel(empId: $empId, orgShortName: $orgShortName, name: $name, email: $email, phone: $phone, role: $role, department: $department, designation: $designation, joiningDate: $joiningDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, assignedProjectIds: $assignedProjectIds, projectNames: $projectNames, shiftId: $shiftId, reportingManagerId: $reportingManagerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.orgShortName, orgShortName) ||
                other.orgShortName == orgShortName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.joiningDate, joiningDate) ||
                other.joiningDate == joiningDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._assignedProjectIds,
              _assignedProjectIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._projectNames,
              _projectNames,
            ) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.reportingManagerId, reportingManagerId) ||
                other.reportingManagerId == reportingManagerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    empId,
    orgShortName,
    name,
    email,
    phone,
    role,
    department,
    designation,
    joiningDate,
    status,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_assignedProjectIds),
    const DeepCollectionEquality().hash(_projectNames),
    shiftId,
    reportingManagerId,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final String empId,
    required final String orgShortName,
    required final String name,
    required final String email,
    final String? phone,
    required final UserRole role,
    final String? department,
    final String? designation,
    final DateTime? joiningDate,
    final UserStatus status,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<String> assignedProjectIds,
    final List<String> projectNames,
    final String? shiftId,
    final String? reportingManagerId,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get empId;
  @override
  String get orgShortName;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get phone;
  @override
  UserRole get role;
  @override
  String? get department;
  @override
  String? get designation;
  @override
  DateTime? get joiningDate;
  @override
  UserStatus get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<String> get assignedProjectIds;
  @override
  List<String> get projectNames;
  @override
  String? get shiftId;
  @override
  String? get reportingManagerId;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
