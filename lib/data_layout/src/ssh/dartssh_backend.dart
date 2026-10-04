import 'package:surf_terminal/domain_layout/domain_layout.dart';

typedef DartHostKeyVerifier = Future<bool> Function(
  String algorithm,
  String fingerprint,
);
typedef DartPasswordRequest = Future<String?> Function();

final class DartSshConnectRequest {
  const DartSshConnectRequest({
    required this.host,
    required this.port,
    required this.username,
    required this.verifyHostKey,
    required this.requestPassword,
    required this.connectTimeout,
    required this.handshakeTimeout,
    required this.authTimeout,
    required this.keepAliveInterval,
    required this.disableHostkeyVerification,
  });

  final String host;
  final int port;
  final String username;
  final DartHostKeyVerifier verifyHostKey;
  final DartPasswordRequest requestPassword;
  final Duration connectTimeout;
  final Duration handshakeTimeout;
  final Duration authTimeout;
  final Duration keepAliveInterval;
  final bool disableHostkeyVerification;
}

abstract interface class DartSshBackend {
  Future<DartSshClientHandle> connect(DartSshConnectRequest request);
}

abstract interface class DartSshClientHandle {
  Future<DartSshShellHandle> openShell(TerminalDimensions dimensions);
  Future<void> get done;
  Future<void> close();
}

abstract interface class DartSshShellHandle {
  Stream<List<int>> get output;
  Stream<List<int>> get errorOutput;
  Future<void> get done;
  int? get exitCode;
  Future<void> write(List<int> bytes);
  Future<void> resize(TerminalDimensions dimensions);
  Future<void> close();
}
