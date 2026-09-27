import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class TerminalSessionsState {
  TerminalSessionsState({
    List<PreviewSession> sessions = const <PreviewSession>[],
    this.activeSessionId,
  }) : sessions = List<PreviewSession>.unmodifiable(sessions);

  final List<PreviewSession> sessions;
  final String? activeSessionId;

  PreviewSession? get activeSession {
    for (final session in sessions) {
      if (session.id == activeSessionId) return session;
    }
    return null;
  }
}
