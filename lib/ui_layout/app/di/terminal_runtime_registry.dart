import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:xterm/xterm.dart' as xterm;

final class TerminalSessionRuntime {
  TerminalSessionRuntime._({
    required this.id,
    required this.profile,
    required this.bloc,
    required this.terminal,
    required this.focusNode,
    required Future<void> Function(CredentialReference) cleanupTransient,
    CredentialReference? transientReference,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _cleanupTransient = cleanupTransient,
       // ignore: prefer_initializing_formals
       _transientReference = transientReference;

  final String id;
  final SshProfile profile;
  final SshSessionBloc bloc;
  final xterm.Terminal terminal;
  final FocusNode focusNode;
  final Future<void> Function(CredentialReference) _cleanupTransient;
  final CredentialReference? _transientReference;
  StreamSubscription<String>? _outputSubscription;
  bool _closed = false;

  void attachOutput(Stream<List<int>> output) {
    _outputSubscription?.cancel();
    _outputSubscription = utf8.decoder.bind(output).listen(terminal.write);
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _outputSubscription?.cancel();
    await bloc.close();
    focusNode.dispose();
    final reference = _transientReference;
    if (reference != null) {
      await _cleanupTransient(reference);
    }
  }
}

final class TerminalRuntimeRegistry {
  TerminalRuntimeRegistry({
    required SshSessionFactory factory,
    required KnownHostsRepository knownHosts,
    required SecureCredentialStore credentials,
    Future<void> Function(CredentialReference)? cleanupTransient,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _factory = factory,
       // ignore: prefer_initializing_formals
       _knownHosts = knownHosts,
       _cleanupTransient =
           cleanupTransient ??
           ((reference) => _bestEffortDelete(credentials, reference));

  final SshSessionFactory _factory;
  final KnownHostsRepository _knownHosts;
  final Future<void> Function(CredentialReference) _cleanupTransient;
  final Map<String, TerminalSessionRuntime> _sessions = {};
  Future<void> _operations = Future<void>.value();
  int _nextId = 0;

  Iterable<TerminalSessionRuntime> get sessions => _sessions.values;
  TerminalSessionRuntime? find(String id) => _sessions[id];

  TerminalSessionRuntime open(
    SshProfile profile, {
    CredentialReference? transientReference,
  }) => _open(profile, transientReference: transientReference);

  Future<TerminalSessionRuntime> replace(
    SshProfile profile, {
    CredentialReference? transientReference,
  }) => _serialize(() async {
    final runtimes = List<TerminalSessionRuntime>.of(_sessions.values);
    _sessions.clear();
    for (final runtime in runtimes) {
      await runtime.close();
    }
    return _open(profile, transientReference: transientReference);
  });

  TerminalSessionRuntime _open(
    SshProfile profile, {
    CredentialReference? transientReference,
  }) {
    final id = 'session-${++_nextId}';
    final terminal = xterm.Terminal(maxLines: 5000);
    final focusNode = FocusNode(debugLabel: 'terminal-$id');
    late final TerminalSessionRuntime runtime;
    final bloc = SshSessionBloc(
      factory: _factory,
      knownHosts: _knownHosts,
      onSessionOpened: (output) => runtime.attachOutput(output),
    );
    runtime = TerminalSessionRuntime._(
      id: id,
      profile: profile,
      bloc: bloc,
      terminal: terminal,
      focusNode: focusNode,
      cleanupTransient: _cleanupTransient,
      transientReference: transientReference,
    );
    terminal.onOutput = (data) =>
        bloc.add(SshSessionEvent.inputSent(utf8.encode(data)));
    terminal.onResize = (columns, rows, _, _) => bloc.add(
      SshSessionEvent.resizeRequested(
        TerminalDimensions(columns: columns, rows: rows),
      ),
    );
    _sessions[id] = runtime;
    bloc.add(
      SshSessionEvent.connectRequested(
        profile,
        const TerminalDimensions(columns: 80, rows: 24),
      ),
    );
    return runtime;
  }

  Future<void> close(String id) async {
    await _sessions.remove(id)?.close();
  }

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = Completer<T>();
    _operations = _operations.then((_) async {
      try {
        result.complete(await operation());
      } on Object catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    });
    return result.future;
  }

  Future<void> disconnectAll() async {
    for (final runtime in List<TerminalSessionRuntime>.of(_sessions.values)) {
      runtime.bloc.add(const SshSessionEvent.disconnectRequested());
    }
  }

  Future<void> dispose() async {
    final runtimes = List<TerminalSessionRuntime>.of(_sessions.values);
    _sessions.clear();
    for (final runtime in runtimes) {
      await runtime.close();
    }
  }
}

Future<void> _bestEffortDelete(
  SecureCredentialStore credentials,
  CredentialReference reference,
) async {
  try {
    await credentials.delete(reference);
  } on Object {
    // Preview/test stores without a cleanup scheduler remain best effort.
  }
}
