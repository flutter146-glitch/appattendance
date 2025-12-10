// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:appattendance/features/auth/data/repositories/auth_repository.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<void> logout() async {
    // Clear token, etc.
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return null; // ya shared prefs se
  }
}

// // lib/features/auth/data/repositories/auth_repository_impl.dart
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:dio/dio.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final Dio dio;

//   AuthRepositoryImpl(this.dio);

//   @override
//   Future<UserModel> login(String email, String password) async {
//     final response = await dio.post(
//       '/auth/login',
//       data: {'email': email, 'password': password},
//     );

//     return UserModel.fromJson(response.data['data']);
//   }
// }
