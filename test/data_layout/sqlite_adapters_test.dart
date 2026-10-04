import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  sqfliteFfiInit();
  late SshDatabase database;

  setUp(() async {
    database = SshDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await database.open();
  });

  tearDown(() => database.close());

  test('opens versioned schema transactionally with foreign keys', () async {
    final db = await database.open();
    final foreignKeys = await db.rawQuery('PRAGMA foreign_keys');
    final version = await db.getVersion();
    final tables = await db.rawQuery(
      "SELECT name, sql FROM sqlite_master WHERE type = 'table' ORDER BY name",
    );

    expect(foreignKeys.single['foreign_keys'], 1);
    expect(version, SshDatabase.schemaVersion);
    expect(
      tables.map((row) => row['name']),
      containsAll(<String>[
        'ssh_profiles',
        'known_hosts',
        'credential_cleanup',
      ]),
    );
    final schema = tables.map((row) => row['sql']).join(' ').toLowerCase();
    expect(schema, isNot(contains('password')));
    expect(schema, isNot(contains('passphrase')));
    expect(schema, isNot(contains('private_key')));
  });

  test(
    'profile CRUD maps non-secret fields and has deterministic ordering',
    () async {
      final repository = SqliteProfilesRepository(
        database: database,
        credentialStore: _NoopCredentialStore(),
      );
      expect(await repository.getAll(), isEmpty);

      await repository.save(_profile('two', 'Zulu', DateTime.utc(2026, 2)));
      await repository.save(_profile('one', 'alpha', DateTime.utc(2026, 1)));
      await repository.save(
        _profile('one', 'Beta', DateTime.utc(2026, 1)).copyWith(
          host: 'renamed.invalid',
          credentialReference: const CredentialReference(
            'opaque-credential-id',
          ),
        ),
      );

      final profiles = await repository.getAll();
      expect(profiles.map((profile) => profile.name), <String>['Beta', 'Zulu']);
      expect(profiles.first.host, 'renamed.invalid');
      expect(profiles.first.label, 'Test');
      expect(profiles.first.startupSnippet, 'uptime');
      expect(profiles.first.sendUtf8Locale, isFalse);
      expect(profiles.first.credentialReference?.value, 'opaque-credential-id');

      await repository.delete('one');
      expect((await repository.getAll()).single.id, 'two');
    },
  );

  test(
    'known hosts use normalized endpoint plus exact algorithm key',
    () async {
      final repository = SqliteKnownHostsRepository(database: database);
      const endpoint = HostEndpoint(host: 'EXAMPLE.invalid.', port: 2222);
      final first = DateTime.utc(2026, 1, 2);
      final record = KnownHostRecord(
        endpoint: endpoint,
        algorithm: 'ssh-ed25519',
        fingerprint: 'SHA256:first',
        firstSeenAt: first,
        lastConfirmedAt: first,
      );

      expect(await repository.find(endpoint, record.algorithm), isNull);
      await repository.save(record);
      expect(
        (await repository.find(
          const HostEndpoint(host: 'example.invalid', port: 2222),
          'ssh-ed25519',
        ))?.fingerprint,
        'SHA256:first',
      );
      expect(await repository.find(endpoint, 'rsa-sha2-512'), isNull);
      expect(
        await repository.find(
          const HostEndpoint(host: 'example.invalid', port: 22),
          record.algorithm,
        ),
        isNull,
      );

      await repository.delete(endpoint, record.algorithm);
      expect(await repository.find(endpoint, record.algorithm), isNull);
    },
  );

  test(
    'failed credential cleanup is sanitized, retained, and retryable',
    () async {
      final credentials = _FailingCredentialStore();
      final repository = SqliteProfilesRepository(
        database: database,
        credentialStore: credentials,
      );
      await repository.save(
        _profile('one', 'Alpha', DateTime.utc(2026)).copyWith(
          credentialReference: const CredentialReference('opaque-cleanup-id'),
        ),
      );

      await expectLater(
        repository.delete('one'),
        throwsA(
          isA<RepositoryFailure>()
              .having((failure) => failure.code, 'code', 'credential_cleanup')
              .having(
                (failure) => failure.toString(),
                'message',
                isNot(contains(_FailingCredentialStore.sensitiveDiagnostic)),
              ),
        ),
      );
      expect(await repository.getAll(), isEmpty);
      expect(await repository.pendingCredentialCleanup(), [
        'opaque-cleanup-id',
      ]);

      credentials.fail = false;
      await repository.retryPendingCredentialCleanup();
      expect(await repository.pendingCredentialCleanup(), isEmpty);
    },
  );
}

SshProfile _profile(String id, String name, DateTime createdAt) => SshProfile(
  id: id,
  name: name,
  host: 'host.invalid',
  port: 22,
  username: 'operator',
  label: 'Test',
  startupSnippet: 'uptime',
  sendUtf8Locale: false,
  credentialReference: const CredentialReference('opaque-default-id'),
  createdAt: createdAt,
  updatedAt: createdAt,
);

final class _NoopCredentialStore implements SecureCredentialStore {
  @override
  Future<bool> contains(CredentialReference reference) async => false;
  @override
  Future<void> delete(CredentialReference reference) async {}
  @override
  Future<String?> read(CredentialReference reference) async => null;
  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}

final class _FailingCredentialStore implements SecureCredentialStore {
  static const sensitiveDiagnostic = 'sensitive-backend-diagnostic';
  var fail = true;

  @override
  Future<void> delete(CredentialReference reference) async {
    if (fail) throw StateError(sensitiveDiagnostic);
  }

  @override
  Future<bool> contains(CredentialReference reference) async => false;
  @override
  Future<String?> read(CredentialReference reference) async => null;
  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}
