import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/pages/connections/dialogs/delete_profile_dialog.dart';
import 'package:surf_terminal/ui_layout/pages/connections/profile_connector.dart';
import 'package:surf_terminal/ui_layout/pages/connections/widgets/connections_body.dart';
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
    final approved = await showDeleteProfileDialog(context, profile);
    if ((approved ?? false) && context.mounted) {
      context.read<ProfilesBloc>().add(
        ProfilesEvent.profileDeleted(profile.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        if (state case ProfilesFailure(:final errorMessage)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () async {
                  await context
                      .read<AppDependencies>()
                      .retryCredentialCleanup()
                      .catchError((_) {});
                  if (context.mounted) {
                    context.read<ProfilesBloc>().add(
                      const ProfilesEvent.loadRequested(),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
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
          extendBodyBehindAppBar: true,
          appBar: ManagementAppBar(
            title: const Text('Surf Terminal'),
            actions: [
              IconButton(
                tooltip: 'Add host',
                onPressed: () => context.push('/connections/new'),
                icon: const Icon(Icons.add_circle_outline),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ManagementSurface(
            child: SafeArea(
              top: false,
              child: ConnectionsBody(
                profiles: profiles,
                query: _query,
                ascending: _ascending,
                scrollController: _scrollController,
                onQueryChanged: (value) => setState(() => _query = value),
                onSort: () => setState(() => _ascending = !_ascending),
                onOpen: (profile) => ProfileConnector.connect(context, profile),
                onEdit: (profile) =>
                    context.push('/connections/${profile.id}/edit'),
                onDelete: (profile) => _delete(context, profile),
              ),
            ),
          ),
        );
      },
    );
  }
}
