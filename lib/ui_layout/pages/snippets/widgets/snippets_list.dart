import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/pages/snippets/widgets/snippet_card.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SnippetsList extends StatelessWidget {
  const SnippetsList({
    required this.snippets,
    required this.filter,
    required this.onFilterChanged,
    required this.onCopy,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<CommandSnippet> snippets;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<CommandSnippet> onCopy;
  final ValueChanged<CommandSnippet> onEdit;
  final ValueChanged<CommandSnippet> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('snippets-scroll'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PageIntro(
          eyebrow: 'Commands',
          title: 'Snippets',
          description: 'Search, copy and edit reusable commands.',
        ),
        const SizedBox(height: 20),
        TextField(
          key: const Key('snippet-search'),
          onChanged: onFilterChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search title, command or label',
          ),
        ),
        const SizedBox(height: 16),
        if (snippets.isEmpty)
          SurfSection(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('No snippets match “$filter”.'),
              ),
            ),
          )
        else
          ...snippets.map(
            (snippet) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SnippetCard(
                snippet: snippet,
                onCopy: () => onCopy(snippet),
                onEdit: () => onEdit(snippet),
                onDelete: () => onDelete(snippet),
              ),
            ),
          ),
      ],
    );
  }
}
