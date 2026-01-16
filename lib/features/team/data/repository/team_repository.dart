// lib/features/team/domain/repositories/team_repository.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';

abstract class TeamRepository {
  Future<List<TeamMember>> getTeamMembers(String managerEmpId);

  Future<TeamMember?> getTeamMemberDetails(String empId, {int recentDays = 30});

  Future<List<TeamMember>> searchTeamMembers(String managerEmpId, String query);
}
