import '../entities/known_host.dart';
import '../entities/ssh_profile.dart';
import '../failures/ssh_failure.dart';
import '../value_objects/ssh_session_values.dart';

abstract interface class SshSessionFactory {
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  );
}

abstract interface class SshConnectionAttempt {
  Future<PresentedHostKey> get presentedHostKey;

  Future<SshSession> get session;

  Future<void> acceptHostKey();

  Future<void> rejectHostKey();

  Future<void> cancel();
}

abstract interface class SshSession {
  Stream<List<int>> get output;

  Future<SshFailure?> get done;

  Future<void> send(List<int> bytes);

  Future<void> resize(TerminalDimensions dimensions);

  Future<void> close();
}
