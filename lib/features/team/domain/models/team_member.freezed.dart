// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) {
  return _TeamMember.fromJson(json);
}

/// @nodoc
mixin _$TeamMember {
  // Core identification
  String get empId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError; // from emp_name
  // Contact & profile
  String? get email => throw _privateConstructorUsedError; // from emp_email
  String? get phone => throw _privateConstructorUsedError; // from emp_phone
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String get avatarFallbackUrl =>
      throw _privateConstructorUsedError; // Professional details
  String? get department => throw _privateConstructorUsedError;
  String? get designation => throw _privateConstructorUsedError;
  UserStatus get status =>
      throw _privateConstructorUsedError; // from emp_status
  DateTime? get dateOfJoining =>
      throw _privateConstructorUsedError; // from emp_joining_date
  // Relationships
  List<String> get projectIds => throw _privateConstructorUsedError;
  List<String> get projectNames =>
      throw _privateConstructorUsedError; // Attendance history (last 30 days or so)
  List<AttendanceModel> get recentAttendanceHistory =>
      throw _privateConstructorUsedError; // Optional analytics
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get attendanceRatePercentage => throw _privateConstructorUsedError;

  /// Serializes this TeamMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMemberCopyWith<TeamMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMemberCopyWith<$Res> {
  factory $TeamMemberCopyWith(
    TeamMember value,
    $Res Function(TeamMember) then,
  ) = _$TeamMemberCopyWithImpl<$Res, TeamMember>;
  @useResult
  $Res call({
    String empId,
    String name,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    String avatarFallbackUrl,
    String? department,
    String? designation,
    UserStatus status,
    DateTime? dateOfJoining,
    List<String> projectIds,
    List<String> projectNames,
    List<AttendanceModel> recentAttendanceHistory,
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? attendanceRatePercentage,
  });
}

/// @nodoc
class _$TeamMemberCopyWithImpl<$Res, $Val extends TeamMember>
    implements $TeamMemberCopyWith<$Res> {
  _$TeamMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? avatarFallbackUrl = null,
    Object? department = freezed,
    Object? designation = freezed,
    Object? status = null,
    Object? dateOfJoining = freezed,
    Object? projectIds = null,
    Object? projectNames = null,
    Object? recentAttendanceHistory = null,
    Object? attendanceRatePercentage = freezed,
  }) {
    return _then(
      _value.copyWith(
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarFallbackUrl: null == avatarFallbackUrl
                ? _value.avatarFallbackUrl
                : avatarFallbackUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            department: freezed == department
                ? _value.department
                : department // ignore: cast_nullable_to_non_nullable
                      as String?,
            designation: freezed == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as UserStatus,
            dateOfJoining: freezed == dateOfJoining
                ? _value.dateOfJoining
                : dateOfJoining // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            projectIds: null == projectIds
                ? _value.projectIds
                : projectIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            projectNames: null == projectNames
                ? _value.projectNames
                : projectNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recentAttendanceHistory: null == recentAttendanceHistory
                ? _value.recentAttendanceHistory
                : recentAttendanceHistory // ignore: cast_nullable_to_non_nullable
                      as List<AttendanceModel>,
            attendanceRatePercentage: freezed == attendanceRatePercentage
                ? _value.attendanceRatePercentage
                : attendanceRatePercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamMemberImplCopyWith<$Res>
    implements $TeamMemberCopyWith<$Res> {
  factory _$$TeamMemberImplCopyWith(
    _$TeamMemberImpl value,
    $Res Function(_$TeamMemberImpl) then,
  ) = __$$TeamMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String empId,
    String name,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    String avatarFallbackUrl,
    String? department,
    String? designation,
    UserStatus status,
    DateTime? dateOfJoining,
    List<String> projectIds,
    List<String> projectNames,
    List<AttendanceModel> recentAttendanceHistory,
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? attendanceRatePercentage,
  });
}

/// @nodoc
class __$$TeamMemberImplCopyWithImpl<$Res>
    extends _$TeamMemberCopyWithImpl<$Res, _$TeamMemberImpl>
    implements _$$TeamMemberImplCopyWith<$Res> {
  __$$TeamMemberImplCopyWithImpl(
    _$TeamMemberImpl _value,
    $Res Function(_$TeamMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empId = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? avatarFallbackUrl = null,
    Object? department = freezed,
    Object? designation = freezed,
    Object? status = null,
    Object? dateOfJoining = freezed,
    Object? projectIds = null,
    Object? projectNames = null,
    Object? recentAttendanceHistory = null,
    Object? attendanceRatePercentage = freezed,
  }) {
    return _then(
      _$TeamMemberImpl(
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarFallbackUrl: null == avatarFallbackUrl
            ? _value.avatarFallbackUrl
            : avatarFallbackUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        department: freezed == department
            ? _value.department
            : department // ignore: cast_nullable_to_non_nullable
                  as String?,
        designation: freezed == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as UserStatus,
        dateOfJoining: freezed == dateOfJoining
            ? _value.dateOfJoining
            : dateOfJoining // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        projectIds: null == projectIds
            ? _value._projectIds
            : projectIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        projectNames: null == projectNames
            ? _value._projectNames
            : projectNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recentAttendanceHistory: null == recentAttendanceHistory
            ? _value._recentAttendanceHistory
            : recentAttendanceHistory // ignore: cast_nullable_to_non_nullable
                  as List<AttendanceModel>,
        attendanceRatePercentage: freezed == attendanceRatePercentage
            ? _value.attendanceRatePercentage
            : attendanceRatePercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMemberImpl extends _TeamMember {
  const _$TeamMemberImpl({
    required this.empId,
    required this.name,
    this.email,
    this.phone,
    this.profilePhotoUrl,
    this.avatarFallbackUrl =
        'https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=',
    this.department,
    this.designation,
    this.status = UserStatus.active,
    this.dateOfJoining,
    final List<String> projectIds = const [],
    final List<String> projectNames = const [],
    final List<AttendanceModel> recentAttendanceHistory = const [],
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.attendanceRatePercentage,
  }) : _projectIds = projectIds,
       _projectNames = projectNames,
       _recentAttendanceHistory = recentAttendanceHistory,
       super._();

  factory _$TeamMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMemberImplFromJson(json);

  // Core identification
  @override
  final String empId;
  @override
  final String name;
  // from emp_name
  // Contact & profile
  @override
  final String? email;
  // from emp_email
  @override
  final String? phone;
  // from emp_phone
  @override
  final String? profilePhotoUrl;
  @override
  @JsonKey()
  final String avatarFallbackUrl;
  // Professional details
  @override
  final String? department;
  @override
  final String? designation;
  @override
  @JsonKey()
  final UserStatus status;
  // from emp_status
  @override
  final DateTime? dateOfJoining;
  // from emp_joining_date
  // Relationships
  final List<String> _projectIds;
  // from emp_joining_date
  // Relationships
  @override
  @JsonKey()
  List<String> get projectIds {
    if (_projectIds is EqualUnmodifiableListView) return _projectIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectIds);
  }

  final List<String> _projectNames;
  @override
  @JsonKey()
  List<String> get projectNames {
    if (_projectNames is EqualUnmodifiableListView) return _projectNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectNames);
  }

  // Attendance history (last 30 days or so)
  final List<AttendanceModel> _recentAttendanceHistory;
  // Attendance history (last 30 days or so)
  @override
  @JsonKey()
  List<AttendanceModel> get recentAttendanceHistory {
    if (_recentAttendanceHistory is EqualUnmodifiableListView)
      return _recentAttendanceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAttendanceHistory);
  }

  // Optional analytics
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? attendanceRatePercentage;

  @override
  String toString() {
    return 'TeamMember(empId: $empId, name: $name, email: $email, phone: $phone, profilePhotoUrl: $profilePhotoUrl, avatarFallbackUrl: $avatarFallbackUrl, department: $department, designation: $designation, status: $status, dateOfJoining: $dateOfJoining, projectIds: $projectIds, projectNames: $projectNames, recentAttendanceHistory: $recentAttendanceHistory, attendanceRatePercentage: $attendanceRatePercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMemberImpl &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.avatarFallbackUrl, avatarFallbackUrl) ||
                other.avatarFallbackUrl == avatarFallbackUrl) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateOfJoining, dateOfJoining) ||
                other.dateOfJoining == dateOfJoining) &&
            const DeepCollectionEquality().equals(
              other._projectIds,
              _projectIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._projectNames,
              _projectNames,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentAttendanceHistory,
              _recentAttendanceHistory,
            ) &&
            (identical(
                  other.attendanceRatePercentage,
                  attendanceRatePercentage,
                ) ||
                other.attendanceRatePercentage == attendanceRatePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    empId,
    name,
    email,
    phone,
    profilePhotoUrl,
    avatarFallbackUrl,
    department,
    designation,
    status,
    dateOfJoining,
    const DeepCollectionEquality().hash(_projectIds),
    const DeepCollectionEquality().hash(_projectNames),
    const DeepCollectionEquality().hash(_recentAttendanceHistory),
    attendanceRatePercentage,
  );

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMemberImplCopyWith<_$TeamMemberImpl> get copyWith =>
      __$$TeamMemberImplCopyWithImpl<_$TeamMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMemberImplToJson(this);
  }
}

abstract class _TeamMember extends TeamMember {
  const factory _TeamMember({
    required final String empId,
    required final String name,
    final String? email,
    final String? phone,
    final String? profilePhotoUrl,
    final String avatarFallbackUrl,
    final String? department,
    final String? designation,
    final UserStatus status,
    final DateTime? dateOfJoining,
    final List<String> projectIds,
    final List<String> projectNames,
    final List<AttendanceModel> recentAttendanceHistory,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final double? attendanceRatePercentage,
  }) = _$TeamMemberImpl;
  const _TeamMember._() : super._();

  factory _TeamMember.fromJson(Map<String, dynamic> json) =
      _$TeamMemberImpl.fromJson;

  // Core identification
  @override
  String get empId;
  @override
  String get name; // from emp_name
  // Contact & profile
  @override
  String? get email; // from emp_email
  @override
  String? get phone; // from emp_phone
  @override
  String? get profilePhotoUrl;
  @override
  String get avatarFallbackUrl; // Professional details
  @override
  String? get department;
  @override
  String? get designation;
  @override
  UserStatus get status; // from emp_status
  @override
  DateTime? get dateOfJoining; // from emp_joining_date
  // Relationships
  @override
  List<String> get projectIds;
  @override
  List<String> get projectNames; // Attendance history (last 30 days or so)
  @override
  List<AttendanceModel> get recentAttendanceHistory; // Optional analytics
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get attendanceRatePercentage;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMemberImplCopyWith<_$TeamMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
