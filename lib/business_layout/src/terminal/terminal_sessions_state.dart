import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'terminal_sessions_state.freezed.dart';

@freezed
sealed class TerminalSessionsState with _$TerminalSessionsState {
  const TerminalSessionsState._();

  const factory TerminalSessionsState.initial({
    @Default(<PreviewSession>[]) List<PreviewSession> sessions,
    String? activeSessionId,
  }) = TerminalSessionsInitial;

  const factory TerminalSessionsState.ready({
    required List<PreviewSession> sessions,
    String? activeSessionId,
  }) = TerminalSessionsReady;

  PreviewSession? get activeSession {
    for (final session in sessions) {
      if (session.id == activeSessionId) return session;
    }
    return null;
  }
}
