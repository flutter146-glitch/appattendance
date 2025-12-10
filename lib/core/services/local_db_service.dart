// lib/core/services/local_db_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class LocalDB {
  static Map<String, dynamic> data = {};

  static Future<void> init() async {
    final String jsonString = await rootBundle.loadString(
      'lib/data/database.json',
    );
    data = jsonDecode(jsonString);
  }

  // Login
  static Map? getUserByEmail(String email) {
    return data['users'].firstWhere(
      (u) => u['email'] == email,
      orElse: () => null,
    );
  }

  // Employee dashboard
  static List getMyAttendance(String userId) {
    return data['attendance'].where((a) => a['userId'] == userId).toList();
  }

  // Manager dashboard
  static Map<String, dynamic> getTeamStats() {
    final employees = data['users']
        .where((u) => u['role'] == 'employee')
        .length;
    final today = DateTime.now().toString().split(' ')[0];
    final presentToday = data['attendance']
        .where((a) => a['date'] == today && a['checkIn'] != null)
        .length;
    return {
      'teamSize': employees,
      'todayPresent': presentToday,
      'todayAbsent': employees - presentToday,
      'totalProjects': data['projects'].length,
    };
  }
}
