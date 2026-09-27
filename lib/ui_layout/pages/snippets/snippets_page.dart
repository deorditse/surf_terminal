import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
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
        content: Text('Remove “${snippet.title}” from this local preview?'),
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
      context.read<SnippetsCubit>().deleteSnippet(snippet.id);
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
    return BlocBuilder<SnippetsCubit, SnippetsState>(
      builder: (context, state) {
        final snippets = state.snippets.where((snippet) {
          final haystack =
              '${snippet.title} ${snippet.command} ${snippet.labels.join(' ')}'
                  .toLowerCase();
          return haystack.contains(state.filter.toLowerCase());
        }).toList();
        return Scaffold(
          key: const Key('snippets-page'),
          appBar: AppBar(title: const Text('Snippets')),
          body: SafeArea(
            top: false,
            child: state.snippets.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: SurfEmptyState(
                      icon: Icons.code_rounded,
                      title: 'Build your command shelf',
                      description: 'Store reusable commands in memory for this preview run.',
                      actionLabel: 'Add snippet',
                      onAction: () => context.push('/snippets/new'),
                    ),
                  )
                : ListView(
                    key: const PageStorageKey('snippets-scroll'),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      const PageIntro(
                        eyebrow: 'Command library',
                        title: 'Move faster',
                        description: 'Search, copy and refine safe reusable command templates.',
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        key: const Key('snippet-search'),
                        onChanged: context.read<SnippetsCubit>().setFilter,
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
                              child: Text(
                                'No snippets match “${state.filter}”.',
                              ),
                            ),
                          ),
                        )
                      else
                        ...snippets.map(
                          (snippet) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snippet.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Copy command',
                                          onPressed: () =>
                                              _copy(context, snippet),
                                          icon: const Icon(Icons.copy_outlined),
                                        ),
                                        PopupMenuButton<String>(
                                          tooltip: 'Snippet actions',
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              context.push(
                                                '/snippets/${snippet.id}/edit',
                                              );
                                            }
                                            if (value == 'delete') {
                                              _delete(context, snippet);
                                            }
                                          },
                                          itemBuilder: (_) => const [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (snippet.description.isNotEmpty) ...[
                                      Text(
                                        snippet.description,
                                        style: const TextStyle(
                                          color: SurfColors.muted,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: SurfColors.ink,
                                        borderRadius: BorderRadius.circular(
                                          SurfRadii.sm,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            const Text(
                                              r'$',
                                              style: TextStyle(
                                                color: SurfColors.tide,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                snippet.command,
                                                style: const TextStyle(
                                                  color: SurfColors.foam,
                                                  fontFamily: 'monospace',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (snippet.labels.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: snippet.labels
                                            .map(
                                              (label) =>
                                                  Chip(label: Text(label)),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('add-snippet-fab'),
            onPressed: () => context.push('/snippets/new'),
            icon: const Icon(Icons.add),
            label: const Text('Snippet'),
          ),
        );
      },
    );
  }
}
