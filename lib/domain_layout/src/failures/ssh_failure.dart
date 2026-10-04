sealed class SshFailure implements Exception {
  const SshFailure(this.message);

  const factory SshFailure.dns({required String message}) = SshDnsFailure;
  const factory SshFailure.timeout({required String message}) =
      SshTimeoutFailure;
  const factory SshFailure.negotiation({required String message}) =
      SshNegotiationFailure;
  const factory SshFailure.transport({required String message}) =
      SshTransportFailure;
  const factory SshFailure.hostKey({required String message}) =
      SshHostKeyFailure;
  const factory SshFailure.authentication({required String message}) =
      SshAuthenticationFailure;
  const factory SshFailure.pty({required String message}) = SshPtyFailure;
  const factory SshFailure.shell({required String message}) = SshShellFailure;
  const factory SshFailure.remoteExit({required String message}) =
      SshRemoteExitFailure;
  const factory SshFailure.cancelled({required String message}) =
      SshCancelledFailure;

  final String message;

  bool get isReconnectable =>
      this is SshDnsFailure ||
      this is SshTimeoutFailure ||
      this is SshTransportFailure ||
      this is SshRemoteExitFailure;

  @override
  String toString() => '$runtimeType: $message';
}

final class SshDnsFailure extends SshFailure {
  const SshDnsFailure({required String message}) : super(message);
}

final class SshTimeoutFailure extends SshFailure {
  const SshTimeoutFailure({required String message}) : super(message);
}

final class SshNegotiationFailure extends SshFailure {
  const SshNegotiationFailure({required String message}) : super(message);
}

final class SshTransportFailure extends SshFailure {
  const SshTransportFailure({required String message}) : super(message);
}

final class SshHostKeyFailure extends SshFailure {
  const SshHostKeyFailure({required String message}) : super(message);
}

final class SshAuthenticationFailure extends SshFailure {
  const SshAuthenticationFailure({required String message}) : super(message);
}

final class SshPtyFailure extends SshFailure {
  const SshPtyFailure({required String message}) : super(message);
}

final class SshShellFailure extends SshFailure {
  const SshShellFailure({required String message}) : super(message);
}

final class SshRemoteExitFailure extends SshFailure {
  const SshRemoteExitFailure({required String message}) : super(message);
}

final class SshCancelledFailure extends SshFailure {
  const SshCancelledFailure({required String message}) : super(message);
}
