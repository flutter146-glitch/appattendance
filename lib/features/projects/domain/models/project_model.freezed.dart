// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get site => throw _privateConstructorUsedError;
  String? get shift => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get clientContact => throw _privateConstructorUsedError;
  String? get managerName => throw _privateConstructorUsedError;
  String? get managerEmail => throw _privateConstructorUsedError;
  String? get managerContact => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get techStack => throw _privateConstructorUsedError;
  DateTime? get assignedDate => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
    ProjectModel value,
    $Res Function(ProjectModel) then,
  ) = _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? status,
    String? site,
    String? shift,
    String? clientName,
    String? clientContact,
    String? managerName,
    String? managerEmail,
    String? managerContact,
    String? description,
    String? techStack,
    DateTime? assignedDate,
  });
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = freezed,
    Object? site = freezed,
    Object? shift = freezed,
    Object? clientName = freezed,
    Object? clientContact = freezed,
    Object? managerName = freezed,
    Object? managerEmail = freezed,
    Object? managerContact = freezed,
    Object? description = freezed,
    Object? techStack = freezed,
    Object? assignedDate = freezed,
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
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            site: freezed == site
                ? _value.site
                : site // ignore: cast_nullable_to_non_nullable
                      as String?,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientName: freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientContact: freezed == clientContact
                ? _value.clientContact
                : clientContact // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerName: freezed == managerName
                ? _value.managerName
                : managerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerEmail: freezed == managerEmail
                ? _value.managerEmail
                : managerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            managerContact: freezed == managerContact
                ? _value.managerContact
                : managerContact // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            techStack: freezed == techStack
                ? _value.techStack
                : techStack // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedDate: freezed == assignedDate
                ? _value.assignedDate
                : assignedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
    _$ProjectModelImpl value,
    $Res Function(_$ProjectModelImpl) then,
  ) = __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? status,
    String? site,
    String? shift,
    String? clientName,
    String? clientContact,
    String? managerName,
    String? managerEmail,
    String? managerContact,
    String? description,
    String? techStack,
    DateTime? assignedDate,
  });
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
    _$ProjectModelImpl _value,
    $Res Function(_$ProjectModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = freezed,
    Object? site = freezed,
    Object? shift = freezed,
    Object? clientName = freezed,
    Object? clientContact = freezed,
    Object? managerName = freezed,
    Object? managerEmail = freezed,
    Object? managerContact = freezed,
    Object? description = freezed,
    Object? techStack = freezed,
    Object? assignedDate = freezed,
  }) {
    return _then(
      _$ProjectModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        site: freezed == site
            ? _value.site
            : site // ignore: cast_nullable_to_non_nullable
                  as String?,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientName: freezed == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientContact: freezed == clientContact
            ? _value.clientContact
            : clientContact // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerName: freezed == managerName
            ? _value.managerName
            : managerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerEmail: freezed == managerEmail
            ? _value.managerEmail
            : managerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        managerContact: freezed == managerContact
            ? _value.managerContact
            : managerContact // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        techStack: freezed == techStack
            ? _value.techStack
            : techStack // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedDate: freezed == assignedDate
            ? _value.assignedDate
            : assignedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl extends _ProjectModel {
  const _$ProjectModelImpl({
    required this.id,
    required this.name,
    this.status,
    this.site,
    this.shift,
    this.clientName,
    this.clientContact,
    this.managerName,
    this.managerEmail,
    this.managerContact,
    this.description,
    this.techStack,
    this.assignedDate,
  }) : super._();

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? status;
  @override
  final String? site;
  @override
  final String? shift;
  @override
  final String? clientName;
  @override
  final String? clientContact;
  @override
  final String? managerName;
  @override
  final String? managerEmail;
  @override
  final String? managerContact;
  @override
  final String? description;
  @override
  final String? techStack;
  @override
  final DateTime? assignedDate;

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, status: $status, site: $site, shift: $shift, clientName: $clientName, clientContact: $clientContact, managerName: $managerName, managerEmail: $managerEmail, managerContact: $managerContact, description: $description, techStack: $techStack, assignedDate: $assignedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientContact, clientContact) ||
                other.clientContact == clientContact) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.managerEmail, managerEmail) ||
                other.managerEmail == managerEmail) &&
            (identical(other.managerContact, managerContact) ||
                other.managerContact == managerContact) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.techStack, techStack) ||
                other.techStack == techStack) &&
            (identical(other.assignedDate, assignedDate) ||
                other.assignedDate == assignedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    status,
    site,
    shift,
    clientName,
    clientContact,
    managerName,
    managerEmail,
    managerContact,
    description,
    techStack,
    assignedDate,
  );

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(this);
  }
}

abstract class _ProjectModel extends ProjectModel {
  const factory _ProjectModel({
    required final String id,
    required final String name,
    final String? status,
    final String? site,
    final String? shift,
    final String? clientName,
    final String? clientContact,
    final String? managerName,
    final String? managerEmail,
    final String? managerContact,
    final String? description,
    final String? techStack,
    final DateTime? assignedDate,
  }) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get status;
  @override
  String? get site;
  @override
  String? get shift;
  @override
  String? get clientName;
  @override
  String? get clientContact;
  @override
  String? get managerName;
  @override
  String? get managerEmail;
  @override
  String? get managerContact;
  @override
  String? get description;
  @override
  String? get techStack;
  @override
  DateTime? get assignedDate;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectAnalytics _$ProjectAnalyticsFromJson(Map<String, dynamic> json) {
  return _ProjectAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ProjectAnalytics {
  Map<String, List<double>> get graphData => throw _privateConstructorUsedError;
  List<String> get labels => throw _privateConstructorUsedError;
  int get totalProjects => throw _privateConstructorUsedError;
  int get totalEmployees => throw _privateConstructorUsedError;
  Map<String, double> get statusDistribution =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get additionalStats =>
      throw _privateConstructorUsedError;

  /// Serializes this ProjectAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectAnalyticsCopyWith<ProjectAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectAnalyticsCopyWith<$Res> {
  factory $ProjectAnalyticsCopyWith(
    ProjectAnalytics value,
    $Res Function(ProjectAnalytics) then,
  ) = _$ProjectAnalyticsCopyWithImpl<$Res, ProjectAnalytics>;
  @useResult
  $Res call({
    Map<String, List<double>> graphData,
    List<String> labels,
    int totalProjects,
    int totalEmployees,
    Map<String, double> statusDistribution,
    Map<String, dynamic> additionalStats,
  });
}

/// @nodoc
class _$ProjectAnalyticsCopyWithImpl<$Res, $Val extends ProjectAnalytics>
    implements $ProjectAnalyticsCopyWith<$Res> {
  _$ProjectAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? graphData = null,
    Object? labels = null,
    Object? totalProjects = null,
    Object? totalEmployees = null,
    Object? statusDistribution = null,
    Object? additionalStats = null,
  }) {
    return _then(
      _value.copyWith(
            graphData: null == graphData
                ? _value.graphData
                : graphData // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<double>>,
            labels: null == labels
                ? _value.labels
                : labels // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            totalProjects: null == totalProjects
                ? _value.totalProjects
                : totalProjects // ignore: cast_nullable_to_non_nullable
                      as int,
            totalEmployees: null == totalEmployees
                ? _value.totalEmployees
                : totalEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
            statusDistribution: null == statusDistribution
                ? _value.statusDistribution
                : statusDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            additionalStats: null == additionalStats
                ? _value.additionalStats
                : additionalStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectAnalyticsImplCopyWith<$Res>
    implements $ProjectAnalyticsCopyWith<$Res> {
  factory _$$ProjectAnalyticsImplCopyWith(
    _$ProjectAnalyticsImpl value,
    $Res Function(_$ProjectAnalyticsImpl) then,
  ) = __$$ProjectAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, List<double>> graphData,
    List<String> labels,
    int totalProjects,
    int totalEmployees,
    Map<String, double> statusDistribution,
    Map<String, dynamic> additionalStats,
  });
}

/// @nodoc
class __$$ProjectAnalyticsImplCopyWithImpl<$Res>
    extends _$ProjectAnalyticsCopyWithImpl<$Res, _$ProjectAnalyticsImpl>
    implements _$$ProjectAnalyticsImplCopyWith<$Res> {
  __$$ProjectAnalyticsImplCopyWithImpl(
    _$ProjectAnalyticsImpl _value,
    $Res Function(_$ProjectAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? graphData = null,
    Object? labels = null,
    Object? totalProjects = null,
    Object? totalEmployees = null,
    Object? statusDistribution = null,
    Object? additionalStats = null,
  }) {
    return _then(
      _$ProjectAnalyticsImpl(
        graphData: null == graphData
            ? _value._graphData
            : graphData // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<double>>,
        labels: null == labels
            ? _value._labels
            : labels // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        totalProjects: null == totalProjects
            ? _value.totalProjects
            : totalProjects // ignore: cast_nullable_to_non_nullable
                  as int,
        totalEmployees: null == totalEmployees
            ? _value.totalEmployees
            : totalEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
        statusDistribution: null == statusDistribution
            ? _value._statusDistribution
            : statusDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        additionalStats: null == additionalStats
            ? _value._additionalStats
            : additionalStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectAnalyticsImpl implements _ProjectAnalytics {
  const _$ProjectAnalyticsImpl({
    required final Map<String, List<double>> graphData,
    required final List<String> labels,
    required this.totalProjects,
    required this.totalEmployees,
    required final Map<String, double> statusDistribution,
    final Map<String, dynamic> additionalStats = const {},
  }) : _graphData = graphData,
       _labels = labels,
       _statusDistribution = statusDistribution,
       _additionalStats = additionalStats;

  factory _$ProjectAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectAnalyticsImplFromJson(json);

  final Map<String, List<double>> _graphData;
  @override
  Map<String, List<double>> get graphData {
    if (_graphData is EqualUnmodifiableMapView) return _graphData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_graphData);
  }

  final List<String> _labels;
  @override
  List<String> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  final int totalProjects;
  @override
  final int totalEmployees;
  final Map<String, double> _statusDistribution;
  @override
  Map<String, double> get statusDistribution {
    if (_statusDistribution is EqualUnmodifiableMapView)
      return _statusDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_statusDistribution);
  }

  final Map<String, dynamic> _additionalStats;
  @override
  @JsonKey()
  Map<String, dynamic> get additionalStats {
    if (_additionalStats is EqualUnmodifiableMapView) return _additionalStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalStats);
  }

  @override
  String toString() {
    return 'ProjectAnalytics(graphData: $graphData, labels: $labels, totalProjects: $totalProjects, totalEmployees: $totalEmployees, statusDistribution: $statusDistribution, additionalStats: $additionalStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectAnalyticsImpl &&
            const DeepCollectionEquality().equals(
              other._graphData,
              _graphData,
            ) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.totalProjects, totalProjects) ||
                other.totalProjects == totalProjects) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            const DeepCollectionEquality().equals(
              other._statusDistribution,
              _statusDistribution,
            ) &&
            const DeepCollectionEquality().equals(
              other._additionalStats,
              _additionalStats,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_graphData),
    const DeepCollectionEquality().hash(_labels),
    totalProjects,
    totalEmployees,
    const DeepCollectionEquality().hash(_statusDistribution),
    const DeepCollectionEquality().hash(_additionalStats),
  );

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectAnalyticsImplCopyWith<_$ProjectAnalyticsImpl> get copyWith =>
      __$$ProjectAnalyticsImplCopyWithImpl<_$ProjectAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectAnalyticsImplToJson(this);
  }
}

abstract class _ProjectAnalytics implements ProjectAnalytics {
  const factory _ProjectAnalytics({
    required final Map<String, List<double>> graphData,
    required final List<String> labels,
    required final int totalProjects,
    required final int totalEmployees,
    required final Map<String, double> statusDistribution,
    final Map<String, dynamic> additionalStats,
  }) = _$ProjectAnalyticsImpl;

  factory _ProjectAnalytics.fromJson(Map<String, dynamic> json) =
      _$ProjectAnalyticsImpl.fromJson;

  @override
  Map<String, List<double>> get graphData;
  @override
  List<String> get labels;
  @override
  int get totalProjects;
  @override
  int get totalEmployees;
  @override
  Map<String, double> get statusDistribution;
  @override
  Map<String, dynamic> get additionalStats;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectAnalyticsImplCopyWith<_$ProjectAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
