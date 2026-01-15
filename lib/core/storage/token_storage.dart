class TokenStorage {
  static String? _token;

  static Future<void> saveToken(String token) async {
    _token = token;
  }

  static String? get token => _token;

  static void clear() {
    _token = null;
  }
}
