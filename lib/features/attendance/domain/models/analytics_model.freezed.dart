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

AnalyticsModel _$AnalyticsModelFromJson(Map<String, dynamic> json) {
  return _AnalyticsModel.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsModel {
  AnalyticsPeriod get period => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;
  int get presentDays => throw _privateConstructorUsedError;
  int get absentDays => throw _privateConstructorUsedError;
  int get leaveDays => throw _privateConstructorUsedError;
  int get lateDays => throw _privateConstructorUsedError;
  int get onTimeDays => throw _privateConstructorUsedError;
  double get dailyAvgHours => throw _privateConstructorUsedError;
  double get monthlyAvgHours => throw _privateConstructorUsedError;
  int get pendingRegularisations =>
      throw _privateConstructorUsedError; // Manager only
  int get pendingLeaves => throw _privateConstructorUsedError; // Manager only
  String? get periodTitle => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsModelCopyWith<AnalyticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsModelCopyWith<$Res> {
  factory $AnalyticsModelCopyWith(
    AnalyticsModel value,
    $Res Function(AnalyticsModel) then,
  ) = _$AnalyticsModelCopyWithImpl<$Res, AnalyticsModel>;
  @useResult
  $Res call({
    AnalyticsPeriod period,
    DateTime startDate,
    DateTime endDate,
    int totalDays,
    int presentDays,
    int absentDays,
    int leaveDays,
    int lateDays,
    int onTimeDays,
    double dailyAvgHours,
    double monthlyAvgHours,
    int pendingRegularisations,
    int pendingLeaves,
    String? periodTitle,
  });
}

/// @nodoc
class _$AnalyticsModelCopyWithImpl<$Res, $Val extends AnalyticsModel>
    implements $AnalyticsModelCopyWith<$Res> {
  _$AnalyticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalDays = null,
    Object? presentDays = null,
    Object? absentDays = null,
    Object? leaveDays = null,
    Object? lateDays = null,
    Object? onTimeDays = null,
    Object? dailyAvgHours = null,
    Object? monthlyAvgHours = null,
    Object? pendingRegularisations = null,
    Object? pendingLeaves = null,
    Object? periodTitle = freezed,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as AnalyticsPeriod,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalDays: null == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            presentDays: null == presentDays
                ? _value.presentDays
                : presentDays // ignore: cast_nullable_to_non_nullable
                      as int,
            absentDays: null == absentDays
                ? _value.absentDays
                : absentDays // ignore: cast_nullable_to_non_nullable
                      as int,
            leaveDays: null == leaveDays
                ? _value.leaveDays
                : leaveDays // ignore: cast_nullable_to_non_nullable
                      as int,
            lateDays: null == lateDays
                ? _value.lateDays
                : lateDays // ignore: cast_nullable_to_non_nullable
                      as int,
            onTimeDays: null == onTimeDays
                ? _value.onTimeDays
                : onTimeDays // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyAvgHours: null == dailyAvgHours
                ? _value.dailyAvgHours
                : dailyAvgHours // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyAvgHours: null == monthlyAvgHours
                ? _value.monthlyAvgHours
                : monthlyAvgHours // ignore: cast_nullable_to_non_nullable
                      as double,
            pendingRegularisations: null == pendingRegularisations
                ? _value.pendingRegularisations
                : pendingRegularisations // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingLeaves: null == pendingLeaves
                ? _value.pendingLeaves
                : pendingLeaves // ignore: cast_nullable_to_non_nullable
                      as int,
            periodTitle: freezed == periodTitle
                ? _value.periodTitle
                : periodTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsModelImplCopyWith<$Res>
    implements $AnalyticsModelCopyWith<$Res> {
  factory _$$AnalyticsModelImplCopyWith(
    _$AnalyticsModelImpl value,
    $Res Function(_$AnalyticsModelImpl) then,
  ) = __$$AnalyticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AnalyticsPeriod period,
    DateTime startDate,
    DateTime endDate,
    int totalDays,
    int presentDays,
    int absentDays,
    int leaveDays,
    int lateDays,
    int onTimeDays,
    double dailyAvgHours,
    double monthlyAvgHours,
    int pendingRegularisations,
    int pendingLeaves,
    String? periodTitle,
  });
}

/// @nodoc
class __$$AnalyticsModelImplCopyWithImpl<$Res>
    extends _$AnalyticsModelCopyWithImpl<$Res, _$AnalyticsModelImpl>
    implements _$$AnalyticsModelImplCopyWith<$Res> {
  __$$AnalyticsModelImplCopyWithImpl(
    _$AnalyticsModelImpl _value,
    $Res Function(_$AnalyticsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalDays = null,
    Object? presentDays = null,
    Object? absentDays = null,
    Object? leaveDays = null,
    Object? lateDays = null,
    Object? onTimeDays = null,
    Object? dailyAvgHours = null,
    Object? monthlyAvgHours = null,
    Object? pendingRegularisations = null,
    Object? pendingLeaves = null,
    Object? periodTitle = freezed,
  }) {
    return _then(
      _$AnalyticsModelImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as AnalyticsPeriod,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalDays: null == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        presentDays: null == presentDays
            ? _value.presentDays
            : presentDays // ignore: cast_nullable_to_non_nullable
                  as int,
        absentDays: null == absentDays
            ? _value.absentDays
            : absentDays // ignore: cast_nullable_to_non_nullable
                  as int,
        leaveDays: null == leaveDays
            ? _value.leaveDays
            : leaveDays // ignore: cast_nullable_to_non_nullable
                  as int,
        lateDays: null == lateDays
            ? _value.lateDays
            : lateDays // ignore: cast_nullable_to_non_nullable
                  as int,
        onTimeDays: null == onTimeDays
            ? _value.onTimeDays
            : onTimeDays // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyAvgHours: null == dailyAvgHours
            ? _value.dailyAvgHours
            : dailyAvgHours // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyAvgHours: null == monthlyAvgHours
            ? _value.monthlyAvgHours
            : monthlyAvgHours // ignore: cast_nullable_to_non_nullable
                  as double,
        pendingRegularisations: null == pendingRegularisations
            ? _value.pendingRegularisations
            : pendingRegularisations // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingLeaves: null == pendingLeaves
            ? _value.pendingLeaves
            : pendingLeaves // ignore: cast_nullable_to_non_nullable
                  as int,
        periodTitle: freezed == periodTitle
            ? _value.periodTitle
            : periodTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsModelImpl extends _AnalyticsModel {
  const _$AnalyticsModelImpl({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.lateDays,
    required this.onTimeDays,
    required this.dailyAvgHours,
    required this.monthlyAvgHours,
    this.pendingRegularisations = 0,
    this.pendingLeaves = 0,
    this.periodTitle,
  }) : super._();

  factory _$AnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsModelImplFromJson(json);

  @override
  final AnalyticsPeriod period;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int totalDays;
  @override
  final int presentDays;
  @override
  final int absentDays;
  @override
  final int leaveDays;
  @override
  final int lateDays;
  @override
  final int onTimeDays;
  @override
  final double dailyAvgHours;
  @override
  final double monthlyAvgHours;
  @override
  @JsonKey()
  final int pendingRegularisations;
  // Manager only
  @override
  @JsonKey()
  final int pendingLeaves;
  // Manager only
  @override
  final String? periodTitle;

  @override
  String toString() {
    return 'AnalyticsModel(period: $period, startDate: $startDate, endDate: $endDate, totalDays: $totalDays, presentDays: $presentDays, absentDays: $absentDays, leaveDays: $leaveDays, lateDays: $lateDays, onTimeDays: $onTimeDays, dailyAvgHours: $dailyAvgHours, monthlyAvgHours: $monthlyAvgHours, pendingRegularisations: $pendingRegularisations, pendingLeaves: $pendingLeaves, periodTitle: $periodTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsModelImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(other.presentDays, presentDays) ||
                other.presentDays == presentDays) &&
            (identical(other.absentDays, absentDays) ||
                other.absentDays == absentDays) &&
            (identical(other.leaveDays, leaveDays) ||
                other.leaveDays == leaveDays) &&
            (identical(other.lateDays, lateDays) ||
                other.lateDays == lateDays) &&
            (identical(other.onTimeDays, onTimeDays) ||
                other.onTimeDays == onTimeDays) &&
            (identical(other.dailyAvgHours, dailyAvgHours) ||
                other.dailyAvgHours == dailyAvgHours) &&
            (identical(other.monthlyAvgHours, monthlyAvgHours) ||
                other.monthlyAvgHours == monthlyAvgHours) &&
            (identical(other.pendingRegularisations, pendingRegularisations) ||
                other.pendingRegularisations == pendingRegularisations) &&
            (identical(other.pendingLeaves, pendingLeaves) ||
                other.pendingLeaves == pendingLeaves) &&
            (identical(other.periodTitle, periodTitle) ||
                other.periodTitle == periodTitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    startDate,
    endDate,
    totalDays,
    presentDays,
    absentDays,
    leaveDays,
    lateDays,
    onTimeDays,
    dailyAvgHours,
    monthlyAvgHours,
    pendingRegularisations,
    pendingLeaves,
    periodTitle,
  );

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsModelImplCopyWith<_$AnalyticsModelImpl> get copyWith =>
      __$$AnalyticsModelImplCopyWithImpl<_$AnalyticsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsModelImplToJson(this);
  }
}

abstract class _AnalyticsModel extends AnalyticsModel {
  const factory _AnalyticsModel({
    required final AnalyticsPeriod period,
    required final DateTime startDate,
    required final DateTime endDate,
    required final int totalDays,
    required final int presentDays,
    required final int absentDays,
    required final int leaveDays,
    required final int lateDays,
    required final int onTimeDays,
    required final double dailyAvgHours,
    required final double monthlyAvgHours,
    final int pendingRegularisations,
    final int pendingLeaves,
    final String? periodTitle,
  }) = _$AnalyticsModelImpl;
  const _AnalyticsModel._() : super._();

  factory _AnalyticsModel.fromJson(Map<String, dynamic> json) =
      _$AnalyticsModelImpl.fromJson;

  @override
  AnalyticsPeriod get period;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get totalDays;
  @override
  int get presentDays;
  @override
  int get absentDays;
  @override
  int get leaveDays;
  @override
  int get lateDays;
  @override
  int get onTimeDays;
  @override
  double get dailyAvgHours;
  @override
  double get monthlyAvgHours;
  @override
  int get pendingRegularisations; // Manager only
  @override
  int get pendingLeaves; // Manager only
  @override
  String? get periodTitle;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsModelImplCopyWith<_$AnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
