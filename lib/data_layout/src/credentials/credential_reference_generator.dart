import 'dart:math';

import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class CredentialReferenceGenerator {
  CredentialReferenceGenerator({Random? random})
    : _random = random ?? Random.secure();

  final Random _random;

  CredentialReference create() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    final uuid =
        '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
    return CredentialReference('surf_terminal.ssh.password.$uuid');
  }
}
