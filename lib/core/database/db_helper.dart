// lib/core/database/db_helper.dart
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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        role TEXT,
        department TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        date TEXT,
        check_in TEXT,
        check_out TEXT,
        status TEXT
      )
    ''');
  }

  // Save user
  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user
  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final maps = await db.query('users', limit: 1);
    return maps.isNotEmpty ? maps.first : null;
  }

  // Save attendance
  Future<void> saveAttendance(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert('attendance', record);
  }

  // Get all attendance (manager ke liye)
  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    final db = await database;
    return await db.query('attendance');
  }
}

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
