// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) {
  return _LeaveModel.fromJson(json);
}

/// @nodoc
mixin _$LeaveModel {
  String get leaveId => throw _privateConstructorUsedError;
  String get empId => throw _privateConstructorUsedError;
  String get mgrEmpId => throw _privateConstructorUsedError;
  DateTime get leaveFromDate => throw _privateConstructorUsedError;
  DateTime get leaveToDate => throw _privateConstructorUsedError;
  LeaveType get leaveType => throw _privateConstructorUsedError;
  String? get leaveJustification => throw _privateConstructorUsedError;
  LeaveStatus get leaveApprovalStatus => throw _privateConstructorUsedError;
  String? get managerComments => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LeaveModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaveModelCopyWith<LeaveModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveModelCopyWith<$Res> {
  factory $LeaveModelCopyWith(
    LeaveModel value,
    $Res Function(LeaveModel) then,
  ) = _$LeaveModelCopyWithImpl<$Res, LeaveModel>;
  @useResult
  $Res call({
    String leaveId,
    String empId,
    String mgrEmpId,
    DateTime leaveFromDate,
    DateTime leaveToDate,
    LeaveType leaveType,
    String? leaveJustification,
    LeaveStatus leaveApprovalStatus,
    String? managerComments,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$LeaveModelCopyWithImpl<$Res, $Val extends LeaveModel>
    implements $LeaveModelCopyWith<$Res> {
  _$LeaveModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaveId = null,
    Object? empId = null,
    Object? mgrEmpId = null,
    Object? leaveFromDate = null,
    Object? leaveToDate = null,
    Object? leaveType = null,
    Object? leaveJustification = freezed,
    Object? leaveApprovalStatus = null,
    Object? managerComments = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            leaveId: null == leaveId
                ? _value.leaveId
                : leaveId // ignore: cast_nullable_to_non_nullable
                      as String,
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            mgrEmpId: null == mgrEmpId
                ? _value.mgrEmpId
                : mgrEmpId // ignore: cast_nullable_to_non_nullable
                      as String,
            leaveFromDate: null == leaveFromDate
                ? _value.leaveFromDate
                : leaveFromDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            leaveToDate: null == leaveToDate
                ? _value.leaveToDate
                : leaveToDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            leaveType: null == leaveType
                ? _value.leaveType
                : leaveType // ignore: cast_nullable_to_non_nullable
                      as LeaveType,
            leaveJustification: freezed == leaveJustification
                ? _value.leaveJustification
                : leaveJustification // ignore: cast_nullable_to_non_nullable
                      as String?,
            leaveApprovalStatus: null == leaveApprovalStatus
                ? _value.leaveApprovalStatus
                : leaveApprovalStatus // ignore: cast_nullable_to_non_nullable
                      as LeaveStatus,
            managerComments: freezed == managerComments
                ? _value.managerComments
                : managerComments // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LeaveModelImplCopyWith<$Res>
    implements $LeaveModelCopyWith<$Res> {
  factory _$$LeaveModelImplCopyWith(
    _$LeaveModelImpl value,
    $Res Function(_$LeaveModelImpl) then,
  ) = __$$LeaveModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leaveId,
    String empId,
    String mgrEmpId,
    DateTime leaveFromDate,
    DateTime leaveToDate,
    LeaveType leaveType,
    String? leaveJustification,
    LeaveStatus leaveApprovalStatus,
    String? managerComments,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$LeaveModelImplCopyWithImpl<$Res>
    extends _$LeaveModelCopyWithImpl<$Res, _$LeaveModelImpl>
    implements _$$LeaveModelImplCopyWith<$Res> {
  __$$LeaveModelImplCopyWithImpl(
    _$LeaveModelImpl _value,
    $Res Function(_$LeaveModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaveId = null,
    Object? empId = null,
    Object? mgrEmpId = null,
    Object? leaveFromDate = null,
    Object? leaveToDate = null,
    Object? leaveType = null,
    Object? leaveJustification = freezed,
    Object? leaveApprovalStatus = null,
    Object? managerComments = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LeaveModelImpl(
        leaveId: null == leaveId
            ? _value.leaveId
            : leaveId // ignore: cast_nullable_to_non_nullable
                  as String,
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        mgrEmpId: null == mgrEmpId
            ? _value.mgrEmpId
            : mgrEmpId // ignore: cast_nullable_to_non_nullable
                  as String,
        leaveFromDate: null == leaveFromDate
            ? _value.leaveFromDate
            : leaveFromDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        leaveToDate: null == leaveToDate
            ? _value.leaveToDate
            : leaveToDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        leaveType: null == leaveType
            ? _value.leaveType
            : leaveType // ignore: cast_nullable_to_non_nullable
                  as LeaveType,
        leaveJustification: freezed == leaveJustification
            ? _value.leaveJustification
            : leaveJustification // ignore: cast_nullable_to_non_nullable
                  as String?,
        leaveApprovalStatus: null == leaveApprovalStatus
            ? _value.leaveApprovalStatus
            : leaveApprovalStatus // ignore: cast_nullable_to_non_nullable
                  as LeaveStatus,
        managerComments: freezed == managerComments
            ? _value.managerComments
            : managerComments // ignore: cast_nullable_to_non_nullable
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
class _$LeaveModelImpl extends _LeaveModel {
  const _$LeaveModelImpl({
    required this.leaveId,
    required this.empId,
    required this.mgrEmpId,
    required this.leaveFromDate,
    required this.leaveToDate,
    required this.leaveType,
    this.leaveJustification,
    required this.leaveApprovalStatus,
    this.managerComments,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$LeaveModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveModelImplFromJson(json);

  @override
  final String leaveId;
  @override
  final String empId;
  @override
  final String mgrEmpId;
  @override
  final DateTime leaveFromDate;
  @override
  final DateTime leaveToDate;
  @override
  final LeaveType leaveType;
  @override
  final String? leaveJustification;
  @override
  final LeaveStatus leaveApprovalStatus;
  @override
  final String? managerComments;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LeaveModel(leaveId: $leaveId, empId: $empId, mgrEmpId: $mgrEmpId, leaveFromDate: $leaveFromDate, leaveToDate: $leaveToDate, leaveType: $leaveType, leaveJustification: $leaveJustification, leaveApprovalStatus: $leaveApprovalStatus, managerComments: $managerComments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveModelImpl &&
            (identical(other.leaveId, leaveId) || other.leaveId == leaveId) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.mgrEmpId, mgrEmpId) ||
                other.mgrEmpId == mgrEmpId) &&
            (identical(other.leaveFromDate, leaveFromDate) ||
                other.leaveFromDate == leaveFromDate) &&
            (identical(other.leaveToDate, leaveToDate) ||
                other.leaveToDate == leaveToDate) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.leaveJustification, leaveJustification) ||
                other.leaveJustification == leaveJustification) &&
            (identical(other.leaveApprovalStatus, leaveApprovalStatus) ||
                other.leaveApprovalStatus == leaveApprovalStatus) &&
            (identical(other.managerComments, managerComments) ||
                other.managerComments == managerComments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leaveId,
    empId,
    mgrEmpId,
    leaveFromDate,
    leaveToDate,
    leaveType,
    leaveJustification,
    leaveApprovalStatus,
    managerComments,
    createdAt,
    updatedAt,
  );

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveModelImplCopyWith<_$LeaveModelImpl> get copyWith =>
      __$$LeaveModelImplCopyWithImpl<_$LeaveModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveModelImplToJson(this);
  }
}

abstract class _LeaveModel extends LeaveModel {
  const factory _LeaveModel({
    required final String leaveId,
    required final String empId,
    required final String mgrEmpId,
    required final DateTime leaveFromDate,
    required final DateTime leaveToDate,
    required final LeaveType leaveType,
    final String? leaveJustification,
    required final LeaveStatus leaveApprovalStatus,
    final String? managerComments,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$LeaveModelImpl;
  const _LeaveModel._() : super._();

  factory _LeaveModel.fromJson(Map<String, dynamic> json) =
      _$LeaveModelImpl.fromJson;

  @override
  String get leaveId;
  @override
  String get empId;
  @override
  String get mgrEmpId;
  @override
  DateTime get leaveFromDate;
  @override
  DateTime get leaveToDate;
  @override
  LeaveType get leaveType;
  @override
  String? get leaveJustification;
  @override
  LeaveStatus get leaveApprovalStatus;
  @override
  String? get managerComments;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveModelImplCopyWith<_$LeaveModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
