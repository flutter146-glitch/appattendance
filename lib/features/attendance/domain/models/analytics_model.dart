// lib/features/attendance/domain/models/analytics_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

enum AnalyticsMode { daily, weekly, monthly, quarterly }

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required int present,
    required int absent,
    required int late,
    required int halfDay,
    required double avgHours,
    DateTime? start,
    DateTime? end,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}
