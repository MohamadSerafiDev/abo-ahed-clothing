import 'dart:convert';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';

class UserApi {
  final ApiService _apiService;

  UserApi(this._apiService);

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await _apiService.postRequest(ApiLinks.logIn, {
      'phone': phone,
      'password': password,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': 'error',
        'code': response.statusCode,
        'message': 'Login failed',
      };
    }
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final response = await _apiService.postRequest(ApiLinks.signUp, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': 'error',
        'code': response.statusCode,
        'message': 'Signup failed',
      };
    }
  }
}
