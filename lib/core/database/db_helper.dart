// lib/core/database/db_helper.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance_db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // FIX: sync_metadata table with correct schema
    await db.execute(''' 
    CREATE TABLE sync_metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sync_key TEXT NOT NULL UNIQUE,
  value TEXT,
  updated_at TEXT
)
''');
    debugPrint("✅ Database created with sync_metadata");
    // 1. user table
    await db.execute(''' CREATE TABLE user (
     emp_id TEXT PRIMARY KEY, 
     email_id TEXT UNIQUE NOT NULL, 
     password TEXT, 
     mpin TEXT, 
     otp TEXT,
      otp_expiry_time INTEGER, 
     emp_status TEXT, -- active / deactive 
     created_at TEXT DEFAULT (datetime('now')), 
     updated_at TEXT DEFAULT (datetime('now')) )
    ''');
    debugPrint("✅ Database created with sync_metadata");

    // 2. organization_master
    await db.execute(
      ''' CREATE TABLE organization_master ( org_id TEXT PRIMARY KEY, org_short_name TEXT UNIQUE,
         org_name TEXT, org_email TEXT UNIQUE, office_working_start_day TEXT, 
         office_working_end_day TEXT, office_start_hrs INTEGER, office_end_hrs INTEGER, 
         working_hrs_in_number INTEGER, created_at TEXT DEFAULT (datetime('now')), 
         updated_at TEXT DEFAULT (datetime('now')) ) ''',
    );
    // 3. employee_master
    await db.execute(
      ''' CREATE TABLE employee_master ( emp_id TEXT PRIMARY KEY, org_short_name TEXT NOT NULL,
         emp_name TEXT NOT NULL,
          emp_email TEXT UNIQUE NOT NULL, emp_role TEXT,
          emp_department TEXT, emp_phone TEXT, emp_status TEXT, 
          created_at TEXT DEFAULT (datetime('now')), updated_at TEXT DEFAULT (datetime('now')) ) ''',
    );
    // 4. project_master
    await db.execute(''' CREATE TABLE project_master (
         project_id TEXT PRIMARY KEY, 
         org_short_name TEXT NOT NULL,
          project_name TEXT NOT NULL,
           project_site TEXT, 
           client_name TEXT, 
           client_location TEXT,
            client_contact TEXT, 
            mng_name TEXT, mng_email TEXT,
             mng_contact TEXT, 
             project_description TEXT, 
             project_techstack TEXT,
              project_assigned_date TEXT,
               created_at TEXT DEFAULT (datetime('now')),
                updated_at TEXT DEFAULT (datetime('now')) ) ''');
    // 5. employee_attendance
    await db.execute(''' CREATE TABLE employee_attendance (
         att_id TEXT PRIMARY KEY, 
        emp_id TEXT NOT NULL, att_timestamp TEXT NOT NULL,
         att_latitude REAL, att_longitude REAL, 
         att_geofence_name TEXT, project_id TEXT,
          att_notes TEXT, att_status TEXT, 
          verification_type TEXT, 
          is_verified INTEGER,
          is_synced INTEGER DEFAULT 0,

           created_at TEXT DEFAULT (datetime('now')), 
           updated_at TEXT DEFAULT (datetime('now')) ) ''');
    // 6. employee_regularization
    await db.execute(''' CREATE TABLE employee_regularization ( 
        reg_id TEXT PRIMARY KEY,
         emp_id TEXT NOT NULL, 
         mgr_emp_id TEXT NOT NULL, 
         reg_applied_for_date TEXT NOT NULL, -- Date jiske liye regularization
          reg_date_applied TEXT NOT NULL, -- Kab apply kiya gaya 
          reg_justification TEXT NOT NULL, -- Employee ka reason 
          shortfall_hrs TEXT, -- Kitna late/shortfall
           reg_approval_status TEXT DEFAULT 'pending', -- pending / approved / rejected 
        mgr_comments TEXT, -- Manager ka comment (approve/reject pe)
is_synced INTEGER DEFAULT 0,
         created_at TEXT DEFAULT (datetime('now')), 
         updated_at TEXT DEFAULT (datetime('now')),
          FOREIGN KEY (emp_id) REFERENCES employee_master (emp_id) ON DELETE CASCADE ) 
          ''');
    // 7. employee_leaves
    await db.execute(
      ''' CREATE TABLE employee_leaves ( leave_id TEXT PRIMARY KEY, 
        emp_id TEXT NOT NULL, mgr_emp_id TEXT NOT NULL, leave_from_date TEXT, 
        leave_to_date TEXT, leave_type TEXT, leave_approval_status TEXT, 
        leave_justification TEXT, manager_comments TEXT, 
        is_synced INTEGER DEFAULT 0,
        created_at TEXT DEFAULT (datetime('now')), 
        updated_at TEXT DEFAULT (datetime('now')) ) ''',
    );
    // 8. user_roles
    await db.execute(''' CREATE TABLE user_roles (
         role_id INTEGER PRIMARY KEY, -- No AUTOINCREMENT as per document 
         role_name TEXT NOT NULL ) ''');
    // 9. employee_mapped_projects
    await db.execute(
      ''' CREATE TABLE employee_mapped_projects ( id INTEGER PRIMARY KEY AUTOINCREMENT,
         emp_id TEXT NOT NULL, project_id TEXT NOT NULL,
          mapping_status TEXT,
           created_at TEXT DEFAULT (datetime('now')),
            updated_at TEXT DEFAULT (datetime('now')) ) ''',
    ); // 10. employee_shifts
    await db.execute(''' CREATE TABLE employee_shifts ( emp_id TEXT NOT NULL, 
        shift_id TEXT, 
        created_at TEXT DEFAULT (datetime('now')),
         updated_at TEXT DEFAULT (datetime('now')) ) ''');
    // 11. employee_roles_mapping
    await db.execute(
      ''' CREATE TABLE employee_roles_mapping ( emp_id TEXT NOT NULL, 
        role_id TEXT,
         created_at TEXT DEFAULT (datetime('now')),
         updated_at TEXT DEFAULT (datetime('now')) ) ''',
    );
    // 12. shift_master
    await db.execute(''' CREATE TABLE shift_master (
         shift_id TEXT PRIMARY KEY, org_short_name TEXT,
          shift_name TEXT, shift_start_time TEXT, 
          shift_end_time TEXT, 
          created_at TEXT DEFAULT (datetime('now')),
           updated_at TEXT DEFAULT (datetime('now')) ) ''');
    // 13. current_user (for login session)
    await db.execute(''' CREATE TABLE current_user ( id INTEGER PRIMARY KEY, 
        user_data TEXT ) ''');
    // 14. attendance_summary ✅
    await db.execute(''' CREATE TABLE attendance_summary ( emp_id TEXT,
         type TEXT, start_date TEXT, end_date TEXT, days INTEGER, 
         present INTEGER, leave_count INTEGER, absent INTEGER,
          on_time INTEGER, late INTEGER, 
          synced_at TEXT, 
          PRIMARY KEY (emp_id, type, start_date, end_date) ) ''');
    // 15. attendance_analytics
    await db.execute(''' 
    CREATE TABLE attendance_analytics ( 
    analytics_id INTEGER PRIMARY KEY AUTOINCREMENT,
     emp_id TEXT NOT NULL, att_date TEXT NOT NULL,
      att_type TEXT, first_checkin TEXT, 
      last_checkout TEXT, worked_hrs REAL,
       shortfall_hrs REAL, on_time INTEGER,
        late INTEGER, 
        created_at TEXT DEFAULT (datetime('now')),
         UNIQUE (emp_id, att_date) )''');
    // Seed dummy data rom JSON
    await _seedMinimalLoginData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint("🔼 Upgrading DB from $oldVersion to $newVersion");

    if (oldVersion < 2) {
      // Drop and recreate sync_metadata with correct schema
      await db.execute('DROP TABLE IF EXISTS sync_metadata');
      await db.execute('''
      CREATE TABLE sync_metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sync_key TEXT NOT NULL UNIQUE,
  value TEXT,
  updated_at TEXT
)
    ''');
    }
    // Recreate other tables if needed
    await db.execute('ALTER TABLE employee_attendance ADD COLUMN is_synced INTEGER DEFAULT 0');
    await db.execute('ALTER TABLE employee_regularization ADD COLUMN is_synced INTEGER DEFAULT 0');
    await db.execute('ALTER TABLE employee_leaves ADD COLUMN is_synced INTEGER DEFAULT 0');

  }

  Future<void> _seedMinimalLoginData(Database db) async {
    // Only seed login credentials for testing
    // All other data will come from API

    await db.insert('user', {
      'emp_id': 'TECHYMONKE2025121',
      'email_id': 'samal@nutantek.com',
      'password': 'pass123',
      'emp_status': 'active',
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.insert('employee_master', {
      'emp_id': 'TECHYMONKE2025121',
      'org_short_name': 'TECHYMONK',
      'emp_name': 'Vainyala Samal',
      'emp_email': 'samal@nutantek.com',
      'emp_role': 'Employee',
      'emp_department': 'Mobile Development',
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint("✅ Minimal login data seeded (API will provide rest)");
  }

  // Save logged in user session
  Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('current_user', {
      'id': 1,
      'user_data': jsonEncode(user),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Save sync metadata
  Future<void> saveSyncMetadata(String key, String value) async {
    final db = await database;
    await db.insert('sync_metadata', {
      'sync_key': key,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get sync metadata
  Future<String?> getSyncMetadata(String key) async {
    try {
      final db = await database;
      final result = await db.query(
        'sync_metadata',
        where: 'sync_key = ?',
        whereArgs: [key],
      );

      if (result.isNotEmpty) {
        return result.first['value'] as String;
      }
    } catch (e) {
      debugPrint("⚠️ Could not get sync metadata for $key: $e");
    }
    return null;
  }

  /// Check if initial sync is done
  Future<bool> isInitialSyncDone() async {
    final value = await getSyncMetadata('initial_sync_done');
    return value == 'true';
  }

  /// Mark initial sync as done
  Future<void> markInitialSyncDone() async {
    await saveSyncMetadata('initial_sync_done', 'true');
    await saveSyncMetadata('last_sync_time', DateTime.now().toIso8601String());
  }

  /// Get pending transactions count
  Future<int> getPendingTransactionsCount(String empId) async {
    final db = await database;

    final attCount =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM employee_attendance WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
            [empId],
          ),
        ) ??
        0;

    final regCount =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM employee_regularization WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
            [empId],
          ),
        ) ??
        0;

    final leaveCount =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM employee_leaves WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
            [empId],
          ),
        ) ??
        0;

    return attCount + regCount + leaveCount;
  }

  Future<void> saveAttendanceSummary(Map<String, dynamic> data) async {
    final db = await database;

    await db.insert('attendance_summary', {
      'emp_id': data['emp_id'],
      'type': data['type'],
      'start_date': data['start_date'],
      'end_date': data['end_date'],
      'days': int.parse(data['days'].toString()),
      'present': int.parse(data['present'].toString()),
      'leave_count': int.parse(data['leave_count'].toString()),
      'absent': int.parse(data['absent'].toString()),
      'on_time': int.parse(data['on_time'].toString()),
      'late': int.parse(data['late'].toString()),
      'synced_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getAttendanceSummaryOffline(
    String empId,
    String type,
    String startDate,
    String endDate,
  ) async {
    final db = await database;

    final result = await db.query(
      'attendance_summary',
      where: 'emp_id=? AND type=? AND start_date=? AND end_date=?',
      whereArgs: [empId, type, startDate, endDate],
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<void> _seedFromJson(Database db) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/dummy_data.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);
      // Insert data for each table
      await _insertTableData(db, 'user', data['user']);
      await _insertTableData(
        db,
        'organization_master',
        data['organization_master'],
      );
      await _insertTableData(db, 'employee_master', data['employee_master']);
      await _insertTableData(db, 'project_master', data['project_master']);
      await _insertTableData(
        db,
        'employee_attendance',
        data['employee_attendance'],
      );
      await _insertTableData(
        db,
        'employee_regularization',
        data['employee_regularization'],
      );
      await _insertTableData(db, 'employee_leaves', data['employee_leaves']);
      await _insertTableData(db, 'user_roles', data['user_roles']);
      await _insertTableData(
        db,
        'employee_mapped_projects',
        data['employee_mapped_projects'],
      );
      await _insertTableData(db, 'employee_shifts', data['employee_shifts']);
      await _insertTableData(
        db,
        'employee_roles_mapping',
        data['employee_roles_mapping'],
      );
      await _insertTableData(db, 'shift_master', data['shift_master']);
      print("✅ All tables seeded successfully from dummy_data.json!");
    } catch (e) {
      print("❌ Error seeding data: $e");
      await _manualFallbackSeed(db);
    }
  }

  Future<void> _insertTableData(
    Database db,
    String tableName,
    List<dynamic>? dataList,
  ) async {
    if (dataList == null || dataList.isEmpty) return;
    for (var item in dataList) {
      try {
        await db.insert(
          tableName,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print("Error inserting $tableName: $e");
      }
    }
  }

  Future<void> _manualFallbackSeed(Database db) async {
    // Minimal fallback data if JSON fails
    await db.insert('user', {
      'emp_id': 'TECHYMONKE2025121',
      'email_id': 'samal@nutantek.com',
      'password': 'pass123',
      'emp_status': 'active',
    });

    await db.insert('employee_master', {
      'emp_id': 'TECHYMONKE2025121',
      'org_short_name': 'TECHYMONK',
      'emp_name': 'Vainyala Samal',
      'emp_email': 'samal@nutantek.com',
      'emp_role': 'Employee',
      'emp_department': 'Mobile Development',
    });
  }

  // Save logged in user session

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final db = await database;
    final result = await db.query(
      'current_user',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (result.isNotEmpty) {
      return jsonDecode(result.first['user_data'] as String);
    }
    return null;
  }

  // Clear login session
  Future<void> clearCurrentUser() async {
    final db = await database;
    await db.delete('current_user');
  }

  // Helper: Get user by emp_id
  Future<Map<String, dynamic>?> getUserByEmpId(String empId) async {
    final db = await database;
    final user = await db.query(
      'user',
      where: 'emp_id = ?',
      whereArgs: [empId],
    );
    if (user.isNotEmpty) {
      final empDetails = await db.query(
        'employee_master',
        where: 'emp_id = ?',
        whereArgs: [empId],
      );
      if (empDetails.isNotEmpty) {
        final userData = user.first;
        userData.addAll(empDetails.first);
        return userData;
      }
    }
    return null;
  }
}
