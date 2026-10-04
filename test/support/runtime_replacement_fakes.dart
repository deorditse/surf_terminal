import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class ReplacementFactory implements SshSessionFactory {
  ReplacementFactory(this.firstSession);

  final ControlledSession firstSession;
  final starts = <SshProfile>[];

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) {
    starts.add(profile);
    return _ImmediateAttempt(
      starts.length == 1 ? firstSession : ControlledSession.unblocked(),
    );
  }
}

final class _ImmediateAttempt implements SshConnectionAttempt {
  _ImmediateAttempt(this._session);
  final SshSession _session;

  @override
  Future<PresentedHostKey> get presentedHostKey async => const PresentedHostKey(
    endpoint: HostEndpoint(host: 'host.invalid', port: 22),
    algorithm: 'ssh-ed25519',
    fingerprint: 'SHA256:current',
  );
  @override
  Future<SshSession> get session async => _session;
  @override
  Future<void> acceptHostKey() async {}
  @override
  Future<void> cancel() async {}
  @override
  Future<void> rejectHostKey() async {}
}

final class ControlledSession implements SshSession {
  ControlledSession(this.events)
    : outputCancelled = Completer<void>(),
      transportClosed = Completer<void>(),
      _output = StreamController<List<int>>();

  ControlledSession.unblocked()
    : events = <String>[],
      outputCancelled = Completer<void>()..complete(),
      transportClosed = Completer<void>()..complete(),
      _output = StreamController<List<int>>();

  final List<String> events;
  final Completer<void> outputCancelled;
  final Completer<void> transportClosed;
  final StreamController<List<int>> _output;
  final Completer<SshFailure?> _done = Completer<SshFailure?>();

  @override
  Stream<List<int>> get output => _output.stream.transform(
    StreamTransformer.fromHandlers(handleDone: (sink) => sink.close()),
  );
  @override
  Future<SshFailure?> get done => _done.future;
  @override
  Future<void> close() async {
    events.add('transport');
    await transportClosed.future;
    if (!_done.isCompleted) _done.complete(null);
    await _output.close();
  }
  @override
  Future<void> resize(TerminalDimensions dimensions) async {}
  @override
  Future<void> send(List<int> bytes) async {}
}

final class TrackingFocusNode extends FocusNode {
  TrackingFocusNode(this.events);
  final List<String> events;

  @override
  void dispose() {
    events.add('focus');
    super.dispose();
  }
}

final class GatedDeleteCredentials implements SecureCredentialStore {
  GatedDeleteCredentials(this.events);
  final List<String> events;
  final deleteGate = Completer<void>();

  @override
  Future<bool> contains(CredentialReference reference) async => true;
  @override
  Future<void> delete(CredentialReference reference) async {
    events.add('transient');
    await deleteGate.future;
  }
  @override
  Future<String?> read(CredentialReference reference) async => 'opaque';
  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}