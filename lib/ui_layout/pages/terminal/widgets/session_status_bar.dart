import 'package:flutter/material.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';

class SessionStatusBar extends StatelessWidget {
  const SessionStatusBar({
    required this.state,
    required this.onRetry,
    required this.onDisconnect,
    super.key,
  });

  final SshSessionState state;
  final VoidCallback onRetry;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final profile = switch (state) {
      SshSessionDisconnected(:final profile) => profile,
      SshSessionConnecting(:final profile) => profile,
      SshSessionVerifying(:final profile) => profile,
      SshSessionAuthenticating(:final profile) => profile,
      SshSessionConnected(:final profile) => profile,
      SshSessionReconnecting(:final profile) => profile,
      SshSessionFailed(:final profile) => profile,
    };
    final (label, busy) = switch (state) {
      SshSessionDisconnected() => ('Disconnected', false),
      SshSessionConnecting() => ('Connecting', true),
      SshSessionVerifying() => ('Verifying host key', true),
      SshSessionAuthenticating() => ('Authenticating', true),
      SshSessionConnected() => ('Connected', false),
      SshSessionReconnecting(:final attempt) => (
        'Reconnecting ($attempt/3)',
        true,
      ),
      SshSessionFailed(:final failure) => (failure.message, false),
    };
    final canRetry =
        state is SshSessionFailed || state is SshSessionDisconnected;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (busy)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            Expanded(
              child: Text(
                '${profile?.endpoint ?? ''} · $label',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (canRetry)
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            if (state is! SshSessionDisconnected)
              TextButton(
                onPressed: onDisconnect,
                child: const Text('Disconnect'),
              ),
          ],
        ),
      ),
    );
  }
}
