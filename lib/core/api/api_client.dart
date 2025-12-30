
// **Haan bhai, bilkul sahi samjha tune** — `api_client.dart` (jo Dio se bana hai) ki zarurat **abhi nahi hai**, lekin **future mein bahut zaroori ho jayegi** jab real backend (API) connect karna hoga.

// Main tujhe **simple language mein pura clear** karta hoon ki yeh kab, kyun, aur kaise use karna hai.

// ### Kab Use Karna Padega? (Timeline)

// | Stage of Project                  | Api_client.dart ki Zarurat? | Kyun?                                                                 |
// |-----------------------------------|------------------------------|-----------------------------------------------------------------------|
// | **Abhi (December 2025)**          | Nahi (Optional)              | Sab dummy_data.json + SQLite (local DB) se chal raha hai             |
// | **Jab real backend aayega**       | Haan (Mandatory)             | Login, check-in, leave apply, regularisation submit sab API se hoga  |
// | **Production launch ke time**     | Haan (Must)                  | Security (token), error handling, offline support ke liye            |
// | **Testing phase**                 | Haan (Recommended)           | Mock API calls ke liye (Dio interceptors se)                          |

// **Summary**:  
// - Abhi ke liye → **disable/comment kar do** (local DB use kar rahe ho)  
// - Jab backend ready ho → **bas uncomment + baseUrl change** kar dena  
// - Future-proof rehne ke liye **abhi se rakho** (code clean rahega)

// ### Kyun Jaruri Hai? (Reasons)

// 1. **Real Backend Integration**  
//    - Login → `/auth/login` (email/password → token + user)
//    - Check-in/out → `/attendance/check-in` (location, verification)
//    - Leave apply → `/leaves/apply`
//    - Regularisation submit → `/regularisation/apply`
//    - Team stats → `/attendance/team` (manager ke liye)

// 2. **Security & Best Practices**  
//    - Token attach (Authorization: Bearer)
//    - 401 error pe auto logout
//    - Timeout, retry, logging sab Dio se easy

// 3. **Future Offline Support**  
//    - API fail hone pe local DB se fallback
//    - Sync later (background job)

// 4. **Testing**  
//    - Mock Dio se unit tests easy (no real network)

// ### Kaise Use Karna Hoga? (Step-by-Step)

// #### 1. Abhi ke liye (Local DB Mode)
// `api_client.dart` ko **comment out** kar do ya **disable** rakho.


import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? params,
      }) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    final res = await http
        .get(uri)
        .timeout(const Duration(seconds: 60));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("GET failed");
    }
  }

  static Future<Map<String, dynamic>> post(
      String url,
      Map<String, dynamic> body,
      ) async {
    final res = await http
        .post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: 60));


    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("POST failed ${res.statusCode}");
    }
  }

}





// lib/core/api/api_client.dart
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://localhost:5000/api', // ← Apna port daal (5000 ya 3000)
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 20),
//     ),
//   );
//
//   dio.interceptors.add(AuthInterceptor(ref));
//   dio.interceptors.add(
//     LogInterceptor(
//       requestBody: true,
//       responseBody: true,
//       logPrint: (obj) => debugPrint(obj.toString()),
//     ),
//   );
//
//   return dio;
// });
//
// // lib/core/api/api_client.dart
//
// class AuthInterceptor extends Interceptor {
//   final Ref ref;
//
//   AuthInterceptor(this.ref);
//
//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // Token ab notifier se alag se milega
//     final authNotifier = ref.read(authProvider.notifier);
//     final token = authNotifier.token;
//
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     handler.next(options);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       ref.read(authProvider.notifier).logout();
//       // Optional: Navigate to login
//     }
//     handler.next(err);
//   }
// }

// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://10.0.2.2:5000/api', // ← Apna URL daal dena
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 120),
//       // headers: {'Content-Type': 'application/json'},
//     ),
//   );

// `auth_repository_impl.dart` mein Dio code ko comment kar do (jo maine pehle diya tha):
// ```dart
// // Dio part comment
// /*
// if (dio == null) throw Exception('Dio not initialized');
// final response = await dio!.post('/auth/login', data: {...});
// */
// ```

// #### 2. Jab Real API Aayega (Switch Karne ka Time)
// Bas yeh changes karo:

// 1. **pubspec.yaml** mein Dio confirm rakho:
//    ```yaml
//    dependencies:
//      dio: ^5.0.0
//    ```

// 2. **Dio Provider** activate karo:
//    ```dart
//    // lib/core/providers/dio_provider.dart
//    final dioProvider = Provider<Dio>((ref) {
//      final dio = Dio(
//        BaseOptions(
//          baseUrl: 'https://your-backend.com/api', // Real URL
//          connectTimeout: const Duration(seconds: 30),
//          receiveTimeout: const Duration(seconds: 30),
//        ),
//      );

//      // Token interceptor (auth ke baad)
//      dio.interceptors.add(InterceptorsWrapper(
//        onRequest: (options, handler) {
//          final token = ref.read(authProvider).value?.token;
//          if (token != null) {
//            options.headers['Authorization'] = 'Bearer $token';
//          }
//          return handler.next(options);
//        },
//        onError: (DioException e, handler) {
//          if (e.response?.statusCode == 401) {
//            ref.read(authProvider.notifier).logout();
//          }
//          return handler.next(e);
//        },
//      ));

//      return dio;
//    });
//    ```

// 3. **Repository Impl mein Dio activate karo**:
//    ```dart
//    @override
//    Future<UserModel> login(String email, String password) async {
//      final dio = ref.read(dioProvider); // ← Yeh activate
//      final response = await dio.post(
//        '/auth/login',
//        data: {'email': email, 'password': password},
//      );

//      final userJson = response.data['user'] as Map<String, dynamic>;
//      final token = response.data['token'] as String?;

//      final user = UserModel.fromJson(userJson);
//      // Save token if needed
//      return user;
//    }
//    ```

// 4. **AuthNotifier mein use**:
//    ```dart
//    final authRepositoryProvider = Provider<AuthRepository>((ref) {
//      final dio = ref.watch(dioProvider);
//      return AuthRepositoryImpl(dio: dio);
//    });
//    ```

// ### Summary (Tere Project ke liye)

// | Current Status | Api_client ki Zarurat? | Action Now | Future Action |
// |----------------|-------------------------|------------|---------------|
// | Dummy Data + SQLite | Nahi (optional rakho) | Comment out Dio code | Jab backend aaye, uncomment + baseUrl change |
// | Real API Ready | Haan (must) | — | Dio activate + token interceptor + API endpoints |

// **Recommendation**:  
// Abhi ke liye **api_client.dart** ko **rakho** (commented mode mein) — code future-proof rahega.  
// Jab backend milega (jaise 1-2 mahine baad), bas 5-10 lines change kar ke switch kar denge.

// Ab tu bol —  
// **AttendanceRepository** (checkIn, checkOut, getToday with DB) banaun?  
// **CheckInOutWidget** mein repository call + location dummy add karun?  
// **Regularisation/Leave** se shuru karun?

// Main ready hoon — **code abhi deta hoon!** 🚀

// App bilkul tere Nutantek live project jaisa chal raha hai bhai! 😎
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



