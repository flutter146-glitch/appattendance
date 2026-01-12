// lib/features/team/domain/repositories/team_repository.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';

abstract class TeamRepository {
  /// Manager ke under saare team members fetch karega
  Future<List<TeamMember>> getTeamMembers(String managerEmpId);

  /// Single team member ka full detail with recent attendance
  Future<TeamMember?> getTeamMemberDetails(String empId, {int recentDays = 30});

  /// Team members ko name, email ya designation se search
  Future<List<TeamMember>> searchTeamMembers(String managerEmpId, String query);
}
