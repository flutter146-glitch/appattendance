// lib/core/database/db_helper.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    // Create tables as per your latest schema (aligned with dummy_data.json)
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

    await db.execute('''
      CREATE TABLE user (
        emp_id TEXT PRIMARY KEY,
        email_id TEXT UNIQUE NOT NULL,
        password TEXT,
        mpin TEXT,
        otp TEXT,
        otp_expiry_time TEXT,
        emp_status TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE employee_master (
        emp_id TEXT PRIMARY KEY,
        org_short_name TEXT,
        emp_name TEXT NOT NULL,
        emp_email TEXT UNIQUE,
        emp_role TEXT,
        emp_department TEXT,
        emp_phone TEXT,
        emp_status TEXT,
        emp_joining_date TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (org_short_name) REFERENCES organization_master(org_short_name)
      )
    ''');

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
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (org_short_name) REFERENCES organization_master(org_short_name)
      )
    ''');

    await db.execute('''
      CREATE TABLE project_site_mapping (
        project_site_id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        project_site_name TEXT,
        project_site_lat TEXT,
        project_site_long TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE employee_attendance (
        att_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        att_timestamp TEXT NOT NULL,
        att_latitude REAL,
        att_longitude REAL,
        att_geofence_name TEXT,
        project_id TEXT,
        att_notes TEXT,
        att_status TEXT CHECK(att_status IN ('checkIn', 'checkOut')),
        verification_type TEXT,
        is_verified INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (emp_id) REFERENCES user(emp_id),
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

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
        FOREIGN KEY (emp_id) REFERENCES user(emp_id),
        FOREIGN KEY (mgr_emp_id) REFERENCES user(emp_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE employee_leaves (
        leave_id TEXT PRIMARY KEY,
        emp_id TEXT NOT NULL,
        mgr_emp_id TEXT,
        leave_from_date TEXT,
        leave_to_date TEXT,
        leave_type TEXT,
        leave_justification TEXT,
        leave_approval_status TEXT,
        manager_comments TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (emp_id) REFERENCES user(emp_id),
        FOREIGN KEY (mgr_emp_id) REFERENCES user(emp_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE employee_mapped_projects (
        emp_id TEXT NOT NULL,
        project_id TEXT NOT NULL,
        mapping_status TEXT CHECK(mapping_status IN ('active', 'deactive')),
        created_at TEXT,
        updated_at TEXT,
        PRIMARY KEY (emp_id, project_id),
        FOREIGN KEY (emp_id) REFERENCES user(emp_id),
        FOREIGN KEY (project_id) REFERENCES project_master(project_id)
      )
    ''');

    // Current user session table
    await db.execute('''
      CREATE TABLE current_user (
        id INTEGER PRIMARY KEY,
        user_data TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // In DBHelper onCreate
    await db.execute('''
  CREATE TABLE geofence_master (
    geo_id TEXT PRIMARY KEY,
    goe_name TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    radius_meters REAL NOT NULL,
    is_active INTEGER DEFAULT 1,
    address TEXT,
    created_at TEXT,
    updated_at TEXT
  )
''');

    // Seed dummy data
    await _seedFromJson(db);
    // await seedGeofences(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future upgrade logic (add columns, migrate data)
    if (oldVersion < 2) {
      // Example: add new column
      await db.execute(
        'ALTER TABLE employee_regularization ADD COLUMN supporting_docs TEXT',
      );
    }
  }

  Future<void> _seedFromJson(Database db) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/dummy_data.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);

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
      await _insertTableData(
        db,
        'project_master',
        data['project_master'] ?? [],
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
      await _insertTableData(
        db,
        'running_serial_number',
        data['running_serial_number'] ?? [],
      );

      await _insertTableData(
        db,
        'geofence_master',
        data['geofence_master'] ?? [],
      );

      print("✅ All tables seeded successfully from dummy_data.json!");
    } catch (e) {
      print("❌ Error seeding data: $e");
    }
  }

  Future<void> _insertTableData(
    Database db,
    String tableName,
    List<dynamic> dataList,
  ) async {
    for (var item in dataList) {
      try {
        final Map<String, Object?> row = Map<String, Object?>.from(item);
        await db.insert(
          tableName,
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print("Error inserting into $tableName: $e");
      }
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

  // Clear login session
  Future<void> clearCurrentUser() async {
    final db = await database;
    await db.delete('current_user');
  }
}

// // lib/core/database/db_helper.dart
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('nutantek.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future<void> _createDB(Database db, int version) async {
//     // 1. user table
//     await db.execute('''
//       CREATE TABLE user (
//         emp_id TEXT PRIMARY KEY,
//         email_id TEXT UNIQUE NOT NULL,
//         password TEXT,
//         mpin TEXT,
//         otp TEXT,
//         otp_expiry_time INTEGER,
//         emp_status TEXT, -- active / deactive
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 2. organization_master
//     await db.execute('''
//       CREATE TABLE organization_master (
//         org_id TEXT PRIMARY KEY,
//         org_name TEXT,
//         org_email TEXT UNIQUE,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 3. employee_master
//     await db.execute('''
//       CREATE TABLE employee_master (
//         emp_id TEXT PRIMARY KEY,
//         org_id TEXT NOT NULL,
//         emp_name TEXT NOT NULL,
//         emp_email TEXT UNIQUE NOT NULL,
//         emp_role TEXT,
//         emp_department TEXT,
//         emp_phone TEXT,
//         check_in_out_status TEXT,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 4. project_master
//     await db.execute('''
//       CREATE TABLE project_master (
//         project_id TEXT PRIMARY KEY,
//         project_name TEXT NOT NULL,
//         project_site TEXT,
//         client_name TEXT,
//         client_location TEXT,
//         client_contact TEXT,
//         project_site_lat TEXT,
//         project_site_long TEXT,
//         mng_name TEXT,
//         mng_email TEXT,
//         mng_contact TEXT,
//         project_description TEXT,
//         project_techstack TEXT,
//         project_assigned_date TEXT,
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 5. employee_attendance
//     await db.execute('''
//       CREATE TABLE employee_attendance (
//         att_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         att_date TEXT NOT NULL,
//         att_timestamp TEXT NOT NULL,
//         att_latitude REAL,
//         att_longitude REAL,
//         att_geofence_name TEXT, -- geofence name like nic office, nutantekoffice
//         att_project_id TEXT,
//         att_notes TEXT,
//         att_status TEXT, -- checkin / checkout
//         verification_type TEXT,
//         is_verified INTEGER, -- 0/1
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 6. employee_regularization
//     await db.execute('''
//   CREATE TABLE employee_regularization (
//     reg_id TEXT PRIMARY KEY,
//     emp_id TEXT NOT NULL,
//     reg_applied_for_date TEXT NOT NULL,        -- Date jiske liye regularization
//     reg_date_applied TEXT NOT NULL,            -- Kab apply kiya gaya
//     reg_type TEXT NOT NULL,                    -- 'Full Day', 'Check-in Only', 'Check-out Only'
//     reg_justification TEXT NOT NULL,           -- Employee ka reason
//     checkin_time TEXT,                         -- Agar partial hai toh actual checkin time
//     checkout_time TEXT,                        -- Agar partial hai toh actual checkout time
//     shortfall_time TEXT,                       -- Kitna late/shortfall
//     reg_approval_status TEXT DEFAULT 'pending', -- pending / approved / rejected
//     manager_remarks TEXT,                      -- Manager ka comment (approve/reject pe)
//     created_at TEXT NOT NULL,
//     updated_at TEXT NOT NULL,
//     FOREIGN KEY (emp_id) REFERENCES employee_master (emp_id) ON DELETE CASCADE
//   )
// ''');

//     // 7. employee_leaves
//     await db.execute('''
//       CREATE TABLE employee_leaves (
//         leave_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         leave_from_date TEXT,
//         leave_to_date TEXT,
//         leave_type TEXT,
//         leave_approval_status TEXT,
//         leave_justification TEXT,
//         manager_comments TEXT
//       )
//     ''');

//     // 8. user_roles
//     await db.execute('''
//       CREATE TABLE user_roles (
//         role_id INTEGER PRIMARY KEY, -- No AUTOINCREMENT as per document
//         role_name TEXT NOT NULL
//       )
//     ''');

//     // 9. employee_mapped_projects
//     await db.execute('''
//       CREATE TABLE employee_mapped_projects (
//         emp_id TEXT NOT NULL,
//         project_id TEXT NOT NULL,
//         mapping_status TEXT -- active / deactive
//       )
//     ''');

//     // 10. employee_shifts
//     await db.execute('''
//       CREATE TABLE employee_shifts (
//         emp_id TEXT NOT NULL,
//         shift_id TEXT
//       )
//     ''');

//     // 11. employee_roles_mapping
//     await db.execute('''
//       CREATE TABLE employee_roles_mapping (
//         emp_id TEXT NOT NULL,
//         role_id TEXT
//       )
//     ''');

//     // 12. shift_master
//     await db.execute('''
//       CREATE TABLE shift_master (
//         shift_id TEXT PRIMARY KEY,
//         shift_name TEXT,
//         shift_start_time TEXT,
//         shift_end_time TEXT
//       )
//     ''');

//     // 13. current_user (for login session)
//     await db.execute('''
//       CREATE TABLE current_user (
//         id INTEGER PRIMARY KEY,
//         user_data TEXT
//       )
//     ''');

//     // Seed dummy data from JSON
//     await _seedFromJson(db);
//   }

//   Future<void> _seedFromJson(Database db) async {
//     try {
//       final String jsonString = await rootBundle.loadString(
//         'assets/data/dummy_data.json',
//       );
//       final Map<String, dynamic> data = jsonDecode(jsonString);

//       // Insert data for each table
//       await _insertTableData(db, 'user', data['user']);
//       await _insertTableData(
//         db,
//         'organization_master',
//         data['organization_master'],
//       );
//       await _insertTableData(db, 'employee_master', data['employee_master']);
//       await _insertTableData(db, 'project_master', data['project_master']);
//       await _insertTableData(
//         db,
//         'employee_attendance',
//         data['employee_attendance'],
//       );
//       await _insertTableData(
//         db,
//         'employee_regularization',
//         data['employee_regularization'],
//       );
//       await _insertTableData(db, 'employee_leaves', data['employee_leaves']);
//       await _insertTableData(db, 'user_roles', data['user_roles']);
//       await _insertTableData(
//         db,
//         'employee_mapped_projects',
//         data['employee_mapped_projects'],
//       );
//       await _insertTableData(db, 'employee_shifts', data['employee_shifts']);
//       await _insertTableData(
//         db,
//         'employee_roles_mapping',
//         data['employee_roles_mapping'],
//       );
//       await _insertTableData(db, 'shift_master', data['shift_master']);

//       print("✅ All tables seeded successfully from dummy_data.json!");
//     } catch (e) {
//       print("❌ Error seeding data: $e");
//       await _manualFallbackSeed(db);
//     }
//   }

//   Future<void> _insertTableData(
//     Database db,
//     String tableName,
//     List<dynamic>? dataList,
//   ) async {
//     if (dataList == null || dataList.isEmpty) return;

//     for (var item in dataList) {
//       try {
//         await db.insert(
//           tableName,
//           item,
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//       } catch (e) {
//         print("Error inserting $tableName: $e");
//       }
//     }
//   }

//   Future<void> _manualFallbackSeed(Database db) async {
//     // Minimal fallback data if JSON fails
//     await db.insert('user', {
//       'emp_id': 'EMP001',
//       'email_id': 'samal@nutantek.com',
//       'password': 'pass123',
//       'emp_status': 'active',
//     });

//     await db.insert('employee_master', {
//       'emp_id': 'EMP001',
//       'org_id': 'ORG001',
//       'emp_name': 'Vainyala Samal',
//       'emp_email': 'samal@nutantek.com',
//       'emp_role': 'Employee',
//       'emp_department': 'Mobile Development',
//     });
//   }

//   // Save logged in user session
//   Future<void> saveCurrentUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   // Get logged in user
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

// // lib/core/database/db_helper.dart
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('nutantek.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future<void> _createDB(Database db, int version) async {
//     // 1. user table
//     await db.execute('''
//       CREATE TABLE user (
//         emp_id TEXT PRIMARY KEY,
//         email_id TEXT UNIQUE NOT NULL,
//         password TEXT,
//         mpin TEXT,
//         otp TEXT,
//         otp_expiry_time INTEGER,
//         emp_status TEXT, -- active / deactive
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 2. organization_master
//     await db.execute('''
//       CREATE TABLE organization_master (
//         org_id TEXT PRIMARY KEY,
//         org_name TEXT,
//         org_email TEXT UNIQUE,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 3. employee_master
//     await db.execute('''
//       CREATE TABLE employee_master (
//         emp_id TEXT PRIMARY KEY,
//         org_id TEXT NOT NULL,
//         emp_name TEXT NOT NULL,
//         emp_email TEXT UNIQUE NOT NULL,
//         emp_role TEXT,
//         emp_department TEXT,
//         emp_phone TEXT,
//         check_in_out_status TEXT,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 4. project_master
//     await db.execute('''
//       CREATE TABLE project_master (
//         project_id TEXT PRIMARY KEY,
//         project_name TEXT NOT NULL,
//         project_site TEXT,
//         client_name TEXT,
//         client_location TEXT,
//         client_contact TEXT,
//         project_site_lat TEXT,
//         project_site_long TEXT,
//         mng_name TEXT,
//         mng_email TEXT,
//         mng_contact TEXT,
//         project_description TEXT,
//         project_techstack TEXT,
//         project_assigned_date TEXT,
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 5. employee_attendance
//     await db.execute('''
//       CREATE TABLE employee_attendance (
//         att_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         att_date TEXT NOT NULL,
//         att_timestamp TEXT NOT NULL,
//         att_latitude REAL,
//         att_longitude REAL,
//         att_geofence_name TEXT,
//         att_project_id TEXT,
//         att_notes TEXT,
//         att_status TEXT, -- checkin / checkout
//         verification_type TEXT,
//         is_verified INTEGER, -- 0/1
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 6. employee_regularization
//     await db.execute('''
//       CREATE TABLE employee_regularization (
//         emp_id TEXT NOT NULL,
//         reg_date_applied TEXT,
//         reg_applied_for_date TEXT,
//         reg_justification TEXT,
//         reg_approval_status TEXT, -- pending/approved/rejected
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 7. employee_leaves
//     await db.execute('''
//       CREATE TABLE employee_leaves (
//         leave_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         leave_from_date TEXT,
//         leave_to_date TEXT,
//         leave_type TEXT,
//         leave_approval_status TEXT,
//         leave_justification TEXT,
//         manager_comments TEXT
//       )
//     ''');

//     // 8. user_roles
//     await db.execute('''
//       CREATE TABLE user_roles (
//         role_id INTEGER PRIMARY KEY,
//         role_name TEXT NOT NULL
//       )
//     ''');

//     // 9. employee_mapped_projects
//     await db.execute('''
//       CREATE TABLE employee_mapped_projects (
//         emp_id TEXT NOT NULL,
//         project_id TEXT NOT NULL,
//         mapping_status TEXT -- active / deactive
//       )
//     ''');

//     // 10. employee_shifts
//     await db.execute('''
//       CREATE TABLE employee_shifts (
//         emp_id TEXT NOT NULL,
//         shift_id TEXT
//       )
//     ''');

//     // 11. employee_roles_mapping
//     await db.execute('''
//       CREATE TABLE employee_roles_mapping (
//         emp_id TEXT NOT NULL,
//         role_id TEXT
//       )
//     ''');

//     // 12. shift_master
//     await db.execute('''
//       CREATE TABLE shift_master (
//         shift_id TEXT PRIMARY KEY,
//         shift_name TEXT,
//         shift_start_time TEXT,
//         shift_end_time TEXT
//       )
//     ''');

//     // 13. current_user (for login session)
//     await db.execute('''
//       CREATE TABLE current_user (
//         id INTEGER PRIMARY KEY,
//         user_data TEXT
//       )
//     ''');

//     // Seed full data from JSON
//     await _seedFromJson(db);
//   }

//   Future<void> _seedFromJson(Database db) async {
//     try {
//       final String jsonString = await rootBundle.loadString(
//         'assets/data/dummy_data.json',
//       );
//       final Map<String, dynamic> data = jsonDecode(jsonString);

//       final List<String> tables = [
//         'user',
//         'organization_master',
//         'employee_master',
//         'project_master',
//         'employee_attendance',
//         'employee_regularization',
//         'employee_leaves',
//         'user_roles',
//         'employee_mapped_projects',
//         'employee_shifts',
//         'employee_roles_mapping',
//         'shift_master',
//       ];

//       for (String table in tables) {
//         if (data[table] != null && data[table] is List) {
//           for (var item in data[table]) {
//             await db.insert(
//               table,
//               item,
//               conflictAlgorithm: ConflictAlgorithm.replace,
//             );
//           }
//         }
//       }

//       print("✅ All tables seeded successfully from dummy_data.json!");
//     } catch (e) {
//       print("❌ Error seeding data: $e");
//       // Fallback: Manual minimal seed if JSON fails
//       await _manualMinimalSeed(db);
//     }
//   }

//   Future<void> _manualMinimalSeed(Database db) async {
//     // Minimal data for testing if JSON not found
//     await db.insert('user', {
//       'emp_id': 'EMP001',
//       'email_id': 'samal@nutantek.com',
//       'password': 'pass123',
//       'emp_status': 'active',
//     });

//     await db.insert('employee_master', {
//       'emp_id': 'EMP001',
//       'org_id': 'ORG001',
//       'emp_name': 'Vainyala Samal',
//       'emp_email': 'samal@nutantek.com',
//       'emp_role': 'Employee',
//       'emp_department': 'Mobile Development',
//     });
//   }

//   Future<void> saveCurrentUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
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

//   Future<void> clearCurrentUser() async {
//     final db = await database;
//     await db.delete('current_user');
//   }
// }

// // lib/core/database/db_helper.dart
// import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('nutantek.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future<void> _createDB(Database db, int version) async {
//     // 1. user table
//     await db.execute('''
//       CREATE TABLE user (
//         emp_id TEXT PRIMARY KEY,
//         email_id TEXT UNIQUE NOT NULL,
//         password TEXT,
//         mpin TEXT,
//         otp TEXT,
//         otp_expiry_time INTEGER,
//         emp_status TEXT,
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 2. organization_master
//     await db.execute('''
//       CREATE TABLE organization_master (
//         org_id TEXT PRIMARY KEY,
//         org_name TEXT,
//         org_email TEXT UNIQUE,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 3. employee_master
//     await db.execute('''
//       CREATE TABLE employee_master (
//         emp_id TEXT PRIMARY KEY,
//         org_id TEXT NOT NULL,
//         emp_name TEXT NOT NULL,
//         emp_email TEXT UNIQUE NOT NULL,
//         emp_role TEXT,
//         emp_department TEXT,
//         emp_phone TEXT,
//         check_in_out_status TEXT,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 4. project_master
//     await db.execute('''
//       CREATE TABLE project_master (
//         project_id TEXT PRIMARY KEY,
//         project_name TEXT NOT NULL,
//         project_site TEXT,
//         client_name TEXT,
//         client_location TEXT,
//         client_contact TEXT,
//         project_site_lat TEXT,
//         project_site_long TEXT,
//         mng_name TEXT,
//         mng_email TEXT,
//         mng_contact TEXT,
//         project_description TEXT,
//         project_techstack TEXT,
//         project_assigned_date TEXT,
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 5. employee_attendance
//     await db.execute('''
//       CREATE TABLE employee_attendance (
//         att_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         att_date TEXT NOT NULL,
//         att_timestamp TEXT NOT NULL,
//         att_latitude REAL,
//         att_longitude REAL,
//         att_geofence_name TEXT,
//         att_project_id TEXT,
//         att_notes TEXT,
//         att_status TEXT,
//         verification_type TEXT,
//         is_verified INTEGER,
//         created_at TEXT,
//         updated_at TEXT
//       )
//     ''');

//     // 6. employee_regularization
//     await db.execute('''
//       CREATE TABLE employee_regularization (
//         emp_id TEXT NOT NULL,
//         reg_date_applied TEXT,
//         reg_applied_for_date TEXT,
//         reg_justification TEXT,
//         reg_approval_status TEXT,
//         created_at TEXT NOT NULL,
//         updated_at TEXT
//       )
//     ''');

//     // 7. employee_leaves
//     await db.execute('''
//       CREATE TABLE employee_leaves (
//         leave_id TEXT PRIMARY KEY,
//         emp_id TEXT NOT NULL,
//         leave_from_date TEXT,
//         leave_to_date TEXT,
//         leave_type TEXT,
//         leave_approval_status TEXT,
//         leave_justification TEXT,
//         manager_comments TEXT
//       )
//     ''');

//     // 8. user_roles
//     await db.execute('''
//       CREATE TABLE user_roles (
//         role_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         role_name TEXT NOT NULL
//       )
//     ''');

//     // 9. employee_mapped_projects
//     await db.execute('''
//       CREATE TABLE employee_mapped_projects (
//         emp_id TEXT NOT NULL,
//         project_id TEXT NOT NULL,
//         mapping_status TEXT
//       )
//     ''');

//     // 10. employee_shifts
//     await db.execute('''
//       CREATE TABLE employee_shifts (
//         emp_id TEXT NOT NULL,
//         shift_id TEXT
//       )
//     ''');

//     // 11. employee_roles_mapping
//     await db.execute('''
//       CREATE TABLE employee_roles_mapping (
//         emp_id TEXT NOT NULL,
//         role_id TEXT
//       )
//     ''');

//     // 12. shift_master
//     await db.execute('''
//       CREATE TABLE shift_master (
//         shift_id TEXT PRIMARY KEY,
//         shift_name TEXT,
//         shift_start_time TEXT,
//         shift_end_time TEXT
//       )
//     ''');

//     // 13. current_user (for login session)
//     await db.execute('''
//       CREATE TABLE current_user (
//         id INTEGER PRIMARY KEY,
//         user_data TEXT
//       )
//     ''');

//     // Seed dummy data
//     await _seedDummyData(db);
//   }

//   Future<void> _seedDummyData(Database db) async {
//     // Organization
//     await db.insert('organization_master', {
//       'org_id': 'ORG001',
//       'org_name': 'Nutantek Solutions',
//       'org_email': 'info@nutantek.com',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     // Users
//     await db.insert('user', {
//       'emp_id': 'EMP001',
//       'email_id': 'samal@nutantek.com',
//       'password': 'pass123',
//       'mpin': '1234',
//       'emp_status': 'active',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     await db.insert('user', {
//       'emp_id': 'EMP002',
//       'email_id': 'raj@nutantek.com',
//       'password': 'manager123',
//       'mpin': '5678',
//       'emp_status': 'active',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     // Employee Master
//     await db.insert('employee_master', {
//       'emp_id': 'EMP001',
//       'org_id': 'ORG001',
//       'emp_name': 'Vainyala Samal',
//       'emp_email': 'samal@nutantek.com',
//       'emp_role': 'Employee',
//       'emp_department': 'Mobile Development',
//       'emp_phone': '9876543210',
//       'check_in_out_status': 'checked_in',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     await db.insert('employee_master', {
//       'emp_id': 'EMP002',
//       'org_id': 'ORG001',
//       'emp_name': 'Raj Sharma',
//       'emp_email': 'raj@nutantek.com',
//       'emp_role': 'Manager',
//       'emp_department': 'Management',
//       'emp_phone': '9123456780',
//       'check_in_out_status': 'checked_in',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     // Projects
//     await db.insert('project_master', {
//       'project_id': 'P001',
//       'project_name': 'Nutantek Office App',
//       'project_site': 'Nutantek Head Office',
//       'client_name': 'Internal',
//       'client_location': 'Bhubaneswar',
//       'project_site_lat': '20.2961',
//       'project_site_long': '85.8245',
//       'mng_name': 'Raj Sharma',
//       'mng_email': 'raj@nutantek.com',
//       'project_description': 'Attendance App',
//       'project_techstack': 'Flutter + MariaDB',
//       'project_assigned_date': '2025-11-01',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String(),
//     });

//     // Roles
//     await db.insert('user_roles', {'role_name': 'Employee'});
//     await db.insert('user_roles', {'role_name': 'Manager'});

//     // Mapping
//     await db.insert('employee_mapped_projects', {
//       'emp_id': 'EMP001',
//       'project_id': 'P001',
//       'mapping_status': 'active',
//     });
//   }

//   // Save current logged in user
//   Future<void> saveCurrentUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   // Get current user
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

//   // Clear login
//   Future<void> clearCurrentUser() async {
//     final db = await database;
//     await db.delete('current_user');
//   }

//   Future<void> saveUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }
// }

// import 'dart:convert';

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('nutantek.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE current_user (
//         id INTEGER PRIMARY KEY,
//         user_data TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE attendance (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id TEXT,
//         date TEXT,
//         check_in TEXT,
//         check_out TEXT,
//         status TEXT
//       )
//     ''');
//   }

//   Future<void> saveUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(user),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<Map<String, dynamic>?> getUser() async {
//     final db = await database;
//     final result = await db.query('current_user');
//     if (result.isNotEmpty) {
//       return jsonDecode(result.first['user_data'] as String);
//     }
//     return null;
//   }

//   // YE METHOD ADD KAR DE — ERROR FIX HO JAYEGA
//   Future<void> clearUser() async {
//     final db = await database;
//     await db.delete('current_user');
//   }

//   // Optional: Attendance save/get methods
//   Future<void> saveAttendance(Map<String, dynamic> record) async {
//     final db = await database;
//     await db.insert('attendance', record);
//   }

//   Future<List<Map<String, dynamic>>> getAllAttendance() async {
//     final db = await database;
//     return await db.query('attendance');
//   }
// }

// // lib/core/database/db_helper.dart
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('nutantek.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         email TEXT,
//         role TEXT,
//         department TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE attendance (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id TEXT,
//         date TEXT,
//         check_in TEXT,
//         check_out TEXT,
//         status TEXT
//       )
//     ''');
//   }

//   // Save user
//   Future<void> saveUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert(
//       'users',
//       user,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Get user
//   Future<Map<String, dynamic>?> getUser() async {
//     final db = await database;
//     final maps = await db.query('users', limit: 1);
//     return maps.isNotEmpty ? maps.first : null;
//   }

//   // Save attendance
//   Future<void> saveAttendance(Map<String, dynamic> record) async {
//     final db = await database;
//     await db.insert('attendance', record);
//   }

//   // Get all attendance (manager ke liye)
//   Future<List<Map<String, dynamic>>> getAllAttendance() async {
//     final db = await database;
//     return await db.query('attendance');
//   }
// }

// // lib/core/database/database_helper.dart → rename kar de → db_helper.dart

// // File name: lib/core/database/db_helper.dart
// import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   // YE NAAM RAKH DE — DBHelper
//   static final DBHelper instance = DBHelper._init();
//   static Database? _database;

//   DBHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('attendance_app.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE current_user (
//         id INTEGER PRIMARY KEY,
//         user_data TEXT NOT NULL
//       )
//     ''');
//   }

//   Future<void> saveUser(Map<String, dynamic> userMap) async {
//     final db = await database;
//     await db.insert('current_user', {
//       'id': 1,
//       'user_data': jsonEncode(userMap),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<Map<String, dynamic>?> getUser() async {
//     final db = await database;
//     final result = await db.query(
//       'current_user',
//       where: 'id = ?',
//       whereArgs: [1],
//     );
//     if (result.isEmpty) return null;
//     return jsonDecode(result.first['user_data'] as String);
//   }

//   Future<void> clearUser() async {
//     final db = await database;
//     await db.delete('current_user');
//   }
// }
