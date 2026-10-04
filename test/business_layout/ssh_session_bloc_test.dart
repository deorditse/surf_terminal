import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'support/ssh_session_fakes.dart';

void main() {
  test(
    'unknown host pauses before authentication until explicitly trusted',
    () async {
      final hosts = FakeKnownHosts();
      final attempt = FakeAttempt(fakeKey(), FakeSession());
      final bloc = SshSessionBloc(
        factory: FakeSessionFactory(<FakeAttempt>[attempt]),
        knownHosts: hosts,
        now: () => DateTime.utc(2026, 1, 2),
      );
      addTearDown(bloc.close);

      bloc.add(
        const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
      );
      final verifying = await bloc.stream
          .where((state) => state is SshSessionVerifying)
          .cast<SshSessionVerifying>()
          .first;

      expect(attempt.acceptCount, 0);
      expect(verifying.challenge.kind, HostKeyChallengeKind.unknown);
      bloc.add(SshSessionEvent.hostKeyAccepted(verifying.connectionId));
      await bloc.stream.where((state) => state is SshSessionConnected).first;

      expect(attempt.acceptCount, 1);
      expect(hosts.saved, hasLength(1));
    },
  );

  test(
    'changed host key requires replacement and rejects stale decisions',
    () async {
      final hosts = FakeKnownHosts(record: fakeRecord('SHA256:old'));
      final attempt = FakeAttempt(fakeKey(), FakeSession());
      final bloc = SshSessionBloc(
        factory: FakeSessionFactory(<FakeAttempt>[attempt]),
        knownHosts: hosts,
      );
      addTearDown(bloc.close);

      bloc.add(
        const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
      );
      final verifying = await bloc.stream
          .where((state) => state is SshSessionVerifying)
          .cast<SshSessionVerifying>()
          .first;
      expect(verifying.challenge.kind, HostKeyChallengeKind.changed);

      bloc.add(const SshSessionEvent.hostKeyAccepted('stale-attempt'));
      await Future<void>.delayed(Duration.zero);
      expect(attempt.acceptCount, 0);

      bloc.add(SshSessionEvent.hostKeyReplaced(verifying.connectionId));
      await bloc.stream.where((state) => state is SshSessionConnected).first;
      expect(hosts.saved.single.fingerprint, fakeKey().fingerprint);
    },
  );

  test(
    'host key rejection cancels the attempt and never authenticates',
    () async {
      final attempt = FakeAttempt(fakeKey(), FakeSession());
      final bloc = SshSessionBloc(
        factory: FakeSessionFactory(<FakeAttempt>[attempt]),
        knownHosts: FakeKnownHosts(),
      );
      addTearDown(bloc.close);

      bloc.add(
        const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
      );
      final verifying = await bloc.stream
          .where((state) => state is SshSessionVerifying)
          .cast<SshSessionVerifying>()
          .first;
      bloc.add(SshSessionEvent.hostKeyRejected(verifying.connectionId));
      final failed = await bloc.stream
          .where((state) => state is SshSessionFailed)
          .cast<SshSessionFailed>()
          .first;

      expect(failed.failure, isA<SshHostKeyFailure>());
      expect(attempt.rejectCount, 1);
      expect(attempt.acceptCount, 0);
    },
  );

  test(
    'duplicate connect requests are dropped while trust is pending',
    () async {
      final factory = FakeSessionFactory(<FakeAttempt>[
        FakeAttempt(fakeKey(), FakeSession()),
      ]);
      final bloc = SshSessionBloc(
        factory: factory,
        knownHosts: FakeKnownHosts(),
      );
      addTearDown(bloc.close);

      bloc
        ..add(
          const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
        )
        ..add(
          const SshSessionEvent.connectRequested(fakeProfile, fakeDimensions),
        );
      await bloc.stream.where((state) => state is SshSessionVerifying).first;

      expect(factory.index, 1);
    },
  );
}
