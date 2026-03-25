/// Domain-level exception that replaces framework-specific errors (e.g. DioError)
/// in the core and presentation layers.
///
/// This ensures the domain and presentation layers remain pure Dart with no
/// dependency on HTTP libraries (AV 2.1.1, AV 1.2.4).
class AppException implements Exception {
  final String? message;
  final int? statusCode;
  final String? identifier;

  const AppException({
    this.message,
    this.statusCode,
    this.identifier,
  });

  @override
  String toString() {
    return 'AppException{message: $message, statusCode: $statusCode, identifier: $identifier}';
  }
}
