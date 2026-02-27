import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final StorageService storage;
  final Function(int statusCode)? onUnauthorized;

  ApiService({required this.storage, this.onUnauthorized});

  // Base URL for Abu Ahed Backend
  final String baseUrl = ApiLinks.BASE_URL;
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
        final dynamic data = jsonDecode(response.body);
        return ApiResponse(statusCode: response.statusCode, data: data);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          if (onUnauthorized != null) {
            onUnauthorized!(response.statusCode);
          }

          dynamic unauthorizedData = {};
          try {
            unauthorizedData = jsonDecode(response.body);
          } catch (_) {}

          return ApiResponse(
            statusCode: response.statusCode,
            data: unauthorizedData,
            error: 'Unauthorized',
          );
        }
        final dynamic data = jsonDecode(response.body);
        String error = 'Unknown error';
        if (data is Map<String, dynamic>) {
          error = (data['error'] ?? data['message'] ?? 'Unknown error')
              .toString();
        }
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

  // SPECIAL: Multipart POST with fields and multiple files
  Future<ApiResponse> multipartPostWithFiles(
    String endpoint, {
    required Map<String, String> fields,
    required List<String> filePaths,
    String fileFieldName = 'media',
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );

      final token = storage.getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.fields.addAll(fields);

      for (final path in filePaths) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            path,
            contentType: _getMediaType(path),
          ),
        );
      }
      log(request.fields.toString(), name: 'fields');
      for (var files in request.files) {
        log(files.toString(), name: 'file_info');
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      log(response.body, name: "multipart response");
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

  // SPECIAL: Multipart PUT with fields and multiple files
  Future<ApiResponse> multipartPutWithFiles(
    String endpoint, {
    required Map<String, String> fields,
    required List<String> filePaths,
    String fileFieldName = 'media',
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl$endpoint'),
      );

      final token = storage.getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.fields.addAll(fields);

      for (final path in filePaths) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            path,
            contentType: _getMediaType(path),
          ),
        );
      }

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
      
      final token = storage.getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'receipt',
          imageBytes,
          filename: fileName,
          contentType: _getMediaTypeFromFilename(fileName),
        ),
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
      
      final token = storage.getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          fieldName,
          imageBytes,
          filename: fileName,
          contentType: _getMediaTypeFromFilename(fileName),
        ),
      );

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      log(response.body, name: "multipart patch response");
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

  /// Returns the correct MediaType for a file based on its extension.
  MediaType _getMediaType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'heic':
        return MediaType('image', 'heic');
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'mov':
        return MediaType('video', 'quicktime');
      case 'avi':
        return MediaType('video', 'x-msvideo');
      case 'mkv':
        return MediaType('video', 'x-matroska');
      case 'wmv':
        return MediaType('video', 'x-ms-wmv');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  /// Returns MediaType from filename (for byte arrays)
  MediaType _getMediaTypeFromFilename(String fileName) {
    return _getMediaType(fileName);
  }
}

class ApiResponse<T> {
  final int statusCode;
  final T data;
  final String? error;

  ApiResponse({required this.statusCode, required this.data, this.error});
}
