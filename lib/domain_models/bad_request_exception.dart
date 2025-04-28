class BadRequestException implements Exception {
  const BadRequestException(this.message);

  final String message;

  @override
  String toString() => 'BadRequestException: $message';
}
