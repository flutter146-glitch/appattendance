// lib/core/services/sync_service.dart
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class SyncService {
  final DBHelper _db = DBHelper.instance;

  /// 🔥 A. Initial Sync - On First Login / App Launch
  Future<SyncResult> initialSync(String empId) async {
    try {
      debugPrint("🔄 Starting INITIAL SYNC for $empId...");

      // 1. Fetch Employee Master Data
      await syncEmployeeData(empId);

      // 2. Fetch Mapped Projects & Project Details
      await syncProjects(empId);

      // 3. Fetch Attendance Data (current + previous month)
      await syncAttendance(empId);

      // 4. Fetch Regularization Data
      await _fetchAndSaveRegularization(empId);

      // 5. Fetch Leave Data (when ready)
      await _fetchAndSaveLeaves(empId);

      debugPrint("✅ Initial sync completed successfully!");

      await _saveLastSyncTime();

      return SyncResult(
        success: true,
        message: "Initial sync completed",
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint("❌ Initial sync failed: $e");
      return SyncResult(
        success: false,
        message: "Initial sync failed: $e",
        timestamp: DateTime.now(),
      );
    }
  }

  /// 🔥 B. Manual Sync - "Sync Now" Button
  Future<SyncResult> manualSync(String empId) async {
    try {
      debugPrint("🔄 Starting MANUAL SYNC for $empId...");

      // Push pending local transactions first
      await _pushPendingTransactions(empId);

      // Pull latest data from server
      await syncEmployeeData(empId);
      await syncProjects(empId);
      await syncAttendance(empId);
      await _fetchAndSaveRegularization(empId);
      await _fetchAndSaveLeaves(empId);

      debugPrint("✅ Manual sync completed!");

      await _saveLastSyncTime();

      return SyncResult(
        success: true,
        message: "Sync completed successfully",
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint("❌ Manual sync failed: $e");
      return SyncResult(
        success: false,
        message: "Sync failed: $e",
        timestamp: DateTime.now(),
      );
    }
  }

  /// 🔥 C. Nightly Sync - Automatic Background
  Future<SyncResult> nightlySync(String empId) async {
    try {
      debugPrint("🌙 Starting NIGHTLY SYNC for $empId...");

      final lastSyncTime = await _getLastSyncTime();

      // Only fetch data changed since last sync
      await syncEmployeeData(empId);
      await syncProjects(empId);
      await syncAttendance(empId);
      await _fetchAndSaveRegularization(empId);
      await _fetchAndSaveLeaves(empId);

      // Cleanup old data
      await _cleanupOldData();

      await _saveLastSyncTime();

      debugPrint("✅ Nightly sync completed!");

      return SyncResult(
        success: true,
        message: "Background sync completed",
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint("❌ Nightly sync failed: $e");
      return SyncResult(
        success: false,
        message: "Background sync failed: $e",
        timestamp: DateTime.now(),
      );
    }
  }

  // ============================================
  // FETCH & SAVE METHODS
  // ============================================

  /// Fetch Employee Master Data
  Future<void> syncEmployeeData(String empId) async {
    try {
      debugPrint("🔄 Syncing employee data for $empId");

      final response = await ApiClient.get(
        ApiEndpoints.getEmployee(empId),
      );

      debugPrint("📦 Employee API response: ${response.toString()}");

      if (response['success'] == true && response['data'] != null) {
        final db = await _db.database;
        await db.insert(
          'employee_master',
          response['data'],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        debugPrint("✅ Employee data saved to DB");
      } else {
        debugPrint("⚠️ Employee API returned no data");
      }
    } catch (e) {
      debugPrint("❌ Employee sync failed: $e");
      rethrow;
    }
  }

  /// Fetch Mapped Projects & Full Project Details
  Future<void> syncProjects(String empId) async {
    try {
      debugPrint("🔄 Syncing projects for $empId");

      final response = await ApiClient.get(
        ApiEndpoints.getMappedProjects(empId),
      );

      debugPrint("📦 Mapped Projects API response: ${response.toString()}");

      if (response['success'] == true && response['data'] != null) {
        final db = await _db.database;
        final mappedProjects = response['data'] as List;

        debugPrint("📊 Found ${mappedProjects.length} mapped projects");

        // Clear old mappings first
        await db.transaction((txn) async {
          await txn.delete(
            'employee_mapped_projects',
            where: 'emp_id = ?',
            whereArgs: [empId],
          );

          for (var mapping in mappedProjects) {
            await txn.insert(
              'employee_mapped_projects',
              {
                'emp_id': empId,
                'project_id': mapping['project_id'],
                'mapping_status': 'active',
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        });

        // Fetch full project details for each mapped project
        final projectIds = mappedProjects
            .map((m) => m['project_id'] as String)
            .toList();

        debugPrint("🔄 Fetching details for ${projectIds.length} projects");

        for (var projectId in projectIds) {
          try {
            final projectRes = await ApiClient.get(
              ApiEndpoints.getProject(projectId),
            );

            if (projectRes['success'] == true && projectRes['data'] != null) {

              final projectData =
              Map<String, dynamic>.from(projectRes['data']);

              // ✅ STEP-5 FIX 1: ADD org_short_name (MANDATORY)
              projectData['org_short_name'] =
                  projectData['org_short_name'] ?? response['data'][0]['org_short_name'];

              // ✅ STEP-5 FIX 2: Convert project_site JSON → STRING
              if (projectData['project_site'] != null &&
                  projectData['project_site'] is Map) {
                projectData['project_site'] =
                    jsonEncode(projectData['project_site']);
              }

              await db.insert(
                'project_master',
                projectData,
                conflictAlgorithm: ConflictAlgorithm.replace,
              );

              debugPrint("✅ Project ${projectData['project_id']} saved");
            }

          } catch (e) {
            debugPrint("⚠️ Failed to fetch project $projectId: $e");
            // Continue with other projects
          }
        }

        debugPrint("✅ All projects synced");
      } else {
        debugPrint("⚠️ No mapped projects found for $empId");
      }
    } catch (e) {
      debugPrint("❌ Projects sync failed: $e");
      rethrow;
    }
  }

  /// Fetch Attendance Data (Current Month + Previous if needed)
  Future<void> syncAttendance(String empId) async {
    try {
      debugPrint("🔄 Syncing attendance for $empId");

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final previousMonth = DateTime(now.year, now.month - 1, 1);

      // Determine date range based on cut-off (5th)
      DateTime fromDate;
      if (now.day <= 5) {
        fromDate = previousMonth;
      } else {
        fromDate = firstDayOfMonth;
      }

      final toDate = now;

      debugPrint("📅 Fetching attendance from ${fromDate.toString().substring(0, 10)} to ${toDate.toString().substring(0, 10)}");

      final response = await ApiClient.get(
        ApiEndpoints.getAttendanceByDateRange(
          empId: empId,
          fromDate: fromDate.toString().substring(0, 10),
          toDate: toDate.toString().substring(0, 10),
        ),
      );

      debugPrint("📦 Attendance API response: ${response.toString()}");

      if (response['success'] == true && response['data'] != null) {
        final db = await _db.database;
        final records = (response['data'] is Map &&
            response['data']['data'] is List)
            ? response['data']['data'] as List
            : [];


        debugPrint("📊 Found ${records.length} attendance records");

        // ✅ FIX: Use att_timestamp instead of att_date for filtering
        // Clear old attendance in date range using timestamp
        await db.delete(
          'employee_attendance',
          where: 'emp_id = ? AND att_timestamp >= ? AND att_timestamp < ?',
          whereArgs: [
            empId,
            '${fromDate.toString().substring(0, 10)} 00:00:00',
            '${toDate.add(Duration(days: 1)).toString().substring(0, 10)} 00:00:00',
          ],
        );

        // Insert new attendance records
        for (var record in records) {
          // ✅ Ensure att_timestamp is present and valid
          if (record['att_timestamp'] != null) {
            await db.insert(
              'employee_attendance',
              {
                ...record,
                'is_synced': 1, // Mark as synced
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }

        debugPrint("✅ Saved ${records.length} attendance records");
      } else {
        debugPrint("⚠️ No attendance records found");
      }
    } catch (e) {
      debugPrint("❌ Attendance sync failed: $e");
      rethrow;
    }
  }

  /// Fetch Regularization Data
  Future<void> _fetchAndSaveRegularization(String empId) async {
    try {
      debugPrint("🔄 Syncing regularization for $empId");

      final response = await ApiClient.get(
        ApiEndpoints.getRegularization(empId),
      );

      debugPrint("📦 Regularization API response: ${response.toString()}");

      if (response['success'] == true && response['data'] != null) {
        final regList = response['data'] as List;

        if (regList.isEmpty) {
          debugPrint("⚠️ No regularization records found");
          return;
        }

        final db = await _db.database;

        // Clear old regularization
        await db.delete(
          'employee_regularization',
          where: 'emp_id = ?',
          whereArgs: [empId],
        );

        // Insert new regularization records
        for (var reg in regList) {
          await db.insert(
            'employee_regularization',
            reg,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        debugPrint("✅ Saved ${regList.length} regularization records");
      }
    } catch (e) {
      debugPrint("❌ Regularization sync failed: $e");
      // Don't rethrow - this is optional data
    }
  }

  /// Fetch Leave Data
  Future<void> _fetchAndSaveLeaves(String empId) async {
    try {
      debugPrint("🔄 Syncing leaves for $empId");

      final response = await ApiClient.get(
        ApiEndpoints.getLeaveByEmpId(empId),
      );

      debugPrint("📦 Leave API response: ${response.toString()}");

      if (response['success'] == true && response['data'] != null) {
        final leaveList = response['data'] as List;

        if (leaveList.isEmpty) {
          debugPrint("⚠️ No leave records found");
          return;
        }

        final db = await _db.database;

        // Clear old leaves
        await db.delete(
          'employee_leaves',
          where: 'emp_id = ?',
          whereArgs: [empId],
        );

        // Insert new leave records
        for (var leave in leaveList) {
          await db.insert(
            'employee_leaves',
            leave,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        debugPrint("✅ Saved ${leaveList.length} leave records");
      }
    } catch (e) {
      debugPrint("❌ Leave sync failed: $e");
      // Don't rethrow - leave API might not be ready
    }
  }

  // ============================================
  // PUSH PENDING TRANSACTIONS
  // ============================================

  Future<void> _pushPendingTransactions(String empId) async {
    try {
      debugPrint("📤 Pushing pending transactions for $empId...");

      final db = await _db.database;

      // 1. Push pending attendance
      final pendingAtt = await db.query(
        'employee_attendance',
        where: 'emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
        whereArgs: [empId],
      );

      for (var att in pendingAtt) {
        try {
          await ApiClient.post(ApiEndpoints.attendance, att);

          // Mark as synced
          await db.update(
            'employee_attendance',
            {'is_synced': 1},
            where: 'att_id = ?',
            whereArgs: [att['att_id']],
          );
        } catch (e) {
          debugPrint("⚠️ Failed to push attendance ${att['att_id']}: $e");
        }
      }

      // 2. Push pending regularization
      final pendingReg = await db.query(
        'employee_regularization',
        where: 'emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
        whereArgs: [empId],
      );

      for (var reg in pendingReg) {
        try {
          await ApiClient.post(ApiEndpoints.regularization, reg);

          // Mark as synced
          await db.update(
            'employee_regularization',
            {'is_synced': 1},
            where: 'reg_id = ?',
            whereArgs: [reg['reg_id']],
          );
        } catch (e) {
          debugPrint("⚠️ Failed to push regularization ${reg['reg_id']}: $e");
        }
      }

      debugPrint("✅ Pending transactions pushed");
    } catch (e) {
      debugPrint("⚠️ Push pending transactions failed: $e");
    }
  }

  // ============================================
  // DATA CLEANUP
  // ============================================

  Future<void> _cleanupOldData() async {
    try {
      final db = await _db.database;
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
      final cutoffString = cutoffDate.toString().substring(0, 10);

      // Remove attendance older than 3 months
      await db.delete(
        'employee_attendance',
        where: 'att_date < ?',
        whereArgs: [cutoffString],
      );

      // Remove regularization older than 3 months
      await db.delete(
        'employee_regularization',
        where: 'reg_date_applied < ?',
        whereArgs: [cutoffString],
      );

      debugPrint("✅ Old data cleaned up (>90 days)");
    } catch (e) {
      debugPrint("⚠️ Cleanup failed: $e");
    }
  }

  // ============================================
  // SYNC TIME MANAGEMENT
  // ============================================

  Future<void> _saveLastSyncTime() async {
    final db = await _db.database;
    await db.insert(
      'sync_metadata',
      {
        'key': 'last_sync_time',
        'value': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> _getLastSyncTime() async {
    try {
      final db = await _db.database;
      final result = await db.query(
        'sync_metadata',
        where: 'key = ?',
        whereArgs: ['last_sync_time'],
      );

      if (result.isNotEmpty) {
        return result.first['value'] as String;
      }
    } catch (e) {
      debugPrint("⚠️ Could not get last sync time: $e");
    }
    return null;
  }
}

/// Result class for sync operations
class SyncResult {
  final bool success;
  final String message;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    required this.message,
    required this.timestamp,
  });
}