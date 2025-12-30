// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeofenceModel _$GeofenceModelFromJson(Map<String, dynamic> json) {
  return _GeofenceModel.fromJson(json);
}

/// @nodoc
mixin _$GeofenceModel {
  String get id =>
      throw _privateConstructorUsedError; // e.g., "OFFICE_MAIN" or UUID
  String get name =>
      throw _privateConstructorUsedError; // "Main Office", "Client Site A"
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get radiusMeters => throw _privateConstructorUsedError; // e.g., 100.0
  bool get isActive => throw _privateConstructorUsedError;
  String? get address =>
      throw _privateConstructorUsedError; // Optional description
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GeofenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeofenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeofenceModelCopyWith<GeofenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceModelCopyWith<$Res> {
  factory $GeofenceModelCopyWith(
    GeofenceModel value,
    $Res Function(GeofenceModel) then,
  ) = _$GeofenceModelCopyWithImpl<$Res, GeofenceModel>;
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double radiusMeters,
    bool isActive,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$GeofenceModelCopyWithImpl<$Res, $Val extends GeofenceModel>
    implements $GeofenceModelCopyWith<$Res> {
  _$GeofenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeofenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? isActive = null,
    Object? address = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            radiusMeters: null == radiusMeters
                ? _value.radiusMeters
                : radiusMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GeofenceModelImplCopyWith<$Res>
    implements $GeofenceModelCopyWith<$Res> {
  factory _$$GeofenceModelImplCopyWith(
    _$GeofenceModelImpl value,
    $Res Function(_$GeofenceModelImpl) then,
  ) = __$$GeofenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double radiusMeters,
    bool isActive,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$GeofenceModelImplCopyWithImpl<$Res>
    extends _$GeofenceModelCopyWithImpl<$Res, _$GeofenceModelImpl>
    implements _$$GeofenceModelImplCopyWith<$Res> {
  __$$GeofenceModelImplCopyWithImpl(
    _$GeofenceModelImpl _value,
    $Res Function(_$GeofenceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeofenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? isActive = null,
    Object? address = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$GeofenceModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        radiusMeters: null == radiusMeters
            ? _value.radiusMeters
            : radiusMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
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
class _$GeofenceModelImpl extends _GeofenceModel {
  const _$GeofenceModelImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.isActive = true,
    this.address,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$GeofenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeofenceModelImplFromJson(json);

  @override
  final String id;
  // e.g., "OFFICE_MAIN" or UUID
  @override
  final String name;
  // "Main Office", "Client Site A"
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double radiusMeters;
  // e.g., 100.0
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? address;
  // Optional description
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GeofenceModel(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, isActive: $isActive, address: $address, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    radiusMeters,
    isActive,
    address,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GeofenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceModelImplCopyWith<_$GeofenceModelImpl> get copyWith =>
      __$$GeofenceModelImplCopyWithImpl<_$GeofenceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeofenceModelImplToJson(this);
  }
}

abstract class _GeofenceModel extends GeofenceModel {
  const factory _GeofenceModel({
    required final String id,
    required final String name,
    required final double latitude,
    required final double longitude,
    required final double radiusMeters,
    final bool isActive,
    final String? address,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$GeofenceModelImpl;
  const _GeofenceModel._() : super._();

  factory _GeofenceModel.fromJson(Map<String, dynamic> json) =
      _$GeofenceModelImpl.fromJson;

  @override
  String get id; // e.g., "OFFICE_MAIN" or UUID
  @override
  String get name; // "Main Office", "Client Site A"
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get radiusMeters; // e.g., 100.0
  @override
  bool get isActive;
  @override
  String? get address; // Optional description
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of GeofenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeofenceModelImplCopyWith<_$GeofenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
