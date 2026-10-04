import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'terminal_sessions_event.freezed.dart';

@freezed
sealed class TerminalSessionsEvent with _$TerminalSessionsEvent {
  const factory TerminalSessionsEvent.sessionOpened(PreviewSession session) =
      TerminalSessionOpened;
  const factory TerminalSessionsEvent.sessionSelected(String id) =
      TerminalSessionSelected;
  const factory TerminalSessionsEvent.sessionClosed(String id) =
      TerminalSessionClosed;
}
