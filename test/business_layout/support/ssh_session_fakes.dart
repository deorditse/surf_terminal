import 'dart:async';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

const fakeProfile = SshProfile(
  id: 'profile-1',
  name: 'Lab',
  host: 'host.invalid',
  port: 22,
  username: 'operator',
);
const fakeDimensions = TerminalDimensions(columns: 80, rows: 24);

PresentedHostKey fakeKey() => const PresentedHostKey(
  endpoint: HostEndpoint(host: 'host.invalid', port: 22),
  algorithm: 'ssh-ed25519',
  fingerprint: 'SHA256:current',
);

KnownHostRecord fakeRecord(String fingerprint) => KnownHostRecord(
  endpoint: fakeKey().endpoint,
  algorithm: fakeKey().algorithm,
  fingerprint: fingerprint,
  firstSeenAt: DateTime.utc(2025),
  lastConfirmedAt: DateTime.utc(2025),
);

final class FakeKnownHosts implements KnownHostsRepository {
  FakeKnownHosts({this.record});
  KnownHostRecord? record;
  final saved = <KnownHostRecord>[];

  @override
  Future<KnownHostRecord?> find(
    HostEndpoint endpoint,
    String algorithm,
  ) async => record;

  @override
  Future<void> save(KnownHostRecord value) async {
    record = value;
    saved.add(value);
  }

  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {}
}

final class FakeSessionFactory implements SshSessionFactory {
  FakeSessionFactory(this.attempts);
  final List<FakeAttempt> attempts;
  var index = 0;

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions dimensions,
  ) => attempts[index++];
}

final class FakeAttempt implements SshConnectionAttempt {
  FakeAttempt(this.key, SshSession session)
    : _realSession = session,
      _failure = null;
  FakeAttempt.failed(
    this.key, [
    this._failure = const SshFailure.transport(message: 'Retry failed'),
  ]) : _realSession = null;

  final PresentedHostKey key;
  final SshSession? _realSession;
  final SshFailure? _failure;
  var acceptCount = 0;
  var rejectCount = 0;

  @override
  Future<PresentedHostKey> get presentedHostKey async => key;
  @override
  Future<SshSession> get session async {
    if (_failure != null) throw _failure;
    return _realSession!;
  }

  @override
  Future<void> acceptHostKey() async => acceptCount++;
  @override
  Future<void> rejectHostKey() async => rejectCount++;
  @override
  Future<void> cancel() async {}
}

final class FakeSession implements SshSession {
  final outputController = StreamController<List<int>>.broadcast();
  final _done = Completer<SshFailure?>();
  final sent = <List<int>>[];
  final resizes = <TerminalDimensions>[];

  @override
  Stream<List<int>> get output => outputController.stream;
  @override
  Future<SshFailure?> get done => _done.future;
  void lose(SshFailure failure) => _done.complete(failure);
  @override
  Future<void> send(List<int> bytes) async => sent.add(List<int>.of(bytes));
  @override
  Future<void> resize(TerminalDimensions dimensions) async =>
      resizes.add(dimensions);
  @override
  Future<void> close() async {
    if (!_done.isCompleted) _done.complete(null);
    await outputController.close();
  }
}
