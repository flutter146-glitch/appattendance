// lib/features/analytics/domain/repositories/analytics_repository.dart
import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';

abstract class AnalyticsRepository {
  /// Period ke hisaab se aggregated analytics fetch karta hai
  Future<AnalyticsModel> getAnalytics({
    required String empId,
    required AnalyticsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Manager ke liye team analytics (team members ke saare stats)
  Future<AnalyticsModel> getTeamAnalytics({
    required String mgrEmpId,
    required AnalyticsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  });
}
