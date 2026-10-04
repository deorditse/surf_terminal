import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/pages/connections/widgets/profile_card.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionsBody extends StatelessWidget {
  const ConnectionsBody({
    required this.profiles,
    required this.query,
    required this.ascending,
    required this.scrollController,
    required this.onQueryChanged,
    required this.onSort,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<SshProfile> profiles;
  final String query;
  final bool ascending;
  final ScrollController scrollController;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSort;
  final ValueChanged<SshProfile> onOpen;
  final ValueChanged<SshProfile> onEdit;
  final ValueChanged<SshProfile> onDelete;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty && query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(SurfSpacing.md),
        child: SurfEmptyState(
          icon: Icons.dns_outlined,
          title: 'No saved hosts',
          description: 'Saved SSH hosts will appear here.',
        ),
      );
    }

    return CustomScrollView(
      key: const PageStorageKey('connections-scroll'),
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList.list(
            children: [
              PageIntro(
                eyebrow: 'SSH workspace',
                title: 'Connections',
                description: 'Search and manage saved SSH profiles.',
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('host-search'),
                      onChanged: onQueryChanged,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search hosts, endpoints or labels',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: ascending ? 'Sort descending' : 'Sort ascending',
                    onPressed: onSort,
                    icon: Icon(
                      ascending ? Icons.south_rounded : Icons.north_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (profiles.isEmpty)
                SurfSection(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: Text('No hosts match “$query”.')),
                  ),
                )
              else
                ...profiles.map(
                  (profile) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProfileCard(
                      profile: profile,
                      onOpen: () => onOpen(profile),
                      onEdit: () => onEdit(profile),
                      onDelete: () => onDelete(profile),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
