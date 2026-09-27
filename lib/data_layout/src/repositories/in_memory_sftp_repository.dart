import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../datasources/preview_fixture_source.dart';

final class InMemorySftpRepository implements SftpRepository {
  InMemorySftpRepository({
    String initialPath = '/home/demo',
    SftpPreviewState initialPreviewState = SftpPreviewState.data,
  }) : _path = initialPath,
       _previewState = initialPreviewState;

  static const PreviewFixtureSource _fixtures = PreviewFixtureSource();
  String _path;
  SftpPreviewState _previewState;

  @override
  String get path => _path;

  @override
  SftpPreviewState get previewState => _previewState;

  @override
  List<SftpEntry> list() => List<SftpEntry>.of(_fixtures.sftpEntries(_path));

  @override
  void setPreviewState(SftpPreviewState state) {
    _previewState = state;
  }

  @override
  void openFolder(String name) {
    final segment = name.replaceAll(RegExp(r'^/+|/+$'), '');
    if (segment.isEmpty) return;
    _path = _path == '/' ? '/$segment' : '$_path/$segment';
  }

  @override
  void goToParent() {
    if (_path == '/') return;
    final separator = _path.lastIndexOf('/');
    _path = separator <= 0 ? '/' : _path.substring(0, separator);
  }
}
