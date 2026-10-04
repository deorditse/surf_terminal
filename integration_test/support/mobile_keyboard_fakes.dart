import 'dart:async';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

const injectedProfile = SshProfile(
  id: 'mobile-keyboard-smoke',
  name: 'Injected connected session',
  host: 'test.invalid',
  port: 22,
  username: 'smoke',
);

PresentedHostKey get injectedHostKey => const PresentedHostKey(
  endpoint: HostEndpoint(host: 'test.invalid', port: 22),
  algorithm: 'ssh-ed25519',
  fingerprint: 'SHA256:integration-only',
);

final class InjectedSessionFactory implements SshSessionFactory {
  InjectedSessionFactory(this.session);

  final InjectedSshSession session;

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) => InjectedConnectionAttempt(session);
}

final class InjectedConnectionAttempt implements SshConnectionAttempt {
  InjectedConnectionAttempt(this._session);

  final InjectedSshSession _session;

  @override
  Future<PresentedHostKey> get presentedHostKey async => injectedHostKey;

  @override
  Future<SshSession> get session async => _session;

  @override
  Future<void> acceptHostKey() async {}

  @override
  Future<void> rejectHostKey() async {}

  @override
  Future<void> cancel() async {}
}

final class InjectedSshSession implements SshSession {
  final _output = StreamController<List<int>>.broadcast();
  final _done = Completer<SshFailure?>();
  final sent = <List<int>>[];
  final resizes = <TerminalDimensions>[];

  @override
  Stream<List<int>> get output => _output.stream;

  @override
  Future<SshFailure?> get done => _done.future;

  @override
  Future<void> send(List<int> bytes) async => sent.add(List<int>.of(bytes));

  @override
  Future<void> resize(TerminalDimensions dimensions) async {
    resizes.add(dimensions);
  }

  @override
  Future<void> close() async {
    if (!_done.isCompleted) _done.complete(null);
    await _output.close();
  }
}

final class InjectedKnownHosts implements KnownHostsRepository {
  final record = KnownHostRecord(
    endpoint: injectedHostKey.endpoint,
    algorithm: injectedHostKey.algorithm,
    fingerprint: injectedHostKey.fingerprint,
    firstSeenAt: DateTime.utc(2026),
    lastConfirmedAt: DateTime.utc(2026),
  );

  @override
  Future<KnownHostRecord?> find(
    HostEndpoint endpoint,
    String algorithm,
  ) async => record;

  @override
  Future<void> save(KnownHostRecord record) async {}

  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {}
}

final class InjectedCredentialStore implements SecureCredentialStore {
  @override
  Future<bool> contains(CredentialReference reference) async => false;

  @override
  Future<String?> read(CredentialReference reference) async => null;

  @override
  Future<void> write(CredentialReference reference, String secret) async {}

  @override
  Future<void> delete(CredentialReference reference) async {}
}
