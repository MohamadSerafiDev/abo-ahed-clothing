class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ClientException implements Exception {
  final String message;
  ClientException(this.message);
}
