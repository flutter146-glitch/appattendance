// lib/features/auth/presentation/providers/auth_notifier.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/data/repositories/auth_repository.dart';
import 'package:appattendance/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(); // Abhi Dio nahi chahiye, toh null pass
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  final AuthRepository repository;

  AuthNotifier(this.ref, this.repository) : super(const AsyncData(null)) {
    _checkCurrentUser();
  }

  /// App start pe check karta hai ki user already logged in hai ya nahi
  Future<void> _checkCurrentUser() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.getCurrentUser();
      state = AsyncData(user);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  /// Login logic - email/password se
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email.trim(), password);
      state = AsyncData(user);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      // Optional: Snackbar ya toast show karo (widget se handle karna better)
    }
  }

  /// Logout - session clear
  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  void updateUser(UserModel updated) {
    state = AsyncData(updated);
  }
}



// // lib/features/auth/presentation/providers/auth_notifier.dart

// import 'dart:convert';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
//   AuthNotifier() : super(const AsyncData(null)) {
//     checkLoginStatus();
//   }

//   String? _token;
//   String? get token => _token;

//   // Helper methods — login_screen ke liye
//   void setLoading(bool loading) {
//     if (loading) {
//       state = const AsyncLoading();
//     }
//   }

//   void setUser(Map<String, dynamic> user) {
//     state = AsyncData(user);
//   }

//   void setError(String error) {
//     state = AsyncError(error, StackTrace.current);
//   }

//   // Login
//   Future<void> login(String email, String password) async {
//     setLoading(true);

//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.125.110:3000/api/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "email": email.trim().toLowerCase(),
//           "password": password,
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         final user = data['user'] as Map<String, dynamic>;
//         final token = data['token'] as String;

//         _token = token;

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);
//         await prefs.setString('user_data', jsonEncode(user));

//         setUser(user);
//       } else {
//         setError(data['message'] ?? "Invalid email or password");
//       }
//     } catch (e) {
//       setError("No internet connection");
//     }
//   }

//   // Auto login
//   Future<void> checkLoginStatus() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       final userJson = prefs.getString('user_data');

//       if (token != null && userJson != null) {
//         _token = token;
//         final user = jsonDecode(userJson) as Map<String, dynamic>;
//         state = AsyncData(user);
//       }
//     } catch (e) {
//       state = const AsyncData(null);
//     }
//   }

//   // Logout
//   Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     state = const AsyncData(null);
//   }
// }

// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((
//       ref,
//     ) {
//       return AuthNotifier();
//     });










// // lib/features/auth/presentation/providers/auth_notifier.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class AuthNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
//   AuthNotifier() : super(const AsyncData(null));

//   bool get isLoading => state.isLoading;
//   String? _token;
//   String? get token => _token;

//   // Yeh methods add kar dena
//   void setLoading(bool loading) {
//     state = loading ? const AsyncLoading() : state;
//   }

//   void setUser(Map<String, dynamic> user) {
//     state = AsyncData(user);
//   }

//   void setError(String error) {
//     state = AsyncError(error, StackTrace.current);
//   }

//   // Login function
//   Future<void> login(String email, String password) async {
//     //setLoading(true);
//     state = const AsyncLoading();
//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.125.110:3000/api/login"), // Apna IP daal dena
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       final data = jsonDecode(response.body);

//       if (data['success'] == true) {
//         final user = data['user'];
//         final token = data['token'];
//         _token = token;

//         // Save to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);
//         await prefs.setString('user_data', jsonEncode(user));

//         state = AsyncData(user);
//       } else {
//         state = AsyncError(
//           data['message'] ?? "Login failed",
//           StackTrace.current,
//         );
//       }
//     } catch (e) {
//       state = AsyncError("No internet", StackTrace.current);
//     }
//   }

//   // Auto login on app start
//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final userJson = prefs.getString('user_data');

//     if (token != null && userJson != null) {
//       _token = token; // Token restore karo
//       state = AsyncData(jsonDecode(userJson));
//     }
//   }

//   // Logout
//   void logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     state = const AsyncData(null);
//   }
// }

// // Provider
// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((
//       ref,
//     ) {
//       final notifier = AuthNotifier();
//       notifier.checkLoginStatus();
//       return notifier;
//     });


//     Final Recommended Code (Copy-Paste Kar De)
// Dartfinal authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
//   return AuthNotifier()..checkLoginStatus();
// });
// Bonus: Agar future mein logout pe dispose bhi karna ho toh
// Dartfinal authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
//   final notifier = AuthNotifier()..checkLoginStatus();
  
//   // Jab provider dispose ho (app band) → cleanup
//   ref.onDispose(() {
//     // Agar koi listener ya stream hai toh cancel kar do
//   });

//   return notifier;
// });

// lib/features/auth/presentation/providers/auth_notifier.dart

// final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
//   final notifier = AuthNotifier();

//   // App start hote hi saved login check karega
//   // Safe hai kyunki async hai aur error handle kar lega
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     notifier.checkLoginStatus();
//   });

//   return notifier;
// });

// Ya phir aur bhi pro-level tareeka (Recommended)
// Dartfinal authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
//   final notifier = AuthNotifier();

//   // Best practice: App start pe turant check karo
//   // Riverpod ke andar hi safe hai
//   ref.onDispose(notifier.dispose); // Agar dispose method banaya ho toh

//   // Yeh sabse safe aur clean tareeka hai
//   notifier.checkLoginStatus();

//   return notifier;
// });

// Sabse Best & Final (Yeh Use Kar)
// Dartfinal authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
//   return AuthNotifier()..checkLoginStatus();
// });

// // lib/features/auth/presentation/providers/auth_notifier.dart

// import 'dart:convert';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
//   AuthNotifier() : super(const AsyncData(null));

//   bool get isLoading => state.isLoading;

//   Future<void> login(String email, String password) async {
//     state = const AsyncLoading();

//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.1.100:3000/api/login"), // Apna IP
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       final data = jsonDecode(response.body);

//       if (data['success'] == true) {
//         final user = data['user'];
//         final token = data['token']; // Yeh important hai!

//         // Token + User save kar do (shared_preferences ya Riverpod mein)
//         await _saveToken(token);
//         await _saveUser(user);

//         state = AsyncData(user);
//       } else {
//         state = AsyncError(
//           data['message'] ?? "Login failed",
//           StackTrace.current,
//         );
//       }
//     } catch (e) {
//       state = AsyncError("No internet", StackTrace.current);
//     }
//   }

//   // Token save karne ke liye
//   Future<void> _saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   Future<void> _saveUser(Map<String, dynamic> user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_data', jsonEncode(user));
//   }

//   // App start pe token load karna
//   Future<void> loadSavedUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final userJson = prefs.getString('user_data');

//     if (token != null && userJson != null) {
//       state = AsyncData(jsonDecode(userJson));
//     }
//   }

//   void logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     state = const AsyncData(null);
//   }
// }

// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<Map<String, dynamic>?>>((
//       ref,
//     ) {
//       return AuthNotifier();
//     });

// // // lib/features/auth/presentation/providers/auth_notifier.dart
// // import 'package:appattendance/core/database/db_helper.dart';
// // import 'package:appattendance/core/providers/role_provider.dart';
// // import 'package:appattendance/features/auth/domain/models/user_model.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class AuthNotifier extends AsyncNotifier<UserModel?> {
// //   @override
// //   Future<UserModel?> build() async {
// //     final userMap = await DBHelper.instance.getUser();
// //     if (userMap == null) return null;
// //     return UserModel.fromJson(userMap);
// //   }

// //   Future<void> login(String email, String password) async {
// //     state = const AsyncLoading();
// //     state = await AsyncValue.guard(() async {
// //       // Simulate API/DB login
// //       await Future.delayed(const Duration(seconds: 1));

// //       // Dummy check
// //       if (email == "employee@nutantek.com" && password == "123456") {
// //         final user = UserModel(
// //           id: "1",
// //           email: email,
// //           name: "Vainyala Samal",
// //           role: UserRole.employee,
// //           department: "Mobile Dev",
// //           token: "dummy-jwt-token-123456",
// //           projects: [],
// //         );
// //         await DBHelper.instance.saveUser(user.toJson());
// //         ref.read(roleProvider.notifier).setUser(user);
// //         return user;
// //       }

// //       if (email == "manager@nutantek.com" && password == "manager123") {
// //         final user = UserModel(
// //           id: "2",
// //           email: email,
// //           name: "Raj Sharma",
// //           role: UserRole.manager,
// //           department: "Management",
// //           projects: [],
// //         );
// //         await DBHelper.instance.saveUser(user.toJson());
// //         ref.read(roleProvider.notifier).setUser(user);
// //         return user;
// //       }

// //       throw "Invalid credentials";
// //     });
// //   }

// //   Future<void> logout() async {
// //     await DBHelper.instance.clearUser();
// //     state = const AsyncData(null);
// //     ref.read(roleProvider.notifier).setUser(null);
// //   }
// // }

// // final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
// //   return AuthNotifier();
// // });
