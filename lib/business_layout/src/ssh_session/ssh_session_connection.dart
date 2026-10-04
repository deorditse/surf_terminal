part of 'ssh_session_bloc.dart';

extension _SshSessionConnection on SshSessionBloc {
  Future<void> _establish(
    int generation,
    String connectionId,
    Emitter<SshSessionState> emit,
  ) async {
    final profile = _profile!;
    final attempt = _factory.start(profile, _dimensions!);
    _attempt = attempt;
    final presented = await attempt.presentedHostKey;
    _ensureCurrent(generation);
    final known = await _knownHosts.find(
      presented.endpoint,
      presented.algorithm,
    );
    _ensureCurrent(generation);

    if (known != null &&
        known.matches(presented.algorithm, presented.fingerprint)) {
      await _knownHosts.save(known.confirmedAt(_now()));
      await attempt.acceptHostKey();
    } else {
      final challenge = HostKeyChallenge(
        presented: presented,
        kind: known == null
            ? HostKeyChallengeKind.unknown
            : HostKeyChallengeKind.changed,
        previousFingerprint: known?.fingerprint,
      );
      emit(
        SshSessionState.verifying(
          connectionId: connectionId,
          profile: profile,
          challenge: challenge,
        ),
      );
      final completer = Completer<_TrustDecision>();
      _trustDecision = completer;
      final decision = await completer.future;
      _trustDecision = null;
      _ensureCurrent(generation);
      if (decision == _TrustDecision.reject) {
        await attempt.rejectHostKey();
        throw const SshFailure.hostKey(
          message: 'Server identity was not trusted.',
        );
      }
      await _knownHosts.save(
        KnownHostRecord(
          endpoint: presented.endpoint,
          algorithm: presented.algorithm,
          fingerprint: presented.fingerprint,
          firstSeenAt: known?.firstSeenAt ?? _now(),
          lastConfirmedAt: _now(),
        ),
      );
      await attempt.acceptHostKey();
    }

    _ensureCurrent(generation);
    emit(
      SshSessionState.authenticating(
        connectionId: connectionId,
        profile: profile,
      ),
    );
    final session = await attempt.session;
    _ensureCurrent(generation);
    _session = session;
    _onSessionOpened?.call(session.output);
    emit(
      SshSessionState.connected(connectionId: connectionId, profile: profile),
    );
    unawaited(
      session.done.then((failure) {
        if (_isCurrent(generation) && !isClosed) {
          add(
            SshSessionEvent.transportLost(
              connectionId,
              failure ??
                  const SshFailure.remoteExit(
                    message: 'The remote shell closed.',
                  ),
            ),
          );
        }
      }),
    );
  }

  Future<void> _reconnect(
    SshTransportLost event,
    SshProfile profile,
    Emitter<SshSessionState> emit,
  ) async {
    final generation = _generation;
    _cancelReconnect();
    final cancellation = Completer<void>();
    _reconnectCancellation = cancellation;
    await _closeResources();
    SshFailure failure = event.failure;
    const delays = <Duration>[
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ];
    for (var index = 0; index < delays.length; index++) {
      final wait = delays[index];
      emit(
        SshSessionState.reconnecting(
          connectionId: event.connectionId,
          profile: profile,
          attempt: index + 1,
          delay: wait,
        ),
      );
      final delayCompleted = await Future.any<bool>(<Future<bool>>[
        _delay(wait).then((_) => true),
        cancellation.future.then((_) => false),
      ]);
      if (!delayCompleted || !_isCurrent(generation)) {
        if (identical(_reconnectCancellation, cancellation)) {
          _reconnectCancellation = null;
        }
        return;
      }
      try {
        await _establish(generation, event.connectionId, emit);
        _reconnectCancellation = null;
        return;
      } on SshCancelledFailure {
        _reconnectCancellation = null;
        return;
      } on SshFailure catch (nextFailure) {
        failure = nextFailure;
        if (!failure.isReconnectable) {
          emit(_failed(event.connectionId, profile, failure));
          _reconnectCancellation = null;
          return;
        }
      } on Object {
        failure = _safeTransportFailure;
      }
      await _attempt?.cancel();
      _attempt = null;
    }
    if (_isCurrent(generation)) {
      emit(_failed(event.connectionId, profile, failure));
    }
    _reconnectCancellation = null;
  }

  void _ensureCurrent(int generation) {
    if (!_isCurrent(generation)) {
      throw const SshFailure.cancelled(message: 'Connection cancelled.');
    }
  }

  Future<void> _closeResources() async {
    final attempt = _attempt;
    final session = _session;
    _attempt = null;
    _session = null;
    if (attempt != null) await attempt.cancel();
    if (session != null) await session.close();
  }
}
