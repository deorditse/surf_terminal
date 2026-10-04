import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  test(
    'opaque reference generator creates UUID-shaped non-identifying keys',
    () {
      final reference = CredentialReferenceGenerator().create();

      expect(
        reference.value,
        matches(
          RegExp(
            r'^surf_terminal\.ssh\.password\.[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(reference.value, isNot(contains('host.invalid')));
      expect(reference.value, isNot(contains('operator')));
      expect(reference.value, isNot(contains('work')));
    },
  );

  test(
    'secure adapter delegates write, availability, read and delete',
    () async {
      final backend = _MemorySecureBackend();
      final store = FlutterSecureCredentialStore(backend: backend);
      const reference = CredentialReference('opaque-reference');

      await store.write(reference, 'fictional-value');
      expect(await store.contains(reference), isTrue);
      expect(await store.read(reference), 'fictional-value');
      await store.write(reference, 'fictional-replacement');
      expect(await store.read(reference), 'fictional-replacement');
      await store.delete(reference);
      expect(await store.contains(reference), isFalse);
    },
  );

  test(
    'secure adapter maps backend diagnostics to sanitized failures',
    () async {
      final store = FlutterSecureCredentialStore(backend: _ThrowingBackend());
      const reference = CredentialReference('opaque-reference');

      for (final operation in <Future<Object?> Function()>[
        () => store.write(reference, 'fictional-value'),
        () => store.read(reference),
        () => store.contains(reference),
        () => store.delete(reference),
      ]) {
        await expectLater(
          operation(),
          throwsA(
            isA<RepositoryFailure>()
                .having(
                  (failure) => failure.code,
                  'code',
                  startsWith('credential_'),
                )
                .having(
                  (failure) => failure.toString(),
                  'sanitized',
                  allOf(
                    isNot(contains('fictional-value')),
                    isNot(contains(_ThrowingBackend.backendDiagnostic)),
                  ),
                ),
          ),
        );
      }
    },
  );
}

final class _MemorySecureBackend implements SecureStorageBackend {
  final values = <String, String>{};

  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<bool> contains(String key) async => values.containsKey(key);
  @override
  Future<void> delete(String key) async => values.remove(key);
}

final class _ThrowingBackend implements SecureStorageBackend {
  static const backendDiagnostic = 'backend-contained-sensitive-diagnostic';
  Never _fail() => throw StateError(backendDiagnostic);

  @override
  Future<void> write(String key, String value) async => _fail();
  @override
  Future<String?> read(String key) async => _fail();
  @override
  Future<bool> contains(String key) async => _fail();
  @override
  Future<void> delete(String key) async => _fail();
}
