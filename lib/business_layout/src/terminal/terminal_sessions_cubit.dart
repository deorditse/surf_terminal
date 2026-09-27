import 'package:bloc/bloc.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'terminal_sessions_state.dart';

final class TerminalSessionsCubit extends Cubit<TerminalSessionsState> {
  TerminalSessionsCubit({
    List<PreviewSession> initialSessions = const <PreviewSession>[],
    String? activeSessionId,
    this._idFactory = dateTimeIdFactory,
  }) : super(
         TerminalSessionsState(
           sessions: initialSessions,
           activeSessionId: activeSessionId,
         ),
       );

  final IdFactory _idFactory;

  PreviewSession openSession(String title) {
    final session = PreviewSession(id: _idFactory('session'), title: title);
    emit(
      TerminalSessionsState(
        sessions: <PreviewSession>[...state.sessions, session],
        activeSessionId: session.id,
      ),
    );
    return session;
  }

  void selectSession(String id) {
    if (!state.sessions.any((session) => session.id == id)) return;
    emit(TerminalSessionsState(sessions: state.sessions, activeSessionId: id));
  }

  void closeSession(String id) {
    final index = state.sessions.indexWhere((session) => session.id == id);
    if (index == -1) return;
    final sessions = List<PreviewSession>.of(state.sessions)..removeAt(index);
    var activeSessionId = state.activeSessionId;
    if (activeSessionId == id) {
      activeSessionId = sessions.isEmpty
          ? null
          : sessions[index < sessions.length ? index : sessions.length - 1].id;
    }
    emit(
      TerminalSessionsState(
        sessions: sessions,
        activeSessionId: activeSessionId,
      ),
    );
  }
}
