import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

class SnippetCard extends StatelessWidget {
  const SnippetCard({
    required this.snippet,
    required this.onCopy,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final CommandSnippet snippet;
  final VoidCallback onCopy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy command',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_outlined),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Snippet actions',
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            if (snippet.description.isNotEmpty) ...[
              Text(
                snippet.description,
                style: const TextStyle(color: SurfColors.muted),
              ),
              const SizedBox(height: 12),
            ],
            DecoratedBox(
              decoration: BoxDecoration(
                color: SurfColors.ink,
                borderRadius: BorderRadius.circular(SurfRadii.sm),
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
                    .map((label) => Chip(label: Text(label)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
