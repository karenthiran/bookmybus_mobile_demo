/// Thrown by [ApiClient] whenever the backend returns a non-2xx response,
/// or when the request itself fails (no network, timeout, etc).
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
