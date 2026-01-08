// lib/features/leave/domain/repositories/leave_repository.dart
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';

abstract class LeaveRepository {
  /// Employee ke saare leaves
  Future<List<LeaveModel>> getLeavesByEmployee(String empId);

  // In LeaveRepository (abstract):
  Future<List<LeaveModel>> getAllLeavesForManager(String mgrEmpId);

  /// Manager ke pending leaves
  Future<List<LeaveModel>> getPendingLeavesForManager(String mgrEmpId);

  // Future<List<LeaveModel>> getAllLeavesForManager(String mgrEmpId);

  /// Apply new leave
  Future<void> applyLeave(LeaveModel leave);

  /// Update status (approve/reject/cancel)
  Future<void> updateLeaveStatus({
    required String leaveId,
    required LeaveStatus newStatus,
    String? managerComments,
  });

  /// Pending count (dashboard ke liye)
  Future<int> getPendingLeavesCount(String mgrEmpId);
}

// // lib/features/leave/domain/repositories/leave_repository.dart
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';

// abstract class LeaveRepository {
//   /// Employee ke saare leaves (all statuses)
//   Future<List<LeaveModel>> getLeavesByEmployee(String empId);

//   /// Manager ke pending leaves (for approval)
//   Future<List<LeaveModel>> getPendingLeavesForManager(String mgrEmpId);

//   /// New leave apply
//   Future<void> applyLeave(LeaveModel leave);

//   /// Approve/Reject/Cancel leave
//   Future<void> updateLeaveStatus({
//     required String leaveId,
//     required LeaveStatus newStatus,
//     String? managerComments,
//   });

//   /// Pending leaves count (for dashboard)
//   Future<int> getPendingLeavesCount(String mgrEmpId);
// }
