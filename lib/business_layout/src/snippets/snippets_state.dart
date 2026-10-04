import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'snippets_state.freezed.dart';

enum SnippetsStatus { loading, success, failure }

@freezed
sealed class SnippetsState with _$SnippetsState {
  const SnippetsState._();

  const factory SnippetsState.loading({
    @Default(<CommandSnippet>[]) List<CommandSnippet> snippets,
    @Default('') String filter,
    String? errorMessage,
  }) = SnippetsLoading;

  const factory SnippetsState.success({
    required List<CommandSnippet> snippets,
    @Default('') String filter,
    String? errorMessage,
  }) = SnippetsSuccess;

  const factory SnippetsState.failure({
    required List<CommandSnippet> snippets,
    @Default('') String filter,
    required String errorMessage,
  }) = SnippetsFailure;

  SnippetsStatus get status => switch (this) {
    SnippetsLoading() => SnippetsStatus.loading,
    SnippetsSuccess() => SnippetsStatus.success,
    SnippetsFailure() => SnippetsStatus.failure,
  };

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
}
