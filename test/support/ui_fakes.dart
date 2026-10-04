import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class AvailableCredentialStore implements SecureCredentialStore {
  @override
  Future<bool> contains(CredentialReference reference) async => true;
  @override
  Future<void> delete(CredentialReference reference) async {}
  @override
  Future<String?> read(CredentialReference reference) async => null;
  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}

final class FailedSshFactory implements SshSessionFactory {
  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) => _FailedAttempt();
}

final class _FailedAttempt implements SshConnectionAttempt {
  static const failure = SshFailure.transport(
    message: 'Deterministic test transport unavailable.',
  );
  @override
  Future<PresentedHostKey> get presentedHostKey => Future.error(failure);
  @override
  Future<SshSession> get session => Future.error(failure);
  @override
  Future<void> acceptHostKey() async {}
  @override
  Future<void> cancel() async {}
  @override
  Future<void> rejectHostKey() async {}
}
