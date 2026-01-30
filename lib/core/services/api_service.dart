import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:get/get.dart';

class ApiService extends GetConnect implements GetxService {
  final storage = Get.find<StorageService>();

  // Base URL for Abu Ahed Backend
  final String baseUrlAddress = "https://api.abuahed.com/v1";

  @override
  void onInit() {
    baseUrl = baseUrlAddress;

    // 1. Request Modifier: Automatically add Token to every request
    httpClient.addRequestModifier<dynamic>((request) {
      final token = storage.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // 2. Response Modifier: Handle global errors (like 401 Unauthorized)
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        // Token expired? Clear storage and go to login
        storage.logout();
        Get.offAllNamed('/login');
      }
      return response;
    });

    super.onInit();
  }

  // --- STANDARD OPERATIONS ---

  // GET Request
  Future<Response> getRequest(String endpoint) async {
    return await get(endpoint);
  }

  // POST Request
  Future<Response> postRequest(String endpoint, dynamic data) async {
    return await post(endpoint, data);
  }

  // PUT Request
  Future<Response> putRequest(String endpoint, dynamic data) async {
    return await put(endpoint, data);
  }

  // DELETE Request
  Future<Response> deleteRequest(String endpoint) async {
    return await delete(endpoint);
  }

  // SPECIAL: Multipart Post (For your Receipt Upload)
  Future<Response> uploadReceipt(
    String endpoint,
    List<int> imageBytes,
    String fileName,
  ) async {
    final form = FormData({
      'receipt': MultipartFile(imageBytes, filename: fileName),
    });
    return await post(endpoint, form);
  }
}
