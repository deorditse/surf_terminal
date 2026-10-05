import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/connect_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/credential_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';

import '../business_layout/support/ssh_session_fakes.dart';
import '../support/save_connect_fakes.dart';
import '../support/ui_fakes.dart';

void main() {
  test('remember disabled clears a stale unavailable reference', () async {
    const stale = CredentialReference('opaque-stale-reference');
    final profiles = TrackingProfilesRepository();
    final credentials = TrackingCredentialStore();
    final runtimes = TerminalRuntimeRegistry(
      factory: FailedSshFactory(),
      knownHosts: FakeKnownHosts(),
      credentials: credentials,
    );
    final coordinator = ConnectCoordinator(
      credentials: CredentialCoordinator(
        profiles: profiles,
        credentials: credentials,
        references: CredentialReferenceGenerator(),
      ),
      runtimes: runtimes,
    );

    final launch = await coordinator.connectWithSecret(
      profile: const SshProfile(
        id: 'saved-profile',
        name: 'Saved host',
        host: 'saved.invalid',
        port: 22,
        username: 'operator',
        credentialReference: stale,
      ),
      secret: 'runtime-${DateTime.now().microsecondsSinceEpoch}',
      remember: false,
    );

    final persisted = await launch.persistence;
    expect(persisted.credentialReference, isNull);
    expect(profiles.profiles.single.credentialReference, isNull);
    await runtimes.dispose();
  });

  test(
    'runtime launch does not await controlled profile persistence',
    () async {
      final saveGate = Completer<void>();
      final profiles = TrackingProfilesRepository(saveGate: saveGate);
      final credentials = TrackingCredentialStore();
      final runtimes = TerminalRuntimeRegistry(
        factory: FailedSshFactory(),
        knownHosts: FakeKnownHosts(),
        credentials: credentials,
      );
      final coordinator = ConnectCoordinator(
        credentials: CredentialCoordinator(
          profiles: profiles,
          credentials: credentials,
          references: CredentialReferenceGenerator(),
        ),
        runtimes: runtimes,
      );

      final launch = await coordinator.connectWithSecret(
        profile: const SshProfile(
          id: 'new-profile',
          name: 'New host',
          host: 'new.invalid',
          port: 22,
          username: 'operator',
        ),
        secret: 'runtime-${DateTime.now().microsecondsSinceEpoch}',
        remember: false,
      );

      expect(runtimes.sessions, <TerminalSessionRuntime>[launch.runtime]);
      expect(profiles.saveCount, 1);
      expect(profiles.profiles, isEmpty);
      saveGate.complete();
      await launch.persistence;
      await runtimes.dispose();
    },
  );
}
