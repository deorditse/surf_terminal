import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  test('credential references are opaque and stable across profile edits', () {
    const reference = CredentialReference('credential-profile-1');
    const profile = SshProfile(
      id: 'profile-1',
      name: 'Lab',
      host: 'lab.invalid',
      port: 22,
      username: 'operator',
      credentialReference: reference,
    );

    final renamed = profile.copyWith(host: 'renamed.invalid');

    expect(renamed.credentialReference, reference);
    expect(reference.value, isNot(contains(profile.host)));
    expect(reference.value, isNot(contains(profile.username)));
  });

  test('known hosts are endpoint and algorithm scoped', () {
    const endpoint = HostEndpoint(host: 'HOST.invalid.', port: 2222);
    final firstSeen = DateTime.utc(2026, 1, 2);
    final record = KnownHostRecord(
      endpoint: endpoint,
      algorithm: 'ssh-ed25519',
      fingerprint: 'SHA256:fingerprint-a',
      firstSeenAt: firstSeen,
      lastConfirmedAt: firstSeen,
    );

    expect(endpoint.normalizedHost, 'host.invalid');
    expect(record.matches('ssh-ed25519', 'SHA256:fingerprint-a'), isTrue);
    expect(record.matches('rsa-sha2-512', 'SHA256:fingerprint-a'), isFalse);
  });

  test('terminal dimensions reject non-positive rows and columns', () {
    expect(
      () => TerminalDimensions(columns: 0, rows: 24),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => TerminalDimensions(columns: 80, rows: 0),
      throwsA(isA<AssertionError>()),
    );
    expect(
      const TerminalDimensions(columns: 80, rows: 24),
      const TerminalDimensions(columns: 80, rows: 24),
    );
  });

  test(
    'typed failures distinguish retryable transport from security failures',
    () {
      const transport = SshFailure.transport(message: 'Connection lost');
      const authentication = SshFailure.authentication(
        message: 'Sign-in failed',
      );
      const hostKey = SshFailure.hostKey(message: 'Server identity changed');

      expect(transport.isReconnectable, isTrue);
      expect(authentication.isReconnectable, isFalse);
      expect(hostKey.isReconnectable, isFalse);
      expect('$authentication', isNot(contains('credential')));
    },
  );

  test('credential intent carries policy but no credential value', () {
    const intents = <CredentialIntent>[
      CredentialIntent.preserve(),
      CredentialIntent.store(),
      CredentialIntent.remove(),
      CredentialIntent.transient(),
    ];

    expect(intents.map((intent) => intent.runtimeType).toSet(), hasLength(4));
  });
}
