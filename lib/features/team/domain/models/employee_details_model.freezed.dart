// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) {
  return _EmployeeModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get designation => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime? get joinDate => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
  List<AttendanceModel> get attendanceHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this EmployeeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeModelCopyWith<EmployeeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeModelCopyWith<$Res> {
  factory $EmployeeModelCopyWith(
    EmployeeModel value,
    $Res Function(EmployeeModel) then,
  ) = _$EmployeeModelCopyWithImpl<$Res, EmployeeModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String designation,
    String email,
    String phone,
    String? status,
    String? avatarUrl,
    DateTime? joinDate,
    String? department,
    @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
    List<AttendanceModel> attendanceHistory,
  });
}

/// @nodoc
class _$EmployeeModelCopyWithImpl<$Res, $Val extends EmployeeModel>
    implements $EmployeeModelCopyWith<$Res> {
  _$EmployeeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? designation = null,
    Object? email = null,
    Object? phone = null,
    Object? status = freezed,
    Object? avatarUrl = freezed,
    Object? joinDate = freezed,
    Object? department = freezed,
    Object? attendanceHistory = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            designation: null == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinDate: freezed == joinDate
                ? _value.joinDate
                : joinDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            department: freezed == department
                ? _value.department
                : department // ignore: cast_nullable_to_non_nullable
                      as String?,
            attendanceHistory: null == attendanceHistory
                ? _value.attendanceHistory
                : attendanceHistory // ignore: cast_nullable_to_non_nullable
                      as List<AttendanceModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeModelImplCopyWith<$Res>
    implements $EmployeeModelCopyWith<$Res> {
  factory _$$EmployeeModelImplCopyWith(
    _$EmployeeModelImpl value,
    $Res Function(_$EmployeeModelImpl) then,
  ) = __$$EmployeeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String designation,
    String email,
    String phone,
    String? status,
    String? avatarUrl,
    DateTime? joinDate,
    String? department,
    @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
    List<AttendanceModel> attendanceHistory,
  });
}

/// @nodoc
class __$$EmployeeModelImplCopyWithImpl<$Res>
    extends _$EmployeeModelCopyWithImpl<$Res, _$EmployeeModelImpl>
    implements _$$EmployeeModelImplCopyWith<$Res> {
  __$$EmployeeModelImplCopyWithImpl(
    _$EmployeeModelImpl _value,
    $Res Function(_$EmployeeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? designation = null,
    Object? email = null,
    Object? phone = null,
    Object? status = freezed,
    Object? avatarUrl = freezed,
    Object? joinDate = freezed,
    Object? department = freezed,
    Object? attendanceHistory = null,
  }) {
    return _then(
      _$EmployeeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        designation: null == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinDate: freezed == joinDate
            ? _value.joinDate
            : joinDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        department: freezed == department
            ? _value.department
            : department // ignore: cast_nullable_to_non_nullable
                  as String?,
        attendanceHistory: null == attendanceHistory
            ? _value._attendanceHistory
            : attendanceHistory // ignore: cast_nullable_to_non_nullable
                  as List<AttendanceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeModelImpl implements _EmployeeModel {
  const _$EmployeeModelImpl({
    required this.id,
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
    this.status,
    this.avatarUrl,
    this.joinDate,
    this.department,
    @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
    final List<AttendanceModel> attendanceHistory = const [],
  }) : _attendanceHistory = attendanceHistory;

  factory _$EmployeeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String designation;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String? status;
  @override
  final String? avatarUrl;
  @override
  final DateTime? joinDate;
  @override
  final String? department;
  final List<AttendanceModel> _attendanceHistory;
  @override
  @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
  List<AttendanceModel> get attendanceHistory {
    if (_attendanceHistory is EqualUnmodifiableListView)
      return _attendanceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attendanceHistory);
  }

  @override
  String toString() {
    return 'EmployeeModel(id: $id, name: $name, designation: $designation, email: $email, phone: $phone, status: $status, avatarUrl: $avatarUrl, joinDate: $joinDate, department: $department, attendanceHistory: $attendanceHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality().equals(
              other._attendanceHistory,
              _attendanceHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    designation,
    email,
    phone,
    status,
    avatarUrl,
    joinDate,
    department,
    const DeepCollectionEquality().hash(_attendanceHistory),
  );

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeModelImplCopyWith<_$EmployeeModelImpl> get copyWith =>
      __$$EmployeeModelImplCopyWithImpl<_$EmployeeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeModelImplToJson(this);
  }
}

abstract class _EmployeeModel implements EmployeeModel {
  const factory _EmployeeModel({
    required final String id,
    required final String name,
    required final String designation,
    required final String email,
    required final String phone,
    final String? status,
    final String? avatarUrl,
    final DateTime? joinDate,
    final String? department,
    @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
    final List<AttendanceModel> attendanceHistory,
  }) = _$EmployeeModelImpl;

  factory _EmployeeModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get designation;
  @override
  String get email;
  @override
  String get phone;
  @override
  String? get status;
  @override
  String? get avatarUrl;
  @override
  DateTime? get joinDate;
  @override
  String? get department;
  @override
  @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
  List<AttendanceModel> get attendanceHistory;

  /// Create a copy of EmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeModelImplCopyWith<_$EmployeeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
