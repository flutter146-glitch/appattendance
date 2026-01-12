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
  DateTime get endDate =>
      throw _privateConstructorUsedError; // Team Aggregate Stats (top row cards)
  Map<String, int> get teamStats =>
      throw _privateConstructorUsedError; // e.g., {'team':50, 'present':35, ...}
  Map<String, double> get teamPercentages =>
      throw _privateConstructorUsedError; // e.g., {'present':70.0, ...}
  // Graph Data (raw for fl_chart conversion)
  Map<String, List<double>> get graphDataRaw =>
      throw _privateConstructorUsedError;
  List<String> get graphLabels =>
      throw _privateConstructorUsedError; // Dynamic insights
  List<String> get insights =>
      throw _privateConstructorUsedError; // Quick computed / summary fields
  int get totalDays => throw _privateConstructorUsedError;
  int get presentDays => throw _privateConstructorUsedError;
  int get absentDays => throw _privateConstructorUsedError;
  int get leaveDays => throw _privateConstructorUsedError;
  int get lateDays => throw _privateConstructorUsedError;
  int get onTimeDays => throw _privateConstructorUsedError;
  double get dailyAvgHours => throw _privateConstructorUsedError;
  double get monthlyAvgHours => throw _privateConstructorUsedError;
  int get pendingRegularisations => throw _privateConstructorUsedError;
  int get pendingLeaves => throw _privateConstructorUsedError;
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
    Map<String, int> teamStats,
    Map<String, double> teamPercentages,
    Map<String, List<double>> graphDataRaw,
    List<String> graphLabels,
    List<String> insights,
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
    Object? teamStats = null,
    Object? teamPercentages = null,
    Object? graphDataRaw = null,
    Object? graphLabels = null,
    Object? insights = null,
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
            teamStats: null == teamStats
                ? _value.teamStats
                : teamStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            teamPercentages: null == teamPercentages
                ? _value.teamPercentages
                : teamPercentages // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            graphDataRaw: null == graphDataRaw
                ? _value.graphDataRaw
                : graphDataRaw // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<double>>,
            graphLabels: null == graphLabels
                ? _value.graphLabels
                : graphLabels // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            insights: null == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
    Map<String, int> teamStats,
    Map<String, double> teamPercentages,
    Map<String, List<double>> graphDataRaw,
    List<String> graphLabels,
    List<String> insights,
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
    Object? teamStats = null,
    Object? teamPercentages = null,
    Object? graphDataRaw = null,
    Object? graphLabels = null,
    Object? insights = null,
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
        teamStats: null == teamStats
            ? _value._teamStats
            : teamStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        teamPercentages: null == teamPercentages
            ? _value._teamPercentages
            : teamPercentages // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        graphDataRaw: null == graphDataRaw
            ? _value._graphDataRaw
            : graphDataRaw // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<double>>,
        graphLabels: null == graphLabels
            ? _value._graphLabels
            : graphLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        insights: null == insights
            ? _value._insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
    final Map<String, int> teamStats = const {},
    final Map<String, double> teamPercentages = const {},
    final Map<String, List<double>> graphDataRaw = const {},
    final List<String> graphLabels = const [],
    final List<String> insights = const [],
    this.totalDays = 0,
    this.presentDays = 0,
    this.absentDays = 0,
    this.leaveDays = 0,
    this.lateDays = 0,
    this.onTimeDays = 0,
    this.dailyAvgHours = 0.0,
    this.monthlyAvgHours = 0.0,
    this.pendingRegularisations = 0,
    this.pendingLeaves = 0,
    this.periodTitle,
  }) : _teamStats = teamStats,
       _teamPercentages = teamPercentages,
       _graphDataRaw = graphDataRaw,
       _graphLabels = graphLabels,
       _insights = insights,
       super._();

  factory _$AnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsModelImplFromJson(json);

  @override
  final AnalyticsPeriod period;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  // Team Aggregate Stats (top row cards)
  final Map<String, int> _teamStats;
  // Team Aggregate Stats (top row cards)
  @override
  @JsonKey()
  Map<String, int> get teamStats {
    if (_teamStats is EqualUnmodifiableMapView) return _teamStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_teamStats);
  }

  // e.g., {'team':50, 'present':35, ...}
  final Map<String, double> _teamPercentages;
  // e.g., {'team':50, 'present':35, ...}
  @override
  @JsonKey()
  Map<String, double> get teamPercentages {
    if (_teamPercentages is EqualUnmodifiableMapView) return _teamPercentages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_teamPercentages);
  }

  // e.g., {'present':70.0, ...}
  // Graph Data (raw for fl_chart conversion)
  final Map<String, List<double>> _graphDataRaw;
  // e.g., {'present':70.0, ...}
  // Graph Data (raw for fl_chart conversion)
  @override
  @JsonKey()
  Map<String, List<double>> get graphDataRaw {
    if (_graphDataRaw is EqualUnmodifiableMapView) return _graphDataRaw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_graphDataRaw);
  }

  final List<String> _graphLabels;
  @override
  @JsonKey()
  List<String> get graphLabels {
    if (_graphLabels is EqualUnmodifiableListView) return _graphLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_graphLabels);
  }

  // Dynamic insights
  final List<String> _insights;
  // Dynamic insights
  @override
  @JsonKey()
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  // Quick computed / summary fields
  @override
  @JsonKey()
  final int totalDays;
  @override
  @JsonKey()
  final int presentDays;
  @override
  @JsonKey()
  final int absentDays;
  @override
  @JsonKey()
  final int leaveDays;
  @override
  @JsonKey()
  final int lateDays;
  @override
  @JsonKey()
  final int onTimeDays;
  @override
  @JsonKey()
  final double dailyAvgHours;
  @override
  @JsonKey()
  final double monthlyAvgHours;
  @override
  @JsonKey()
  final int pendingRegularisations;
  @override
  @JsonKey()
  final int pendingLeaves;
  @override
  final String? periodTitle;

  @override
  String toString() {
    return 'AnalyticsModel(period: $period, startDate: $startDate, endDate: $endDate, teamStats: $teamStats, teamPercentages: $teamPercentages, graphDataRaw: $graphDataRaw, graphLabels: $graphLabels, insights: $insights, totalDays: $totalDays, presentDays: $presentDays, absentDays: $absentDays, leaveDays: $leaveDays, lateDays: $lateDays, onTimeDays: $onTimeDays, dailyAvgHours: $dailyAvgHours, monthlyAvgHours: $monthlyAvgHours, pendingRegularisations: $pendingRegularisations, pendingLeaves: $pendingLeaves, periodTitle: $periodTitle)';
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
            const DeepCollectionEquality().equals(
              other._teamStats,
              _teamStats,
            ) &&
            const DeepCollectionEquality().equals(
              other._teamPercentages,
              _teamPercentages,
            ) &&
            const DeepCollectionEquality().equals(
              other._graphDataRaw,
              _graphDataRaw,
            ) &&
            const DeepCollectionEquality().equals(
              other._graphLabels,
              _graphLabels,
            ) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
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
  int get hashCode => Object.hashAll([
    runtimeType,
    period,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_teamStats),
    const DeepCollectionEquality().hash(_teamPercentages),
    const DeepCollectionEquality().hash(_graphDataRaw),
    const DeepCollectionEquality().hash(_graphLabels),
    const DeepCollectionEquality().hash(_insights),
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
  ]);

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
    final Map<String, int> teamStats,
    final Map<String, double> teamPercentages,
    final Map<String, List<double>> graphDataRaw,
    final List<String> graphLabels,
    final List<String> insights,
    final int totalDays,
    final int presentDays,
    final int absentDays,
    final int leaveDays,
    final int lateDays,
    final int onTimeDays,
    final double dailyAvgHours,
    final double monthlyAvgHours,
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
  DateTime get endDate; // Team Aggregate Stats (top row cards)
  @override
  Map<String, int> get teamStats; // e.g., {'team':50, 'present':35, ...}
  @override
  Map<String, double> get teamPercentages; // e.g., {'present':70.0, ...}
  // Graph Data (raw for fl_chart conversion)
  @override
  Map<String, List<double>> get graphDataRaw;
  @override
  List<String> get graphLabels; // Dynamic insights
  @override
  List<String> get insights; // Quick computed / summary fields
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
  int get pendingRegularisations;
  @override
  int get pendingLeaves;
  @override
  String? get periodTitle;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsModelImplCopyWith<_$AnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
