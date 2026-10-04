import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_pane.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class TerminalPage extends StatelessWidget {
  const TerminalPage({required this.sessionId, super.key});
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final runtime = context.read<AppDependencies>().terminalRuntimes.find(
      sessionId,
    );
    return Scaffold(
      key: const Key('terminal-page'),
      backgroundColor: const Color(0xFF080B0F),
      appBar: AppBar(title: const Text('Terminal')),
      body: SafeArea(
        top: false,
        child: runtime == null
            ? SurfEmptyState(
                icon: Icons.terminal,
                title: 'Session unavailable',
                description: 'Return to SSH profiles to start a session.',
                actionLabel: 'SSH profiles',
                onAction: () => context.go('/connections'),
              )
            : BlocSelector<SettingsBloc, SettingsState, TerminalPreferences>(
                selector: (state) => state.preferences,
                builder: (context, preferences) => SessionPane(
                  key: ValueKey(runtime.id),
                  runtime: runtime,
                  preferences: preferences,
                ),
              ),
      ),
    );
  }
}
