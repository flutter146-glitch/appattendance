// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      present: (json['present'] as num).toInt(),
      absent: (json['absent'] as num).toInt(),
      late: (json['late'] as num).toInt(),
      halfDay: (json['halfDay'] as num).toInt(),
      avgHours: (json['avgHours'] as num).toDouble(),
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'present': instance.present,
      'absent': instance.absent,
      'late': instance.late,
      'halfDay': instance.halfDay,
      'avgHours': instance.avgHours,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };
