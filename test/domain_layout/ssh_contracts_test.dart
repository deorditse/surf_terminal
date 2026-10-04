import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  test('SSH contracts remain transport and plugin agnostic', () async {
    final knownHosts = _KnownHostsRepository();
    final credentials = _SecureCredentials();
    final factory = _SessionFactory();
    const reference = CredentialReference('credential-profile-1');
    const endpoint = HostEndpoint(host: 'host.invalid', port: 22);

    expect(await knownHosts.find(endpoint, 'ssh-ed25519'), isNull);
    expect(await credentials.contains(reference), isFalse);
    final attempt = factory.start(
      const SshProfile(
        id: 'profile-1',
        name: 'Host',
        host: 'host.invalid',
        port: 22,
        username: 'operator',
      ),
      const TerminalDimensions(columns: 80, rows: 24),
    );

    expect(await attempt.presentedHostKey, isA<PresentedHostKey>());
    await attempt.cancel();
  });
}

final class _KnownHostsRepository implements KnownHostsRepository {
  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {}

  @override
  Future<KnownHostRecord?> find(
    HostEndpoint endpoint,
    String algorithm,
  ) async => null;

  @override
  Future<void> save(KnownHostRecord record) async {}
}

final class _SecureCredentials implements SecureCredentialStore {
  @override
  Future<bool> contains(CredentialReference reference) async => false;

  @override
  Future<void> delete(CredentialReference reference) async {}

  @override
  Future<String?> read(CredentialReference reference) async => null;

  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}

final class _SessionFactory implements SshSessionFactory {
  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) => _ConnectionAttempt();
}

final class _ConnectionAttempt implements SshConnectionAttempt {
  final _session = Completer<SshSession>();

  @override
  Future<PresentedHostKey> get presentedHostKey async => const PresentedHostKey(
    endpoint: HostEndpoint(host: 'host.invalid', port: 22),
    algorithm: 'ssh-ed25519',
    fingerprint: 'SHA256:generated-fingerprint',
  );

  @override
  Future<SshSession> get session => _session.future;

  @override
  Future<void> acceptHostKey() async {}

  @override
  Future<void> cancel() async {}

  @override
  Future<void> rejectHostKey() async {}
}
