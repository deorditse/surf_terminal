import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'dartssh_backend.dart';

final class DartSsh2Backend implements DartSshBackend {
  const DartSsh2Backend();

  @override
  Future<DartSshClientHandle> connect(DartSshConnectRequest request) async {
    final socket = await SSHSocket.connect(
      request.host,
      request.port,
      timeout: request.connectTimeout,
    );
    final client = SSHClient(
      socket,
      username: request.username,
      onVerifyHostKey: (algorithm, fingerprint) => request.verifyHostKey(
        algorithm,
        utf8.decode(fingerprint, allowMalformed: false),
      ),
      onPasswordRequest: request.requestPassword,
      keepAliveInterval: request.keepAliveInterval,
      handshakeTimeout: request.handshakeTimeout,
      authTimeout: request.authTimeout,
      disableHostkeyVerification: false,
    );
    return _DartSsh2Client(client);
  }
}

final class _DartSsh2Client implements DartSshClientHandle {
  _DartSsh2Client(this._client);
  final SSHClient _client;

  @override
  Future<DartSshShellHandle> openShell(TerminalDimensions dimensions) async {
    final shell = await _client.shell(
      pty: SSHPtyConfig(width: dimensions.columns, height: dimensions.rows),
    );
    return _DartSsh2Shell(shell);
  }

  @override
  Future<void> get done => _client.done;
  @override
  Future<void> close() => _client.close();
}

final class _DartSsh2Shell implements DartSshShellHandle {
  _DartSsh2Shell(this._shell);
  final SSHSession _shell;

  @override
  Stream<List<int>> get output => _shell.stdout;
  @override
  Stream<List<int>> get errorOutput => _shell.stderr;
  @override
  Future<void> get done => _shell.done;
  @override
  int? get exitCode => _shell.exitCode;

  @override
  Future<void> write(List<int> bytes) async {
    _shell.write(Uint8List.fromList(bytes));
  }

  @override
  Future<void> resize(TerminalDimensions dimensions) async {
    _shell.resizeTerminal(dimensions.columns, dimensions.rows);
  }

  @override
  Future<void> close() async => _shell.close();
}
