import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'snippets_event.freezed.dart';

@freezed
sealed class SnippetsEvent with _$SnippetsEvent {
  const factory SnippetsEvent.loadRequested() = SnippetsLoadRequested;
  const factory SnippetsEvent.filterChanged(String value) =
      SnippetsFilterChanged;
  const factory SnippetsEvent.snippetSaved(CommandSnippet snippet) =
      SnippetSaved;
  const factory SnippetsEvent.snippetDeleted(String id) = SnippetDeleted;
}
