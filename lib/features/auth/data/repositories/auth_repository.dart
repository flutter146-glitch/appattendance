// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:appattendance/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  /// Email aur password se login karta hai, UserModel return karta hai
  Future<UserModel> login(String email, String password);

  /// User ko logout karta hai (session clear)
  Future<void> logout();

  /// Current logged-in user ko local se load karta hai
  Future<UserModel?> getCurrentUser();
}

// // lib/features/auth/domain/repositories/auth_repository.dart
// import 'package:appattendance/features/auth/domain/models/user_model.dart';

// abstract class AuthRepository {
//   Future<UserModel> login(String email, String password);
//   Future<void> logout();
//   Future<UserModel?> getCurrentUser();
// }
