// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  int get present => throw _privateConstructorUsedError;
  int get absent => throw _privateConstructorUsedError;
  int get late => throw _privateConstructorUsedError;
  int get halfDay => throw _privateConstructorUsedError;
  double get avgHours => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
    AnalyticsData value,
    $Res Function(AnalyticsData) then,
  ) = _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call({
    int present,
    int absent,
    int late,
    int halfDay,
    double avgHours,
    DateTime? start,
    DateTime? end,
  });
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? present = null,
    Object? absent = null,
    Object? late = null,
    Object? halfDay = null,
    Object? avgHours = null,
    Object? start = freezed,
    Object? end = freezed,
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
            halfDay: null == halfDay
                ? _value.halfDay
                : halfDay // ignore: cast_nullable_to_non_nullable
                      as int,
            avgHours: null == avgHours
                ? _value.avgHours
                : avgHours // ignore: cast_nullable_to_non_nullable
                      as double,
            start: freezed == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            end: freezed == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
    _$AnalyticsDataImpl value,
    $Res Function(_$AnalyticsDataImpl) then,
  ) = __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int present,
    int absent,
    int late,
    int halfDay,
    double avgHours,
    DateTime? start,
    DateTime? end,
  });
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
    _$AnalyticsDataImpl _value,
    $Res Function(_$AnalyticsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? present = null,
    Object? absent = null,
    Object? late = null,
    Object? halfDay = null,
    Object? avgHours = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _$AnalyticsDataImpl(
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
        halfDay: null == halfDay
            ? _value.halfDay
            : halfDay // ignore: cast_nullable_to_non_nullable
                  as int,
        avgHours: null == avgHours
            ? _value.avgHours
            : avgHours // ignore: cast_nullable_to_non_nullable
                  as double,
        start: freezed == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        end: freezed == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl({
    required this.present,
    required this.absent,
    required this.late,
    required this.halfDay,
    required this.avgHours,
    this.start,
    this.end,
  });

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  final int present;
  @override
  final int absent;
  @override
  final int late;
  @override
  final int halfDay;
  @override
  final double avgHours;
  @override
  final DateTime? start;
  @override
  final DateTime? end;

  @override
  String toString() {
    return 'AnalyticsData(present: $present, absent: $absent, late: $late, halfDay: $halfDay, avgHours: $avgHours, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.present, present) || other.present == present) &&
            (identical(other.absent, absent) || other.absent == absent) &&
            (identical(other.late, late) || other.late == late) &&
            (identical(other.halfDay, halfDay) || other.halfDay == halfDay) &&
            (identical(other.avgHours, avgHours) ||
                other.avgHours == avgHours) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    present,
    absent,
    late,
    halfDay,
    avgHours,
    start,
    end,
  );

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(this);
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData({
    required final int present,
    required final int absent,
    required final int late,
    required final int halfDay,
    required final double avgHours,
    final DateTime? start,
    final DateTime? end,
  }) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  int get present;
  @override
  int get absent;
  @override
  int get late;
  @override
  int get halfDay;
  @override
  double get avgHours;
  @override
  DateTime? get start;
  @override
  DateTime? get end;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
