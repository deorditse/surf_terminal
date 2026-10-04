import 'dart:async';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'dartssh_backend.dart';
import 'ssh_exception_mapper.dart';

final class DartSshSession implements SshSession {
  DartSshSession({
    required DartSshClientHandle client,
    required DartSshShellHandle shell,
  }) : // Public dependency name intentionally differs from the private field.
       // ignore: prefer_initializing_formals
       _client = client,
       _shell = shell {
    _outputSubscription = shell.output.listen(
      (bytes) => _output.add(List<int>.of(bytes)),
      onError: _onOutputError,
      onDone: _streamDone,
    );
    _errorSubscription = shell.errorOutput.listen(
      (bytes) => _output.add(List<int>.of(bytes)),
      onError: _onOutputError,
      onDone: _streamDone,
    );
    unawaited(shell.done.then(_onShellDone, onError: _onShellError));
  }

  final DartSshClientHandle _client;
  final DartSshShellHandle _shell;
  final _output = StreamController<List<int>>.broadcast();
  final _completion = Completer<SshFailure?>();
  late final StreamSubscription<List<int>> _outputSubscription;
  late final StreamSubscription<List<int>> _errorSubscription;
  var _closed = false;
  var _streamsDone = 0;

  @override
  Stream<List<int>> get output => _output.stream;
  @override
  Future<SshFailure?> get done => _completion.future;

  @override
  Future<void> send(List<int> bytes) async {
    _ensureOpen();
    try {
      await _shell.write(List<int>.of(bytes));
    } on Object catch (error) {
      throw mapSshException(error, operation: SshOperation.session);
    }
  }

  @override
  Future<void> resize(TerminalDimensions dimensions) async {
    _ensureOpen();
    try {
      await _shell.resize(dimensions);
    } on Object catch (error) {
      throw mapSshException(error, operation: SshOperation.pty);
    }
  }

  void _ensureOpen() {
    if (_closed) {
      throw const SshFailure.cancelled(message: 'The SSH session is closed.');
    }
  }

  void _onOutputError(Object error, StackTrace stackTrace) {
    if (!_completion.isCompleted) {
      _completion.complete(
        mapSshException(error, operation: SshOperation.session),
      );
    }
  }

  void _streamDone() {
    _streamsDone++;
    if (_streamsDone == 2 && !_output.isClosed) unawaited(_output.close());
  }

  void _onShellDone(void _) {
    if (_completion.isCompleted) return;
    if (_closed || _shell.exitCode == 0) {
      _completion.complete(null);
    } else {
      _completion.complete(
        const SshFailure.remoteExit(message: 'The remote shell exited.'),
      );
    }
  }

  void _onShellError(Object error, StackTrace stackTrace) {
    if (!_completion.isCompleted) {
      _completion.complete(
        mapSshException(error, operation: SshOperation.session),
      );
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _outputSubscription.cancel();
    await _errorSubscription.cancel();
    try {
      await _shell.close();
    } on Object {
      // Continue closing the owning client; close remains idempotent.
    }
    try {
      await _client.close();
    } on Object {
      // Resources are already considered closed to prevent reuse.
    }
    if (!_output.isClosed) await _output.close();
    if (!_completion.isCompleted) _completion.complete(null);
  }
}
