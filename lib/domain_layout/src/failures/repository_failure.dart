final class RepositoryFailure implements Exception {
  const RepositoryFailure(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'RepositoryFailure($code): $message';
}
