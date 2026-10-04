import '../value_objects/credential.dart';

abstract interface class SecureCredentialStore {
  Future<void> write(CredentialReference reference, String secret);

  Future<String?> read(CredentialReference reference);

  Future<bool> contains(CredentialReference reference);

  Future<void> delete(CredentialReference reference);
}
