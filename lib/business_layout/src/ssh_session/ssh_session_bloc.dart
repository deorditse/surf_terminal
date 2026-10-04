import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'ssh_session_event.dart';
import 'ssh_session_state.dart';

part 'ssh_session_connection.dart';

typedef SshDelay = Future<void> Function(Duration duration);
typedef SshNow = DateTime Function();

enum _TrustDecision { accept, replace, reject }

final class SshSessionBloc extends Bloc<SshSessionEvent, SshSessionState> {
  SshSessionBloc({
    required SshSessionFactory factory,
    required KnownHostsRepository knownHosts,
    void Function(Stream<List<int>> output)? onSessionOpened,
    SshDelay delay = _defaultDelay,
    SshNow? now,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _factory = factory,
       // ignore: prefer_initializing_formals
       _knownHosts = knownHosts,
       // ignore: prefer_initializing_formals
       _onSessionOpened = onSessionOpened,
       // ignore: prefer_initializing_formals
       _delay = delay,
       _now = now ?? DateTime.now,
       super(const SshSessionState.disconnected()) {
    on<SshConnectRequested>(_onConnect, transformer: droppable());
    on<SshHostKeyAccepted>(_onAccepted, transformer: sequential());
    on<SshHostKeyReplaced>(_onReplaced, transformer: sequential());
    on<SshHostKeyRejected>(_onRejected, transformer: sequential());
    on<SshInputSent>(_onInput, transformer: sequential());
    on<SshResizeRequested>(_onResize, transformer: restartable());
    on<SshDisconnectRequested>(_onDisconnect, transformer: sequential());
    on<SshTransportLost>(_onTransportLost, transformer: sequential());
  }

  final SshSessionFactory _factory;
  final KnownHostsRepository _knownHosts;
  final SshDelay _delay;
  final SshNow _now;
  final void Function(Stream<List<int>> output)? _onSessionOpened;
  int _generation = 0;
  SshConnectionAttempt? _attempt;
  SshSession? _session;
  SshProfile? _profile;
  TerminalDimensions? _dimensions;
  Completer<_TrustDecision>? _trustDecision;
  Completer<void>? _reconnectCancellation;

  Future<void> _onConnect(
    SshConnectRequested event,
    Emitter<SshSessionState> emit,
  ) async {
    final generation = ++_generation;
    _profile = event.profile;
    _dimensions = event.dimensions;
    final id = '$generation';
    emit(SshSessionState.connecting(connectionId: id, profile: event.profile));
    try {
      await _establish(generation, id, emit);
    } on SshCancelledFailure {
      return;
    } on SshFailure catch (failure) {
      if (_isCurrent(generation)) {
        emit(_failed(id, event.profile, failure));
      }
    } on Object {
      if (_isCurrent(generation)) {
        emit(_failed(id, event.profile, _safeTransportFailure));
      }
    }
  }

  void _onAccepted(SshHostKeyAccepted event, Emitter<SshSessionState> emit) {
    final current = state;
    if (current is! SshSessionVerifying ||
        current.connectionId != event.connectionId ||
        current.challenge.kind != HostKeyChallengeKind.unknown) {
      return;
    }
    _resolveTrust(_TrustDecision.accept);
  }

  void _onReplaced(SshHostKeyReplaced event, Emitter<SshSessionState> emit) {
    final current = state;
    if (current is! SshSessionVerifying ||
        current.connectionId != event.connectionId ||
        current.challenge.kind != HostKeyChallengeKind.changed) {
      return;
    }
    _resolveTrust(_TrustDecision.replace);
  }

  Future<void> _onRejected(
    SshHostKeyRejected event,
    Emitter<SshSessionState> emit,
  ) async {
    final current = state;
    if (current is! SshSessionVerifying ||
        current.connectionId != event.connectionId) {
      return;
    }
    _resolveTrust(_TrustDecision.reject);
  }

  Future<void> _onInput(
    SshInputSent event,
    Emitter<SshSessionState> emit,
  ) async {
    if (state is SshSessionConnected) {
      await _session?.send(event.bytes);
    }
  }

  Future<void> _onResize(
    SshResizeRequested event,
    Emitter<SshSessionState> emit,
  ) async {
    _dimensions = event.dimensions;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!emit.isDone && state is SshSessionConnected) {
      await _session?.resize(event.dimensions);
    }
  }

  Future<void> _onDisconnect(
    SshDisconnectRequested event,
    Emitter<SshSessionState> emit,
  ) async {
    ++_generation;
    _cancelReconnect();
    _resolveTrust(_TrustDecision.reject);
    await _closeResources();
    emit(SshSessionState.disconnected(profile: _profile));
  }

  Future<void> _onTransportLost(
    SshTransportLost event,
    Emitter<SshSessionState> emit,
  ) async {
    final current = state;
    if (current is! SshSessionConnected ||
        current.connectionId != event.connectionId) {
      return;
    }
    if (!event.failure.isReconnectable) {
      await _closeResources();
      emit(_failed(event.connectionId, current.profile, event.failure));
      return;
    }
    await _reconnect(event, current.profile, emit);
  }

  void _resolveTrust(_TrustDecision decision) {
    final completer = _trustDecision;
    if (completer != null && !completer.isCompleted) {
      completer.complete(decision);
    }
  }

  void _cancelReconnect() {
    final cancellation = _reconnectCancellation;
    _reconnectCancellation = null;
    if (cancellation != null && !cancellation.isCompleted) {
      cancellation.complete();
    }
  }

  bool _isCurrent(int generation) => generation == _generation && !isClosed;

  SshSessionState _failed(String id, SshProfile profile, SshFailure failure) =>
      SshSessionState.failed(
        connectionId: id,
        profile: profile,
        failure: failure,
      );

  @override
  Future<void> close() async {
    ++_generation;
    _cancelReconnect();
    _resolveTrust(_TrustDecision.reject);
    await _closeResources();
    return super.close();
  }
}

Future<void> _defaultDelay(Duration duration) => Future<void>.delayed(duration);

const _safeTransportFailure = SshFailure.transport(
  message: 'The SSH connection could not be established.',
);
