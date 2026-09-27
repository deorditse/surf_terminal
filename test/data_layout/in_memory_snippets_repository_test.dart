import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('InMemorySnippetsRepository', () {
    test('starts with fictional preview snippets', () {
      final snippets = InMemorySnippetsRepository().getAll();

      expect(snippets.map((snippet) => snippet.title), <String>[
        'Service status',
        'Disk overview',
      ]);
      expect(snippets.first.command, 'systemctl --no-pager --failed');
      expect(snippets.last.command, 'df -hT');
    });

    test('returns a collection copy', () {
      final repository = InMemorySnippetsRepository();

      repository.getAll().clear();

      expect(repository.getAll(), hasLength(2));
    });

    test('saves a snippet and updates the matching id in place', () {
      final repository = InMemorySnippetsRepository(initialSnippets: const []);
      final snippet = CommandSnippet(
        id: 'snippet-local',
        title: 'List directory',
        command: 'ls',
      );

      repository.save(snippet);
      repository.save(snippet.copyWith(title: 'List files'));

      expect(repository.getAll(), hasLength(1));
      expect(repository.getAll().single.title, 'List files');
    });

    test('deletes snippets through the final empty state', () {
      final repository = InMemorySnippetsRepository();

      for (final snippet in repository.getAll()) {
        repository.delete(snippet.id);
      }

      expect(repository.getAll(), isEmpty);
    });
  });
}
