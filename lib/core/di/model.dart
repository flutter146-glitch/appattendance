//  Future<UserModel?> getUserByEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     final db = await database;

//     try {
//       // 1. Check in user table
//       final userRows = await db.query(
//         'user',
//         where: 'email_id = ? AND password = ?',
//         whereArgs: [email.trim().toLowerCase(), password],
//       );

//       if (userRows.isEmpty) return null;

//       final userRow = userRows.first;
//       final empId = userRow['emp_id'] as String;

//       // 2. Get employee details
//       final empRows = await db.query(
//         'employee_master',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//       );

//       if (empRows.isEmpty) return null;

//       final empRow = empRows.first;

//       // 3. Create UserModel
//       return userFromDB(userRow, empRow);
//     } catch (e) {
//       print('Error in getUserByEmailAndPassword: $e');
//       return null;
//     }
//   }

//   /// Save logged in user session (updated for UserModel)
//   Future<void> saveCurrentUser(UserModel user, [String? token]) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user.toJson()),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get logged in user (returns UserModel)
//   Future<UserModel?> getCurrentUser() async {
//     final db = await database;
//     final result = await db.query(
//       'current_user',
//       where: 'id = ?',
//       whereArgs: [1],
//     );

//     if (result.isEmpty) return null;

//     try {
//       final data = jsonDecode(result.first['user_data'] as String) 
//           as Map<String, dynamic>;
//       return UserModel.fromJson(data);
//     } catch (e) {
//       print('Error parsing current user: $e');
//       return null;
//     }
//   }

//   /// Get user by employee ID
//   Future<UserModel?> getUserByEmpId(String empId) async {
//     final db = await database;

//     try {
//       final userRows = await db.query(
//         'user',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//       );

//       if (userRows.isEmpty) return null;

//       final userRow = userRows.first;

//       final empRows = await db.query(
//         'employee_master',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//       );

//       if (empRows.isEmpty) return null;

//       final empRow = empRows.first;

//       return userFromDB(userRow, empRow);
//     } catch (e) {
//       print('Error in getUserByEmpId: $e');
//       return null;
//     }
//   }

//   /// Get all users (for managers/admin)
//   Future<List<UserModel>> getAllUsers() async {
//     final db = await database;
//     final List<UserModel> users = [];

//     try {
//       final userRows = await db.query('user');
      
//       for (final userRow in userRows) {
//         final empId = userRow['emp_id'] as String;
//         final empRows = await db.query(
//           'employee_master',
//           where: 'emp_id = ?',
//           whereArgs: [empId],
//         );

//         if (empRows.isNotEmpty) {
//           users.add(userFromDB(userRow, empRows.first));
//         }
//       }

//       return users;
//     } catch (e) {
//       print('Error in getAllUsers: $e');
//       return [];
//     }
//   }

//   /// Get team members for a manager
//   Future<List<UserModel>> getTeamMembers(String managerEmpId) async {
//     final db = await database;
//     final List<UserModel> teamMembers = [];

//     try {
//       // First get manager's department
//       final manager = await getUserByEmpId(managerEmpId);
//       if (manager == null || manager.department == null) return [];

//       // Get all users in same department except manager
//       final allUsers = await getAllUsers();
      
//       for (final user in allUsers) {
//         if (user.empId != managerEmpId && 
//             user.department == manager.department &&
//             user.isActive) {
//           teamMembers.add(user);
//         }
//       }

//       return teamMembers;
//     } catch (e) {
//       print('Error in getTeamMembers: $e');
//       return [];
//     }
//   }

//   // ==================== ATTENDANCE METHODS ====================

//   /// Save attendance record
//   Future<bool> saveAttendance({
//     required String empId,
//     required DateTime timestamp,
//     required AttendanceStatus status,
//     double? latitude,
//     double? longitude,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//     String verificationType = 'manual',
//   }) async {
//     final db = await database;

//     try {
//       // Generate attendance ID
//       final attId = 'ATT_${empId}_${timestamp.millisecondsSinceEpoch}';

//       await db.insert('employee_attendance', {
//         'att_id': attId,
//         'emp_id': empId,
//         'att_timestamp': timestamp.toIso8601String(),
//         'att_latitude': latitude,
//         'att_longitude': longitude,
//         'att_geofence_name': geofenceName,
//         'project_id': projectId,
//         'att_notes': notes,
//         'att_status': status.name,
//         'verification_type': verificationType,
//         'is_verified': 1,
//         'created_at': DateTime.now().toIso8601String(),
//         'updated_at': DateTime.now().toIso8601String(),
//       });

//       return true;
//     } catch (e) {
//       print('Error saving attendance: $e');
//       return false;
//     }
//   }

//   /// Get user's attendance records
//   Future<List<Map<String, dynamic>>> getUserAttendance(
//     String empId, {
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final db = await database;

//     try {
//       String whereClause = 'emp_id = ?';
//       List<Object?> whereArgs = [empId];

//       if (startDate != null && endDate != null) {
//         whereClause += ' AND att_timestamp BETWEEN ? AND ?';
//         whereArgs.add(startDate.toIso8601String());
//         whereArgs.add(endDate.toIso8601String());
//       }

//       return await db.query(
//         'employee_attendance',
//         where: whereClause,
//         whereArgs: whereArgs,
//         orderBy: 'att_timestamp DESC',
//       );
//     } catch (e) {
//       print('Error getting user attendance: $e');
//       return [];
//     }
//   }

//   // ==================== LEAVE METHODS ====================

//   /// Apply for leave
//   Future<bool> applyLeave({
//     required String empId,
//     required DateTime fromDate,
//     required DateTime toDate,
//     required String leaveType,
//     required String justification,
//     required String managerEmpId,
//   }) async {
//     final db = await database;

//     try {
//       final leaveId = 'LEAVE_${empId}_${DateTime.now().millisecondsSinceEpoch}';

//       await db.insert('employee_leaves', {
//         'leave_id': leaveId,
//         'emp_id': empId,
//         'mgr_emp_id': managerEmpId,
//         'leave_from_date': fromDate.toIso8601String(),
//         'leave_to_date': toDate.toIso8601String(),
//         'leave_type': leaveType,
//         'leave_justification': justification,
//         'leave_approval_status': 'pending',
//         'created_at': DateTime.now().toIso8601String(),
//         'updated_at': DateTime.now().toIso8601String(),
//       });

//       return true;
//     } catch (e) {
//       print('Error applying leave: $e');
//       return false;
//     }
//   }

//   /// Get user's leaves
//   Future<List<Map<String, dynamic>>> getUserLeaves(String empId) async {
//     final db = await database;

//     try {
//       return await db.query(
//         'employee_leaves',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//         orderBy: 'leave_from_date DESC',
//       );
//     } catch (e) {
//       print('Error getting user leaves: $e');
//       return [];
//     }
//   }

//   /// Get pending leaves for approval (for managers)
//   Future<List<Map<String, dynamic>>> getPendingLeavesForApproval(
//     String managerEmpId,
//   ) async {
//     final db = await database;

//     try {
//       return await db.query(
//         'employee_leaves',
//         where: 'mgr_emp_id = ? AND leave_approval_status = ?',
//         whereArgs: [managerEmpId, 'pending'],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e) {
//       print('Error getting pending leaves: $e');
//       return [];
//     }
//   }

//   // ==================== REGULARIZATION METHODS ====================

//   /// Apply for regularization
//   Future<bool> applyRegularization({
//     required String empId,
//     required DateTime appliedForDate,
//     required String justification,
//     required String firstCheckIn,
//     required String lastCheckOut,
//     required String shortfallHrs,
//     required String managerEmpId,
//   }) async {
//     final db = await database;

//     try {
//       final regId = 'REG_${empId}_${DateTime.now().millisecondsSinceEpoch}';

//       await db.insert('employee_regularization', {
//         'reg_id': regId,
//         'emp_id': empId,
//         'mgr_emp_id': managerEmpId,
//         'reg_date_applied': DateTime.now().toIso8601String(),
//         'reg_applied_for_date': appliedForDate.toIso8601String(),
//         'reg_justification': justification,
//         'reg_first_check_in': firstCheckIn,
//         'reg_last_check_out': lastCheckOut,
//         'shortfall_hrs': shortfallHrs,
//         'reg_approval_status': 'pending',
//         'created_at': DateTime.now().toIso8601String(),
//         'updated_at': DateTime.now().toIso8601String(),
//       });

//       return true;
//     } catch (e) {
//       print('Error applying regularization: $e');
//       return false;
//     }
//   }

//   /// Get user's regularization requests
//   Future<List<Map<String, dynamic>>> getUserRegularizations(
//     String empId,
//   ) async {
//     final db = await database;

//     try {
//       return await db.query(
//         'employee_regularization',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//         orderBy: 'reg_date_applied DESC',
//       );
//     } catch (e) {
//       print('Error getting user regularizations: $e');
//       return [];
//     }
//   }

//   /// Get pending regularizations for approval (for managers)
//   Future<List<Map<String, dynamic>>> getPendingRegularizationsForApproval(
//     String managerEmpId,
//   ) async {
//     final db = await database;

//     try {
//       return await db.query(
//         'employee_regularization',
//         where: 'mgr_emp_id = ? AND reg_approval_status = ?',
//         whereArgs: [managerEmpId, 'pending'],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e) {
//       print('Error getting pending regularizations: $e');
//       return [];
//     }
//   }

//   // ==================== PROJECT METHODS ====================

//   /// Get user's assigned projects
//   Future<List<Map<String, dynamic>>> getUserProjects(String empId) async {
//     final db = await database;

//     try {
//       return await db.query(
//         'employee_mapped_projects',
//         where: 'emp_id = ? AND mapping_status = ?',
//         whereArgs: [empId, 'active'],
//       );
//     } catch (e) {
//       print('Error getting user projects: $e');
//       return [];
//     }
//   }

//   /// Get all projects
//   Future<List<Map<String, dynamic>>> getAllProjects() async {
//     final db = await database;

//     try {
//       return await db.query('project_master');
//     } catch (e) {
//       print('Error getting all projects: $e');
//       return [];
//     }
//   }
// }