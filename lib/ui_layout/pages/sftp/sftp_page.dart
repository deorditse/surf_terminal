import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SftpPage extends StatelessWidget {
  const SftpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SftpCubit, SftpState>(
      builder: (context, state) {
        return Scaffold(
          key: const Key('sftp-page'),
          appBar: AppBar(title: const Text('SFTP')),
          body: SafeArea(
            top: false,
            child: ListView(
              key: const PageStorageKey('sftp-scroll'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const PageIntro(
                  eyebrow: 'File workspace',
                  title: 'Browse safely',
                  description: 'Explore a local file fixture. Upload, download and delete remain disabled.',
                  trailing: PreviewBadge(),
                ),
                const SizedBox(height: 20),
                SegmentedButton<SftpPreviewState>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: SftpPreviewState.empty,
                      label: Text('Empty'),
                    ),
                    ButtonSegment(
                      value: SftpPreviewState.loading,
                      label: Text('Loading'),
                    ),
                    ButtonSegment(
                      value: SftpPreviewState.data,
                      label: Text('Files'),
                    ),
                    ButtonSegment(
                      value: SftpPreviewState.error,
                      label: Text('Error'),
                    ),
                  ],
                  selected: {state.previewState},
                  onSelectionChanged: (value) =>
                      context.read<SftpCubit>().setPreviewState(value.first),
                ),
                const SizedBox(height: 18),
                _SftpBody(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SftpBody extends StatelessWidget {
  const _SftpBody({required this.state});
  final SftpState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.previewState) {
      SftpPreviewState.empty => SurfEmptyState(
        icon: Icons.folder_off_outlined,
        title: 'Choose a host first',
        description: 'A profile will anchor this preview. No remote filesystem is contacted.',
        actionLabel: 'Use fixture host',
        onAction: () =>
            context.read<SftpCubit>().setPreviewState(SftpPreviewState.data),
      ),
      SftpPreviewState.loading => const SurfSection(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 42),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading fixture…'),
              ],
            ),
          ),
        ),
      ),
      SftpPreviewState.error => SurfEmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Fixture unavailable',
        description:
            'This is a designed error state, not a failed network request.',
        actionLabel: 'Retry fixture',
        onAction: () =>
            context.read<SftpCubit>().setPreviewState(SftpPreviewState.data),
      ),
      SftpPreviewState.data => _FixtureBrowser(
        path: state.path,
        entries: state.entries,
      ),
    };
  }
}

class _FixtureBrowser extends StatelessWidget {
  const _FixtureBrowser({required this.path, required this.entries});
  final String path;
  final List<SftpEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Fixture files',
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.folder_open_outlined),
            title: Text(
              path,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            subtitle: const Text('Local presentation data'),
            trailing: IconButton(
              tooltip: 'Parent folder',
              onPressed: () =>
                  context.read<SftpCubit>().goToParentFixtureFolder(),
              icon: const Icon(Icons.arrow_upward),
            ),
          ),
          const Divider(height: 1),
          for (final entry in entries)
            _FileRow(
              icon: entry.isDirectory
                  ? Icons.folder_rounded
                  : entry.name.endsWith('.json')
                  ? Icons.data_object
                  : Icons.description_outlined,
              name: entry.name,
              metadata: entry.isDirectory
                  ? 'Folder • fixture'
                  : '${entry.metadata} • preview only',
              onTap: entry.isDirectory
                  ? () =>
                        context.read<SftpCubit>().openFixtureFolder(entry.name)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.icon,
    required this.name,
    required this.metadata,
    this.onTap,
  });
  final IconData icon;
  final String name;
  final String metadata;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: icon == Icons.folder_rounded
            ? Theme.of(context).colorScheme.secondary
            : SurfColors.muted,
      ),
      title: Text(name),
      subtitle: Text(metadata),
      onTap: onTap,
      trailing: PopupMenuButton<String>(
        tooltip: 'Preview file actions',
        itemBuilder: (_) => const [
          PopupMenuItem(
            enabled: false,
            value: 'download',
            child: Text('Download — coming later'),
          ),
          PopupMenuItem(
            enabled: false,
            value: 'rename',
            child: Text('Rename — coming later'),
          ),
          PopupMenuItem(
            enabled: false,
            value: 'delete',
            child: Text('Delete — coming later'),
          ),
        ],
      ),
    );
  }
}
