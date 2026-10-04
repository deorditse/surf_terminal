part of '../asyncssh_real_adapter_test.dart';

final class _HarnessEnvironment {
  _HarnessEnvironment({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.controlDirectory,
  });

  factory _HarnessEnvironment.from(Map<String, String> environment) {
    final host = environment['SURF_ASYNCSSH_HOST'];
    final port = int.tryParse(environment['SURF_ASYNCSSH_PORT'] ?? '');
    final username = environment['SURF_ASYNCSSH_USERNAME'];
    final password = environment['SURF_ASYNCSSH_PASSWORD'];
    final controlPath = environment['SURF_ASYNCSSH_CONTROL_DIR'];
    if (host != '127.0.0.1' ||
        port == null ||
        username == null ||
        password == null ||
        controlPath == null) {
      throw StateError('The localhost harness environment is incomplete.');
    }
    return _HarnessEnvironment(
      host: host!,
      port: port,
      username: username,
      password: password,
      controlDirectory: Directory(controlPath),
    );
  }

  final String host;
  final int port;
  final String username;
  final String password;
  final Directory controlDirectory;
  var _sequence = 0;

  Future<void> command(String name) async {
    final id = '${++_sequence}';
    final request = File('${controlDirectory.path}/$id.$name.request');
    final ack = File('${controlDirectory.path}/$id.$name.ack');
    final error = File('${controlDirectory.path}/$id.$name.error');
    await request.writeAsString(name, flush: true);
    await _waitUntil(
      () => ack.existsSync() || error.existsSync(),
      description: '$name control acknowledgement',
    );
    if (error.existsSync()) {
      throw StateError(
        'Sanitized harness control failed: ${error.readAsStringSync()}',
      );
    }
  }

  Future<void> waitForDimensions(TerminalDimensions expected) async {
    final state = File('${controlDirectory.path}/pty-size.json');
    await _waitUntil(() {
      if (!state.existsSync()) return false;
      try {
        final value =
            jsonDecode(state.readAsStringSync()) as Map<String, Object?>;
        return value['columns'] == expected.columns &&
            value['rows'] == expected.rows;
      } on Object {
        return false;
      }
    }, description: 'PTY dimensions');
  }
}
