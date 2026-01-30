import 'dart:convert';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final StorageService storage;
  final Function(int statusCode)? onUnauthorized;

  ApiService({required this.storage, this.onUnauthorized});

  // Base URL for Abu Ahed Backend
  final String baseUrl = "http://127.0.0.1/v1";

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
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }

  // POST Request
  Future<http.Response> postRequest(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // PUT Request
  Future<http.Response> putRequest(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // DELETE Request
  Future<http.Response> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }

  // Handle Response (Global Error Handling)
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      if (onUnauthorized != null) {
        onUnauthorized!(response.statusCode);
      }
    }
    return response;
  }

  // SPECIAL: Multipart Post (For Receipt Upload)
  Future<http.Response> uploadReceipt(
    String endpoint,
    List<int> imageBytes,
    String fileName,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );
    request.headers.addAll(_getHeaders());

    request.files.add(
      http.MultipartFile.fromBytes('receipt', imageBytes, filename: fileName),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }
}
