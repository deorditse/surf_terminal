import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  bool _control = false;
  bool _alt = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TerminalSessionsCubit>();
    if (cubit.state.sessions.any((item) => item.id == widget.sessionId)) {
      cubit.selectSession(widget.sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalSessionsCubit, TerminalSessionsState>(
      builder: (context, state) {
        final active = state.activeSession;
        return Scaffold(
          key: const Key('terminal-page'),
          appBar: AppBar(
            title: const Text('Terminal preview'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(child: PreviewBadge(label: 'OFFLINE')),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                _SessionTabs(activeId: state.activeSessionId),
                Expanded(
                  child: active == null
                      ? SurfEmptyState(
                          icon: Icons.tab_unselected,
                          title: 'No preview sessions',
                          description: 'Add a local session tab to explore the terminal workspace without opening a network connection.',
                          actionLabel: 'New preview session',
                          onAction: () =>
                              context.read<TerminalSessionsCubit>().openSession(
                                'Preview ${state.sessions.length + 1}',
                              ),
                        )
                      : BlocSelector<
                          SettingsCubit,
                          SettingsState,
                          TerminalPreferences
                        >(
                          selector: (state) => state.preferences,
                          builder: (context, preferences) => _TerminalViewport(
                            session: active,
                            preferences: preferences,
                          ),
                        ),
                ),
                if (active != null)
                  _SpecialKeys(
                    control: _control,
                    alt: _alt,
                    onControl: () => setState(() => _control = !_control),
                    onAlt: () => setState(() => _alt = !_alt),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SessionTabs extends StatelessWidget {
  const _SessionTabs({required this.activeId});
  final String? activeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalSessionsCubit, TerminalSessionsState>(
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
                      onSelected: (_) => context
                          .read<TerminalSessionsCubit>()
                          .selectSession(session.id),
                      deleteIcon: const Icon(Icons.close, size: 17),
                      onDeleted: () => context
                          .read<TerminalSessionsCubit>()
                          .closeSession(session.id),
                    );
                  },
                ),
              ),
              IconButton(
                key: const Key('add-session'),
                tooltip: 'Add preview session',
                onPressed: () => context
                    .read<TerminalSessionsCubit>()
                    .openSession('Preview ${state.sessions.length + 1}'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _TerminalViewport extends StatelessWidget {
  const _TerminalViewport({required this.session, required this.preferences});
  final PreviewSession session;
  final TerminalPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final cursor = switch (preferences.cursorStyle) {
      TerminalCursorStyle.block => '█',
      TerminalCursorStyle.underline => '_',
      TerminalCursorStyle.bar => '▏',
    };
    return Semantics(
      label: 'Synthetic offline terminal preview for ${session.title}',
      child: ColoredBox(
        color: preferences.terminalBackground,
        child: ListView(
          key: const Key('terminal-viewport'),
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'Surf Terminal • ${session.title}',
              style: TextStyle(
                color: preferences.terminalForeground,
                fontFamily: 'monospace',
                fontSize: preferences.fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Offline preview — no SSH connection is active.\n\npreview@local:~\$ ls -lah\ndrwxr-xr-x  docs\ndrwxr-xr-x  projects\n-rw-r--r--  README.md\n\npreview@local:~\$ $cursor',
              style: TextStyle(
                color: preferences.terminalForeground.withValues(alpha: 0.88),
                fontFamily: 'monospace',
                fontSize: preferences.fontSize,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialKeys extends StatelessWidget {
  const _SpecialKeys({
    required this.control,
    required this.alt,
    required this.onControl,
    required this.onAlt,
  });
  final bool control;
  final bool alt;
  final VoidCallback onControl;
  final VoidCallback onAlt;

  @override
  Widget build(BuildContext context) {
    Widget keyButton(
      String label, {
      VoidCallback? onPressed,
      bool selected = false,
      IconData? icon,
    }) {
      return Semantics(
        label: '$label terminal key',
        selected: selected,
        button: true,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: selected
              ? FilledButton.tonalIcon(
                  onPressed: onPressed,
                  icon: Icon(icon ?? Icons.keyboard_command_key, size: 18),
                  label: Text(label),
                )
              : OutlinedButton(
                  onPressed: onPressed,
                  child: icon == null ? Text(label) : Icon(icon),
                ),
        ),
      );
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 64,
        child: ListView(
          key: const Key('special-key-toolbar'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          scrollDirection: Axis.horizontal,
          children: [
            keyButton('Esc'),
            keyButton('Ctrl', onPressed: onControl, selected: control),
            keyButton('Alt', onPressed: onAlt, selected: alt),
            keyButton('Tab'),
            keyButton(
              'Paste',
              onPressed: () => Clipboard.getData(Clipboard.kTextPlain),
              icon: Icons.content_paste,
            ),
            keyButton('Left', icon: Icons.arrow_back),
            keyButton('Down', icon: Icons.arrow_downward),
            keyButton('Up', icon: Icons.arrow_upward),
            keyButton('Right', icon: Icons.arrow_forward),
            keyButton(
              'Hide keyboard',
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              icon: Icons.keyboard_hide,
            ),
          ],
        ),
      ),
    );
  }
}
