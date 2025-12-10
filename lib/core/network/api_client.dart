// lib/core/network/api_client.dart
import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5000/api', // ← Apna port daal (5000 ya 3000)
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref));
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ),
  );

  return dio;
});
// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://10.0.2.2:5000/api', // ← Apna URL daal dena
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 120),
//       // headers: {'Content-Type': 'application/json'},
//     ),
//   );

//   // Add Auth Interceptor
//   dio.interceptors.add(AuthInterceptor(ref));
//   dio.interceptors.add(
//     LogInterceptor(
//       responseBody: true,
//       requestBody: true,
//       logPrint: (object) => debugPrint(object.toString()),
//     ),
//   );

//   return dio;
// });

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // SAHI TARIKA JAB AsyncNotifier USE KAR RAHE HO
    final authState = ref.read(authProvider);

    // authState AsyncValue hai → .value se UserModel? niklega
    final user = authState.value; // ← YEHI LINE CHANGE KI HAI!

    if (user?.token != null) {
      options.headers['Authorization'] = 'Bearer ${user!.token}';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      ref.read(authProvider.notifier).logout();
    }
    handler.next(err);
  }
}

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final user = ref.read(authProvider); // ← SAHI — direct UserModel? milega

//     if (user?.token != null) {
//       options.headers['Authorization'] = 'Bearer ${user!.token}';
//     }

//     handler.next(options); // ← SAHI
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       ref.read(authProvider.notifier).logout();
//     }
//     handler.next(err); // ← SAHI
//   }
// }

// class AuthInterceptor extends Interceptor {
//   final Ref ref;

//   AuthInterceptor(this.ref);

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // SAHI TARIKA — authProvider direct UserModel? deta hai (kyunki StateNotifier hai)
//     final user = ref.read(
//       authProvider,
//     ); // ← Yeh direct UserModel? hai, AsyncValue nahi

//     if (user?.token != null) {
//       options.headers['Authorization'] = 'Bearer ${user!.token}';
//     }

//     handler.next(options); // ← super.onRequest() ki jagah yeh use karo
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       // Token expired ya invalid → logout
//       ref.read(authProvider.notifier).logout();
//     }
//     handler.next(err);
//   }
// }

// class AuthInterceptor extends Interceptor {
//   final Ref ref;

//   AuthInterceptor(this.ref);

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final token = ref.read(authProvider)?.token;
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     super.onRequest(options, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       // Token expired → logout
//       ref.read(authProvider.notifier).logout();
//     }
//     super.onError(err, handler);
//   }
// }
