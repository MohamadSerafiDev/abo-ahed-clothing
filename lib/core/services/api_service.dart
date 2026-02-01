import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:abo_abed_clothing/core/errors/exceptions.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final StorageService storage;
  final Function(int statusCode)? onUnauthorized;

  ApiService({required this.storage, this.onUnauthorized});

  // Base URL for Abu Ahed Backend
  final String baseUrl = "http://192.168.59.55:5000/api";
  final Duration _timeout = const Duration(minutes: 1);

  Map<String, String> _getHeaders() {
    final token = storage.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- STANDARD OPERATIONS ---

  // GET Request
  Future<http.Response> getRequest(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: _getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on http.ClientException catch (e) {
      throw ClientException('A client error occurred: ${e.message}');
    }
  }

  // POST Request
  Future<http.Response> postRequest(String endpoint, dynamic data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      log(response.body);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on http.ClientException catch (e) {
      throw ClientException('A client error occurred: ${e.message}');
    }
  }

  // PUT Request
  Future<http.Response> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on http.ClientException catch (e) {
      throw ClientException('A client error occurred: ${e.message}');
    }
  }

  // DELETE Request
  Future<http.Response> deleteRequest(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: _getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on http.ClientException catch (e) {
      throw ClientException('A client error occurred: ${e.message}');
    }
  }

  // Handle Response (Global Error Handling)
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      if (onUnauthorized != null) {
        onUnauthorized!(response.statusCode);
      }
      throw ServerException(response.body);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ClientException(response.body);
    } else if (response.statusCode >= 500) {
      throw ServerException(response.body);
    } else {
      return response;
    }
  }

  // SPECIAL: Multipart Post (For Receipt Upload)
  Future<http.Response> uploadReceipt(
    String endpoint,
    List<int> imageBytes,
    String fileName,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );
      request.headers.addAll(_getHeaders());

      request.files.add(
        http.MultipartFile.fromBytes('receipt', imageBytes, filename: fileName),
      );

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on http.ClientException catch (e) {
      throw ClientException('A client error occurred: ${e.message}');
    }
  }
}
