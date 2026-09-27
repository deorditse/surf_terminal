import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class SftpState {
  SftpState({
    this.previewState = SftpPreviewState.loading,
    this.path = '/',
    List<SftpEntry> entries = const <SftpEntry>[],
    this.errorMessage,
  }) : entries = List<SftpEntry>.unmodifiable(entries);

  final SftpPreviewState previewState;
  final String path;
  final List<SftpEntry> entries;
  final String? errorMessage;
}
