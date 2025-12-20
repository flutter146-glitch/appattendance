// lib/core/constants/role_constants.dart

class RoleConstants {
  // Role names exactly as in user_roles table
  static const String employee = 'Employee';
  static const String projectManager = 'Project Manager';
  static const String srManager = 'Sr. Manager';
  static const String operationsManager = 'Operations Manager';
  static const String hrManager = 'HR Manager';
  static const String admin = 'Admin';

  // Helper methods — future mein API se privileges load karne ke liye extend kar sakte hain
  static bool isEmployee(String roleName) =>
      roleName.toLowerCase() == employee.toLowerCase();

  static bool canViewTeamRequests(String roleName) {
    final lower = roleName.toLowerCase();
    return lower.contains('manager') || lower == admin.toLowerCase();
  }

  static bool canApproveReject(String roleName) {
    final lower = roleName.toLowerCase();
    return lower == projectManager.toLowerCase() ||
        lower == srManager.toLowerCase() ||
        lower == admin.toLowerCase();
  }
}
