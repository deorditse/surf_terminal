import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'support/asyncssh_harness_environment.dart';
part 'support/asyncssh_test_support.dart';

void main() {
  final environment = Platform.environment;
  final enabled = environment['SURF_ASYNCSSH_TEST'] == '1';

  test(
    'real adapter enforces trust, authentication, PTY, rotation, and retry flows',
    () async {
      final harness = _HarnessEnvironment.from(environment);
      final credentialStore = _MemoryCredentialStore(harness.password);
      final knownHosts = _MemoryKnownHosts();
      final delay = _HarnessDelay();
      final output = <int>[];
      final outputSubscriptions = <StreamSubscription<List<int>>>[];
      final profile = SshProfile(
        id: 'loopback-profile',
        name: 'Loopback integration',
        host: harness.host,
        port: harness.port,
        username: harness.username,
        credentialReference: const CredentialReference(
          'runtime-only-reference',
        ),
      );
      final factory = DartSshSessionFactory(
        credentialStore: credentialStore,
        connectTimeout: const Duration(seconds: 2),
        handshakeTimeout: const Duration(seconds: 2),
        authTimeout: const Duration(seconds: 2),
        keepAliveInterval: const Duration(seconds: 1),
      );
      final bloc = SshSessionBloc(
        factory: factory,
        knownHosts: knownHosts,
        delay: delay.call,
        onSessionOpened: (stream) {
          outputSubscriptions.add(stream.listen(output.addAll));
        },
      );

      try {
        bloc.add(SshSessionEvent.connectRequested(profile, _initialDimensions));
        final unknown = await _waitForState<SshSessionVerifying>(bloc);
        expect(unknown.challenge.kind, HostKeyChallengeKind.unknown);
        expect(credentialStore.readCount, 0);
        bloc.add(SshSessionEvent.hostKeyAccepted(unknown.connectionId));
        await _waitForState<SshSessionConnected>(bloc);
        expect(credentialStore.readCount, 1);
        expect(knownHosts.record, isNotNull);

        final marker = _randomMarker();
        bloc.add(SshSessionEvent.inputSent(utf8.encode('$marker\n')));
        await _waitUntil(
          () => _containsBytes(output, utf8.encode(marker)),
          description: 'echo output',
        );

        const resized = TerminalDimensions(columns: 113, rows: 37);
        bloc.add(const SshSessionEvent.resizeRequested(resized));
        await harness.waitForDimensions(resized);

        await _disconnect(bloc);
        final repeatedStates = <Type>[];
        final repeatedSubscription = bloc.stream.listen(
          (state) => repeatedStates.add(state.runtimeType),
        );
        bloc.add(SshSessionEvent.connectRequested(profile, _initialDimensions));
        await _waitForState<SshSessionConnected>(bloc);
        await repeatedSubscription.cancel();
        expect(repeatedStates, isNot(contains(SshSessionVerifying)));
        expect(credentialStore.readCount, 2);
        await _disconnect(bloc);

        final trustedFingerprint = knownHosts.record!.fingerprint;
        await harness.command('rotate');
        bloc.add(SshSessionEvent.connectRequested(profile, _initialDimensions));
        final changed = await _waitForState<SshSessionVerifying>(bloc);
        expect(changed.challenge.kind, HostKeyChallengeKind.changed);
        expect(
          knownHosts.record!.fingerprint == trustedFingerprint,
          isTrue,
          reason: 'A mismatch must not overwrite persisted trust.',
        );
        bloc.add(SshSessionEvent.hostKeyRejected(changed.connectionId));
        await _waitForState<SshSessionFailed>(bloc);
        expect(
          knownHosts.record!.fingerprint == trustedFingerprint,
          isTrue,
          reason: 'Rejecting a mismatch must preserve persisted trust.',
        );

        bloc.add(SshSessionEvent.connectRequested(profile, _initialDimensions));
        final replacement = await _waitForState<SshSessionVerifying>(bloc);
        expect(replacement.challenge.kind, HostKeyChallengeKind.changed);
        bloc.add(SshSessionEvent.hostKeyReplaced(replacement.connectionId));
        await _waitForState<SshSessionConnected>(bloc);
        expect(
          knownHosts.record!.fingerprint != trustedFingerprint,
          isTrue,
          reason: 'Explicit replacement must persist the rotated identity.',
        );

        delay.observed.clear();
        await harness.command('interrupt');
        await _waitForState<SshSessionReconnecting>(bloc);
        await _waitForState<SshSessionConnected>(bloc);
        expect(delay.observed, const <Duration>[Duration(seconds: 1)]);

        delay.observed.clear();
        await harness.command('pause');
        final exhausted = await _waitForState<SshSessionFailed>(bloc);
        expect(exhausted.failure.isReconnectable, isTrue);
        expect(delay.observed, const <Duration>[
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ]);
        await harness.command('resume');

        bloc.add(SshSessionEvent.connectRequested(profile, _initialDimensions));
        await _waitForState<SshSessionConnected>(bloc);
        delay
          ..observed.clear()
          ..hold = true;
        await harness.command('interrupt');
        await _waitForState<SshSessionReconnecting>(bloc);
        bloc.add(const SshSessionEvent.disconnectRequested());
        await _waitForState<SshSessionDisconnected>(bloc);
        delay.release();
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(bloc.state, isA<SshSessionDisconnected>());
        expect(delay.observed, const <Duration>[Duration(seconds: 1)]);
      } finally {
        delay.release();
        await bloc.close();
        for (final subscription in outputSubscriptions) {
          await subscription.cancel();
        }
      }
    },
    skip: enabled
        ? false
        : 'Requires tool/run_asyncssh_integration.sh; no network is contacted.',
    timeout: const Timeout(Duration(seconds: 45)),
  );
}

const _initialDimensions = TerminalDimensions(columns: 80, rows: 24);
