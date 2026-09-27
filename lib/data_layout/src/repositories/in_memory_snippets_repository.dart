import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../datasources/preview_fixture_source.dart';

final class InMemorySnippetsRepository implements SnippetsRepository {
  InMemorySnippetsRepository({List<CommandSnippet>? initialSnippets})
    : _snippets = List<CommandSnippet>.of(
        initialSnippets ?? const PreviewFixtureSource().snippets(),
      );

  final List<CommandSnippet> _snippets;

  @override
  List<CommandSnippet> getAll() => List<CommandSnippet>.of(_snippets);

  @override
  void save(CommandSnippet snippet) {
    final index = _snippets.indexWhere((item) => item.id == snippet.id);
    if (index == -1) {
      _snippets.add(snippet);
    } else {
      _snippets[index] = snippet;
    }
  }

  @override
  void delete(String id) {
    _snippets.removeWhere((snippet) => snippet.id == id);
  }
}
