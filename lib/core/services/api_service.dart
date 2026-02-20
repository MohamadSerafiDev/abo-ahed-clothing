import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final StorageService storage;
  final Function(int statusCode)? onUnauthorized;

  ApiService({required this.storage, this.onUnauthorized});

  // Base URL for Abu Ahed Backend
  final String baseUrl = "http://192.168.1.110:5000/api";
  final Duration _timeout = const Duration(seconds: 45);

  Map<String, String> _getHeaders() {
    final token = storage.getToken();
    log(token.toString());
    log(storage.getRole());
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- STANDARD OPERATIONS ---

  // GET Request
  Future<ApiResponse> getRequest(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: _getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // POST Request
  Future<ApiResponse> postRequest(String endpoint, dynamic data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      // log(response.body);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // PUT Request
  Future<ApiResponse> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // PATCH Request
  Future<ApiResponse> patchRequest(String endpoint, dynamic data) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // DELETE Request
  Future<ApiResponse> deleteRequest(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: _getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // Handle Response (Global Error Handling)
  ApiResponse _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ApiResponse(statusCode: response.statusCode, data: data);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          if (onUnauthorized != null) {
            onUnauthorized!(response.statusCode);
          }

          Map<String, dynamic> unauthorizedData = {};
          try {
            unauthorizedData =
                jsonDecode(response.body) as Map<String, dynamic>;
          } catch (_) {}

          return ApiResponse(
            statusCode: response.statusCode,
            data: unauthorizedData,
            error: 'Unauthorized',
          );
        }
        final Map<String, dynamic> data = jsonDecode(response.body);
        final error = data['error'] ?? data['message'] ?? 'Unknown error';
        return ApiResponse(
          statusCode: response.statusCode,
          data: data,
          error: error,
        );
      }
    } catch (e) {
      return ApiResponse(
        statusCode: response.statusCode,
        data: {},
        error: e.toString(),
      );
    }
  }

  // SPECIAL: Multipart Post (For Receipt Upload)
  Future<ApiResponse> uploadReceipt(
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
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }

  // SPECIAL: Multipart PATCH (For Payment Image Upload)
  Future<ApiResponse> multipartPatch(
    String endpoint,
    List<int> imageBytes,
    String fileName, {
    String fieldName = 'paymentImage',
  }) async {
    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl$endpoint'),
      );
      request.headers.addAll(_getHeaders());

      request.files.add(
        http.MultipartFile.fromBytes(fieldName, imageBytes, filename: fileName),
      );

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        statusCode: 0,
        data: {},
        error: "check_your_internet_connection",
      );
    } on TimeoutException {
      return ApiResponse(statusCode: 0, data: {}, error: "time_out_exception");
    } catch (e) {
      return ApiResponse(statusCode: 0, data: {}, error: e.toString());
    }
  }
}

class ApiResponse<T> {
  final int statusCode;
  final T data;
  final String? error;

  ApiResponse({required this.statusCode, required this.data, this.error});
}
