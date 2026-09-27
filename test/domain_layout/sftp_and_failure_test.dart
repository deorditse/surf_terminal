import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  test('SFTP values represent every preview state without platform types', () {
    const entry = SftpEntry(
      name: 'logs',
      metadata: 'Directory',
      isDirectory: true,
    );

    expect(entry.name, 'logs');
    expect(entry.metadata, 'Directory');
    expect(entry.isDirectory, isTrue);
    expect(SftpPreviewState.values, <SftpPreviewState>[
      SftpPreviewState.empty,
      SftpPreviewState.loading,
      SftpPreviewState.data,
      SftpPreviewState.error,
    ]);
  });

  test('RepositoryFailure has stable non-secret diagnostics', () {
    const failure = RepositoryFailure('unavailable', 'Repository unavailable');

    expect(failure.code, 'unavailable');
    expect(failure.message, 'Repository unavailable');
    expect(
      failure.toString(),
      'RepositoryFailure(unavailable): Repository unavailable',
    );
  });
}
