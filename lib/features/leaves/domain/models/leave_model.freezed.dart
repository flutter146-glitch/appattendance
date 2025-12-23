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
  String get leaveId => throw _privateConstructorUsedError; // PK
  String get empId =>
      throw _privateConstructorUsedError; // FK → employee_master
  String? get mgrEmpId =>
      throw _privateConstructorUsedError; // Manager who approves
  DateTime get leaveFromDate => throw _privateConstructorUsedError;
  DateTime get leaveToDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  TimeOfDay get fromTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  TimeOfDay get toTime => throw _privateConstructorUsedError;
  LeaveType get leaveType => throw _privateConstructorUsedError;
  String get justification => throw _privateConstructorUsedError;
  String get approvalStatus =>
      throw _privateConstructorUsedError; // Pending/Approved/Rejected
  DateTime get appliedDate => throw _privateConstructorUsedError;
  String? get managerComments => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool? get isHalfDayFrom => throw _privateConstructorUsedError;
  bool? get isHalfDayTo => throw _privateConstructorUsedError;
  String? get projectName => throw _privateConstructorUsedError;
  List<String> get supportingDocs => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get handoverPersonName => throw _privateConstructorUsedError;
  String? get handoverPersonEmail => throw _privateConstructorUsedError;
  String? get handoverPersonPhone => throw _privateConstructorUsedError;
  String? get handoverPersonPhoto => throw _privateConstructorUsedError;
  int? get totalDays => throw _privateConstructorUsedError;

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
    String? mgrEmpId,
    DateTime leaveFromDate,
    DateTime leaveToDate,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    TimeOfDay fromTime,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    TimeOfDay toTime,
    LeaveType leaveType,
    String justification,
    String approvalStatus,
    DateTime appliedDate,
    String? managerComments,
    DateTime? updatedAt,
    bool? isHalfDayFrom,
    bool? isHalfDayTo,
    String? projectName,
    List<String> supportingDocs,
    String? contactNumber,
    String? handoverPersonName,
    String? handoverPersonEmail,
    String? handoverPersonPhone,
    String? handoverPersonPhoto,
    int? totalDays,
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
    Object? mgrEmpId = freezed,
    Object? leaveFromDate = null,
    Object? leaveToDate = null,
    Object? fromTime = null,
    Object? toTime = null,
    Object? leaveType = null,
    Object? justification = null,
    Object? approvalStatus = null,
    Object? appliedDate = null,
    Object? managerComments = freezed,
    Object? updatedAt = freezed,
    Object? isHalfDayFrom = freezed,
    Object? isHalfDayTo = freezed,
    Object? projectName = freezed,
    Object? supportingDocs = null,
    Object? contactNumber = freezed,
    Object? handoverPersonName = freezed,
    Object? handoverPersonEmail = freezed,
    Object? handoverPersonPhone = freezed,
    Object? handoverPersonPhoto = freezed,
    Object? totalDays = freezed,
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
            mgrEmpId: freezed == mgrEmpId
                ? _value.mgrEmpId
                : mgrEmpId // ignore: cast_nullable_to_non_nullable
                      as String?,
            leaveFromDate: null == leaveFromDate
                ? _value.leaveFromDate
                : leaveFromDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            leaveToDate: null == leaveToDate
                ? _value.leaveToDate
                : leaveToDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fromTime: null == fromTime
                ? _value.fromTime
                : fromTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay,
            toTime: null == toTime
                ? _value.toTime
                : toTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay,
            leaveType: null == leaveType
                ? _value.leaveType
                : leaveType // ignore: cast_nullable_to_non_nullable
                      as LeaveType,
            justification: null == justification
                ? _value.justification
                : justification // ignore: cast_nullable_to_non_nullable
                      as String,
            approvalStatus: null == approvalStatus
                ? _value.approvalStatus
                : approvalStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            appliedDate: null == appliedDate
                ? _value.appliedDate
                : appliedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            managerComments: freezed == managerComments
                ? _value.managerComments
                : managerComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isHalfDayFrom: freezed == isHalfDayFrom
                ? _value.isHalfDayFrom
                : isHalfDayFrom // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isHalfDayTo: freezed == isHalfDayTo
                ? _value.isHalfDayTo
                : isHalfDayTo // ignore: cast_nullable_to_non_nullable
                      as bool?,
            projectName: freezed == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            supportingDocs: null == supportingDocs
                ? _value.supportingDocs
                : supportingDocs // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            contactNumber: freezed == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            handoverPersonName: freezed == handoverPersonName
                ? _value.handoverPersonName
                : handoverPersonName // ignore: cast_nullable_to_non_nullable
                      as String?,
            handoverPersonEmail: freezed == handoverPersonEmail
                ? _value.handoverPersonEmail
                : handoverPersonEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            handoverPersonPhone: freezed == handoverPersonPhone
                ? _value.handoverPersonPhone
                : handoverPersonPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            handoverPersonPhoto: freezed == handoverPersonPhoto
                ? _value.handoverPersonPhoto
                : handoverPersonPhoto // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalDays: freezed == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int?,
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
    String? mgrEmpId,
    DateTime leaveFromDate,
    DateTime leaveToDate,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    TimeOfDay fromTime,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    TimeOfDay toTime,
    LeaveType leaveType,
    String justification,
    String approvalStatus,
    DateTime appliedDate,
    String? managerComments,
    DateTime? updatedAt,
    bool? isHalfDayFrom,
    bool? isHalfDayTo,
    String? projectName,
    List<String> supportingDocs,
    String? contactNumber,
    String? handoverPersonName,
    String? handoverPersonEmail,
    String? handoverPersonPhone,
    String? handoverPersonPhoto,
    int? totalDays,
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
    Object? mgrEmpId = freezed,
    Object? leaveFromDate = null,
    Object? leaveToDate = null,
    Object? fromTime = null,
    Object? toTime = null,
    Object? leaveType = null,
    Object? justification = null,
    Object? approvalStatus = null,
    Object? appliedDate = null,
    Object? managerComments = freezed,
    Object? updatedAt = freezed,
    Object? isHalfDayFrom = freezed,
    Object? isHalfDayTo = freezed,
    Object? projectName = freezed,
    Object? supportingDocs = null,
    Object? contactNumber = freezed,
    Object? handoverPersonName = freezed,
    Object? handoverPersonEmail = freezed,
    Object? handoverPersonPhone = freezed,
    Object? handoverPersonPhoto = freezed,
    Object? totalDays = freezed,
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
        mgrEmpId: freezed == mgrEmpId
            ? _value.mgrEmpId
            : mgrEmpId // ignore: cast_nullable_to_non_nullable
                  as String?,
        leaveFromDate: null == leaveFromDate
            ? _value.leaveFromDate
            : leaveFromDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        leaveToDate: null == leaveToDate
            ? _value.leaveToDate
            : leaveToDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fromTime: null == fromTime
            ? _value.fromTime
            : fromTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay,
        toTime: null == toTime
            ? _value.toTime
            : toTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay,
        leaveType: null == leaveType
            ? _value.leaveType
            : leaveType // ignore: cast_nullable_to_non_nullable
                  as LeaveType,
        justification: null == justification
            ? _value.justification
            : justification // ignore: cast_nullable_to_non_nullable
                  as String,
        approvalStatus: null == approvalStatus
            ? _value.approvalStatus
            : approvalStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        appliedDate: null == appliedDate
            ? _value.appliedDate
            : appliedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        managerComments: freezed == managerComments
            ? _value.managerComments
            : managerComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isHalfDayFrom: freezed == isHalfDayFrom
            ? _value.isHalfDayFrom
            : isHalfDayFrom // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isHalfDayTo: freezed == isHalfDayTo
            ? _value.isHalfDayTo
            : isHalfDayTo // ignore: cast_nullable_to_non_nullable
                  as bool?,
        projectName: freezed == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        supportingDocs: null == supportingDocs
            ? _value._supportingDocs
            : supportingDocs // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        contactNumber: freezed == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        handoverPersonName: freezed == handoverPersonName
            ? _value.handoverPersonName
            : handoverPersonName // ignore: cast_nullable_to_non_nullable
                  as String?,
        handoverPersonEmail: freezed == handoverPersonEmail
            ? _value.handoverPersonEmail
            : handoverPersonEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        handoverPersonPhone: freezed == handoverPersonPhone
            ? _value.handoverPersonPhone
            : handoverPersonPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        handoverPersonPhoto: freezed == handoverPersonPhoto
            ? _value.handoverPersonPhoto
            : handoverPersonPhoto // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalDays: freezed == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int?,
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
    this.mgrEmpId,
    required this.leaveFromDate,
    required this.leaveToDate,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required this.fromTime,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required this.toTime,
    required this.leaveType,
    required this.justification,
    required this.approvalStatus,
    required this.appliedDate,
    this.managerComments,
    this.updatedAt,
    this.isHalfDayFrom,
    this.isHalfDayTo,
    this.projectName,
    final List<String> supportingDocs = const [],
    this.contactNumber,
    this.handoverPersonName,
    this.handoverPersonEmail,
    this.handoverPersonPhone,
    this.handoverPersonPhoto,
    this.totalDays,
  }) : _supportingDocs = supportingDocs,
       super._();

  factory _$LeaveModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveModelImplFromJson(json);

  @override
  final String leaveId;
  // PK
  @override
  final String empId;
  // FK → employee_master
  @override
  final String? mgrEmpId;
  // Manager who approves
  @override
  final DateTime leaveFromDate;
  @override
  final DateTime leaveToDate;
  @override
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  final TimeOfDay fromTime;
  @override
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  final TimeOfDay toTime;
  @override
  final LeaveType leaveType;
  @override
  final String justification;
  @override
  final String approvalStatus;
  // Pending/Approved/Rejected
  @override
  final DateTime appliedDate;
  @override
  final String? managerComments;
  @override
  final DateTime? updatedAt;
  @override
  final bool? isHalfDayFrom;
  @override
  final bool? isHalfDayTo;
  @override
  final String? projectName;
  final List<String> _supportingDocs;
  @override
  @JsonKey()
  List<String> get supportingDocs {
    if (_supportingDocs is EqualUnmodifiableListView) return _supportingDocs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportingDocs);
  }

  @override
  final String? contactNumber;
  @override
  final String? handoverPersonName;
  @override
  final String? handoverPersonEmail;
  @override
  final String? handoverPersonPhone;
  @override
  final String? handoverPersonPhoto;
  @override
  final int? totalDays;

  @override
  String toString() {
    return 'LeaveModel(leaveId: $leaveId, empId: $empId, mgrEmpId: $mgrEmpId, leaveFromDate: $leaveFromDate, leaveToDate: $leaveToDate, fromTime: $fromTime, toTime: $toTime, leaveType: $leaveType, justification: $justification, approvalStatus: $approvalStatus, appliedDate: $appliedDate, managerComments: $managerComments, updatedAt: $updatedAt, isHalfDayFrom: $isHalfDayFrom, isHalfDayTo: $isHalfDayTo, projectName: $projectName, supportingDocs: $supportingDocs, contactNumber: $contactNumber, handoverPersonName: $handoverPersonName, handoverPersonEmail: $handoverPersonEmail, handoverPersonPhone: $handoverPersonPhone, handoverPersonPhoto: $handoverPersonPhoto, totalDays: $totalDays)';
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
            (identical(other.fromTime, fromTime) ||
                other.fromTime == fromTime) &&
            (identical(other.toTime, toTime) || other.toTime == toTime) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.appliedDate, appliedDate) ||
                other.appliedDate == appliedDate) &&
            (identical(other.managerComments, managerComments) ||
                other.managerComments == managerComments) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isHalfDayFrom, isHalfDayFrom) ||
                other.isHalfDayFrom == isHalfDayFrom) &&
            (identical(other.isHalfDayTo, isHalfDayTo) ||
                other.isHalfDayTo == isHalfDayTo) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality().equals(
              other._supportingDocs,
              _supportingDocs,
            ) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.handoverPersonName, handoverPersonName) ||
                other.handoverPersonName == handoverPersonName) &&
            (identical(other.handoverPersonEmail, handoverPersonEmail) ||
                other.handoverPersonEmail == handoverPersonEmail) &&
            (identical(other.handoverPersonPhone, handoverPersonPhone) ||
                other.handoverPersonPhone == handoverPersonPhone) &&
            (identical(other.handoverPersonPhoto, handoverPersonPhoto) ||
                other.handoverPersonPhoto == handoverPersonPhoto) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    leaveId,
    empId,
    mgrEmpId,
    leaveFromDate,
    leaveToDate,
    fromTime,
    toTime,
    leaveType,
    justification,
    approvalStatus,
    appliedDate,
    managerComments,
    updatedAt,
    isHalfDayFrom,
    isHalfDayTo,
    projectName,
    const DeepCollectionEquality().hash(_supportingDocs),
    contactNumber,
    handoverPersonName,
    handoverPersonEmail,
    handoverPersonPhone,
    handoverPersonPhoto,
    totalDays,
  ]);

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
    final String? mgrEmpId,
    required final DateTime leaveFromDate,
    required final DateTime leaveToDate,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required final TimeOfDay fromTime,
    @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
    required final TimeOfDay toTime,
    required final LeaveType leaveType,
    required final String justification,
    required final String approvalStatus,
    required final DateTime appliedDate,
    final String? managerComments,
    final DateTime? updatedAt,
    final bool? isHalfDayFrom,
    final bool? isHalfDayTo,
    final String? projectName,
    final List<String> supportingDocs,
    final String? contactNumber,
    final String? handoverPersonName,
    final String? handoverPersonEmail,
    final String? handoverPersonPhone,
    final String? handoverPersonPhoto,
    final int? totalDays,
  }) = _$LeaveModelImpl;
  const _LeaveModel._() : super._();

  factory _LeaveModel.fromJson(Map<String, dynamic> json) =
      _$LeaveModelImpl.fromJson;

  @override
  String get leaveId; // PK
  @override
  String get empId; // FK → employee_master
  @override
  String? get mgrEmpId; // Manager who approves
  @override
  DateTime get leaveFromDate;
  @override
  DateTime get leaveToDate;
  @override
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  TimeOfDay get fromTime;
  @override
  @JsonKey(fromJson: _timeOfDayFromString, toJson: _timeOfDayToString)
  TimeOfDay get toTime;
  @override
  LeaveType get leaveType;
  @override
  String get justification;
  @override
  String get approvalStatus; // Pending/Approved/Rejected
  @override
  DateTime get appliedDate;
  @override
  String? get managerComments;
  @override
  DateTime? get updatedAt;
  @override
  bool? get isHalfDayFrom;
  @override
  bool? get isHalfDayTo;
  @override
  String? get projectName;
  @override
  List<String> get supportingDocs;
  @override
  String? get contactNumber;
  @override
  String? get handoverPersonName;
  @override
  String? get handoverPersonEmail;
  @override
  String? get handoverPersonPhone;
  @override
  String? get handoverPersonPhoto;
  @override
  int? get totalDays;

  /// Create a copy of LeaveModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveModelImplCopyWith<_$LeaveModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) {
  return _LeaveBalance.fromJson(json);
}

/// @nodoc
mixin _$LeaveBalance {
  String get employeeId => throw _privateConstructorUsedError;
  LeaveType get leaveType => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;
  int get usedDays => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;

  /// Serializes this LeaveBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaveBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaveBalanceCopyWith<LeaveBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveBalanceCopyWith<$Res> {
  factory $LeaveBalanceCopyWith(
    LeaveBalance value,
    $Res Function(LeaveBalance) then,
  ) = _$LeaveBalanceCopyWithImpl<$Res, LeaveBalance>;
  @useResult
  $Res call({
    String employeeId,
    LeaveType leaveType,
    int totalDays,
    int usedDays,
    int year,
  });
}

/// @nodoc
class _$LeaveBalanceCopyWithImpl<$Res, $Val extends LeaveBalance>
    implements $LeaveBalanceCopyWith<$Res> {
  _$LeaveBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaveBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? leaveType = null,
    Object? totalDays = null,
    Object? usedDays = null,
    Object? year = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            leaveType: null == leaveType
                ? _value.leaveType
                : leaveType // ignore: cast_nullable_to_non_nullable
                      as LeaveType,
            totalDays: null == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            usedDays: null == usedDays
                ? _value.usedDays
                : usedDays // ignore: cast_nullable_to_non_nullable
                      as int,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaveBalanceImplCopyWith<$Res>
    implements $LeaveBalanceCopyWith<$Res> {
  factory _$$LeaveBalanceImplCopyWith(
    _$LeaveBalanceImpl value,
    $Res Function(_$LeaveBalanceImpl) then,
  ) = __$$LeaveBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    LeaveType leaveType,
    int totalDays,
    int usedDays,
    int year,
  });
}

/// @nodoc
class __$$LeaveBalanceImplCopyWithImpl<$Res>
    extends _$LeaveBalanceCopyWithImpl<$Res, _$LeaveBalanceImpl>
    implements _$$LeaveBalanceImplCopyWith<$Res> {
  __$$LeaveBalanceImplCopyWithImpl(
    _$LeaveBalanceImpl _value,
    $Res Function(_$LeaveBalanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaveBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? leaveType = null,
    Object? totalDays = null,
    Object? usedDays = null,
    Object? year = null,
  }) {
    return _then(
      _$LeaveBalanceImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        leaveType: null == leaveType
            ? _value.leaveType
            : leaveType // ignore: cast_nullable_to_non_nullable
                  as LeaveType,
        totalDays: null == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        usedDays: null == usedDays
            ? _value.usedDays
            : usedDays // ignore: cast_nullable_to_non_nullable
                  as int,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveBalanceImpl implements _LeaveBalance {
  const _$LeaveBalanceImpl({
    required this.employeeId,
    required this.leaveType,
    required this.totalDays,
    required this.usedDays,
    required this.year,
  });

  factory _$LeaveBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveBalanceImplFromJson(json);

  @override
  final String employeeId;
  @override
  final LeaveType leaveType;
  @override
  final int totalDays;
  @override
  final int usedDays;
  @override
  final int year;

  @override
  String toString() {
    return 'LeaveBalance(employeeId: $employeeId, leaveType: $leaveType, totalDays: $totalDays, usedDays: $usedDays, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveBalanceImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(other.usedDays, usedDays) ||
                other.usedDays == usedDays) &&
            (identical(other.year, year) || other.year == year));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    leaveType,
    totalDays,
    usedDays,
    year,
  );

  /// Create a copy of LeaveBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveBalanceImplCopyWith<_$LeaveBalanceImpl> get copyWith =>
      __$$LeaveBalanceImplCopyWithImpl<_$LeaveBalanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveBalanceImplToJson(this);
  }
}

abstract class _LeaveBalance implements LeaveBalance {
  const factory _LeaveBalance({
    required final String employeeId,
    required final LeaveType leaveType,
    required final int totalDays,
    required final int usedDays,
    required final int year,
  }) = _$LeaveBalanceImpl;

  factory _LeaveBalance.fromJson(Map<String, dynamic> json) =
      _$LeaveBalanceImpl.fromJson;

  @override
  String get employeeId;
  @override
  LeaveType get leaveType;
  @override
  int get totalDays;
  @override
  int get usedDays;
  @override
  int get year;

  /// Create a copy of LeaveBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveBalanceImplCopyWith<_$LeaveBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
