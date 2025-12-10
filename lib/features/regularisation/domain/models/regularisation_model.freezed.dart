// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'regularisation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegularisationModel _$RegularisationModelFromJson(Map<String, dynamic> json) {
  return _RegularisationModel.fromJson(json);
}

/// @nodoc
mixin _$RegularisationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  RegularisationType get type => throw _privateConstructorUsedError;
  RegularisationStatus get status => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get managerRemarks => throw _privateConstructorUsedError;
  List<String> get supportingDocs => throw _privateConstructorUsedError;
  DateTime? get requestedDate => throw _privateConstructorUsedError;
  DateTime? get approvedDate => throw _privateConstructorUsedError;

  /// Serializes this RegularisationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegularisationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegularisationModelCopyWith<RegularisationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegularisationModelCopyWith<$Res> {
  factory $RegularisationModelCopyWith(
    RegularisationModel value,
    $Res Function(RegularisationModel) then,
  ) = _$RegularisationModelCopyWithImpl<$Res, RegularisationModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime date,
    RegularisationType type,
    RegularisationStatus status,
    String reason,
    String? managerRemarks,
    List<String> supportingDocs,
    DateTime? requestedDate,
    DateTime? approvedDate,
  });
}

/// @nodoc
class _$RegularisationModelCopyWithImpl<$Res, $Val extends RegularisationModel>
    implements $RegularisationModelCopyWith<$Res> {
  _$RegularisationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegularisationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? type = null,
    Object? status = null,
    Object? reason = null,
    Object? managerRemarks = freezed,
    Object? supportingDocs = null,
    Object? requestedDate = freezed,
    Object? approvedDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RegularisationType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RegularisationStatus,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            managerRemarks: freezed == managerRemarks
                ? _value.managerRemarks
                : managerRemarks // ignore: cast_nullable_to_non_nullable
                      as String?,
            supportingDocs: null == supportingDocs
                ? _value.supportingDocs
                : supportingDocs // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            requestedDate: freezed == requestedDate
                ? _value.requestedDate
                : requestedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            approvedDate: freezed == approvedDate
                ? _value.approvedDate
                : approvedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegularisationModelImplCopyWith<$Res>
    implements $RegularisationModelCopyWith<$Res> {
  factory _$$RegularisationModelImplCopyWith(
    _$RegularisationModelImpl value,
    $Res Function(_$RegularisationModelImpl) then,
  ) = __$$RegularisationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime date,
    RegularisationType type,
    RegularisationStatus status,
    String reason,
    String? managerRemarks,
    List<String> supportingDocs,
    DateTime? requestedDate,
    DateTime? approvedDate,
  });
}

/// @nodoc
class __$$RegularisationModelImplCopyWithImpl<$Res>
    extends _$RegularisationModelCopyWithImpl<$Res, _$RegularisationModelImpl>
    implements _$$RegularisationModelImplCopyWith<$Res> {
  __$$RegularisationModelImplCopyWithImpl(
    _$RegularisationModelImpl _value,
    $Res Function(_$RegularisationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegularisationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? type = null,
    Object? status = null,
    Object? reason = null,
    Object? managerRemarks = freezed,
    Object? supportingDocs = null,
    Object? requestedDate = freezed,
    Object? approvedDate = freezed,
  }) {
    return _then(
      _$RegularisationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RegularisationType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RegularisationStatus,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        managerRemarks: freezed == managerRemarks
            ? _value.managerRemarks
            : managerRemarks // ignore: cast_nullable_to_non_nullable
                  as String?,
        supportingDocs: null == supportingDocs
            ? _value._supportingDocs
            : supportingDocs // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        requestedDate: freezed == requestedDate
            ? _value.requestedDate
            : requestedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        approvedDate: freezed == approvedDate
            ? _value.approvedDate
            : approvedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegularisationModelImpl extends _RegularisationModel {
  const _$RegularisationModelImpl({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.status,
    required this.reason,
    this.managerRemarks,
    final List<String> supportingDocs = const [],
    this.requestedDate,
    this.approvedDate,
  }) : _supportingDocs = supportingDocs,
       super._();

  factory _$RegularisationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegularisationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;
  @override
  final RegularisationType type;
  @override
  final RegularisationStatus status;
  @override
  final String reason;
  @override
  final String? managerRemarks;
  final List<String> _supportingDocs;
  @override
  @JsonKey()
  List<String> get supportingDocs {
    if (_supportingDocs is EqualUnmodifiableListView) return _supportingDocs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportingDocs);
  }

  @override
  final DateTime? requestedDate;
  @override
  final DateTime? approvedDate;

  @override
  String toString() {
    return 'RegularisationModel(id: $id, userId: $userId, date: $date, type: $type, status: $status, reason: $reason, managerRemarks: $managerRemarks, supportingDocs: $supportingDocs, requestedDate: $requestedDate, approvedDate: $approvedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegularisationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.managerRemarks, managerRemarks) ||
                other.managerRemarks == managerRemarks) &&
            const DeepCollectionEquality().equals(
              other._supportingDocs,
              _supportingDocs,
            ) &&
            (identical(other.requestedDate, requestedDate) ||
                other.requestedDate == requestedDate) &&
            (identical(other.approvedDate, approvedDate) ||
                other.approvedDate == approvedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    date,
    type,
    status,
    reason,
    managerRemarks,
    const DeepCollectionEquality().hash(_supportingDocs),
    requestedDate,
    approvedDate,
  );

  /// Create a copy of RegularisationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegularisationModelImplCopyWith<_$RegularisationModelImpl> get copyWith =>
      __$$RegularisationModelImplCopyWithImpl<_$RegularisationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegularisationModelImplToJson(this);
  }
}

abstract class _RegularisationModel extends RegularisationModel {
  const factory _RegularisationModel({
    required final String id,
    required final String userId,
    required final DateTime date,
    required final RegularisationType type,
    required final RegularisationStatus status,
    required final String reason,
    final String? managerRemarks,
    final List<String> supportingDocs,
    final DateTime? requestedDate,
    final DateTime? approvedDate,
  }) = _$RegularisationModelImpl;
  const _RegularisationModel._() : super._();

  factory _RegularisationModel.fromJson(Map<String, dynamic> json) =
      _$RegularisationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  RegularisationType get type;
  @override
  RegularisationStatus get status;
  @override
  String get reason;
  @override
  String? get managerRemarks;
  @override
  List<String> get supportingDocs;
  @override
  DateTime? get requestedDate;
  @override
  DateTime? get approvedDate;

  /// Create a copy of RegularisationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegularisationModelImplCopyWith<_$RegularisationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
