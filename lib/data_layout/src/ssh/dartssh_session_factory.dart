import 'dart:async';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'dartssh_backend.dart';
import 'dartssh2_backend.dart';
import 'dartssh_session.dart';
import 'ssh_exception_mapper.dart';

final class DartSshSessionFactory implements SshSessionFactory {
  DartSshSessionFactory({
    DartSshBackend? backend,
    required SecureCredentialStore credentialStore,
    this.connectTimeout = const Duration(seconds: 10),
    this.handshakeTimeout = const Duration(seconds: 15),
    this.authTimeout = const Duration(seconds: 15),
    this.keepAliveInterval = const Duration(seconds: 10),
  }) : _backend = backend ?? const DartSsh2Backend(),
       // Public dependency name intentionally differs from the private field.
       // ignore: prefer_initializing_formals
       _credentialStore = credentialStore;

  final DartSshBackend _backend;
  final SecureCredentialStore _credentialStore;
  final Duration connectTimeout;
  final Duration handshakeTimeout;
  final Duration authTimeout;
  final Duration keepAliveInterval;

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) => DartSshConnectionAttempt(
    backend: _backend,
    credentialStore: _credentialStore,
    profile: profile,
    dimensions: initialDimensions,
    connectTimeout: connectTimeout,
    handshakeTimeout: handshakeTimeout,
    authTimeout: authTimeout,
    keepAliveInterval: keepAliveInterval,
  );
}

final class DartSshConnectionAttempt implements SshConnectionAttempt {
  DartSshConnectionAttempt({
    required DartSshBackend backend,
    required SecureCredentialStore credentialStore,
    required SshProfile profile,
    required TerminalDimensions dimensions,
    required Duration connectTimeout,
    required Duration handshakeTimeout,
    required Duration authTimeout,
    required Duration keepAliveInterval,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _credentialStore = credentialStore,
       // ignore: prefer_initializing_formals
       _profile = profile,
       // ignore: prefer_initializing_formals
       _dimensions = dimensions {
    _client = _connect(
      backend,
      connectTimeout,
      handshakeTimeout,
      authTimeout,
      keepAliveInterval,
    );
    unawaited(_client.then<void>((_) {}, onError: (_) {}));
  }

  final SecureCredentialStore _credentialStore;
  final SshProfile _profile;
  final TerminalDimensions _dimensions;
  final _presented = Completer<PresentedHostKey>();
  final _decision = Completer<bool>();
  final _verified = Completer<void>();
  late final Future<DartSshClientHandle> _client;
  Future<SshSession>? _session;
  var _cancelled = false;
  var _hostKeyAccepted = false;

  @override
  Future<PresentedHostKey> get presentedHostKey => _presented.future;

  @override
  Future<SshSession> get session => _session ??= _openSession();

  Future<DartSshClientHandle> _connect(
    DartSshBackend backend,
    Duration connectTimeout,
    Duration handshakeTimeout,
    Duration authTimeout,
    Duration keepAliveInterval,
  ) async {
    try {
      return await backend.connect(
        DartSshConnectRequest(
          host: _profile.host,
          port: _profile.port,
          username: _profile.username,
          verifyHostKey: _verify,
          requestPassword: _requestPassword,
          connectTimeout: connectTimeout,
          handshakeTimeout: handshakeTimeout,
          authTimeout: authTimeout,
          keepAliveInterval: keepAliveInterval,
          disableHostkeyVerification: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      final failure = mapSshException(error, operation: SshOperation.connect);
      _completeError(_presented, failure, stackTrace);
      if (!_verified.isCompleted) _verified.complete();
      Error.throwWithStackTrace(failure, stackTrace);
    }
  }

  Future<bool> _verify(String algorithm, String fingerprint) async {
    if (_cancelled) return false;
    if (!_presented.isCompleted) {
      _presented.complete(
        PresentedHostKey(
          endpoint: HostEndpoint(host: _profile.host, port: _profile.port),
          algorithm: algorithm,
          fingerprint: fingerprint,
        ),
      );
    }
    final accepted = await _decision.future;
    _hostKeyAccepted = accepted;
    if (!_verified.isCompleted) _verified.complete();
    return accepted;
  }

  Future<String?> _requestPassword() async {
    final reference = _profile.credentialReference;
    if (reference == null || _cancelled) return null;
    try {
      return await _credentialStore.read(reference);
    } on Object {
      throw const SshFailure.authentication(
        message: 'The SSH credential could not be accessed.',
      );
    }
  }

  Future<SshSession> _openSession() async {
    try {
      final client = await _client;
      await _verified.future;
      if (_cancelled) throw _cancelledFailure;
      if (!_hostKeyAccepted) {
        throw const SshFailure.hostKey(
          message: 'Server identity was not trusted.',
        );
      }
      final shell = await client.openShell(_dimensions);
      return DartSshSession(client: client, shell: shell);
    } on Object catch (error) {
      throw mapSshException(error, operation: SshOperation.shell);
    }
  }

  @override
  Future<void> acceptHostKey() async => _resolve(true);
  @override
  Future<void> rejectHostKey() async => _resolve(false);

  void _resolve(bool accepted) {
    if (!_decision.isCompleted) _decision.complete(accepted);
  }

  @override
  Future<void> cancel() async {
    if (_cancelled) return;
    _cancelled = true;
    _resolve(false);
    _completeError(_presented, _cancelledFailure, StackTrace.current);
    if (!_verified.isCompleted) _verified.complete();
    unawaited(_client.then((client) => client.close(), onError: (_) {}));
  }
}

void _completeError<T>(Completer<T> completer, Object error, StackTrace stack) {
  if (!completer.isCompleted) completer.completeError(error, stack);
}

const _cancelledFailure = SshFailure.cancelled(
  message: 'Connection cancelled.',
);
