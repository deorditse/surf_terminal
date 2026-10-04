import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'terminal_sessions_event.dart';
import 'terminal_sessions_state.dart';

final class TerminalSessionsBloc
    extends Bloc<TerminalSessionsEvent, TerminalSessionsState> {
  TerminalSessionsBloc({
    List<PreviewSession> initialSessions = const <PreviewSession>[],
    String? activeSessionId,
    this._idFactory = dateTimeIdFactory,
  }) : super(
         TerminalSessionsState.initial(
           sessions: initialSessions,
           activeSessionId: activeSessionId,
         ),
       ) {
    on<TerminalSessionOpened>(_onSessionOpened, transformer: sequential());
    on<TerminalSessionSelected>(_onSessionSelected, transformer: sequential());
    on<TerminalSessionClosed>(_onSessionClosed, transformer: sequential());
  }

  final IdFactory _idFactory;

  PreviewSession createSession(String title) =>
      PreviewSession(id: _idFactory('session'), title: title);

  void _onSessionOpened(
    TerminalSessionOpened event,
    Emitter<TerminalSessionsState> emit,
  ) {
    emit(
      TerminalSessionsState.ready(
        sessions: <PreviewSession>[...state.sessions, event.session],
        activeSessionId: event.session.id,
      ),
    );
  }

  void _onSessionSelected(
    TerminalSessionSelected event,
    Emitter<TerminalSessionsState> emit,
  ) {
    if (!state.sessions.any((session) => session.id == event.id)) return;
    emit(
      TerminalSessionsState.ready(
        sessions: state.sessions,
        activeSessionId: event.id,
      ),
    );
  }

  void _onSessionClosed(
    TerminalSessionClosed event,
    Emitter<TerminalSessionsState> emit,
  ) {
    final index = state.sessions.indexWhere(
      (session) => session.id == event.id,
    );
    if (index == -1) return;
    final sessions = List<PreviewSession>.of(state.sessions)..removeAt(index);
    var activeSessionId = state.activeSessionId;
    if (activeSessionId == event.id) {
      activeSessionId = sessions.isEmpty
          ? null
          : sessions[index < sessions.length ? index : sessions.length - 1].id;
    }
    emit(
      TerminalSessionsState.ready(
        sessions: sessions,
        activeSessionId: activeSessionId,
      ),
    );
  }
}
