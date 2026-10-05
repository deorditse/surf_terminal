import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/credential_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';

final class ConnectCoordinator {
  ConnectCoordinator({
    required CredentialCoordinator credentials,
    required TerminalRuntimeRegistry runtimes,
  }) : _credentials = credentials,
       _runtimes = runtimes;

  final CredentialCoordinator _credentials;
  final TerminalRuntimeRegistry _runtimes;

  Future<ConnectLaunch> connectWithSecret({
    required SshProfile profile,
    required String secret,
    required bool remember,
  }) async {
    final prepared = await _credentials.prepareTransient(profile, secret);
    try {
      final runtime = await _runtimes.replace(
        prepared.profile,
        transientReference: prepared.reference,
      );
      final persistence = _persist(
        profile: profile,
        secret: secret,
        remember: remember,
      );
      return ConnectLaunch(runtime: runtime, persistence: persistence);
    } on Object {
      await _credentials.cleanupTransient(prepared.reference);
      rethrow;
    }
  }

  Future<TerminalSessionRuntime> connectStored(SshProfile profile) =>
      _runtimes.replace(profile);

  Future<SshProfile> _persist({
    required SshProfile profile,
    required String secret,
    required bool remember,
  }) => _credentials.save(
    profile: profile,
    intent: remember
        ? const CredentialIntent.store()
        : const CredentialIntent.remove(),
    secret: remember ? secret : null,
  );
}

final class ConnectLaunch {
  const ConnectLaunch({required this.runtime, required this.persistence});

  final TerminalSessionRuntime runtime;
  final Future<SshProfile> persistence;
}
