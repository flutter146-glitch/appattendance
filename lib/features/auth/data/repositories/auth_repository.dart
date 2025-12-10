// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:appattendance/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
