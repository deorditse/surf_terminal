import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/host_trust_dialog.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/special_keys.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/terminal_lifecycle_surface.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/terminal_viewport.dart';

class SessionPane extends StatefulWidget {
  const SessionPane({
    required this.runtime,
    required this.preferences,
    super.key,
  });
  final TerminalSessionRuntime runtime;
  final TerminalPreferences preferences;
  @override
  State<SessionPane> createState() => _SessionPaneState();
}

class _SessionPaneState extends State<SessionPane> {
  bool _control = false;
  bool _alt = false;
  String? _promptedConnectionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = widget.runtime.bloc.state;
      if (mounted && state is SshSessionVerifying) _trust(state);
    });
  }

  void _send(String sequence) {
    widget.runtime.terminal.textInput(sequence);
    widget.runtime.focusNode.requestFocus();
    setState(() {
      _control = false;
      _alt = false;
    });
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text != null && text.isNotEmpty) widget.runtime.terminal.paste(text);
    widget.runtime.focusNode.requestFocus();
  }

  Future<void> _trust(SshSessionVerifying state) async {
    if (_promptedConnectionId == state.connectionId) return;
    _promptedConnectionId = state.connectionId;
    final decision = await showHostTrustDialog(context, state.challenge);
    if (!mounted) return;
    widget.runtime.bloc.add(switch (decision) {
      HostTrustDecision.accept => SshSessionEvent.hostKeyAccepted(
        state.connectionId,
      ),
      HostTrustDecision.replace => SshSessionEvent.hostKeyReplaced(
        state.connectionId,
      ),
      HostTrustDecision.reject => SshSessionEvent.hostKeyRejected(
        state.connectionId,
      ),
    });
  }

  void _retry() => widget.runtime.bloc.add(
    SshSessionEvent.connectRequested(
      widget.runtime.profile,
      TerminalDimensions(
        columns: widget.runtime.terminal.viewWidth,
        rows: widget.runtime.terminal.viewHeight,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: widget.runtime.bloc,
    child: BlocConsumer<SshSessionBloc, SshSessionState>(
      listenWhen: (previous, current) =>
          current is SshSessionVerifying && previous != current,
      listener: (context, state) {
        if (state is SshSessionVerifying) _trust(state);
      },
      builder: (context, state) => ColoredBox(
        color: widget.preferences.terminalBackground,
        child: switch (state) {
          SshSessionConnected() => Column(
            children: [
              Expanded(
                child: TerminalViewport(
                  runtime: widget.runtime,
                  preferences: widget.preferences,
                ),
              ),
              SpecialKeys(
                control: _control,
                alt: _alt,
                onControl: () => setState(() => _control = !_control),
                onAlt: () => setState(() => _alt = !_alt),
                onSend: _send,
                onPaste: _paste,
                onHideKeyboard: () {
                  widget.runtime.focusNode.unfocus();
                  SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
                },
              ),
            ],
          ),
          SshSessionConnecting() => const TerminalSetupSurface(
            label: 'Connecting',
          ),
          SshSessionVerifying() => const TerminalSetupSurface(
            label: 'Verifying host key',
          ),
          SshSessionAuthenticating() => const TerminalSetupSurface(
            label: 'Authenticating',
          ),
          SshSessionReconnecting(:final attempt) => TerminalSetupSurface(
            label: 'Reconnecting ($attempt/3)',
          ),
          SshSessionFailed(:final failure) => TerminalFailureSurface(
            message: failure.message,
            onRetry: _retry,
            onProfiles: () => context.go('/connections'),
          ),
          SshSessionDisconnected() => TerminalFailureSurface(
            message: 'Disconnected',
            onRetry: _retry,
            onProfiles: () => context.go('/connections'),
          ),
        },
      ),
    ),
  );
}
