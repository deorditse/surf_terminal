import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  final _scrollController = ScrollController();
  String _query = '';
  bool _ascending = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _delete(BuildContext context, SshProfile profile) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete host?'),
        content: Text('Remove “${profile.name}” from this local preview?'),
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
    if (approved ?? false) {
      if (context.mounted) {
        context.read<ProfilesCubit>().deleteProfile(profile.id);
      }
    }
  }

  void _openTerminal(BuildContext context, SshProfile profile) {
    final session = context.read<TerminalSessionsCubit>().openSession(
      profile.name,
    );
    context.push('/terminal/${session.id}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final profiles =
            state.profiles.where((profile) {
              final haystack =
                  '${profile.name} ${profile.endpoint} ${profile.label}'
                      .toLowerCase();
              return haystack.contains(_query.toLowerCase());
            }).toList()..sort(
              (a, b) => _ascending
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name),
            );

        return Scaffold(
          key: const Key('connections-page'),
          appBar: AppBar(
            title: const Text('Surf Terminal'),
            actions: [
              IconButton(
                tooltip: 'Add SSH host',
                onPressed: () => context.push('/connections/new'),
                icon: const Icon(Icons.add_circle_outline),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: profiles.isEmpty && _query.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(SurfSpacing.md),
                    child: SurfEmptyState(
                      icon: Icons.dns_outlined,
                      title: 'Your terminal starts here',
                      description: 'Create a local SSH profile. Credentials and network connections are intentionally disabled in this preview.',
                      actionLabel: 'Create host',
                      onAction: () => context.push('/connections/new'),
                    ),
                  )
                : CustomScrollView(
                    key: const PageStorageKey('connections-scroll'),
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        sliver: SliverList.list(
                          children: [
                            PageIntro(
                              eyebrow: 'SSH workspace',
                              title: 'Connections',
                              description: 'Launch an offline terminal preview or manage local presentation profiles.',
                              trailing: const PreviewBadge(),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    key: const Key('host-search'),
                                    onChanged: (value) =>
                                        setState(() => _query = value),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText:
                                          'Search hosts, endpoints or labels',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton.filledTonal(
                                  tooltip: _ascending
                                      ? 'Sort descending'
                                      : 'Sort ascending',
                                  onPressed: () =>
                                      setState(() => _ascending = !_ascending),
                                  icon: Icon(
                                    _ascending
                                        ? Icons.south_rounded
                                        : Icons.north_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            if (profiles.isEmpty)
                              SurfSection(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  child: Center(
                                    child: Text('No hosts match “$_query”.'),
                                  ),
                                ),
                              )
                            else
                              ...profiles.map(
                                (profile) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ProfileCard(
                                    profile: profile,
                                    onOpen: () =>
                                        _openTerminal(context, profile),
                                    onEdit: () => context.push(
                                      '/connections/${profile.id}/edit',
                                    ),
                                    onDelete: () => _delete(context, profile),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          floatingActionButton: profiles.isEmpty && _query.isEmpty
              ? null
              : FloatingActionButton.extended(
                  key: const Key('add-host-fab'),
                  onPressed: () => context.push('/connections/new'),
                  icon: const Icon(Icons.add),
                  label: const Text('Host'),
                ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final SshProfile profile;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: Key('profile-${profile.id}'),
        borderRadius: BorderRadius.circular(SurfRadii.md),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.14),
                child: Icon(
                  Icons.terminal,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            child: Text(
                              profile.label,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.endpoint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: SurfColors.muted,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Host actions',
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
