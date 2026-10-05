import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/credential_coordinator.dart';

void main() {
  test(
    'secure write happens before profile advertises its reference',
    () async {
      final calls = <String>[];
      final profiles = _Profiles(calls);
      final credentials = _Credentials(calls);
      final coordinator = CredentialCoordinator(
        profiles: profiles,
        credentials: credentials,
        references: CredentialReferenceGenerator(),
      );

      await coordinator.save(
        profile: const SshProfile(
          id: 'p1',
          name: 'Host',
          host: 'host.test',
          port: 22,
          username: 'user',
        ),
        intent: const CredentialIntent.store(),
        secret: String.fromCharCode(120),
      );

      expect(calls, <String>['credential-write', 'profile-save']);
      expect(profiles.saved!.credentialReference, isNotNull);
    },
  );

  test('secure write failure never saves credential metadata', () async {
    final profiles = _Profiles(<String>[]);
    final credentials = _Credentials(<String>[])..failWrite = true;
    final coordinator = CredentialCoordinator(
      profiles: profiles,
      credentials: credentials,
      references: CredentialReferenceGenerator(),
    );

    await expectLater(
      coordinator.save(
        profile: const SshProfile(
          id: 'p1',
          name: 'Host',
          host: 'host.test',
          port: 22,
          username: 'user',
        ),
        intent: const CredentialIntent.store(),
        secret: String.fromCharCode(120),
      ),
      throwsA(isA<RepositoryFailure>()),
    );
    expect(profiles.saved, isNull);
  });

  test('preserve never reads or rewrites the saved value', () async {
    final calls = <String>[];
    final profiles = _Profiles(calls);
    final credentials = _Credentials(calls);
    final coordinator = CredentialCoordinator(
      profiles: profiles,
      credentials: credentials,
      references: CredentialReferenceGenerator(),
    );
    final profile = _profile(const CredentialReference('opaque-existing'));

    await coordinator.save(
      profile: profile,
      intent: const CredentialIntent.preserve(),
    );

    expect(calls, <String>['profile-save']);
    expect(profiles.saved!.credentialReference, profile.credentialReference);
  });

  test(
    'explicit remove clears metadata before deleting secure value',
    () async {
      final calls = <String>[];
      final profiles = _Profiles(calls);
      final credentials = _Credentials(calls);
      final coordinator = CredentialCoordinator(
        profiles: profiles,
        credentials: credentials,
        references: CredentialReferenceGenerator(),
      );

      await coordinator.save(
        profile: _profile(const CredentialReference('opaque-existing')),
        intent: const CredentialIntent.remove(),
      );

      expect(calls, <String>['profile-save', 'credential-delete']);
      expect(profiles.saved!.credentialReference, isNull);
    },
  );

  test('failed secure deletion is queued after metadata is cleared', () async {
    final calls = <String>[];
    final queued = <CredentialReference>[];
    final profiles = _Profiles(calls);
    final credentials = _Credentials(calls)..failDelete = true;
    final coordinator = CredentialCoordinator(
      profiles: profiles,
      credentials: credentials,
      references: CredentialReferenceGenerator(),
      scheduleCleanup: (reference) async {
        calls.add('cleanup-queued');
        queued.add(reference);
      },
    );
    const reference = CredentialReference('opaque-existing');

    await coordinator.save(
      profile: _profile(reference),
      intent: const CredentialIntent.remove(),
    );

    expect(calls, <String>[
      'profile-save',
      'credential-delete',
      'cleanup-queued',
    ]);
    expect(profiles.saved!.credentialReference, isNull);
    expect(queued, <CredentialReference>[reference]);
  });

  test('failed transient deletion is queued for retry', () async {
    final calls = <String>[];
    final queued = <CredentialReference>[];
    final coordinator = CredentialCoordinator(
      profiles: _Profiles(calls),
      credentials: _Credentials(calls)..failDelete = true,
      references: CredentialReferenceGenerator(),
      scheduleCleanup: (reference) async {
        calls.add('cleanup-queued');
        queued.add(reference);
      },
    );
    const reference = CredentialReference('opaque-transient');

    await coordinator.cleanupTransient(reference);

    expect(calls, <String>['credential-delete', 'cleanup-queued']);
    expect(queued, <CredentialReference>[reference]);
  });
}

SshProfile _profile(CredentialReference reference) => SshProfile(
  id: 'p1',
  name: 'Host',
  host: 'host.test',
  port: 22,
  username: 'user',
  credentialReference: reference,
);

final class _Profiles implements ProfilesRepository {
  _Profiles(this.calls);
  final List<String> calls;
  SshProfile? saved;

  @override
  Future<void> delete(String id) async {}
  @override
  Future<List<SshProfile>> getAll() async => <SshProfile>[];
  @override
  Future<void> save(SshProfile profile) async {
    calls.add('profile-save');
    saved = profile;
  }
}

final class _Credentials implements SecureCredentialStore {
  _Credentials(this.calls);
  final List<String> calls;
  bool failWrite = false;
  bool failDelete = false;
  @override
  Future<bool> contains(CredentialReference reference) async => false;
  @override
  Future<void> delete(CredentialReference reference) async {
    calls.add('credential-delete');
    if (failDelete) throw const RepositoryFailure('delete', 'failed');
  }

  @override
  Future<String?> read(CredentialReference reference) async => null;
  @override
  Future<void> write(CredentialReference reference, String secret) async {
    calls.add('credential-write');
    if (failWrite) throw const RepositoryFailure('write', 'failed');
  }
}
