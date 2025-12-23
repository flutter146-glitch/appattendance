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
  String get id => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  AttendanceType get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
  GeofenceModel? get geofence => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get projectName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  AttendanceStatus? get status => throw _privateConstructorUsedError;

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
    String id,
    String? userId,
    DateTime timestamp,
    AttendanceType type,
    @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
    GeofenceModel? geofence,
    double latitude,
    double longitude,
    String? projectName,
    String? notes,
    AttendanceStatus? status,
  });

  $GeofenceModelCopyWith<$Res>? get geofence;
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
    Object? id = null,
    Object? userId = freezed,
    Object? timestamp = null,
    Object? type = null,
    Object? geofence = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? projectName = freezed,
    Object? notes = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AttendanceType,
            geofence: freezed == geofence
                ? _value.geofence
                : geofence // ignore: cast_nullable_to_non_nullable
                      as GeofenceModel?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            projectName: freezed == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttendanceStatus?,
          )
          as $Val,
    );
  }

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeofenceModelCopyWith<$Res>? get geofence {
    if (_value.geofence == null) {
      return null;
    }

    return $GeofenceModelCopyWith<$Res>(_value.geofence!, (value) {
      return _then(_value.copyWith(geofence: value) as $Val);
    });
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
    String id,
    String? userId,
    DateTime timestamp,
    AttendanceType type,
    @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
    GeofenceModel? geofence,
    double latitude,
    double longitude,
    String? projectName,
    String? notes,
    AttendanceStatus? status,
  });

  @override
  $GeofenceModelCopyWith<$Res>? get geofence;
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
    Object? id = null,
    Object? userId = freezed,
    Object? timestamp = null,
    Object? type = null,
    Object? geofence = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? projectName = freezed,
    Object? notes = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$AttendanceModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AttendanceType,
        geofence: freezed == geofence
            ? _value.geofence
            : geofence // ignore: cast_nullable_to_non_nullable
                  as GeofenceModel?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        projectName: freezed == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttendanceStatus?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceModelImpl extends _AttendanceModel {
  const _$AttendanceModelImpl({
    required this.id,
    this.userId,
    required this.timestamp,
    required this.type,
    @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
    this.geofence,
    required this.latitude,
    required this.longitude,
    this.projectName,
    this.notes,
    this.status,
  }) : super._();

  factory _$AttendanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? userId;
  @override
  final DateTime timestamp;
  @override
  final AttendanceType type;
  @override
  @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
  final GeofenceModel? geofence;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? projectName;
  @override
  final String? notes;
  @override
  final AttendanceStatus? status;

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, timestamp: $timestamp, type: $type, geofence: $geofence, latitude: $latitude, longitude: $longitude, projectName: $projectName, notes: $notes, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.geofence, geofence) ||
                other.geofence == geofence) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    timestamp,
    type,
    geofence,
    latitude,
    longitude,
    projectName,
    notes,
    status,
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
    required final String id,
    final String? userId,
    required final DateTime timestamp,
    required final AttendanceType type,
    @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
    final GeofenceModel? geofence,
    required final double latitude,
    required final double longitude,
    final String? projectName,
    final String? notes,
    final AttendanceStatus? status,
  }) = _$AttendanceModelImpl;
  const _AttendanceModel._() : super._();

  factory _AttendanceModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get userId;
  @override
  DateTime get timestamp;
  @override
  AttendanceType get type;
  @override
  @JsonKey(fromJson: _geofenceFromJson, toJson: _geofenceToJson)
  GeofenceModel? get geofence;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get projectName;
  @override
  String? get notes;
  @override
  AttendanceStatus? get status;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceStats _$AttendanceStatsFromJson(Map<String, dynamic> json) {
  return _AttendanceStats.fromJson(json);
}

/// @nodoc
mixin _$AttendanceStats {
  int get present => throw _privateConstructorUsedError;
  int get absent => throw _privateConstructorUsedError;
  int get late => throw _privateConstructorUsedError;
  int get leave => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;
  int get attendancePercentage => throw _privateConstructorUsedError;

  /// Serializes this AttendanceStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceStatsCopyWith<AttendanceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceStatsCopyWith<$Res> {
  factory $AttendanceStatsCopyWith(
    AttendanceStats value,
    $Res Function(AttendanceStats) then,
  ) = _$AttendanceStatsCopyWithImpl<$Res, AttendanceStats>;
  @useResult
  $Res call({
    int present,
    int absent,
    int late,
    int leave,
    int totalDays,
    int attendancePercentage,
  });
}

/// @nodoc
class _$AttendanceStatsCopyWithImpl<$Res, $Val extends AttendanceStats>
    implements $AttendanceStatsCopyWith<$Res> {
  _$AttendanceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? present = null,
    Object? absent = null,
    Object? late = null,
    Object? leave = null,
    Object? totalDays = null,
    Object? attendancePercentage = null,
  }) {
    return _then(
      _value.copyWith(
            present: null == present
                ? _value.present
                : present // ignore: cast_nullable_to_non_nullable
                      as int,
            absent: null == absent
                ? _value.absent
                : absent // ignore: cast_nullable_to_non_nullable
                      as int,
            late: null == late
                ? _value.late
                : late // ignore: cast_nullable_to_non_nullable
                      as int,
            leave: null == leave
                ? _value.leave
                : leave // ignore: cast_nullable_to_non_nullable
                      as int,
            totalDays: null == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            attendancePercentage: null == attendancePercentage
                ? _value.attendancePercentage
                : attendancePercentage // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceStatsImplCopyWith<$Res>
    implements $AttendanceStatsCopyWith<$Res> {
  factory _$$AttendanceStatsImplCopyWith(
    _$AttendanceStatsImpl value,
    $Res Function(_$AttendanceStatsImpl) then,
  ) = __$$AttendanceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int present,
    int absent,
    int late,
    int leave,
    int totalDays,
    int attendancePercentage,
  });
}

/// @nodoc
class __$$AttendanceStatsImplCopyWithImpl<$Res>
    extends _$AttendanceStatsCopyWithImpl<$Res, _$AttendanceStatsImpl>
    implements _$$AttendanceStatsImplCopyWith<$Res> {
  __$$AttendanceStatsImplCopyWithImpl(
    _$AttendanceStatsImpl _value,
    $Res Function(_$AttendanceStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? present = null,
    Object? absent = null,
    Object? late = null,
    Object? leave = null,
    Object? totalDays = null,
    Object? attendancePercentage = null,
  }) {
    return _then(
      _$AttendanceStatsImpl(
        present: null == present
            ? _value.present
            : present // ignore: cast_nullable_to_non_nullable
                  as int,
        absent: null == absent
            ? _value.absent
            : absent // ignore: cast_nullable_to_non_nullable
                  as int,
        late: null == late
            ? _value.late
            : late // ignore: cast_nullable_to_non_nullable
                  as int,
        leave: null == leave
            ? _value.leave
            : leave // ignore: cast_nullable_to_non_nullable
                  as int,
        totalDays: null == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        attendancePercentage: null == attendancePercentage
            ? _value.attendancePercentage
            : attendancePercentage // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceStatsImpl implements _AttendanceStats {
  const _$AttendanceStatsImpl({
    required this.present,
    required this.absent,
    required this.late,
    required this.leave,
    required this.totalDays,
    required this.attendancePercentage,
  });

  factory _$AttendanceStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceStatsImplFromJson(json);

  @override
  final int present;
  @override
  final int absent;
  @override
  final int late;
  @override
  final int leave;
  @override
  final int totalDays;
  @override
  final int attendancePercentage;

  @override
  String toString() {
    return 'AttendanceStats(present: $present, absent: $absent, late: $late, leave: $leave, totalDays: $totalDays, attendancePercentage: $attendancePercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceStatsImpl &&
            (identical(other.present, present) || other.present == present) &&
            (identical(other.absent, absent) || other.absent == absent) &&
            (identical(other.late, late) || other.late == late) &&
            (identical(other.leave, leave) || other.leave == leave) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(other.attendancePercentage, attendancePercentage) ||
                other.attendancePercentage == attendancePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    present,
    absent,
    late,
    leave,
    totalDays,
    attendancePercentage,
  );

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceStatsImplCopyWith<_$AttendanceStatsImpl> get copyWith =>
      __$$AttendanceStatsImplCopyWithImpl<_$AttendanceStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceStatsImplToJson(this);
  }
}

abstract class _AttendanceStats implements AttendanceStats {
  const factory _AttendanceStats({
    required final int present,
    required final int absent,
    required final int late,
    required final int leave,
    required final int totalDays,
    required final int attendancePercentage,
  }) = _$AttendanceStatsImpl;

  factory _AttendanceStats.fromJson(Map<String, dynamic> json) =
      _$AttendanceStatsImpl.fromJson;

  @override
  int get present;
  @override
  int get absent;
  @override
  int get late;
  @override
  int get leave;
  @override
  int get totalDays;
  @override
  int get attendancePercentage;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceStatsImplCopyWith<_$AttendanceStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
