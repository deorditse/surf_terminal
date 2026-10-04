import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import 'support/dartssh_adapter_fakes.dart';

void main() {
  const dimensions = TerminalDimensions(columns: 100, rows: 30);
  const profile = SshProfile(
    id: 'profile-id',
    name: 'Test',
    host: 'host.invalid',
    port: 2222,
    username: 'operator',
    credentialReference: CredentialReference('opaque-id'),
  );

  test(
    'mandatory verifier blocks until accepted and password is read for auth',
    () async {
      final backend = FakeSshBackend();
      final credentials = FakeCredentialStore();
      final attempt = DartSshSessionFactory(
        backend: backend,
        credentialStore: credentials,
      ).start(profile, dimensions);
      await backend.connected;

      expect(backend.request!.disableHostkeyVerification, isFalse);
      final verification = backend.request!.verifyHostKey(
        'ssh-ed25519',
        'SHA256:fictional-fingerprint',
      );
      final presented = await attempt.presentedHostKey;
      expect(
        presented.endpoint,
        const HostEndpoint(host: 'host.invalid', port: 2222),
      );
      expect(credentials.readCount, 0);
      expect(await futureStaysPending(verification), isTrue);

      await attempt.acceptHostKey();
      expect(await verification, isTrue);
      final session = await attempt.session;
      expect(session, isA<SshSession>());
      expect(credentials.readCount, 1);
      expect(backend.client.openedDimensions, dimensions);
    },
  );

  test(
    'rejection resolves verifier false and does not retrieve credential',
    () async {
      final backend = FakeSshBackend();
      final credentials = FakeCredentialStore();
      final attempt = DartSshSessionFactory(
        backend: backend,
        credentialStore: credentials,
      ).start(profile, dimensions);
      await backend.connected;
      final verification = backend.request!.verifyHostKey(
        'ssh-ed25519',
        'SHA256:fictional-fingerprint',
      );
      await attempt.presentedHostKey;

      await attempt.rejectHostKey();
      expect(await verification, isFalse);
      expect(credentials.readCount, 0);
    },
  );

  test(
    'session preserves fragmented bytes and supports resize and close',
    () async {
      final shell = FakeShell();
      final client = FakeClient(shell);
      final session = DartSshSession(client: client, shell: shell);
      final chunks = <List<int>>[];
      final subscription = session.output.listen(chunks.add);

      shell.stdout.add(<int>[0xe2]);
      shell.stdout.add(<int>[0x82, 0xac, 0x1b, 0x5b, 0x31, 0x6d]);
      shell.stderr.add(<int>[0x65, 0x72, 0x72]);
      await Future<void>.delayed(Duration.zero);
      expect(chunks, hasLength(3));
      expect(
        chunks.any((chunk) => chunk.length == 1 && chunk.first == 0xe2),
        isTrue,
      );
      expect(
        chunks.any(
          (chunk) =>
              chunk.length == 6 &&
              chunk[0] == 0x82 &&
              chunk[1] == 0xac &&
              chunk[2] == 0x1b,
        ),
        isTrue,
      );
      expect(
        chunks.any(
          (chunk) => chunk.length == 3 && chunk[0] == 0x65 && chunk[1] == 0x72,
        ),
        isTrue,
      );
      expect(
        chunks.indexWhere((chunk) => chunk.length == 1 && chunk.first == 0xe2),
        lessThan(
          chunks.indexWhere(
            (chunk) => chunk.length == 6 && chunk.first == 0x82,
          ),
        ),
      );

      await session.send(<int>[3]);
      await session.resize(const TerminalDimensions(columns: 120, rows: 40));
      expect(shell.writes, <List<int>>[
        <int>[3],
      ]);
      expect(shell.resizes.single.columns, 120);
      await session.close();
      await session.close();
      expect(shell.closeCount, 1);
      expect(client.closeCount, 1);
      await expectLater(
        session.send(<int>[1]),
        throwsA(isA<SshCancelledFailure>()),
      );
      await subscription.cancel();
    },
  );

  test('exception mapper returns sanitized typed failures', () {
    const diagnostic = 'fictional-sensitive-backend-diagnostic';
    final cases = <(Object, SshFailure)>[
      (SocketException(diagnostic), const SshFailure.dns(message: '')),
      (TimeoutException(diagnostic), const SshFailure.timeout(message: '')),
      (
        SSHHandshakeError('Handshake timed out: $diagnostic'),
        const SshFailure.timeout(message: ''),
      ),
      (
        SSHAuthAbortError('Authentication timed out: $diagnostic'),
        const SshFailure.timeout(message: ''),
      ),
      (
        SSHHandshakeError(diagnostic),
        const SshFailure.negotiation(message: ''),
      ),
      (SSHHostkeyError(diagnostic), const SshFailure.hostKey(message: '')),
      (
        SSHAuthFailError(diagnostic),
        const SshFailure.authentication(message: ''),
      ),
      (SSHChannelOpenError(1, diagnostic), const SshFailure.shell(message: '')),
      (
        SSHChannelRequestError('Failed to allocate pty: $diagnostic'),
        const SshFailure.pty(message: ''),
      ),
    ];

    for (final (error, expected) in cases) {
      final mapped = mapSshException(error, operation: SshOperation.connect);
      expect(mapped.runtimeType, expected.runtimeType);
      expect(mapped.toString(), isNot(contains(diagnostic)));
    }
    expect(
      mapSshException(StateError(diagnostic), operation: SshOperation.shell),
      isA<SshShellFailure>(),
    );
  });
}
