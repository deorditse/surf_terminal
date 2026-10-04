part of '../asyncssh_real_adapter_test.dart';

final class _MemoryCredentialStore implements SecureCredentialStore {
  _MemoryCredentialStore(this._secret);
  final String _secret;
  var readCount = 0;

  @override
  Future<bool> contains(CredentialReference reference) async => true;
  @override
  Future<void> delete(CredentialReference reference) async {}
  @override
  Future<String?> read(CredentialReference reference) async {
    readCount++;
    return _secret;
  }

  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}

final class _MemoryKnownHosts implements KnownHostsRepository {
  KnownHostRecord? record;

  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {
    record = null;
  }

  @override
  Future<KnownHostRecord?> find(HostEndpoint endpoint, String algorithm) async {
    final current = record;
    return current != null &&
            current.endpoint == endpoint &&
            current.algorithm == algorithm
        ? current
        : null;
  }

  @override
  Future<void> save(KnownHostRecord value) async {
    record = value;
  }
}

final class _HarnessDelay {
  final observed = <Duration>[];
  bool hold = false;
  Completer<void>? _held;

  Future<void> call(Duration duration) async {
    observed.add(duration);
    if (hold) {
      _held ??= Completer<void>();
      await _held!.future;
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 75));
    }
  }

  void release() {
    hold = false;
    final held = _held;
    _held = null;
    if (held != null && !held.isCompleted) held.complete();
  }
}

Future<T> _waitForState<T extends SshSessionState>(SshSessionBloc bloc) async {
  await _waitUntil(() => bloc.state is T, description: '$T state');
  return bloc.state as T;
}

Future<void> _disconnect(SshSessionBloc bloc) async {
  bloc.add(const SshSessionEvent.disconnectRequested());
  await _waitForState<SshSessionDisconnected>(bloc);
}

Future<void> _waitUntil(
  bool Function() predicate, {
  String description = 'sanitized harness state',
}) async {
  final deadline = DateTime.now().add(const Duration(seconds: 8));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Timed out waiting for $description.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

String _randomMarker() {
  final random = Random.secure();
  return List<int>.generate(
    24,
    (_) => random.nextInt(26) + 97,
  ).map(String.fromCharCode).join();
}

bool _containsBytes(List<int> source, List<int> target) {
  if (target.isEmpty || source.length < target.length) return false;
  for (var offset = 0; offset <= source.length - target.length; offset++) {
    var matches = true;
    for (var index = 0; index < target.length; index++) {
      if (source[offset + index] != target[index]) {
        matches = false;
        break;
      }
    }
    if (matches) return true;
  }
  return false;
}
