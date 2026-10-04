import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

class TerminalSessionTabs extends StatelessWidget {
  const TerminalSessionTabs({required this.activeId, super.key});

  final String? activeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalSessionsBloc, TerminalSessionsState>(
      builder: (context, state) => ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.sessions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final session = state.sessions[index];
                    final selected = session.id == activeId;
                    return FilterChip(
                      key: Key('session-${session.id}'),
                      selected: selected,
                      label: Text(session.title),
                      avatar: Icon(
                        Icons.circle,
                        size: 9,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : SurfColors.muted,
                      ),
                      onSelected: (_) =>
                          context.read<TerminalSessionsBloc>().add(
                            TerminalSessionsEvent.sessionSelected(session.id),
                          ),
                      deleteIcon: const Icon(Icons.close, size: 17),
                      onDeleted: () async {
                        await context
                            .read<AppDependencies>()
                            .terminalRuntimes
                            .close(session.id);
                        if (context.mounted) {
                          context.read<TerminalSessionsBloc>().add(
                            TerminalSessionsEvent.sessionClosed(session.id),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
