// lib/core/services/realtime_api_service.dart
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

/// 🔥 Real-time API Service - Immediate Server Calls
/// These don't wait for sync - they push data immediately
class RealtimeApiService {
  final DBHelper _db = DBHelper.instance;

  // ============================================
  // ATTENDANCE CHECK-IN / CHECK-OUT
  // ============================================

  /// Check-in
  Future<Map<String, dynamic>> checkIn({
    required String empId,
    required double latitude,
    required double longitude,
    String? projectId,
    String? geofenceName,
    String? notes,
  }) async {
    try {
      debugPrint("🔵 Sending check-in to server...");

      final requestBody = {
        "emp_id": empId,
        "att_status": "checkin",
        "att_latitude": latitude,
        "att_longitude": longitude,
        "att_timestamp": DateTime.now().toIso8601String(),
        "att_date": DateTime.now().toString().substring(0, 10),
        "att_project_id": projectId,
        "att_geofence_name": geofenceName,
        "att_notes": notes,
        "verification_type": "GPS",
      };

      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        requestBody,
      );

      debugPrint("✅ Check-in successful: ${response['data']}");

      // Save to local DB
      final attendanceData = response['data'];
      if (attendanceData != null) {
        final db = await _db.database;
        await db.insert(
          'employee_attendance',
          {
            ...attendanceData,
            'is_synced': 1, // Mark as synced
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return {
        'success': true,
        'message': 'Check-in successful',
        'data': attendanceData,
      };
    } catch (e) {
      debugPrint("❌ Check-in failed: $e");

      // Save locally with pending status
      await _savePendingAttendance(
        empId: empId,
        status: 'checkin',
        latitude: latitude,
        longitude: longitude,
        projectId: projectId,
        geofenceName: geofenceName,
        notes: notes,
      );

      return {
        'success': false,
        'message': 'Check-in saved locally. Will sync later.',
        'error': e.toString(),
      };
    }
  }

  /// Check-out
  Future<Map<String, dynamic>> checkOut({
    required String empId,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      debugPrint("🔴 Sending check-out to server...");

      final requestBody = {
        "emp_id": empId,
        "att_status": "checkout",
        "att_latitude": latitude,
        "att_longitude": longitude,
        "att_timestamp": DateTime.now().toIso8601String(),
        "att_date": DateTime.now().toString().substring(0, 10),
        "att_notes": notes,
        "verification_type": "GPS",
      };

      final response = await ApiClient.post(
        ApiEndpoints.attendance,
        requestBody,
      );

      debugPrint("✅ Check-out successful: ${response['data']}");

      // Save to local DB
      final attendanceData = response['data'];
      if (attendanceData != null) {
        final db = await _db.database;
        await db.insert(
          'employee_attendance',
          {
            ...attendanceData,
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return {
        'success': true,
        'message': 'Check-out successful',
        'data': attendanceData,
      };
    } catch (e) {
      debugPrint("❌ Check-out failed: $e");

      // Save locally with pending status
      await _savePendingAttendance(
        empId: empId,
        status: 'checkout',
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      );

      return {
        'success': false,
        'message': 'Check-out saved locally. Will sync later.',
        'error': e.toString(),
      };
    }
  }

  /// Save pending attendance (offline mode)
  Future<void> _savePendingAttendance({
    required String empId,
    required String status,
    required double latitude,
    required double longitude,
    String? projectId,
    String? geofenceName,
    String? notes,
  }) async {
    final db = await _db.database;
    final timestamp = DateTime.now();

    await db.insert(
      'employee_attendance',
      {
        'att_id': 'PENDING_${timestamp.millisecondsSinceEpoch}',
        'emp_id': empId,
        'att_date': timestamp.toString().substring(0, 10),
        'att_timestamp': timestamp.toIso8601String(),
        'att_latitude': latitude,
        'att_longitude': longitude,
        'att_geofence_name': geofenceName,
        'att_project_id': projectId,
        'att_notes': notes,
        'att_status': status,
        'verification_type': 'GPS',
        'is_verified': 0,
        'is_synced': 0, // Mark as pending
        'created_at': timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint("💾 Attendance saved locally (pending sync)");
  }

  // ============================================
  // REGULARIZATION
  // ============================================

  /// Submit Regularization Request
  Future<Map<String, dynamic>> submitRegularization({
    required String empId,
    required String appliedForDate,
    required String regType,
    required String justification,
    String? checkinTime,
    String? checkoutTime,
    String? shortfallTime,
  }) async {
    try {
      debugPrint("📝 Submitting regularization request...");

      final requestBody = {
        "emp_id": empId,
        "reg_applied_for_date": appliedForDate,
        "reg_date_applied": DateTime.now().toString().substring(0, 10),
        "reg_type": regType,
        "reg_justification": justification,
        "checkin_time": checkinTime,
        "checkout_time": checkoutTime,
        "shortfall_time": shortfallTime,
        "reg_approval_status": "pending",
        "created_at": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String(),
      };

      final response = await ApiClient.post(
        "${ApiEndpoints.baseUrl}/regularization",
        requestBody,
      );

      debugPrint("✅ Regularization submitted: ${response['data']}");

      // Save to local DB
      final regData = response['data'];
      if (regData != null) {
        final db = await _db.database;
        await db.insert(
          'employee_regularization',
          {
            ...regData,
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return {
        'success': true,
        'message': 'Regularization request submitted',
        'data': regData,
      };
    } catch (e) {
      debugPrint("❌ Regularization failed: $e");

      // Save locally with pending status
      await _savePendingRegularization(
        empId: empId,
        appliedForDate: appliedForDate,
        regType: regType,
        justification: justification,
        checkinTime: checkinTime,
        checkoutTime: checkoutTime,
        shortfallTime: shortfallTime,
      );

      return {
        'success': false,
        'message': 'Request saved locally. Will sync later.',
        'error': e.toString(),
      };
    }
  }

  /// Save pending regularization (offline mode)
  Future<void> _savePendingRegularization({
    required String empId,
    required String appliedForDate,
    required String regType,
    required String justification,
    String? checkinTime,
    String? checkoutTime,
    String? shortfallTime,
  }) async {
    final db = await _db.database;
    final timestamp = DateTime.now();

    await db.insert(
      'employee_regularization',
      {
        'reg_id': 'PENDING_${timestamp.millisecondsSinceEpoch}',
        'emp_id': empId,
        'reg_applied_for_date': appliedForDate,
        'reg_date_applied': timestamp.toString().substring(0, 10),
        'reg_type': regType,
        'reg_justification': justification,
        'checkin_time': checkinTime,
        'checkout_time': checkoutTime,
        'shortfall_time': shortfallTime,
        'reg_approval_status': 'pending',
        'is_synced': 0, // Mark as pending
        'created_at': timestamp.toIso8601String(),
        'updated_at': timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint("💾 Regularization saved locally (pending sync)");
  }

  // ============================================
  // LEAVE APPLICATION
  // ============================================

  /// Apply Leave
  Future<Map<String, dynamic>> applyLeave({
    required String empId,
    required String leaveFromDate,
    required String leaveToDate,
    required String leaveType,
    required String justification,
  }) async {
    try {
      debugPrint("🏖️ Submitting leave application...");

      final requestBody = {
        "emp_id": empId,
        "leave_from_date": leaveFromDate,
        "leave_to_date": leaveToDate,
        "leave_type": leaveType,
        "leave_justification": justification,
        "leave_approval_status": "pending",
        "applied_at": DateTime.now().toIso8601String(),
      };

      final response = await ApiClient.post(
        "${ApiEndpoints.baseUrl}/leave",
        requestBody,
      );

      debugPrint("✅ Leave applied: ${response['data']}");

      // Save to local DB
      final leaveData = response['data'];
      if (leaveData != null) {
        final db = await _db.database;
        await db.insert(
          'employee_leaves',
          {
            ...leaveData,
            'is_synced': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return {
        'success': true,
        'message': 'Leave application submitted',
        'data': leaveData,
      };
    } catch (e) {
      debugPrint("❌ Leave application failed: $e");

      // Save locally with pending status
      await _savePendingLeave(
        empId: empId,
        leaveFromDate: leaveFromDate,
        leaveToDate: leaveToDate,
        leaveType: leaveType,
        justification: justification,
      );

      return {
        'success': false,
        'message': 'Leave saved locally. Will sync later.',
        'error': e.toString(),
      };
    }
  }

  /// Save pending leave (offline mode)
  Future<void> _savePendingLeave({
    required String empId,
    required String leaveFromDate,
    required String leaveToDate,
    required String leaveType,
    required String justification,
  }) async {
    final db = await _db.database;
    final timestamp = DateTime.now();

    await db.insert(
      'employee_leaves',
      {
        'leave_id': 'PENDING_${timestamp.millisecondsSinceEpoch}',
        'emp_id': empId,
        'leave_from_date': leaveFromDate,
        'leave_to_date': leaveToDate,
        'leave_type': leaveType,
        'leave_justification': justification,
        'leave_approval_status': 'pending',
        'is_synced': 0, // Mark as pending
        'applied_at': timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint("💾 Leave saved locally (pending sync)");
  }

  // ============================================
  // GET PENDING TRANSACTIONS
  // ============================================

  Future<Map<String, List<Map<String, dynamic>>>> getPendingTransactions(
      String empId,
      ) async {
    final db = await _db.database;

    final pendingAttendance = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
      whereArgs: [empId],
    );

    final pendingReg = await db.query(
      'employee_regularization',
      where: 'emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
      whereArgs: [empId],
    );

    final pendingLeaves = await db.query(
      'employee_leaves',
      where: 'emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
      whereArgs: [empId],
    );

    return {
      'attendance': pendingAttendance,
      'regularization': pendingReg,
      'leaves': pendingLeaves,
    };
  }
}