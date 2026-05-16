class ApiException implements Exception {
  final String message;
  final dynamic statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}