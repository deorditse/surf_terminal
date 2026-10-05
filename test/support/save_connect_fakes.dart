import 'dart:async';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class TrackingProfilesRepository implements ProfilesRepository {
  TrackingProfilesRepository({
    List<SshProfile> initialProfiles = const <SshProfile>[],
    this.failSave = false,
    this.saveGate,
  }) : profiles = List<SshProfile>.of(initialProfiles);

  final List<SshProfile> profiles;
  final bool failSave;
  final Completer<void>? saveGate;
  var saveCount = 0;
  final saveStarted = Completer<void>();

  @override
  Future<List<SshProfile>> getAll() async => List<SshProfile>.of(profiles);

  @override
  Future<void> save(SshProfile profile) async {
    saveCount++;
    if (!saveStarted.isCompleted) saveStarted.complete();
    await saveGate?.future;
    if (failSave) {
      throw const RepositoryFailure('save_failed', 'Profile storage failed.');
    }
    final index = profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      profiles.add(profile);
    } else {
      profiles[index] = profile;
    }
  }

  @override
  Future<void> delete(String id) async {
    profiles.removeWhere((profile) => profile.id == id);
  }
}

final class TrackingCredentialStore implements SecureCredentialStore {
  TrackingCredentialStore({this.failWriteNumber});

  final _references = <CredentialReference>{};
  final deleted = <CredentialReference>[];
  final written = <CredentialReference>[];
  final int? failWriteNumber;
  var writeCount = 0;

  @override
  Future<bool> contains(CredentialReference reference) async =>
      _references.contains(reference);

  @override
  Future<void> delete(CredentialReference reference) async {
    deleted.add(reference);
    _references.remove(reference);
  }

  @override
  Future<String?> read(CredentialReference reference) async =>
      _references.contains(reference) ? 'available-at-runtime' : null;

  @override
  Future<void> write(CredentialReference reference, String secret) async {
    writeCount++;
    written.add(reference);
    if (writeCount == failWriteNumber) {
      throw const RepositoryFailure(
        'secure_write_failed',
        'Credential storage failed.',
      );
    }
    _references.add(reference);
  }
}

final class PendingSessionFactory implements SshSessionFactory {
  final startedProfiles = <SshProfile>[];
  final attempts = <PendingConnectionAttempt>[];

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) {
    startedProfiles.add(profile);
    final attempt = PendingConnectionAttempt(
      HostEndpoint(host: profile.host, port: profile.port),
    );
    attempts.add(attempt);
    return attempt;
  }
}

final class PendingConnectionAttempt implements SshConnectionAttempt {
  PendingConnectionAttempt(this.endpoint) {
    _failureTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_presentedHostKey.isCompleted) {
        _presentedHostKey.completeError(
          const SshFailure.transport(message: 'Controlled test failure.'),
        );
      }
    });
  }

  final HostEndpoint endpoint;
  final _presentedHostKey = Completer<PresentedHostKey>();
  late final Timer _failureTimer;

  @override
  Future<PresentedHostKey> get presentedHostKey => _presentedHostKey.future;

  @override
  Future<SshSession> get session => Future<SshSession>.error(
    const SshFailure.transport(message: 'Controlled test failure.'),
  );

  @override
  Future<void> acceptHostKey() async {}

  @override
  Future<void> rejectHostKey() async {}

  @override
  Future<void> cancel() async {
    _failureTimer.cancel();
    if (!_presentedHostKey.isCompleted) {
      _presentedHostKey.completeError(
        const SshFailure.cancelled(message: 'Connection cancelled.'),
      );
    }
  }
}

final class EmptyKnownHosts implements KnownHostsRepository {
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
