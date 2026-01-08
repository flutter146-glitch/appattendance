// lib/core/api/api_endpoints.dart - COMPLETE VERSION
import 'package:flutter/cupertino.dart';
class ApiEndpoints {
  // Base URL - Change this to your server IP
  static const baseUrl = "https://d6af6c0bcf95.ngrok-free.app/api/v1";

  // Authentication
  static const login = "$baseUrl/auth/login";
  static const logout = "$baseUrl/auth/logout";

  // Employee
  static const employee = "$baseUrl/employee";
  static String getEmployee(String empId) => "$employee/$empId";

  // Attendance
  static const attendance = "$baseUrl/attendance";
  static String getAttendanceByEmpId(String empId) => "$attendance/$empId";
  static String getAttendanceByDateRange({
    required String empId,
    required String fromDate,
    required String toDate,
  }) => "$attendance?emp_id=$empId&from_date=$fromDate&to_date=$toDate";

  // Projects
  static const projects = "$baseUrl/projects";
  static String getProject(String projectId) => "$projects/$projectId";

  // Mapped Projects
  static const mappedProjects = "$baseUrl/emp_mapped_projects";
  static String getMappedProjects(String empId) => "$mappedProjects/$empId";

  // Regularization
  static const regularization = "$baseUrl/regularization";
  static String getRegularization(String empId) => "$regularization/$empId";

  // Leave
  static const leave = "$baseUrl/leaves";
  static String getLeaveByEmpId(String empId) => "$leave/$empId";

  // Attendance Analytics
  static const attendanceSummary = "$baseUrl/attendance_analytics/summary";
  static const attendanceDaily = "$baseUrl/attendance_analytics/daily";

  // Sync
  static const manualSync = "$baseUrl/sync/manual";
  static const nightlySync = "$baseUrl/sync/nightly";

  static const String attendanceAnalyticsSummary = "$baseUrl/attendance_analytics/summary";
  static const String attendanceAnalyticsDaily = "$baseUrl/attendance_analytics/daily";
}