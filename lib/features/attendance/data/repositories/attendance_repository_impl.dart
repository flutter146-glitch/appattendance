import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/attendance/data/repositories/attendance_repository.dart';
import 'package:appattendance/features/attendance/data/services/offline_attendance_service.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:dio/dio.dart'; // Future API
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // For unique att_id

class AttendanceRepositoryImpl implements AttendanceRepository {
  final DBHelper dbHelper;
  final Uuid uuid = const Uuid();

  AttendanceRepositoryImpl(this.dbHelper); // Positional argument required

  @override
  Future<void> checkIn({
    required String empId,
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
    String? photoProofPath,
    bool offlineQueue = false,
  }) async {
    if (offlineQueue) {
      final att = AttendanceModel(
        attId: uuid.v4(),
        empId: empId,
        timestamp: DateTime.now(),
        attendanceDate: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        geofenceName: geofenceName,
        projectId: projectId,
        notes: notes,
        status: AttendanceStatus.checkIn,
        verificationType: verificationType,
        isVerified: true,
        photoProofPath: photoProofPath,
      );
      @override
      Future<void> syncOfflineQueue(WidgetRef widgetRef) async {
        await OfflineAttendanceService().syncQueue(widgetRef);
      }

      return;
    }

    final db = await dbHelper.database;
    final attId = uuid.v4();
    final timestamp = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(timestamp);

    await db.insert('employee_attendance', {
      'att_id': attId,
      'emp_id': empId,
      'att_timestamp': timestamp.toIso8601String(),
      'att_date': today,
      'att_latitude': latitude,
      'att_longitude': longitude,
      'att_geofence_name': geofenceName,
      'project_id': projectId,
      'att_notes': notes,
      'att_status': 'checkIn',
      'verification_type': verificationType.name,
      'is_verified': 1,
      'photo_proof_path': photoProofPath,
      'created_at': timestamp.toIso8601String(),
      'updated_at': timestamp.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> checkOut({
    required String empId,
    required double latitude,
    required double longitude,
    required VerificationType verificationType,
    String? geofenceName,
    String? projectId,
    String? notes,
    bool offlineQueue = false,
  }) async {
    if (offlineQueue) {
      final att = AttendanceModel(
        attId: uuid.v4(),
        empId: empId,
        timestamp: DateTime.now(),
        attendanceDate: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        geofenceName: geofenceName,
        projectId: projectId,
        notes: notes,
        status: AttendanceStatus.checkOut,
        verificationType: verificationType,
        isVerified: true,
      );
      await OfflineAttendanceService().queueCheckIn(att); // Reuse queue
      return;
    }

    final db = await dbHelper.database;
    final attId = uuid.v4();
    final timestamp = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(timestamp);

    final checkIn = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND att_date = ? AND att_status = ?',
      whereArgs: [empId, today, 'checkIn'],
      orderBy: 'att_timestamp DESC',
      limit: 1,
    );

    if (checkIn.isEmpty) {
      throw Exception('No check-in found for today');
    }

    await db.insert('employee_attendance', {
      'att_id': attId,
      'emp_id': empId,
      'att_timestamp': timestamp.toIso8601String(),
      'att_date': today,
      'att_latitude': latitude,
      'att_longitude': longitude,
      'att_geofence_name': geofenceName,
      'project_id': projectId,
      'att_notes': notes,
      'att_status': 'checkOut',
      'verification_type': verificationType.name,
      'is_verified': 1,
      'created_at': timestamp.toIso8601String(),
      'updated_at': timestamp.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<AttendanceModel>> getTodayAttendance(String empId) async {
    final db = await dbHelper.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final rows = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND att_date = ?',
      whereArgs: [empId, today],
      orderBy: 'att_timestamp ASC',
    );

    return rows.map(attendanceFromDB).toList();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory(
    String empId,
    DateTime start,
    DateTime end,
  ) async {
    final db = await dbHelper.database;
    final startStr = DateFormat('yyyy-MM-dd').format(start);
    final endStr = DateFormat('yyyy-MM-dd').format(end);

    final rows = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND att_date BETWEEN ? AND ?',
      whereArgs: [empId, startStr, endStr],
      orderBy: 'att_date ASC, att_timestamp ASC',
    );

    return rows.map(attendanceFromDB).toList();
  }

  @override
  Future<Map<String, dynamic>> getTodayStatusSummary(String empId) async {
    final db = await dbHelper.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final rows = await db.query(
      'attendance_analytics',
      where: 'emp_id = ? AND att_date = ?',
      whereArgs: [empId, today],
    );

    if (rows.isEmpty) {
      return {
        'status': 'Not Checked In',
        'first_checkin': null,
        'last_checkout': null,
        'worked_hrs': 0.0,
        'shortfall_hrs': 9.0,
        'on_time': false,
        'late': false,
      };
    }

    final row = rows.first;
    return {
      'status': row['att_type'] as String,
      'first_checkin': row['first_checkin'] as String?,
      'last_checkout': row['last_checkout'] as String?,
      'worked_hrs': row['worked_hrs'] as double? ?? 0.0,
      'shortfall_hrs': row['shortfall_hrs'] as double? ?? 0.0,
      'on_time': (row['on_time'] as int? ?? 0) == 1,
      'late': (row['late'] as int? ?? 0) == 1,
    };
  }

  @override
  Future<List<AttendanceModel>> getTeamAttendance(
    String mgrEmpId,
    DateTime date,
  ) async {
    final db = await dbHelper.database;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final teamMembers = await db.query(
      'employee_master',
      where: 'reporting_manager_id = ?',
      whereArgs: [mgrEmpId],
    );

    if (teamMembers.isEmpty) return [];

    final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

    final rows = await db.query(
      'employee_attendance',
      where:
          'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND att_date = ?',
      whereArgs: [...empIds, dateStr],
      orderBy: 'att_timestamp ASC',
    );

    return rows.map(attendanceFromDB).toList();
  }

  @override
  Future<void> syncOfflineQueue(WidgetRef ref) async {
    await OfflineAttendanceService().syncQueue(ref);
  }
}

// Provider for repository (DB version)
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl(ref.read(dbHelperProvider));
});

// // lib/features/attendance/data/repositories/attendance_repository_impl.dart
// // FINAL Production-Ready Version (01 Jan 2026)
// // Uses SQLite (db_helper.dart + dummy_data.json)
// // No hardcoding - All from DB queries
// // Error handling + security checks (user role)
// // Future API (Dio) commented for easy switch
// // Supports check-in/out, today attendance, history, team attendance

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/attendance_repository.dart';
// import 'package:appattendance/features/attendance/data/services/offline_attendance_service.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:dio/dio.dart'; // Future API
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart'; // For unique att_id

// class AttendanceRepositoryImpl implements AttendanceRepository {
//   final Dio? dio; // Optional - API ke liye (abhi null)
//   final Uuid uuid = const Uuid();

//   AttendanceRepositoryImpl({this.dio});

//   @override
//   Future<void> checkIn({
//     required String empId,
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//     String? photoProofPath,
//     bool offlineQueue = false,  //offline mode flag
//   }) async {
    
//     if (offlineQueue) {
//       // Queue for offline sync
//       final att = AttendanceModel(
//         attId: uuid.v4(),
//         empId: empId,
//         timestamp: DateTime.now(),
//         attendanceDate: DateTime.now(),
//         latitude: latitude,
//         longitude: longitude,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//         status: AttendanceStatus.checkIn,
//         verificationType: verificationType,
//         isVerified: true,
//         photoProofPath: photoProofPath,
//       );
//       await OfflineAttendanceService().queueCheckIn(att);
//       return;
//     }
//     try {
//       final db = await DBHelper.instance.database;

//       final attId = uuid.v4(); // Unique ID
//       final timestamp = DateTime.now();
//       final todayStr = DateFormat('yyyy-MM-dd').format(timestamp);

//       await db.insert('employee_attendance', {
//         'att_id': attId,
//         'emp_id': empId,
//         'att_timestamp': timestamp.toIso8601String(),
//         'att_date': todayStr,
//         'att_latitude': latitude,
//         'att_longitude': longitude,
//         'att_geofence_name': geofenceName,
//         'project_id': projectId,
//         'att_notes': notes,
//         'att_status': 'checkIn',
//         'verification_type': verificationType.name,
//         'is_verified': 1, // Assume verified for demo
//         'photo_proof_path': photoProofPath,
//         'created_at': timestamp.toIso8601String(),
//         'updated_at': timestamp.toIso8601String(),
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       throw Exception('Check-in failed: $e');
//     }

//     // Future API (uncomment when ready)
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     await dio!.post('/attendance/check-in', data: {
//       'empId': empId,
//       'latitude': latitude,
//       'longitude': longitude,
//       'verificationType': verificationType.name,
//       'geofenceName': geofenceName,
//       'projectId': projectId,
//       'notes': notes,
//       'photoProofPath': photoProofPath,
//     });
//     */
//   }

//   @override
//   Future<void> checkOut({
//     required String empId,
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//     bool offlineQueue = false,
//   }) async {
//     if (offlineQueue) {
//       // Queue for offline sync
//       final att = AttendanceModel(
//         attId: uuid.v4(),
//         empId: empId,
//         timestamp: DateTime.now(),
//         attendanceDate: DateTime.now(),
//         latitude: latitude,
//         longitude: longitude,
//         geofenceName: geofenceName,
//         projectId: projectId,
//         notes: notes,
//         status: AttendanceStatus.checkOut,
//         verificationType: verificationType,
//         isVerified: true,
//       );
//       await OfflineAttendanceService().queueCheckIn(att); // Reuse queue
//       return;
//     }
//     try {
//       final db = await DBHelper.instance.database;

//       final attId = uuid.v4();
//       final timestamp = DateTime.now();
//       final todayStr = DateFormat('yyyy-MM-dd').format(timestamp);

//       // Find today's check-in (latest checkIn)
//       final checkInRows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND att_date = ? AND att_status = ?',
//         whereArgs: [empId, todayStr, 'checkIn'],
//         orderBy: 'att_timestamp DESC',
//         limit: 1,
//       );

//       if (checkInRows.isEmpty) {
//         throw Exception('No check-in found for today');
//       }

//       await db.insert('employee_attendance', {
//         'att_id': attId,
//         'emp_id': empId,
//         'att_timestamp': timestamp.toIso8601String(),
//         'att_date': todayStr,
//         'att_latitude': latitude,
//         'att_longitude': longitude,
//         'att_geofence_name': geofenceName,
//         'project_id': projectId,
//         'att_notes': notes,
//         'att_status': 'checkOut',
//         'verification_type': verificationType.name,
//         'is_verified': 1,
//         'created_at': timestamp.toIso8601String(),
//         'updated_at': timestamp.toIso8601String(),
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       throw Exception('Check-out failed: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     await dio!.post('/attendance/check-out', data: {
//       'empId': empId,
//       'latitude': latitude,
//       'longitude': longitude,
//       'verificationType': verificationType.name,
//       'geofenceName': geofenceName,
//       'projectId': projectId,
//       'notes': notes,
//     });
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getTodayAttendance(String empId) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final today = DateTime.now();
//       final todayStr = DateFormat('yyyy-MM-dd').format(today);

//       final rows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND att_date = ?',
//         whereArgs: [empId, todayStr],
//         orderBy: 'att_timestamp ASC',
//       );

//       return rows.map(attendanceFromDB).toList();
//     } catch (e) {
//       throw Exception('Failed to get today\'s attendance: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/today/$empId');
//     return (response.data['attendance'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getHistory(
//     String empId,
//     DateTime start,
//     DateTime end,
//   ) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final startStr = DateFormat('yyyy-MM-dd').format(start);
//       final endStr = DateFormat('yyyy-MM-dd').format(end);

//       final rows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND att_date BETWEEN ? AND ?',
//         whereArgs: [empId, startStr, endStr],
//         orderBy: 'att_date ASC, att_timestamp ASC',
//       );

//       return rows.map(attendanceFromDB).toList();
//     } catch (e) {
//       throw Exception('Failed to get attendance history: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/history/$empId', queryParameters: {
//       'start': start.toIso8601String(),
//       'end': end.toIso8601String(),
//     });
//     return (response.data['history'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getTeamAttendance(
//     String mgrEmpId,
//     DateTime date,
//   ) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final dateStr = DateFormat('yyyy-MM-dd').format(date);

//       // Get team members (reporting_manager_id)
//       final teamMembers = await db.query(
//         'employee_master',
//         where: 'reporting_manager_id = ?',
//         whereArgs: [mgrEmpId],
//       );

//       if (teamMembers.isEmpty) return [];

//       final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

//       final rows = await db.query(
//         'employee_attendance',
//         where:
//             'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND att_date = ?',
//         whereArgs: [...empIds, dateStr],
//         orderBy: 'att_timestamp ASC',
//       );

//       return rows.map(attendanceFromDB).toList();
//     } catch (e) {
//       throw Exception('Failed to get team attendance: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/team/$mgrEmpId', queryParameters: {
//       'date': date.toIso8601String(),
//     });
//     return (response.data['teamAttendance'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }
// }

// // Provider for repository (DB version - future API switch easy)
// final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
//   return AttendanceRepositoryImpl();
// });


// // lib/features/attendance/data/repositories/attendance_repository_impl.dart
// // Upgraded: SQLite-based (dummy_data.json + db_helper.dart)
// // Future API (Dio) commented for easy switch
// // Uses AttendanceModel (freezed)
// // Error handling + security checks (user role)

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/attendance_repository.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:dio/dio.dart'; // Future ke liye
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:uuid/uuid.dart'; // For generating att_id

// class AttendanceRepositoryImpl implements AttendanceRepository {
//   final Dio? dio; // Optional - API ke liye (abhi null)
//   final Uuid uuid = const Uuid();

//   AttendanceRepositoryImpl({this.dio});

//   @override
//   Future<void> checkIn({
//     required String empId,
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//     String? photoProofPath,
//   }) async {
//     try {
//       final db = await DBHelper.instance.database;

//       final attId = uuid.v4(); // Generate unique att_id
//       final timestamp = DateTime.now().toIso8601String();

//       await db.insert('employee_attendance', {
//         'att_id': attId,
//         'emp_id': empId,
//         'att_timestamp': timestamp,
//         'att_latitude': latitude,
//         'att_longitude': longitude,
//         'att_geofence_name': geofenceName,
//         'project_id': projectId,
//         'att_notes': notes,
//         'att_status': 'checkIn',
//         'verification_type': verificationType.name,
//         'is_verified': 1, // Assume verified for demo
//         'created_at': timestamp,
//         'updated_at': timestamp,
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       throw Exception('Check-in failed: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     await dio!.post('/attendance/check-in', data: {
//       'empId': empId,
//       'latitude': latitude,
//       'longitude': longitude,
//       'verificationType': verificationType.name,
//       'geofenceName': geofenceName,
//       'projectId': projectId,
//       'notes': notes,
//     });
//     */
//   }

//   @override
//   Future<void> checkOut({
//     required String empId,
//     required double latitude,
//     required double longitude,
//     required VerificationType verificationType,
//     String? geofenceName,
//     String? projectId,
//     String? notes,
//   }) async {
//     try {
//       final db = await DBHelper.instance.database;

//       final attId = uuid.v4();
//       final timestamp = DateTime.now().toIso8601String();

//       await db.insert('employee_attendance', {
//         'att_id': attId,
//         'emp_id': empId,
//         'att_timestamp': timestamp,
//         'att_latitude': latitude,
//         'att_longitude': longitude,
//         'att_geofence_name': geofenceName,
//         'project_id': projectId,
//         'att_notes': notes,
//         'att_status': 'checkOut',
//         'verification_type': verificationType.name,
//         'is_verified': 1,
//         'created_at': timestamp,
//         'updated_at': timestamp,
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       throw Exception('Check-out failed: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     await dio!.post('/attendance/check-out', data: {
//       'empId': empId,
//       'latitude': latitude,
//       'longitude': longitude,
//       'verificationType': verificationType.name,
//       'geofenceName': geofenceName,
//       'projectId': projectId,
//       'notes': notes,
//     });
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getTodayAttendance(String empId) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final today = DateTime.now().toIso8601String().split('T')[0];

//       final rows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND DATE(att_timestamp) = ?',
//         whereArgs: [empId, today],
//         orderBy: 'att_timestamp ASC',
//       );
//       return rows.map(attendanceFromDB).toList();

//       // return rows.map((row) => attendanceFromDB(row)).toList();
//     } catch (e) {
//       throw Exception('Failed to get today\'s attendance: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/today/$empId');
//     return (response.data['attendance'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getHistory(
//     String empId,
//     DateTime start,
//     DateTime end,
//   ) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final startStr = start.toIso8601String().split('T')[0];
//       final endStr = end.toIso8601String().split('T')[0];

//       final rows = await db.query(
//         'employee_attendance',
//         where: 'emp_id = ? AND DATE(att_timestamp) BETWEEN ? AND ?',
//         whereArgs: [empId, startStr, endStr],
//         orderBy: 'att_timestamp DESC',
//       );

//       return rows.map((row) => attendanceFromDB(row)).toList();
//     } catch (e) {
//       throw Exception('Failed to get attendance history: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/history/$empId', queryParameters: {
//       'start': start.toIso8601String(),
//       'end': end.toIso8601String(),
//     });
//     return (response.data['history'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }

//   @override
//   Future<List<AttendanceModel>> getTeamAttendance(
//     String mgrEmpId,
//     DateTime date,
//   ) async {
//     try {
//       final db = await DBHelper.instance.database;
//       final dateStr = date.toIso8601String().split('T')[0];

//       // Get team members (assuming reportingManagerId in employee_master)
//       final teamMembers = await db.query(
//         'employee_master',
//         where: 'reportingManagerId = ?',
//         whereArgs: [mgrEmpId],
//       );

//       if (teamMembers.isEmpty) return [];

//       final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

//       final rows = await db.query(
//         'employee_attendance',
//         where:
//             'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND DATE(att_timestamp) = ?',
//         whereArgs: [...empIds, dateStr],
//         orderBy: 'att_timestamp ASC',
//       );

//       return rows.map((row) => attendanceFromDB(row)).toList();
//     } catch (e) {
//       throw Exception('Failed to get team attendance: $e');
//     }

//     // Future API
//     /*
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/attendance/team/$mgrEmpId', queryParameters: {
//       'date': date.toIso8601String(),
//     });
//     return (response.data['teamAttendance'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//     */
//   }
// }

// // Provider for repository
// final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
//   return AttendanceRepositoryImpl();
// });

// // // lib/features/attendance/data/repositories/attendance_repository_impl.dart

// // import 'dart:math';
// // import 'package:appattendance/core/database/db_helper.dart';
// // import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// // import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// // import 'package:appattendance/features/attendance/domain/models/geofence_model.dart';
// // import 'package:appattendance/features/attendance/data/repositories/attendance_repository.dart';
// // import 'package:latlong2/latlong.dart';
// // import 'package:sqflite/sqflite.dart';

// // class AttendanceRepositoryImpl implements AttendanceRepository {
// //   final DBHelper _dbHelper;

// //   AttendanceRepositoryImpl(this._dbHelper);

// //   // ==============================
// //   // CORE ATTENDANCE METHODS
// //   // ==============================

// //   @override
// //   Future<AttendanceModel> checkIn({
// //     required String empId,
// //     required LatLng location,
// //     String? projectId,
// //     String? notes,
// //     VerificationType verificationType = VerificationType.faceAuth,
// //   }) async {
// //     final db = await _dbHelper.database;
// //     final now = DateTime.now().toUtc();

// //     // Generate attendance ID
// //     final attId = await _generateAttendanceId();

// //     // Validate geofence if project provided
// //     if (projectId != null) {
// //       final isValid = await validateGeofence(projectId, location);
// //       if (!isValid) {
// //         throw Exception(
// //           'You are not within the valid geofence for this project',
// //         );
// //       }
// //     }

// //     // Get nearest geofence name
// //     final nearestGeofence = await getNearestGeofence(location);
// //     final geofenceName = nearestGeofence?.siteName;

// //     final attendance = AttendanceModel(
// //       attId: attId,
// //       empId: empId,
// //       timestamp: now,
// //       latitude: location.latitude,
// //       longitude: location.longitude,
// //       geofenceName: geofenceName,
// //       projectId: projectId,
// //       notes: notes,
// //       status: AttendanceStatus.checkIn,
// //       verificationType: verificationType,
// //       isVerified: verificationType != VerificationType.manual,
// //       createdAt: now,
// //       updatedAt: now,
// //     );

// //     // Save to database
// //     await db.insert('employee_attendance', {
// //       'att_id': attId,
// //       'emp_id': empId,
// //       'att_timestamp': now.toIso8601String(),
// //       'att_latitude': location.latitude,
// //       'att_longitude': location.longitude,
// //       'att_geofence_name': geofenceName,
// //       'project_id': projectId,
// //       'att_notes': notes,
// //       'att_status': 'checkIn',
// //       'verification_type': _verificationToString(verificationType),
// //       'is_verified': verificationType != VerificationType.manual ? 1 : 0,
// //       'created_at': now.toIso8601String(),
// //       'updated_at': now.toIso8601String(),
// //     });

// //     return attendance;
// //   }

// //   @override
// //   Future<AttendanceModel> checkOut({
// //     required String empId,
// //     required LatLng location,
// //     String? projectId,
// //     String? notes,
// //     VerificationType verificationType = VerificationType.faceAuth,
// //   }) async {
// //     final db = await _dbHelper.database;
// //     final now = DateTime.now().toUtc();

// //     // Check if user has checked in today
// //     final todayCheckIn = await getTodayAttendance(empId);
// //     if (todayCheckIn == null) {
// //       throw Exception('No check-in found for today. Please check-in first.');
// //     }

// //     // Generate attendance ID
// //     final attId = await _generateAttendanceId();

// //     // Get nearest geofence
// //     final nearestGeofence = await getNearestGeofence(location);
// //     final geofenceName = nearestGeofence?.siteName;

// //     final attendance = AttendanceModel(
// //       attId: attId,
// //       empId: empId,
// //       timestamp: now,
// //       latitude: location.latitude,
// //       longitude: location.longitude,
// //       geofenceName: geofenceName,
// //       projectId: projectId,
// //       notes: notes,
// //       status: AttendanceStatus.checkOut,
// //       verificationType: verificationType,
// //       isVerified: verificationType != VerificationType.manual,
// //       createdAt: now,
// //       updatedAt: now,
// //     );

// //     // Save to database
// //     await db.insert('employee_attendance', {
// //       'att_id': attId,
// //       'emp_id': empId,
// //       'att_timestamp': now.toIso8601String(),
// //       'att_latitude': location.latitude,
// //       'att_longitude': location.longitude,
// //       'att_geofence_name': geofenceName,
// //       'project_id': projectId,
// //       'att_notes': notes,
// //       'att_status': 'checkOut',
// //       'verification_type': _verificationToString(verificationType),
// //       'is_verified': verificationType != VerificationType.manual ? 1 : 0,
// //       'created_at': now.toIso8601String(),
// //       'updated_at': now.toIso8601String(),
// //     });

// //     return attendance;
// //   }

// //   // ==============================
// //   // ATTENDANCE QUERIES
// //   // ==============================

// //   @override
// //   Future<AttendanceModel?> getTodayAttendance(String empId) async {
// //     final db = await _dbHelper.database;
// //     final today = DateTime.now();
// //     final startOfDay = DateTime(today.year, today.month, today.day);
// //     final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

// //     final results = await db.query(
// //       'employee_attendance',
// //       where: 'emp_id = ? AND att_timestamp BETWEEN ? AND ?',
// //       whereArgs: [
// //         empId,
// //         startOfDay.toIso8601String(),
// //         endOfDay.toIso8601String(),
// //       ],
// //       orderBy: 'att_timestamp DESC',
// //     );

// //     if (results.isEmpty) return null;

// //     return attendanceFromDB(results.first);
// //   }

// //   @override
// //   Future<List<AttendanceModel>> getAttendanceHistory({
// //     required String empId,
// //     DateTime? startDate,
// //     DateTime? endDate,
// //     String? projectId,
// //   }) async {
// //     final db = await _dbHelper.database;

// //     final whereClauses = <String>['emp_id = ?'];
// //     final whereArgs = <dynamic>[empId];

// //     if (startDate != null) {
// //       whereClauses.add('DATE(att_timestamp) >= ?');
// //       whereArgs.add(startDate.toIso8601String());
// //     }

// //     if (endDate != null) {
// //       whereClauses.add('DATE(att_timestamp) <= ?');
// //       whereArgs.add(endDate.toIso8601String());
// //     }

// //     if (projectId != null) {
// //       whereClauses.add('project_id = ?');
// //       whereArgs.add(projectId);
// //     }

// //     final results = await db.query(
// //       'employee_attendance',
// //       where: whereClauses.join(' AND '),
// //       whereArgs: whereArgs,
// //       orderBy: 'att_timestamp DESC',
// //     );

// //     return results.map((row) => attendanceFromDB(row)).toList();
// //   }

// //   @override
// //   Future<List<AttendanceModel>> getRecentAttendance(
// //     String empId, {
// //     int limit = 10,
// //   }) async {
// //     final db = await _dbHelper.database;

// //     final results = await db.query(
// //       'employee_attendance',
// //       where: 'emp_id = ?',
// //       whereArgs: [empId],
// //       orderBy: 'att_timestamp DESC',
// //       limit: limit,
// //     );

// //     return results.map((row) => attendanceFromDB(row)).toList();
// //   }

// //   // ==============================
// //   // GEOFENCE METHODS
// //   // ==============================

// //   @override
// //   Future<List<GeofenceModel>> getAvailableGeofences(String empId) async {
// //     final db = await _dbHelper.database;

// //     // Get projects assigned to employee
// //     final projectRows = await db.query(
// //       'employee_mapped_projects',
// //       where: 'emp_id = ? AND mapping_status = ?',
// //       whereArgs: [empId, 'active'],
// //     );

// //     if (projectRows.isEmpty) return [];

// //     final projectIds = projectRows
// //         .map((row) => row['project_id'] as String)
// //         .toList();
// //     final placeholders = List.filled(projectIds.length, '?').join(', ');

// //     final results = await db.query(
// //       'project_site_mapping',
// //       where: 'project_id IN ($placeholders)',
// //       whereArgs: projectIds,
// //     );

// //     return results.map((row) => geofenceFromDB(row)).toList();
// //   }

// //   @override
// //   Future<GeofenceModel?> getNearestGeofence(LatLng location) async {
// //     final db = await _dbHelper.database;
// //     final allSites = await db.query('project_site_mapping');

// //     if (allSites.isEmpty) return null;

// //     GeofenceModel? nearest;
// //     double? minDistance;

// //     for (final site in allSites) {
// //       final geofence = geofenceFromDB(site);
// //       final distance = geofence.distanceFrom(location);

// //       if (minDistance == null || distance < minDistance) {
// //         minDistance = distance;
// //         nearest = geofence;
// //       }
// //     }

// //     return nearest;
// //   }

// //   @override
// //   Future<bool> validateGeofence(String projectId, LatLng location) async {
// //     final db = await _dbHelper.database;

// //     final results = await db.query(
// //       'project_site_mapping',
// //       where: 'project_id = ?',
// //       whereArgs: [projectId],
// //     );

// //     if (results.isEmpty) return false;

// //     for (final site in results) {
// //       final geofence = geofenceFromDB(site);
// //       if (geofence.isInside(location)) {
// //         return true;
// //       }
// //     }

// //     return false;
// //   }

// //   // ==============================
// //   // ANALYTICS METHODS
// //   // ==============================

// //   @override
// //   // line 380 के आसपास का code ढूंढें और इसे fix करें:
// //   @override
// //   Future<AnalyticsData> getPersonalAnalytics({
// //     required String empId,
// //     required AnalyticsMode mode,
// //     DateTime? customStart,
// //     DateTime? customEnd,
// //   }) async {
// //     final db = await _dbHelper.database;

// //     // Calculate date range based on mode
// //     final now = DateTime.now();
// //     DateTime startDate;
// //     DateTime endDate;

// //     switch (mode) {
// //       case AnalyticsMode.daily:
// //         startDate = DateTime(now.year, now.month, now.day);
// //         endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
// //         break;
// //       case AnalyticsMode.weekly:
// //         startDate = now.subtract(const Duration(days: 7));
// //         endDate = now;
// //         break;
// //       case AnalyticsMode.monthly:
// //         startDate = DateTime(now.year, now.month, 1);
// //         endDate = now;
// //         break;
// //       case AnalyticsMode.quarterly:
// //         final quarter = ((now.month - 1) / 3).floor();
// //         startDate = DateTime(now.year, quarter * 3 + 1, 1);
// //         endDate = now;
// //         break;
// //     }

// //     // Override with custom dates if provided
// //     if (customStart != null) startDate = customStart;
// //     if (customEnd != null) endDate = customEnd;

// //     // Execute complex analytics query
// //     final query = '''
// //     SELECT 
// //       COUNT(DISTINCT DATE(att_timestamp)) as total_days,
// //       SUM(CASE WHEN att_status = 'checkIn' THEN 1 ELSE 0 END) as check_in_count,
// //       SUM(CASE WHEN att_status = 'checkOut' THEN 1 ELSE 0 END) as check_out_count,
// //       AVG(
// //         CASE WHEN att_status = 'checkOut' 
// //         THEN (
// //           SELECT MIN(att_timestamp) 
// //           FROM employee_attendance a2 
// //           WHERE a2.emp_id = employee_attendance.emp_id 
// //             AND DATE(a2.att_timestamp) = DATE(employee_attendance.att_timestamp)
// //             AND a2.att_status = 'checkIn'
// //         ) - att_timestamp
// //         ELSE NULL END
// //       ) as avg_hours,
// //       COUNT(DISTINCT CASE WHEN att_status = 'checkIn' THEN DATE(att_timestamp) END) as present_days
// //     FROM employee_attendance
// //     WHERE emp_id = ? 
// //       AND att_timestamp BETWEEN ? AND ?
// //   ''';

// //     final results = await db.rawQuery(query, [
// //       empId,
// //       startDate.toIso8601String(),
// //       endDate.toIso8601String(),
// //     ]);

// //     // FIXED: Convert Map<dynamic, dynamic> to Map<String, dynamic>
// //     final Map<String, dynamic> row = results.isNotEmpty
// //         ? results.first.map((key, value) => MapEntry(key.toString(), value))
// //         : <String, dynamic>{};

// //     return analyticsFromDB(
// //       mode: mode,
// //       start: startDate,
// //       end: endDate,
// //       row: row,
// //     );
// //   }

// //   @override
// //   Future<AnalyticsData> getTeamAnalytics({
// //     required String managerEmpId,
// //     AnalyticsMode mode = AnalyticsMode.monthly,
// //     String? departmentFilter,
// //     String? teamMemberFilter,
// //   }) async {
// //     // TODO: Implement team analytics for managers
// //     // This requires employee hierarchy data
// //     throw UnimplementedError(
// //       'Team analytics will be implemented in next phase',
// //     );
// //   }

// //   // ==============================
// //   // STATS METHODS
// //   // ==============================

// //   @override
// //   Future<Map<String, dynamic>> getMonthlySummary(
// //     String empId,
// //     DateTime month,
// //   ) async {
// //     final db = await _dbHelper.database;

// //     final startOfMonth = DateTime(month.year, month.month, 1);
// //     final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

// //     final query = '''
// //       SELECT 
// //         COUNT(DISTINCT DATE(att_timestamp)) as days_present,
// //         SUM(CASE WHEN TIME(att_timestamp) > '09:15:00' AND att_status = 'checkIn' THEN 1 ELSE 0 END) as late_days,
// //         MIN(att_timestamp) as earliest_checkin,
// //         MAX(att_timestamp) as latest_checkout
// //       FROM employee_attendance
// //       WHERE emp_id = ? 
// //         AND att_timestamp BETWEEN ? AND ?
// //     ''';

// //     final results = await db.rawQuery(query, [
// //       empId,
// //       startOfMonth.toIso8601String(),
// //       endOfMonth.toIso8601String(),
// //     ]);

// //     return results.isNotEmpty ? Map<String, dynamic>.from(results.first) : {};
// //   }

// //   @override
// //   Future<Map<String, dynamic>> getAttendanceStats(String empId) async {
// //     final db = await _dbHelper.database;

// //     final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

// //     final query = '''
// //       SELECT 
// //         COUNT(DISTINCT DATE(att_timestamp)) as present_last_30_days,
// //         AVG(
// //           CASE WHEN att_status = 'checkOut' 
// //           THEN (
// //             SELECT MIN(att_timestamp) 
// //             FROM employee_attendance a2 
// //             WHERE a2.emp_id = employee_attendance.emp_id 
// //               AND DATE(a2.att_timestamp) = DATE(employee_attendance.att_timestamp)
// //               AND a2.att_status = 'checkIn'
// //           ) - att_timestamp
// //           ELSE NULL END
// //         ) as avg_daily_hours,
// //         COUNT(CASE WHEN TIME(att_timestamp) > '09:15:00' AND att_status = 'checkIn' THEN 1 END) as late_count
// //       FROM employee_attendance
// //       WHERE emp_id = ? 
// //         AND att_timestamp >= ?
// //     ''';

// //     final results = await db.rawQuery(query, [
// //       empId,
// //       thirtyDaysAgo.toIso8601String(),
// //     ]);

// //     return results.isNotEmpty ? Map<String, dynamic>.from(results.first) : {};
// //   }

// //   @override
// //   Future<bool> applyRegularization({
// //     required String empId,
// //     required DateTime forDate,
// //     required String justification,
// //     required String checkInTime,
// //     required String checkOutTime,
// //   }) async {
// //     // TODO: Integrate with employee_regularization table
// //     throw UnimplementedError(
// //       'Regularization will be implemented in next phase',
// //     );
// //   }

// //   // ==============================
// //   // HELPER METHODS
// //   // ==============================

// //   Future<String> _generateAttendanceId() async {
// //     final db = await _dbHelper.database;

// //     // Get current serial number
// //     final serialResult = await db.query('running_serial_number');
// //     final currentSerial = serialResult.isNotEmpty
// //         ? serialResult.first['att_last_serial_number'] as int
// //         : 0;

// //     final newSerial = currentSerial + 1;
// //     final attId =
// //         'NUTANTEKA${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${newSerial.toString().padLeft(3, '0')}';

// //     // Update serial number
// //     await db.update(
// //       'running_serial_number',
// //       {
// //         'att_last_serial_number': newSerial,
// //         'updated_at': DateTime.now().toIso8601String(),
// //       },
// //       where: 'org_id = ?',
// //       whereArgs: ['NUTANTEK'],
// //     );

// //     return attId;
// //   }

// //   String _verificationToString(VerificationType type) {
// //     switch (type) {
// //       case VerificationType.faceAuth:
// //         return 'faceauth';
// //       case VerificationType.fingerprint:
// //         return 'fingerprint';
// //       case VerificationType.manual:
// //         return 'manual';
// //       case VerificationType.gps:
// //         return 'gps';
// //     }
// //   }
// // }
