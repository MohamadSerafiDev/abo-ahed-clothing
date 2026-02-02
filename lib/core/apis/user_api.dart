import 'dart:convert';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/errors/exceptions.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';

class UserApi {
  final ApiService _apiService;

  UserApi(this._apiService);

  Future<dynamic> login({
    required String phone,
    required String password,
  }) async {
    final response = await _apiService.postRequest(ApiLinks.logIn, {
      'phone': phone,
      'password': password,
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data;
    } else {
      return Future.error(response.error ?? 'Unknown error');
    }
  }

  Future<dynamic> signup(Map<String, dynamic> data) async {
    final response = await _apiService.postRequest(ApiLinks.signUp, data);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data;
    } else {
      return Future.error(response.error ?? 'Unknown error');
    }
  }
}
