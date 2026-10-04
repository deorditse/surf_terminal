import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'support/ssh_session_fakes.dart';

void main() {
  test('connected input is ordered and output never enters state', () async {
    final session = FakeSession();
    final bloc = _connectedBloc(<FakeAttempt>[FakeAttempt(fakeKey(), session)]);
    addTearDown(bloc.close);
    bloc.add(
      const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
    );
    await _connected(bloc);

    bloc
      ..add(const SshSessionEvent.inputSent(<int>[1]))
      ..add(const SshSessionEvent.inputSent(<int>[2]));
    await Future<void>.delayed(Duration.zero);
    session.outputController.add(<int>[99]);
    await Future<void>.delayed(Duration.zero);

    expect(session.sent, <List<int>>[
      <int>[1],
      <int>[2],
    ]);
    expect(bloc.state.toString(), isNot(contains('99')));
  });

  test(
    'resize events deliver only the latest dimensions after debounce',
    () async {
      final session = FakeSession();
      final bloc = _connectedBloc(<FakeAttempt>[
        FakeAttempt(fakeKey(), session),
      ]);
      addTearDown(bloc.close);
      bloc.add(
        const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
      );
      await _connected(bloc);

      bloc
        ..add(
          const SshSessionEvent.resizeRequested(
            TerminalDimensions(columns: 100, rows: 30),
          ),
        )
        ..add(
          const SshSessionEvent.resizeRequested(
            TerminalDimensions(columns: 120, rows: 40),
          ),
        );
      await Future<void>.delayed(const Duration(milliseconds: 70));

      expect(session.resizes, const <TerminalDimensions>[
        TerminalDimensions(columns: 120, rows: 40),
      ]);
    },
  );

  test('unexpected loss retries with bounded 1 2 4 second delays', () async {
    final delays = <Duration>[];
    final session = FakeSession();
    final bloc = SshSessionBloc(
      factory: FakeSessionFactory(<FakeAttempt>[
        FakeAttempt(fakeKey(), session),
        FakeAttempt.failed(fakeKey()),
        FakeAttempt.failed(fakeKey()),
        FakeAttempt.failed(fakeKey()),
      ]),
      knownHosts: FakeKnownHosts(record: fakeRecord(fakeKey().fingerprint)),
      delay: (duration) async => delays.add(duration),
    );
    addTearDown(bloc.close);
    bloc.add(
      const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
    );
    await _connected(bloc);

    session.lose(const SshFailure.transport(message: 'Connection lost'));
    final failed = await bloc.stream
        .where((state) => state is SshSessionFailed)
        .cast<SshSessionFailed>()
        .first;

    expect(delays, const <Duration>[
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ]);
    expect(failed.failure, isA<SshTransportFailure>());
  });

  test('reconnect stops after the first successful retry', () async {
    final delays = <Duration>[];
    final session = FakeSession();
    final bloc = SshSessionBloc(
      factory: FakeSessionFactory(<FakeAttempt>[
        FakeAttempt(fakeKey(), session),
        FakeAttempt.failed(fakeKey()),
        FakeAttempt(fakeKey(), FakeSession()),
      ]),
      knownHosts: FakeKnownHosts(record: fakeRecord(fakeKey().fingerprint)),
      delay: (duration) async => delays.add(duration),
    );
    addTearDown(bloc.close);
    bloc.add(
      const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
    );
    await _connected(bloc);

    final reconnected = _connected(bloc);
    session.lose(const SshFailure.transport(message: 'Connection lost'));
    await reconnected;

    expect(delays, const <Duration>[
      Duration(seconds: 1),
      Duration(seconds: 2),
    ]);
  });

  test('authentication failure never starts automatic reconnect', () async {
    final delays = <Duration>[];
    final bloc = SshSessionBloc(
      factory: FakeSessionFactory(<FakeAttempt>[
        FakeAttempt.failed(
          fakeKey(),
          const SshFailure.authentication(message: 'Sign-in failed'),
        ),
      ]),
      knownHosts: FakeKnownHosts(record: fakeRecord(fakeKey().fingerprint)),
      delay: (duration) async => delays.add(duration),
    );
    addTearDown(bloc.close);

    bloc.add(
      const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
    );
    final failed = await bloc.stream
        .where((state) => state is SshSessionFailed)
        .cast<SshSessionFailed>()
        .first;

    expect(failed.failure, isA<SshAuthenticationFailure>());
    expect(delays, isEmpty);
  });

  test('manual disconnect cancels a pending reconnect delay', () async {
    final wait = Completer<void>();
    final session = FakeSession();
    final factory = FakeSessionFactory(<FakeAttempt>[
      FakeAttempt(fakeKey(), session),
      FakeAttempt(fakeKey(), FakeSession()),
    ]);
    final bloc = SshSessionBloc(
      factory: factory,
      knownHosts: FakeKnownHosts(record: fakeRecord(fakeKey().fingerprint)),
      delay: (_) => wait.future,
    );
    bloc.add(
      const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
    );
    await _connected(bloc);

    session.lose(const SshFailure.transport(message: 'Connection lost'));
    await bloc.stream.where((state) => state is SshSessionReconnecting).first;
    bloc.add(const SshSessionEvent.disconnectRequested());
    await bloc.stream.where((state) => state is SshSessionDisconnected).first;

    expect(factory.index, 1);
    expect(bloc.state, isA<SshSessionDisconnected>());
    await expectLater(
      bloc.close().timeout(const Duration(milliseconds: 100)),
      completes,
    );
  });
}

SshSessionBloc _connectedBloc(List<FakeAttempt> attempts) => SshSessionBloc(
  factory: FakeSessionFactory(attempts),
  knownHosts: FakeKnownHosts(record: fakeRecord(fakeKey().fingerprint)),
);

Future<SshSessionState> _connected(SshSessionBloc bloc) =>
    bloc.stream.where((state) => state is SshSessionConnected).first;
