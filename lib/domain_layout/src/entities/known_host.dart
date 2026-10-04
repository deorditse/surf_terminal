final class HostEndpoint {
  const HostEndpoint({required this.host, required this.port})
    : assert(host != ''),
      assert(port > 0 && port <= 65535);

  final String host;
  final int port;

  String get normalizedHost {
    final lower = host.trim().toLowerCase();
    return lower.endsWith('.') ? lower.substring(0, lower.length - 1) : lower;
  }

  @override
  bool operator ==(Object other) =>
      other is HostEndpoint &&
      other.normalizedHost == normalizedHost &&
      other.port == port;

  @override
  int get hashCode => Object.hash(normalizedHost, port);

  @override
  String toString() => '$normalizedHost:$port';
}

final class PresentedHostKey {
  const PresentedHostKey({
    required this.endpoint,
    required this.algorithm,
    required this.fingerprint,
  });

  final HostEndpoint endpoint;
  final String algorithm;
  final String fingerprint;
}

final class KnownHostRecord {
  const KnownHostRecord({
    required this.endpoint,
    required this.algorithm,
    required this.fingerprint,
    required this.firstSeenAt,
    required this.lastConfirmedAt,
  });

  final HostEndpoint endpoint;
  final String algorithm;
  final String fingerprint;
  final DateTime firstSeenAt;
  final DateTime lastConfirmedAt;

  bool matches(String candidateAlgorithm, String candidateFingerprint) =>
      algorithm == candidateAlgorithm && fingerprint == candidateFingerprint;

  KnownHostRecord confirmedAt(DateTime value) => KnownHostRecord(
    endpoint: endpoint,
    algorithm: algorithm,
    fingerprint: fingerprint,
    firstSeenAt: firstSeenAt,
    lastConfirmedAt: value,
  );
}

enum HostKeyChallengeKind { unknown, changed }

final class HostKeyChallenge {
  const HostKeyChallenge({
    required this.presented,
    required this.kind,
    this.previousFingerprint,
  });

  final PresentedHostKey presented;
  final HostKeyChallengeKind kind;
  final String? previousFingerprint;
}
