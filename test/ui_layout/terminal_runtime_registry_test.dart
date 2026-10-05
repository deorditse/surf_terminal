import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/credential_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';

import '../business_layout/support/ssh_session_fakes.dart';
import '../support/save_connect_fakes.dart';
import '../support/runtime_replacement_fakes.dart';
import '../support/ui_fakes.dart';

void main() {
  test(
    'replacement closes the active runtime before starting the next',
    () async {
      const transient = CredentialReference('opaque-active-reference');
      final events = <String>[];
      final credentials = GatedDeleteCredentials(events);
      final factory = ReplacementFactory(ControlledSession.unblocked());
      final registry = TerminalRuntimeRegistry(
        factory: factory,
        knownHosts: FakeKnownHosts(),
        credentials: credentials,
      );

      final first = await registry.replace(
        fakeProfile,
        transientReference: transient,
      );
      await Future<void>.delayed(Duration.zero);
      final replacement = registry.replace(fakeProfile);
      await Future<void>.delayed(Duration.zero);

      expect(factory.starts, hasLength(1));
      expect(events, contains('transient'));
      credentials.deleteGate.complete();
      final second = await replacement;
      expect(factory.starts, hasLength(2));
      expect(registry.sessions, <TerminalSessionRuntime>[second]);
      expect(registry.find(first.id), isNull);
      await registry.dispose();
    },
  );

  test('disposing a runtime deletes its transient credential', () async {
    const transient = CredentialReference('opaque-transient-reference');
    final credentials = TrackingCredentialStore();
    await credentials.write(
      transient,
      'runtime-${DateTime.now().microsecondsSinceEpoch}',
    );
    final registry = TerminalRuntimeRegistry(
      factory: FailedSshFactory(),
      knownHosts: FakeKnownHosts(),
      credentials: credentials,
    );

    registry.open(fakeProfile, transientReference: transient);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await registry.dispose();

    expect(credentials.deleted, contains(transient));
    expect(await credentials.contains(transient), isFalse);
  });

  test('failed transient cleanup is scheduled by the registry', () async {
    const transient = CredentialReference('opaque-retryable-transient');
    final queued = <CredentialReference>[];
    final credentials = _FailingDeleteCredentials();
    final coordinator = CredentialCoordinator(
      profiles: TrackingProfilesRepository(),
      credentials: credentials,
      references: CredentialReferenceGenerator(),
      scheduleCleanup: (reference) async => queued.add(reference),
    );
    final registry = TerminalRuntimeRegistry(
      factory: FailedSshFactory(),
      knownHosts: FakeKnownHosts(),
      credentials: credentials,
      cleanupTransient: coordinator.cleanupTransient,
    );

    registry.open(fakeProfile, transientReference: transient);
    await Future<void>.delayed(Duration.zero);
    await registry.dispose();

    expect(queued, <CredentialReference>[transient]);
  });
}

final class _FailingDeleteCredentials implements SecureCredentialStore {
  @override
  Future<bool> contains(CredentialReference reference) async => true;

  @override
  Future<void> delete(CredentialReference reference) async {
    throw const RepositoryFailure('delete_failed', 'Delete failed.');
  }

  @override
  Future<String?> read(CredentialReference reference) async => null;

  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}
