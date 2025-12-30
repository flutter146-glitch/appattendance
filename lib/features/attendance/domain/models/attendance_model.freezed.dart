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
  String get attId => throw _privateConstructorUsedError; // att_id (PK)
  String get empId => throw _privateConstructorUsedError; // emp_id (FK)
  DateTime get timestamp => throw _privateConstructorUsedError; // att_timestamp
  double? get latitude => throw _privateConstructorUsedError; // att_latitude
  double? get longitude => throw _privateConstructorUsedError; // att_longitude
  String? get geofenceName =>
      throw _privateConstructorUsedError; // att_geofence_name
  String? get projectId =>
      throw _privateConstructorUsedError; // project_id (FK)
  String? get notes => throw _privateConstructorUsedError; // att_notes
  AttendanceStatus get status =>
      throw _privateConstructorUsedError; // att_status
  VerificationType? get verificationType =>
      throw _privateConstructorUsedError; // verification_type
  bool get isVerified =>
      throw _privateConstructorUsedError; // is_verified (0/1 → bool)
  DateTime? get createdAt => throw _privateConstructorUsedError; // created_at
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
    DateTime timestamp,
    double? latitude,
    double? longitude,
    String? geofenceName,
    String? projectId,
    String? notes,
    AttendanceStatus status,
    VerificationType? verificationType,
    bool isVerified,
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
    Object? timestamp = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? geofenceName = freezed,
    Object? projectId = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? verificationType = freezed,
    Object? isVerified = null,
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
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttendanceStatus,
            verificationType: freezed == verificationType
                ? _value.verificationType
                : verificationType // ignore: cast_nullable_to_non_nullable
                      as VerificationType?,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
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
    DateTime timestamp,
    double? latitude,
    double? longitude,
    String? geofenceName,
    String? projectId,
    String? notes,
    AttendanceStatus status,
    VerificationType? verificationType,
    bool isVerified,
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
    Object? timestamp = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? geofenceName = freezed,
    Object? projectId = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? verificationType = freezed,
    Object? isVerified = null,
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
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttendanceStatus,
        verificationType: freezed == verificationType
            ? _value.verificationType
            : verificationType // ignore: cast_nullable_to_non_nullable
                  as VerificationType?,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
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
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.geofenceName,
    this.projectId,
    this.notes,
    required this.status,
    this.verificationType,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$AttendanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceModelImplFromJson(json);

  @override
  final String attId;
  // att_id (PK)
  @override
  final String empId;
  // emp_id (FK)
  @override
  final DateTime timestamp;
  // att_timestamp
  @override
  final double? latitude;
  // att_latitude
  @override
  final double? longitude;
  // att_longitude
  @override
  final String? geofenceName;
  // att_geofence_name
  @override
  final String? projectId;
  // project_id (FK)
  @override
  final String? notes;
  // att_notes
  @override
  final AttendanceStatus status;
  // att_status
  @override
  final VerificationType? verificationType;
  // verification_type
  @override
  @JsonKey()
  final bool isVerified;
  // is_verified (0/1 → bool)
  @override
  final DateTime? createdAt;
  // created_at
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AttendanceModel(attId: $attId, empId: $empId, timestamp: $timestamp, latitude: $latitude, longitude: $longitude, geofenceName: $geofenceName, projectId: $projectId, notes: $notes, status: $status, verificationType: $verificationType, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceModelImpl &&
            (identical(other.attId, attId) || other.attId == attId) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.geofenceName, geofenceName) ||
                other.geofenceName == geofenceName) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verificationType, verificationType) ||
                other.verificationType == verificationType) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    attId,
    empId,
    timestamp,
    latitude,
    longitude,
    geofenceName,
    projectId,
    notes,
    status,
    verificationType,
    isVerified,
    createdAt,
    updatedAt,
  );

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
    required final DateTime timestamp,
    final double? latitude,
    final double? longitude,
    final String? geofenceName,
    final String? projectId,
    final String? notes,
    required final AttendanceStatus status,
    final VerificationType? verificationType,
    final bool isVerified,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$AttendanceModelImpl;
  const _AttendanceModel._() : super._();

  factory _AttendanceModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceModelImpl.fromJson;

  @override
  String get attId; // att_id (PK)
  @override
  String get empId; // emp_id (FK)
  @override
  DateTime get timestamp; // att_timestamp
  @override
  double? get latitude; // att_latitude
  @override
  double? get longitude; // att_longitude
  @override
  String? get geofenceName; // att_geofence_name
  @override
  String? get projectId; // project_id (FK)
  @override
  String? get notes; // att_notes
  @override
  AttendanceStatus get status; // att_status
  @override
  VerificationType? get verificationType; // verification_type
  @override
  bool get isVerified; // is_verified (0/1 → bool)
  @override
  DateTime? get createdAt; // created_at
  @override
  DateTime? get updatedAt;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
