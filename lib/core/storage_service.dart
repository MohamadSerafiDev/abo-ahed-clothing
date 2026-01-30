import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role'; // e.g., 'admin' or 'customer'
  static const String _isLoggedInKey = 'is_logged_in';

  // This is called when the app starts
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // --- Token Operations ---
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setBool(_isLoggedInKey, true);
  }

  String? getToken() => _prefs.getString(_tokenKey);

  // --- Role Operations ---
  Future<void> saveRole(String role) async {
    await _prefs.setString(_roleKey, role);
  }

  String getRole() => _prefs.getString(_roleKey) ?? 'guest';

  // --- Status Checks ---
  bool isLoggedIn() => _prefs.getBool(_isLoggedInKey) ?? false;

  // --- Clear Storage (Logout) ---
  Future<void> logout() async {
    await _prefs.clear(); // Deletes everything
    // Or selectively: await _prefs.remove(_tokenKey);
  }
}
