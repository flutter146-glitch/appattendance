// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) {
  return _AttendanceModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceModel {
  String get attId => throw _privateConstructorUsedError;
  String get empId => throw _privateConstructorUsedError;
  DateTime get attendanceDate => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  double? get workedHours => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get geofenceName => throw _privateConstructorUsedError;
  VerificationType? get verificationType => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get leaveType => throw _privateConstructorUsedError;
  AttendanceStatus get status => throw _privateConstructorUsedError;
  DailyAttendanceStatus get dailyStatus => throw _privateConstructorUsedError;
  String? get photoProofPath => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceModelCopyWith<AttendanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceModelCopyWith<$Res> {
  factory $AttendanceModelCopyWith(
    AttendanceModel value,
    $Res Function(AttendanceModel) then,
  ) = _$AttendanceModelCopyWithImpl<$Res, AttendanceModel>;
  @useResult
  $Res call({
    String attId,
    String empId,
    DateTime attendanceDate,
    DateTime timestamp,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? workedHours,
    double? latitude,
    double? longitude,
    String? geofenceName,
    VerificationType? verificationType,
    bool isVerified,
    String? projectId,
    String? notes,
    String? leaveType,
    AttendanceStatus status,
    DailyAttendanceStatus dailyStatus,
    String? photoProofPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res, $Val extends AttendanceModel>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attId = null,
    Object? empId = null,
    Object? attendanceDate = null,
    Object? timestamp = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? workedHours = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? geofenceName = freezed,
    Object? verificationType = freezed,
    Object? isVerified = null,
    Object? projectId = freezed,
    Object? notes = freezed,
    Object? leaveType = freezed,
    Object? status = null,
    Object? dailyStatus = null,
    Object? photoProofPath = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            attId: null == attId
                ? _value.attId
                : attId // ignore: cast_nullable_to_non_nullable
                      as String,
            empId: null == empId
                ? _value.empId
                : empId // ignore: cast_nullable_to_non_nullable
                      as String,
            attendanceDate: null == attendanceDate
                ? _value.attendanceDate
                : attendanceDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            checkInTime: freezed == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            checkOutTime: freezed == checkOutTime
                ? _value.checkOutTime
                : checkOutTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            workedHours: freezed == workedHours
                ? _value.workedHours
                : workedHours // ignore: cast_nullable_to_non_nullable
                      as double?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            geofenceName: freezed == geofenceName
                ? _value.geofenceName
                : geofenceName // ignore: cast_nullable_to_non_nullable
                      as String?,
            verificationType: freezed == verificationType
                ? _value.verificationType
                : verificationType // ignore: cast_nullable_to_non_nullable
                      as VerificationType?,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            leaveType: freezed == leaveType
                ? _value.leaveType
                : leaveType // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttendanceStatus,
            dailyStatus: null == dailyStatus
                ? _value.dailyStatus
                : dailyStatus // ignore: cast_nullable_to_non_nullable
                      as DailyAttendanceStatus,
            photoProofPath: freezed == photoProofPath
                ? _value.photoProofPath
                : photoProofPath // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AttendanceModelImplCopyWith<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  factory _$$AttendanceModelImplCopyWith(
    _$AttendanceModelImpl value,
    $Res Function(_$AttendanceModelImpl) then,
  ) = __$$AttendanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String attId,
    String empId,
    DateTime attendanceDate,
    DateTime timestamp,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? workedHours,
    double? latitude,
    double? longitude,
    String? geofenceName,
    VerificationType? verificationType,
    bool isVerified,
    String? projectId,
    String? notes,
    String? leaveType,
    AttendanceStatus status,
    DailyAttendanceStatus dailyStatus,
    String? photoProofPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AttendanceModelImplCopyWithImpl<$Res>
    extends _$AttendanceModelCopyWithImpl<$Res, _$AttendanceModelImpl>
    implements _$$AttendanceModelImplCopyWith<$Res> {
  __$$AttendanceModelImplCopyWithImpl(
    _$AttendanceModelImpl _value,
    $Res Function(_$AttendanceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attId = null,
    Object? empId = null,
    Object? attendanceDate = null,
    Object? timestamp = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? workedHours = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? geofenceName = freezed,
    Object? verificationType = freezed,
    Object? isVerified = null,
    Object? projectId = freezed,
    Object? notes = freezed,
    Object? leaveType = freezed,
    Object? status = null,
    Object? dailyStatus = null,
    Object? photoProofPath = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AttendanceModelImpl(
        attId: null == attId
            ? _value.attId
            : attId // ignore: cast_nullable_to_non_nullable
                  as String,
        empId: null == empId
            ? _value.empId
            : empId // ignore: cast_nullable_to_non_nullable
                  as String,
        attendanceDate: null == attendanceDate
            ? _value.attendanceDate
            : attendanceDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        checkInTime: freezed == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        checkOutTime: freezed == checkOutTime
            ? _value.checkOutTime
            : checkOutTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        workedHours: freezed == workedHours
            ? _value.workedHours
            : workedHours // ignore: cast_nullable_to_non_nullable
                  as double?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        geofenceName: freezed == geofenceName
            ? _value.geofenceName
            : geofenceName // ignore: cast_nullable_to_non_nullable
                  as String?,
        verificationType: freezed == verificationType
            ? _value.verificationType
            : verificationType // ignore: cast_nullable_to_non_nullable
                  as VerificationType?,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        leaveType: freezed == leaveType
            ? _value.leaveType
            : leaveType // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttendanceStatus,
        dailyStatus: null == dailyStatus
            ? _value.dailyStatus
            : dailyStatus // ignore: cast_nullable_to_non_nullable
                  as DailyAttendanceStatus,
        photoProofPath: freezed == photoProofPath
            ? _value.photoProofPath
            : photoProofPath // ignore: cast_nullable_to_non_nullable
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
class _$AttendanceModelImpl extends _AttendanceModel {
  const _$AttendanceModelImpl({
    required this.attId,
    required this.empId,
    required this.attendanceDate,
    required this.timestamp,
    this.checkInTime,
    this.checkOutTime,
    this.workedHours,
    this.latitude,
    this.longitude,
    this.geofenceName,
    this.verificationType,
    this.isVerified = false,
    this.projectId,
    this.notes,
    this.leaveType,
    this.status = AttendanceStatus.checkIn,
    this.dailyStatus = DailyAttendanceStatus.present,
    this.photoProofPath,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$AttendanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceModelImplFromJson(json);

  @override
  final String attId;
  @override
  final String empId;
  @override
  final DateTime attendanceDate;
  @override
  final DateTime timestamp;
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final double? workedHours;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? geofenceName;
  @override
  final VerificationType? verificationType;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? projectId;
  @override
  final String? notes;
  @override
  final String? leaveType;
  @override
  @JsonKey()
  final AttendanceStatus status;
  @override
  @JsonKey()
  final DailyAttendanceStatus dailyStatus;
  @override
  final String? photoProofPath;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AttendanceModel(attId: $attId, empId: $empId, attendanceDate: $attendanceDate, timestamp: $timestamp, checkInTime: $checkInTime, checkOutTime: $checkOutTime, workedHours: $workedHours, latitude: $latitude, longitude: $longitude, geofenceName: $geofenceName, verificationType: $verificationType, isVerified: $isVerified, projectId: $projectId, notes: $notes, leaveType: $leaveType, status: $status, dailyStatus: $dailyStatus, photoProofPath: $photoProofPath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceModelImpl &&
            (identical(other.attId, attId) || other.attId == attId) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.attendanceDate, attendanceDate) ||
                other.attendanceDate == attendanceDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.workedHours, workedHours) ||
                other.workedHours == workedHours) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.geofenceName, geofenceName) ||
                other.geofenceName == geofenceName) &&
            (identical(other.verificationType, verificationType) ||
                other.verificationType == verificationType) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dailyStatus, dailyStatus) ||
                other.dailyStatus == dailyStatus) &&
            (identical(other.photoProofPath, photoProofPath) ||
                other.photoProofPath == photoProofPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    attId,
    empId,
    attendanceDate,
    timestamp,
    checkInTime,
    checkOutTime,
    workedHours,
    latitude,
    longitude,
    geofenceName,
    verificationType,
    isVerified,
    projectId,
    notes,
    leaveType,
    status,
    dailyStatus,
    photoProofPath,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      __$$AttendanceModelImplCopyWithImpl<_$AttendanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceModelImplToJson(this);
  }
}

abstract class _AttendanceModel extends AttendanceModel {
  const factory _AttendanceModel({
    required final String attId,
    required final String empId,
    required final DateTime attendanceDate,
    required final DateTime timestamp,
    final DateTime? checkInTime,
    final DateTime? checkOutTime,
    final double? workedHours,
    final double? latitude,
    final double? longitude,
    final String? geofenceName,
    final VerificationType? verificationType,
    final bool isVerified,
    final String? projectId,
    final String? notes,
    final String? leaveType,
    final AttendanceStatus status,
    final DailyAttendanceStatus dailyStatus,
    final String? photoProofPath,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$AttendanceModelImpl;
  const _AttendanceModel._() : super._();

  factory _AttendanceModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceModelImpl.fromJson;

  @override
  String get attId;
  @override
  String get empId;
  @override
  DateTime get attendanceDate;
  @override
  DateTime get timestamp;
  @override
  DateTime? get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  double? get workedHours;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get geofenceName;
  @override
  VerificationType? get verificationType;
  @override
  bool get isVerified;
  @override
  String? get projectId;
  @override
  String? get notes;
  @override
  String? get leaveType;
  @override
  AttendanceStatus get status;
  @override
  DailyAttendanceStatus get dailyStatus;
  @override
  String? get photoProofPath;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
