import 'dart:convert';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/errors/exceptions.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';

class UserApi {
  final ApiService _apiService;

  UserApi(this._apiService);

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.postRequest(ApiLinks.logIn, {
        'phone': phone,
        'password': password,
      });

      return jsonDecode(response.body);
    } on ServerException catch (e) {
      return {'error': jsonDecode(e.message)['error'] ?? 'Server error'};
    } on ClientException catch (e) {
      return {'error': jsonDecode(e.message)['error'] ?? 'Client error'};
    } on NetworkException catch (e) {
      return {'error': e.message};
    } catch (e) {
      return {'error': 'An unexpected error occurred.'};
    }
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.postRequest(ApiLinks.signUp, data);
      return jsonDecode(response.body);
    } on ServerException catch (e) {
      return {'error': jsonDecode(e.message)['error'] ?? 'Server error'};
    } on ClientException catch (e) {
      return {'error': jsonDecode(e.message)['error'] ?? 'Client error'};
    } on NetworkException catch (e) {
      return {'error': e.message};
    } catch (e) {
      return {'error': 'An unexpected error occurred.'};
    }
  }
}
