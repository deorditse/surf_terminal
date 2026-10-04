import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

abstract interface class SecureStorageBackend {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<bool> contains(String key);
  Future<void> delete(String key);
}

final class FlutterSecureStorageBackend implements SecureStorageBackend {
  FlutterSecureStorageBackend({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
            mOptions: MacOsOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  @override
  Future<String?> read(String key) => _storage.read(key: key);
  @override
  Future<bool> contains(String key) => _storage.containsKey(key: key);
  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

final class FlutterSecureCredentialStore implements SecureCredentialStore {
  FlutterSecureCredentialStore({required SecureStorageBackend backend})
    : // Public dependency name intentionally differs from the private field.
      // ignore: prefer_initializing_formals
      _backend = backend;

  factory FlutterSecureCredentialStore.platform() =>
      FlutterSecureCredentialStore(backend: FlutterSecureStorageBackend());

  final SecureStorageBackend _backend;

  @override
  Future<void> write(CredentialReference reference, String secret) async {
    try {
      await _backend.write(reference.value, secret);
    } on Object {
      throw const RepositoryFailure(
        'credential_write',
        'The credential could not be stored securely.',
      );
    }
  }

  @override
  Future<String?> read(CredentialReference reference) async {
    try {
      return await _backend.read(reference.value);
    } on Object {
      throw const RepositoryFailure(
        'credential_read',
        'The credential could not be accessed securely.',
      );
    }
  }

  @override
  Future<bool> contains(CredentialReference reference) async {
    try {
      return await _backend.contains(reference.value);
    } on Object {
      throw const RepositoryFailure(
        'credential_availability',
        'Credential availability could not be checked.',
      );
    }
  }

  @override
  Future<void> delete(CredentialReference reference) async {
    try {
      await _backend.delete(reference.value);
    } on Object {
      throw const RepositoryFailure(
        'credential_delete',
        'The credential could not be removed securely.',
      );
    }
  }
}
