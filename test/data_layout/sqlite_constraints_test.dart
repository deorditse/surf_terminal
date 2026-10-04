import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  sqfliteFfiInit();

  test(
    'malformed profile rolls back and duplicate known host is replaced',
    () async {
      final database = SshDatabase(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
      final profiles = SqliteProfilesRepository(database: database);
      final malformed = SshProfile(
        id: 'malformed',
        name: 'Invalid',
        host: 'host.invalid',
        port: 70000,
        username: 'operator',
      );

      await expectLater(
        profiles.save(malformed),
        throwsA(
          isA<RepositoryFailure>().having(
            (failure) => failure.code,
            'code',
            'profile_save',
          ),
        ),
      );
      expect(await profiles.getAll(), isEmpty);

      final knownHosts = SqliteKnownHostsRepository(database: database);
      const endpoint = HostEndpoint(host: 'host.invalid', port: 22);
      final firstSeen = DateTime.utc(2026, 1);
      await knownHosts.save(
        KnownHostRecord(
          endpoint: endpoint,
          algorithm: 'ssh-ed25519',
          fingerprint: 'SHA256:first',
          firstSeenAt: firstSeen,
          lastConfirmedAt: firstSeen,
        ),
      );
      await knownHosts.save(
        KnownHostRecord(
          endpoint: endpoint,
          algorithm: 'ssh-ed25519',
          fingerprint: 'SHA256:replacement',
          firstSeenAt: firstSeen,
          lastConfirmedAt: DateTime.utc(2026, 2),
        ),
      );

      expect(
        (await knownHosts.find(endpoint, 'ssh-ed25519'))?.fingerprint,
        'SHA256:replacement',
      );
      final rows = await (await database.open()).query('known_hosts');
      expect(rows, hasLength(1));
      await database.close();
    },
  );
}
