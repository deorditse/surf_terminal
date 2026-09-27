import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('InMemorySftpRepository', () {
    test('starts at /home/demo with preview folders and files', () {
      final repository = InMemorySftpRepository();

      expect(repository.path, '/home/demo');
      expect(repository.previewState, SftpPreviewState.data);
      expect(repository.list().map((entry) => entry.name), <String>[
        'projects',
        'notes',
        'README.md',
        'sample.json',
      ]);
      expect(
        repository.list().where((entry) => entry.isDirectory),
        hasLength(2),
      );
      expect(
        repository.list().where((entry) => !entry.isDirectory),
        hasLength(2),
      );
    });

    test('returns a collection copy', () {
      final repository = InMemorySftpRepository();

      repository.list().clear();

      expect(repository.list(), hasLength(4));
    });

    test('lists path-dependent fixture content after opening a folder', () {
      final repository = InMemorySftpRepository();

      repository.openFolder('projects');

      expect(repository.path, '/home/demo/projects');
      expect(repository.list().map((entry) => entry.name), <String>[
        'surf-terminal',
        'release-notes.txt',
      ]);
    });

    test('navigates to parents and does not move above root', () {
      final repository = InMemorySftpRepository();

      repository.openFolder('notes');
      repository.goToParent();
      expect(repository.path, '/home/demo');
      repository.goToParent();
      expect(repository.path, '/home');
      repository.goToParent();
      expect(repository.path, '/');
      repository.goToParent();
      expect(repository.path, '/');
    });

    test('supports empty, loading, data, and error preview states', () {
      final repository = InMemorySftpRepository();

      for (final state in SftpPreviewState.values) {
        repository.setPreviewState(state);
        expect(repository.previewState, state);
      }
    });

    test('unknown fixture paths have an empty listing', () {
      final repository = InMemorySftpRepository();

      repository.openFolder('missing');

      expect(repository.path, '/home/demo/missing');
      expect(repository.list(), isEmpty);
    });
  });
}
