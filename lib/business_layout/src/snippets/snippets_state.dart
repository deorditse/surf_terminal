import 'package:surf_terminal/domain_layout/domain_layout.dart';

enum SnippetsStatus { loading, success, failure }

final class SnippetsState {
  SnippetsState({
    this.status = SnippetsStatus.loading,
    List<CommandSnippet> snippets = const <CommandSnippet>[],
    this.filter = '',
    this.errorMessage,
  }) : snippets = List<CommandSnippet>.unmodifiable(snippets);

  final SnippetsStatus status;
  final List<CommandSnippet> snippets;
  final String filter;
  final String? errorMessage;

  List<CommandSnippet> get filteredSnippets {
    final query = filter.trim().toLowerCase();
    if (query.isEmpty) return snippets;
    return List<CommandSnippet>.unmodifiable(
      snippets.where((snippet) {
        final searchable = <String>[
          snippet.title,
          snippet.command,
          snippet.description,
          ...snippet.labels,
        ].join(' ').toLowerCase();
        return searchable.contains(query);
      }),
    );
  }

  SnippetsState copyWith({
    SnippetsStatus? status,
    List<CommandSnippet>? snippets,
    String? filter,
    String? errorMessage,
    bool clearError = false,
  }) => SnippetsState(
    status: status ?? this.status,
    snippets: snippets ?? this.snippets,
    filter: filter ?? this.filter,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
