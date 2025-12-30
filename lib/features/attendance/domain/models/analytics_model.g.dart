// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsModelImpl _$$AnalyticsModelImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsModelImpl(
      period: $enumDecode(_$AnalyticsPeriodEnumMap, json['period']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalDays: (json['totalDays'] as num).toInt(),
      presentDays: (json['presentDays'] as num).toInt(),
      absentDays: (json['absentDays'] as num).toInt(),
      leaveDays: (json['leaveDays'] as num).toInt(),
      lateDays: (json['lateDays'] as num).toInt(),
      onTimeDays: (json['onTimeDays'] as num).toInt(),
      dailyAvgHours: (json['dailyAvgHours'] as num).toDouble(),
      monthlyAvgHours: (json['monthlyAvgHours'] as num).toDouble(),
      pendingRegularisations:
          (json['pendingRegularisations'] as num?)?.toInt() ?? 0,
      pendingLeaves: (json['pendingLeaves'] as num?)?.toInt() ?? 0,
      periodTitle: json['periodTitle'] as String?,
    );

Map<String, dynamic> _$$AnalyticsModelImplToJson(
  _$AnalyticsModelImpl instance,
) => <String, dynamic>{
  'period': _$AnalyticsPeriodEnumMap[instance.period]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'totalDays': instance.totalDays,
  'presentDays': instance.presentDays,
  'absentDays': instance.absentDays,
  'leaveDays': instance.leaveDays,
  'lateDays': instance.lateDays,
  'onTimeDays': instance.onTimeDays,
  'dailyAvgHours': instance.dailyAvgHours,
  'monthlyAvgHours': instance.monthlyAvgHours,
  'pendingRegularisations': instance.pendingRegularisations,
  'pendingLeaves': instance.pendingLeaves,
  'periodTitle': instance.periodTitle,
};

const _$AnalyticsPeriodEnumMap = {
  AnalyticsPeriod.daily: 'daily',
  AnalyticsPeriod.weekly: 'weekly',
  AnalyticsPeriod.monthly: 'monthly',
  AnalyticsPeriod.quarterly: 'quarterly',
};
