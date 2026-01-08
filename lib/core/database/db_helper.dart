// lib/core/database/db_helper.dart
// Updated & Refined Version (2 Jan 2026)
// Enhanced: attendance_analytics table + queries for real analytics (no hardcoding)
// All tables aligned with dummy_data.dart + new seeding
// Future-proof for backend switch

import 'dart:convert';
import 'package:appattendance/core/database/dummy_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nutantek.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // organization_master
    await db.execute('''
      CREATE TABLE organization_master (
        org_id TEXT PRIMARY KEY,
        org_short_name TEXT UNIQUE,
        org_name TEXT NOT NULL,
        org_email TEXT,
        office_start_hrs TEXT,
        office_end_hrs TEXT,
        working_hrs_in_number INTEGER,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // user
    await db.execute('''
      CREATE TABLE user (
        emp_id TEXT PRIMARY KEY,
        email_id TEXT UNIQUE NOT NULL,
        password TEXT,
        mpin TEXT,
        otp TEXT,
        otp_expiry_time TEXT,
        emp_status TEXT,
        biometric_enabled INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // employee_master
    await db.execute('''
  CREATE TABLE employee_master (
    emp_id TEXT PRIMARY KEY,
    org_short_name TEXT,
    emp_name TEXT NOT NULL,
    emp_email TEXT UNIQUE NOT NULL,
    emp_role TEXT,
    emp_department TEXT,
    emp_phone TEXT,
    reporting_manager_id TEXT, 
    emp_joining_date TEXT,
    emp_status TEXT DEFAULT 'active',
    designation TEXT DEFAULT 'Employee',  
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (org_short_name) REFERENCES organization_master(org_short_name),
    FOREIGN KEY (reporting_manager_id) REFERENCES employee_master(emp_id)
  )
''');

    // project_master
    await db.execute('''
  CREATE TABLE project_master (
    project_id TEXT PRIMARY KEY,
    org_short_name TEXT,
    project_name TEXT NOT NULL,
    project_site TEXT,
    client_name TEXT,
    client_location TEXT,
    client_contact TEXT,
    mng_name TEXT,
    mng_email TEXT,
    mng_contact TEXT,
    project_description TEXT,
    project_techstack TEXT,
    project_assigned_date TEXT,
    estd_start_date TEXT,       -- ← Added
    estd_end_date TEXT,         -- ← Added
    estd_effort TEXT,           -- ← Added
    estd_cost TEXT,             -- ← Added
    status TEXT DEFAULT 'active',
    priority TEXT DEFAULT 'HIGH',
    progress REAL DEFAULT 0.0,
    created_at TEXT,
    updated_at TEXT,
    FOREIGN KEY (org_short_name) REFERENCES organization_master(org_short_name)
  )
''');

    // project_site_mapping
    await db.execute('''
      CREATE TABLE project_site_mapping (
        project_site_id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        project_site_name TEXT,
        project_site_lat REAL,
        project_site_long REAL,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

    // employee_attendance
    await db.execute('''
      CREATE TABLE employee_attendance (
        att_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        att_timestamp TEXT NOT NULL,
        att_date TEXT NOT NULL,
        att_latitude REAL,
        att_longitude REAL,
        att_geofence_name TEXT,
        project_id TEXT,
        att_notes TEXT,
        att_status TEXT CHECK(att_status IN ('checkIn', 'checkOut')),
        verification_type TEXT,
        is_verified INTEGER DEFAULT 0,
        photo_proof_path TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (emp_id) REFERENCES employee_master(emp_id),
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

    // employee_regularization
    await db.execute('''
      CREATE TABLE employee_regularization (
        reg_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        mgr_emp_id TEXT,
        reg_date_applied TEXT,
        reg_applied_for_date TEXT,
        reg_justification TEXT,
        reg_first_check_in TEXT,
        reg_last_check_out TEXT,
        shortfall_hrs TEXT,
        reg_approval_status TEXT CHECK(reg_approval_status IN ('pending', 'approved', 'rejected')),
        mgr_comments TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (emp_id) REFERENCES employee_master(emp_id),
        FOREIGN KEY (mgr_emp_id) REFERENCES employee_master(emp_id)
      )
    ''');

    // employee_leaves
    await db.execute('''
      CREATE TABLE employee_leaves (
        leave_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        mgr_emp_id TEXT,
        leave_from_date TEXT NOT NULL,
        leave_to_date TEXT NOT NULL,
        leave_type TEXT NOT NULL,
        leave_justification TEXT,
        leave_approval_status TEXT CHECK(leave_approval_status IN ('pending', 'approved', 'rejected', 'cancelled', 'query')),
        manager_comments TEXT,
        from_time TEXT,
        to_time TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (emp_id) REFERENCES employee_master(emp_id),
        FOREIGN KEY (mgr_emp_id) REFERENCES employee_master(emp_id)
      )
    ''');

    // employee_mapped_projects
    await db.execute('''
      CREATE TABLE employee_mapped_projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emp_id TEXT NOT NULL,
        project_id TEXT NOT NULL,
        mapping_status TEXT CHECK(mapping_status IN ('active', 'deactive')),
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (emp_id) REFERENCES employee_master(emp_id),
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

    // current_user (session)
    await db.execute('''
      CREATE TABLE current_user (
        id INTEGER PRIMARY KEY,
        user_data TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // geofence_master
    await db.execute('''
      CREATE TABLE geofence_master (
        geo_id TEXT PRIMARY KEY,
        geo_name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        radius_meters REAL NOT NULL,
        is_active INTEGER DEFAULT 1,
        address TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // NEW: attendance_analytics (daily per-employee stats - no hardcoding)
    await db.execute('''
      CREATE TABLE attendance_analytics (
        analytics_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        att_date TEXT NOT NULL,
        att_type TEXT CHECK(att_type IN ('Present', 'Absent', 'Leave', 'Late', 'Holiday', 'Weekend')),
        first_checkin TEXT,
        last_checkout TEXT,
        worked_hrs REAL DEFAULT 0.0,
        shortfall_hrs REAL DEFAULT 0.0,
        on_time INTEGER DEFAULT 0,
        late INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (emp_id) REFERENCES employee_master(emp_id)
      )
    ''');

    // Seed dummy data from Dart file
    await _seedFromDartData(db);
    //   final users = await db.query('user');
    //   print("Total users seeded: ${users.length}");
    //   for (var user in users) {
    //     print("User: ${user['email_id']} | Password: ${user['password']}");
    //   }

    //   // Check employee table
    //   final emps = await db.query('employee_master');
    //   print("Total employees seeded: ${emps.length}");
    //   for (var emp in emps) {
    //     print("Employee: ${emp['emp_name']} | Email: ${emp['emp_email']}");
    //   }

    // Seed ke baad check (sirf development mein)
    if (kDebugMode) {
      final users = await db.query('user');
      if (users.isEmpty) {
        throw Exception('DB seeding failed - no users found!');
      }
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Run all upgrades in a transaction for safety
    await db.transaction((txn) async {
      // Upgrade from any old version to current
      if (oldVersion < 2) {
        // Add new columns only if they don't exist (SQLite doesn't have IF NOT EXISTS for ALTER, so check manually)
        final columns = await txn.rawQuery(
          'PRAGMA table_info(employee_attendance)',
        );

        final columnNames = columns.map((c) => c['name'] as String).toSet();

        if (!columnNames.contains('att_date')) {
          await txn.execute(
            'ALTER TABLE employee_attendance ADD COLUMN att_date TEXT;',
          );
        }
        if (!columnNames.contains('check_in_time')) {
          await txn.execute(
            'ALTER TABLE employee_attendance ADD COLUMN check_in_time TEXT;',
          );
        }
        if (!columnNames.contains('check_out_time')) {
          await txn.execute(
            'ALTER TABLE employee_attendance ADD COLUMN check_out_time TEXT;',
          );
        }
        if (!columnNames.contains('leave_type')) {
          await txn.execute(
            'ALTER TABLE employee_attendance ADD COLUMN leave_type TEXT;',
          );
        }
        if (!columnNames.contains('photo_proof_path')) {
          await txn.execute(
            'ALTER TABLE employee_attendance ADD COLUMN photo_proof_path TEXT;',
          );
        }
        await db.execute(
          'ALTER TABLE employee_master ADD COLUMN emp_phone TEXT;',
        );
      }
      // if (oldVersion < 2) {
      //   // Add new columns or tables for version 2
      //   await db.execute(
      //     'ALTER TABLE employee_master ADD COLUMN emp_phone TEXT;',
      //   ); // Example upgrade
      // }

      // Future upgrades (add more if blocks for higher versions)
      if (oldVersion < 3) {
        // Example: Add notes to attendance_analytics
        final analyticsColumns = await txn.rawQuery(
          'PRAGMA table_info(attendance_analytics)',
        );
        final analyticsNames = analyticsColumns
            .map((c) => c['name'] as String)
            .toSet();

        if (!analyticsNames.contains('notes')) {
          await txn.execute(
            'ALTER TABLE attendance_analytics ADD COLUMN notes TEXT;',
          );
        }
      }
    });
  }

  Future<void> _seedFromDartData(Database db) async {
    final Map<String, dynamic> data = dummyData;

    // Seed all tables (existing + new)
    await _insertTableData(
      db,
      'organization_master',
      data['organization_master'] ?? [],
    );
    await _insertTableData(db, 'user', data['user'] ?? []);
    await _insertTableData(
      db,
      'employee_master',
      data['employee_master'] ?? [],
    );
    await _insertTableData(db, 'project_master', data['project_master'] ?? []);
    await _insertTableData(
      db,
      'project_site_mapping',
      data['project_site_mapping'] ?? [],
    );
    await _insertTableData(
      db,
      'employee_attendance',
      data['employee_attendance'] ?? [],
    );
    await _insertTableData(
      db,
      'employee_regularization',
      data['employee_regularization'] ?? [],
    );
    await _insertTableData(
      db,
      'employee_leaves',
      data['employee_leaves'] ?? [],
    );
    await _insertTableData(
      db,
      'employee_mapped_projects',
      data['employee_mapped_projects'] ?? [],
    );
    // await _insertTableData(
    //   db,
    //   'running_serial_number',
    //   data['running_serial_number'] ?? [],
    // );
    await _insertTableData(
      db,
      'geofence_master',
      data['geofence_master'] ?? [],
    );

    // NEW: Seed attendance_analytics
    await _insertTableData(
      db,
      'attendance_analytics',
      data['attendance_analytics'] ?? [],
    );
  }

  Future<void> _insertTableData(
    Database db,
    String tableName,
    List<dynamic> dataList,
  ) async {
    for (var item in dataList) {
      final Map<String, Object?> row = Map<String, Object?>.from(item);

      // Auto-fill att_date if missing in employee_attendance
      if (tableName == 'employee_attendance') {
        if (!row.containsKey('att_date') || row['att_date'] == null) {
          final timestampStr = row['att_timestamp'] as String?;
          if (timestampStr != null) {
            try {
              final dateTime = DateTime.parse(timestampStr);
              row['att_date'] = DateFormat('yyyy-MM-dd').format(dateTime);
            } catch (_) {
              row['att_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
            }
          } else {
            row['att_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
          }
        }
      }

      await db.insert(
        tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Save logged in user session
  Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('current_user', {
      'id': 1,
      'user_data': jsonEncode(user),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get logged in user
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

  // Enable/Disable biometrics
  Future<void> enableBiometricsForUser(String empId, bool enabled) async {
    final db = await database;
    await db.update(
      'user',
      {'biometric_enabled': enabled ? 1 : 0},
      where: 'emp_id = ?',
      whereArgs: [empId],
    );
  }

  Future<bool> isBiometricsEnabled(String empId) async {
    final db = await database;
    final result = await db.query(
      'user',
      columns: ['biometric_enabled'],
      where: 'emp_id = ?',
      whereArgs: [empId],
    );
    if (result.isNotEmpty) {
      return (result.first['biometric_enabled'] as int) == 1;
    }
    return false;
  }

  // Clear login session
  Future<void> clearCurrentUser() async {
    final db = await database;
    await db.delete('current_user');
  }

  // NEW: Queries for Attendance Analytics

  // Get analytics for a specific employee over a period
  Future<List<Map<String, dynamic>>> getAttendanceAnalyticsForPeriod({
    required String empId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await database;
    return await db.query(
      'attendance_analytics',
      where: 'emp_id = ? AND att_date BETWEEN ? AND ?',
      whereArgs: [
        empId,
        DateFormat('yyyy-MM-dd').format(start),
        DateFormat('yyyy-MM-dd').format(end),
      ],
      orderBy: 'att_date ASC',
    );
  }

  // Get aggregated team stats for manager over a period
  Future<Map<String, dynamic>> getTeamAnalyticsForPeriod({
    required String mgrEmpId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT
        COUNT(DISTINCT aa.emp_id) as team_size,
        SUM(CASE WHEN aa.att_type = 'Present' AND aa.on_time = 1 THEN 1 ELSE 0 END) as on_time,
        SUM(CASE WHEN aa.att_type = 'Present' AND aa.late = 1 THEN 1 ELSE 0 END) as late,
        SUM(CASE WHEN aa.att_type = 'Present' THEN 1 ELSE 0 END) as present,
        SUM(CASE WHEN aa.att_type = 'Leave' THEN 1 ELSE 0 END) as leave,
        SUM(CASE WHEN aa.att_type = 'Absent' THEN 1 ELSE 0 END) as absent
      FROM attendance_analytics aa
      JOIN employee_master em ON aa.emp_id = em.emp_id
      WHERE em.reporting_manager_id = ?
        AND aa.att_date BETWEEN ? AND ?
    ''',
      [
        mgrEmpId,
        DateFormat('yyyy-MM-dd').format(start),
        DateFormat('yyyy-MM-dd').format(end),
      ],
    );

    final row = result.isNotEmpty ? result.first : {};
    return {
      'team': row['team_size'] as int? ?? 0,
      'present': row['present'] as int? ?? 0,
      'leave': row['leave'] as int? ?? 0,
      'absent': row['absent'] as int? ?? 0,
      'onTime': row['on_time'] as int? ?? 0,
      'late': row['late'] as int? ?? 0,
    };
  }

  // Get pending counts for manager
  Future<int> getPendingLeavesCount(String mgrEmpId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM employee_leaves WHERE mgr_emp_id = ? AND leave_approval_status = ?',
      [mgrEmpId, 'pending'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getPendingRegularisationsCount(String mgrEmpId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM employee_regularization WHERE mgr_emp_id = ? AND reg_approval_status = ?',
      [mgrEmpId, 'pending'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Helper: Delete DB for testing/reset
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nutantek.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}


//*************************************************************
//               vainyala code
//
//************************************************************ */ */


// // lib/core/database/db_helper.dart

// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     debugPrint("➡️ DBHelper.database called");

//     if (_database != null) {
//       debugPrint("✅ Using existing database instance");
//       return _database!;
//     }

//     debugPrint("🆕 Creating new database instance");
//     _database = await _initDB('attendance_db');
//     return _database!;
//   }


//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     debugPrint("📂 DB Path: $path");

//     return await openDatabase(
//       path,
//       version: 4,
//       onCreate: (db, version) async {
//         debugPrint("🆕 onCreate called");
//         await _createDB(db, version);
//       },
//       // onUpgrade: (db, oldVersion, newVersion) async {
//       //   debugPrint("🔼 onUpgrade called");
//       //   await _onUpgrade(db, oldVersion, newVersion);
//       // },
//       onOpen: (db) {
//         debugPrint("📖 Database opened successfully");
//       },
//     );
//   }


//   Future<void> _createDB(Database db, int version) async {
//     debugPrint("🚀 Creating tables...");
//     // FIX: sync_metadata table with correct schema
//     await db.execute(''' 
//     CREATE TABLE sync_metadata (
//   id INTEGER PRIMARY KEY AUTOINCREMENT,
//   sync_key TEXT NOT NULL UNIQUE,
//   value TEXT,
//   updated_at TEXT
// )
// ''');
//     debugPrint("✅ Database created with sync_metadata");
//     // 1. user table
//     await db.execute(''' CREATE TABLE user (
//      emp_id TEXT PRIMARY KEY, 
//      email_id TEXT UNIQUE NOT NULL, 
//      password TEXT, 
//      mpin TEXT, 
//      otp TEXT,
//       otp_expiry_time INTEGER, 
//      emp_status TEXT, -- active / deactive 
//      created_at TEXT DEFAULT (datetime('now')), 
//      updated_at TEXT DEFAULT (datetime('now')) )
//     ''');
//     debugPrint("✅ user table created");

//     // 2. organization_master
//     await db.execute(
//       ''' CREATE TABLE organization_master ( org_id TEXT PRIMARY KEY, org_short_name TEXT UNIQUE,
//          org_name TEXT, org_email TEXT UNIQUE, office_working_start_day TEXT, 
//          office_working_end_day TEXT, office_start_hrs INTEGER, office_end_hrs INTEGER, 
//          working_hrs_in_number INTEGER, created_at TEXT DEFAULT (datetime('now')), 
//          updated_at TEXT DEFAULT (datetime('now')) ) ''',
//     );
//     debugPrint("✅ organization_master table created");
//     // 3. employee_master
//     await db.execute(
//       ''' CREATE TABLE employee_master ( emp_id TEXT PRIMARY KEY, org_short_name TEXT NOT NULL,
//          emp_name TEXT NOT NULL,
//           emp_email TEXT UNIQUE NOT NULL, emp_role TEXT,
//           emp_department TEXT, emp_phone TEXT, emp_status TEXT, 
//           created_at TEXT DEFAULT (datetime('now')), updated_at TEXT DEFAULT (datetime('now')) ) ''',
//     );
//     debugPrint("✅ employee_master table created");
//     // 4. project_master
//     await db.execute(''' CREATE TABLE project_master (
//          project_id TEXT PRIMARY KEY, 
//          org_short_name TEXT NOT NULL,
//           project_name TEXT NOT NULL,
//            project_site TEXT, 
//            client_name TEXT, 
//            client_location TEXT,
//             client_contact TEXT, 
//             mng_name TEXT, mng_email TEXT,
//              mng_contact TEXT, 
//              project_description TEXT, 
//              project_techstack TEXT,
//               project_assigned_date TEXT,
//                created_at TEXT DEFAULT (datetime('now')),
//                 updated_at TEXT DEFAULT (datetime('now')) ) ''');
//     debugPrint("✅ project_master table created");
//     // 5. employee_attendance
//     await db.execute(''' CREATE TABLE employee_attendance (
//          att_id TEXT PRIMARY KEY, 
//         emp_id TEXT NOT NULL, att_timestamp TEXT NOT NULL,
//          att_latitude REAL, att_longitude REAL, 
//          att_geofence_name TEXT, project_id TEXT,
//           att_notes TEXT, att_status TEXT, 
//           verification_type TEXT, 
//           is_verified INTEGER,
//           is_synced INTEGER DEFAULT 0,

//            created_at TEXT DEFAULT (datetime('now')), 
//            updated_at TEXT DEFAULT (datetime('now')) ) ''');
//     debugPrint("✅ employee_attendance table created");
//     // 6. employee_regularization
//     await db.execute(''' CREATE TABLE employee_regularization ( 
//         reg_id TEXT PRIMARY KEY,
//          emp_id TEXT NOT NULL, 
//          mgr_emp_id TEXT NOT NULL, 
//          reg_applied_for_date TEXT NOT NULL, -- Date jiske liye regularization
//           reg_date_applied TEXT NOT NULL, -- Kab apply kiya gaya 
//           reg_justification TEXT NOT NULL, -- Employee ka reason 
//           shortfall_hrs TEXT, -- Kitna late/shortfall
//            reg_approval_status TEXT DEFAULT 'pending', -- pending / approved / rejected 
//         mgr_comments TEXT, -- Manager ka comment (approve/reject pe)
// is_synced INTEGER DEFAULT 0,
//          created_at TEXT DEFAULT (datetime('now')), 
//          updated_at TEXT DEFAULT (datetime('now')),
//           FOREIGN KEY (emp_id) REFERENCES employee_master (emp_id) ON DELETE CASCADE ) 
//           ''');
//     debugPrint("✅ employee_regularization table created");
//     // 7. employee_leaves
//     await db.execute(
//       ''' CREATE TABLE employee_leaves ( leave_id TEXT PRIMARY KEY, 
//         emp_id TEXT NOT NULL, mgr_emp_id TEXT NOT NULL, leave_from_date TEXT, 
//         leave_to_date TEXT, leave_type TEXT, leave_approval_status TEXT, 
//         leave_justification TEXT, manager_comments TEXT, 
//         is_synced INTEGER DEFAULT 0,
//         created_at TEXT DEFAULT (datetime('now')), 
//         updated_at TEXT DEFAULT (datetime('now')) ) ''',
//     );
//     debugPrint("✅ employee_leaves table created");
//     // 8. user_roles
//     await db.execute(''' CREATE TABLE user_roles (
//          role_id INTEGER PRIMARY KEY, -- No AUTOINCREMENT as per document 
//          role_name TEXT NOT NULL ) ''');
//     debugPrint("✅ user_roles table created");
//     // 9. employee_mapped_projects
//     await db.execute('''
// CREATE TABLE employee_mapped_projects (
//   emp_id TEXT NOT NULL,
//   project_id TEXT NOT NULL,
//   mapping_status TEXT DEFAULT 'active',
//   PRIMARY KEY (emp_id, project_id)
// )
// ''');
//     debugPrint("✅ employee_mapped_projects table created");
//     // 10. employee_shifts
//     await db.execute(''' CREATE TABLE employee_shifts ( emp_id TEXT NOT NULL, 
//         shift_id TEXT, 
//         created_at TEXT DEFAULT (datetime('now')),
//          updated_at TEXT DEFAULT (datetime('now')) ) ''');
//     debugPrint("✅ employee_shifts table created");
//     // 11. employee_roles_mapping
//     await db.execute(
//       ''' CREATE TABLE employee_roles_mapping ( emp_id TEXT NOT NULL, 
//         role_id TEXT,
//          created_at TEXT DEFAULT (datetime('now')),
//          updated_at TEXT DEFAULT (datetime('now')) ) ''',
//     );
//     debugPrint("✅ employee_roles_mapping table created");
//     // 12. shift_master
//     await db.execute(''' CREATE TABLE shift_master (
//          shift_id TEXT PRIMARY KEY, org_short_name TEXT,
//           shift_name TEXT, shift_start_time TEXT, 
//           shift_end_time TEXT, 
//           created_at TEXT DEFAULT (datetime('now')),
//            updated_at TEXT DEFAULT (datetime('now')) ) ''');
//     debugPrint("✅ shift_master table created");
//     // 13. current_user (for login session)
//     await db.execute(''' CREATE TABLE current_user ( id INTEGER PRIMARY KEY, 
//         user_data TEXT ) ''');
//     debugPrint("✅ current_user table created");
//     // 14. attendance_summary ✅
//     await db.execute(''' CREATE TABLE attendance_summary ( emp_id TEXT,
//          type TEXT, start_date TEXT, end_date TEXT, days INTEGER, 
//          present INTEGER, leave_count INTEGER, absent INTEGER,
//           on_time INTEGER, late INTEGER, 
//           synced_at TEXT, 
//           PRIMARY KEY (emp_id, type, start_date, end_date) ) ''');
//     debugPrint("✅ oattendance_summary table created");
//     // 15. attendance_analytics
//     await db.execute(''' 
//     CREATE TABLE attendance_analytics ( 
//     analytics_id INTEGER PRIMARY KEY AUTOINCREMENT,
//      emp_id TEXT NOT NULL, att_date TEXT NOT NULL,
//       att_type TEXT, first_checkin TEXT, 
//       last_checkout TEXT, worked_hrs REAL,
//        shortfall_hrs REAL, on_time INTEGER,
//         late INTEGER, 
//         created_at TEXT DEFAULT (datetime('now')),
//          UNIQUE (emp_id, att_date) )''');
//     debugPrint("✅ attendance_analytics table created");
//     // Seed dummy data rom JSON
//     await _seedMinimalLoginData(db);
//   }

// //   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
// //     debugPrint("🔼 Upgrading DB from $oldVersion to $newVersion");
// //
// //     if (oldVersion < 4) {
// //       // Drop and recreate sync_metadata with correct schema
// //       await db.execute('DROP TABLE IF EXISTS sync_metadata');
// //       await db.execute('''
// //       CREATE TABLE sync_metadata (
// //   id INTEGER PRIMARY KEY AUTOINCREMENT,
// //   sync_key TEXT NOT NULL UNIQUE,
// //   value TEXT,
// //   updated_at TEXT
// // )
// //     ''');
// //     }
// //     // Recreate other tables if needed
// //     await db.execute('ALTER TABLE employee_attendance ADD COLUMN is_synced INTEGER DEFAULT 0');
// //     await db.execute('ALTER TABLE employee_regularization ADD COLUMN is_synced INTEGER DEFAULT 0');
// //     await db.execute('ALTER TABLE employee_leaves ADD COLUMN is_synced INTEGER DEFAULT 0');
// //
// //   }

//   Future<void> _seedMinimalLoginData(Database db) async {
//     // Only seed login credentials for testing
//     // All other data will come from API

//     await db.insert('user', {
//       'emp_id': 'TECHYMONKE2025121',
//       'email_id': 'samal@nutantek.com',
//       'password': 'pass123',
//       'emp_status': 'active',
//       'created_at': DateTime.now().toIso8601String(),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);

//     await db.insert('employee_master', {
//       'emp_id': 'TECHYMONKE2025121',
//       'org_short_name': 'TECHYMONK',
//       'emp_name': 'Vainyala Samal',
//       'emp_email': 'samal@nutantek.com',
//        'emp_role': 'Employee',
//       'emp_department': 'Mobile Development',
//       'created_at': DateTime.now().toIso8601String(),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);

//     debugPrint("✅ Minimal login data seeded (API will provide rest)");
//   }

//   // Save logged in user session
//   Future<void> saveCurrentUser(Map<String, dynamic> user) async {
//     final db = await database;
//     debugPrint("💾 saveCurrentUser called → $user");
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//     debugPrint("✅ current_user saved");
//   }

//   /// Save sync metadata
//   Future<void> saveSyncMetadata(String key, String value) async {
//     debugPrint("💾 saveSyncMetadata called → $key = $value");

//     final db = await database;
//     await db.insert(
//       'sync_metadata',
//       {
//         'sync_key': key,
//         'value': value,
//         'updated_at': DateTime.now().toIso8601String(),
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );

//     debugPrint("✅ sync_metadata saved");
//   }


//   /// Get sync metadata
//   Future<String?> getSyncMetadata(String key) async {
//     try {
//       debugPrint("🔍 getSyncMetadata called for key: $key");

//       final db = await database;

//       final result = await db.query(
//         'sync_metadata',
//         where: 'sync_key = ?',
//         whereArgs: [key],
//       );

//       debugPrint("📊 Query result: $result");

//       if (result.isNotEmpty) {
//         return result.first['value'] as String;
//       }
//     } catch (e) {
//       debugPrint("❌ getSyncMetadata error: $e");
//     }
//     return null;
//   }

//   /// Check if initial sync is done
//   Future<bool> isInitialSyncDone() async {
//     final value = await getSyncMetadata('initial_sync_done');
//     return value == 'true';
//   }

//   /// Mark initial sync as done
//   Future<void> markInitialSyncDone() async {
//     await saveSyncMetadata('initial_sync_done', 'true');
//     await saveSyncMetadata('last_sync_time', DateTime.now().toIso8601String());
//   }

//   /// Get pending transactions count
//   Future<int> getPendingTransactionsCount(String empId) async {
//     final db = await database;

//     final attCount =
//         Sqflite.firstIntValue(
//           await db.rawQuery(
//             'SELECT COUNT(*) FROM employee_attendance WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
//             [empId],
//           ),
//         ) ??
//         0;

//     final regCount =
//         Sqflite.firstIntValue(
//           await db.rawQuery(
//             'SELECT COUNT(*) FROM employee_regularization WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
//             [empId],
//           ),
//         ) ??
//         0;

//     final leaveCount =
//         Sqflite.firstIntValue(
//           await db.rawQuery(
//             'SELECT COUNT(*) FROM employee_leaves WHERE emp_id = ? AND (is_synced IS NULL OR is_synced = 0)',
//             [empId],
//           ),
//         ) ??
//         0;

//     return attCount + regCount + leaveCount;
//   }

//   Future<void> saveAttendanceSummary(Map<String, dynamic> data) async {
//     final db = await database;
//     debugPrint(" saveAttendanceSummary data: $data");
//     await db.insert('attendance_summary', {
//       'emp_id': data['emp_id'],
//       'type': data['type'],
//       'start_date': data['start_date'],
//       'end_date': data['end_date'],
//       'days': int.parse(data['days'].toString()),
//       'present': int.parse(data['present'].toString()),
//       'leave_count': int.parse(data['leave_count'].toString()),
//       'absent': int.parse(data['absent'].toString()),
//       'on_time': int.parse(data['on_time'].toString()),
//       'late': int.parse(data['late'].toString()),
//       'synced_at': DateTime.now().toIso8601String(),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//     debugPrint("✅ saveAttendanceSummary saved");
//   }

//   Future<Map<String, dynamic>?> getAttendanceSummaryOffline(
//       String empId,
//       String type,
//       String startDate,
//       String endDate,
//       ) async {
//     debugPrint("📥 Fetching attendance_summary");
//     debugPrint("➡️ empId=$empId, type=$type");

//     final db = await database;

//     final result = await db.query(
//       'attendance_summary',
//       where: 'emp_id=? AND type=? AND start_date=? AND end_date=?',
//       whereArgs: [empId, type, startDate, endDate],
//     );

//     debugPrint("📊 attendance_summary result: $result");

//     if (result.isNotEmpty) return result.first;
//     return null;
//   }

//   Future<Map<String, dynamic>?> getCurrentUser() async {
//     final db = await database;
//     final result = await db.query(
//       'current_user',
//       where: 'id = ?',
//       whereArgs: [1],
//     );
//     if (result.isNotEmpty) {
//       return jsonDecode(result.first['user_data'] as String);
//     }
//     return null;
//   }

//   // Clear login session
//   Future<void> clearCurrentUser() async {
//     final db = await database;
//     await db.delete('current_user');
//   }

//   // Helper: Get user by emp_id
//   Future<Map<String, dynamic>?> getUserByEmpId(String empId) async {
//     final db = await database;
//     debugPrint("getUserByEmpId emp_id: $empId");
//     final user = await db.query(
//       'user',
//       where: 'emp_id = ?',
//       whereArgs: [empId],
//     );
//     if (user.isNotEmpty) {
//       final empDetails = await db.query(
//         'employee_master',
//         where: 'emp_id = ?',
//         whereArgs: [empId],
//       );
//       if (empDetails.isNotEmpty) {
//         final userData = user.first;
//         userData.addAll(empDetails.first);
//         return userData;
//       }
//     }
//     return null;
//   }
// }