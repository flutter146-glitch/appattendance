// lib/features/project/domain/repositories/project_repository.dart
// UPGRADED & ROBUST VERSION - January 09, 2026
// Improvements: DartDoc comments, optional params, better typing, future-proof
// Still 100% backward compatible - no breaking changes

import 'package:appattendance/features/projects/domain/models/project_model.dart';

/// Repository contract for project-related operations.
/// Handles both employee-mapped projects and manager team projects.
/// All methods are null-safe and throw exceptions on failure.
abstract class ProjectRepository {
  /// Fetches all **active** projects mapped to the given employee.
  /// Returns empty list if no mappings found.
  Future<List<MappedProject>> getMappedProjects(String empId);

  /// Fetches all **unique active** projects assigned to the team of the given manager.
  /// Uses reporting hierarchy to find team members, then their project mappings.
  /// Returns empty list if manager has no team or no projects.
  Future<List<ProjectModel>> getTeamProjects(String mgrEmpId);

  /// Fetches complete details of a single project by its ID.
  /// Returns null if project not found or inactive.
  Future<ProjectModel?> getProjectById(String projectId);

  // ── Optional Future-Proof Methods (uncomment when needed) ────────────────

  /*
  /// Fetches mapped projects with optional filters (e.g., status, date range)
  Future<List<MappedProject>> getMappedProjectsFiltered(
    String empId, {
    String? status = 'active',
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
    int offset = 0,
  });

  /// Stream of project updates for real-time listening (Firebase/Supabase ready)
  Stream<List<ProjectModel>> watchTeamProjects(String mgrEmpId);
  */
}
