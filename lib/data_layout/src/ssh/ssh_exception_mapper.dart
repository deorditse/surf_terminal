import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

enum SshOperation { connect, authenticate, pty, shell, session }

SshFailure mapSshException(Object error, {required SshOperation operation}) {
  if (error is SshFailure) return error;
  if (error is TimeoutException) {
    return const SshFailure.timeout(message: 'The SSH operation timed out.');
  }
  if (error is SocketException) {
    return operation == SshOperation.connect
        ? const SshFailure.dns(message: 'The SSH host could not be reached.')
        : const SshFailure.transport(message: 'The SSH transport was lost.');
  }
  if ((error is SSHHandshakeError && _timedOut(error.message)) ||
      (error is SSHAuthAbortError && _timedOut(error.message))) {
    return const SshFailure.timeout(message: 'The SSH operation timed out.');
  }
  if (error is SSHHostkeyError) {
    return const SshFailure.hostKey(
      message: 'Server identity verification failed.',
    );
  }
  if (error is SSHAuthError) {
    return const SshFailure.authentication(
      message: 'SSH authentication was rejected.',
    );
  }
  if (error is SSHHandshakeError ||
      error is SSHPacketError ||
      error is SSHStateError) {
    return const SshFailure.negotiation(
      message: 'SSH protocol negotiation failed.',
    );
  }
  if (error is SSHChannelRequestError) {
    return error.message.toLowerCase().contains('pty')
        ? const SshFailure.pty(
            message: 'The remote terminal could not be created.',
          )
        : const SshFailure.shell(
            message: 'The remote shell could not be started.',
          );
  }
  if (operation == SshOperation.pty) {
    return const SshFailure.pty(
      message: 'The remote terminal could not be created.',
    );
  }
  if (error is SSHChannelOpenError || operation == SshOperation.shell) {
    return const SshFailure.shell(
      message: 'The remote shell could not be started.',
    );
  }
  return const SshFailure.transport(
    message: 'The SSH connection failed unexpectedly.',
  );
}

bool _timedOut(String message) => message.toLowerCase().contains('timed out');
