// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:appattendance/features/auth/data/repositories/auth_repository.dart';
import 'package:appattendance/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider (Dio null for local mode)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(); // Dio null pass kiya
});

// Yeh provider sab jagah se user state access karne ke liye use hota hai
// Auth state provider
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthNotifier(ref, repository);
    });
// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
//       (ref) => AuthNotifier(ref),
//     );

// // lib/features/auth/presentation/providers/auth_provider.dart
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
//       (ref) => AuthNotifier(ref),
//     );
