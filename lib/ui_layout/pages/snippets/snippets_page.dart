import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/pages/snippets/widgets/snippets_list.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SnippetsPage extends StatefulWidget {
  const SnippetsPage({super.key});

  @override
  State<SnippetsPage> createState() => _SnippetsPageState();
}

class _SnippetsPageState extends State<SnippetsPage> {
  Future<void> _delete(BuildContext context, CommandSnippet snippet) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete snippet?'),
        content: Text('Remove “${snippet.title}” from your snippets?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if ((approved ?? false) && context.mounted) {
      context.read<SnippetsBloc>().add(
        SnippetsEvent.snippetDeleted(snippet.id),
      );
    }
  }

  Future<void> _copy(BuildContext context, CommandSnippet snippet) async {
    await Clipboard.setData(ClipboardData(text: snippet.command));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Command copied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SnippetsBloc, SnippetsState>(
      builder: (context, state) {
        final snippets = state.snippets.where((snippet) {
          final haystack =
              '${snippet.title} ${snippet.command} ${snippet.labels.join(' ')}'
                  .toLowerCase();
          return haystack.contains(state.filter.toLowerCase());
        }).toList();
        return Scaffold(
          key: const Key('snippets-page'),
          extendBodyBehindAppBar: true,
          appBar: ManagementAppBar(title: const Text('Snippets')),
          body: ManagementSurface(
            child: SafeArea(
              top: false,
              child: state.snippets.isEmpty
                  ? ListView(
                      key: const PageStorageKey('snippets-scroll'),
                      padding: EdgeInsets.fromLTRB(
                        16,
                        managementScrollTopPadding(context),
                        16,
                        24,
                      ),
                      children: [
                        SurfEmptyState(
                          icon: Icons.code_rounded,
                          title: 'No snippets',
                          description: 'Reusable commands will appear here.',
                          actionLabel: 'Add snippet',
                          onAction: () => context.push('/snippets/new'),
                        ),
                      ],
                    )
                  : SnippetsList(
                      snippets: snippets,
                      filter: state.filter,
                      onFilterChanged: (value) => context
                          .read<SnippetsBloc>()
                          .add(SnippetsEvent.filterChanged(value)),
                      onCopy: (snippet) => _copy(context, snippet),
                      onEdit: (snippet) =>
                          context.push('/snippets/${snippet.id}/edit'),
                      onDelete: (snippet) => _delete(context, snippet),
                    ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('add-snippet-fab'),
            heroTag: 'snippets-add-fab',
            onPressed: () => context.push('/snippets/new'),
            icon: const Icon(Icons.add),
            label: const Text('Snippet'),
          ),
        );
      },
    );
  }
}
