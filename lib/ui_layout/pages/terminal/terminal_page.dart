import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
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
    return ColoredBox(
      key: const Key('terminal-page'),
      color: SurfColors.ink,
      child: Stack(
        fit: StackFit.expand,
        children: [
          runtime == null
              ? SurfEmptyState(
                  icon: CupertinoIcons.device_desktop,
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
          Positioned(
            left: 12,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: SizedBox.square(
                dimension: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GlassContainer(
                      key: const Key('terminal-glass-top-controls'),
                      useOwnLayer: true,
                      quality: GlassQuality.standard,
                      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
                      padding: EdgeInsets.zero,
                      child: const SizedBox.square(dimension: 32),
                    ),
                    CupertinoButton(
                      minimumSize: const Size(44, 44),
                      padding: EdgeInsets.zero,
                      onPressed: () => context.go('/connections'),
                      child: const Icon(CupertinoIcons.back, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
