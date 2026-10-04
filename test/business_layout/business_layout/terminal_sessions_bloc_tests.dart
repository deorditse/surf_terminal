part of '../business_layout_test.dart';

void _registerTerminalSessionsTests() {
  group('TerminalSessionsBloc', () {
    test(
      'opens, selects, and closes sessions using neighboring selection',
      () async {
        var next = 0;
        final bloc = TerminalSessionsBloc(
          idFactory: (prefix) => '$prefix-${next++}',
        );
        addTearDown(bloc.close);

        final one = bloc.createSession('One');
        final two = bloc.createSession('Two');
        final three = bloc.createSession('Three');
        bloc
          ..add(TerminalSessionsEvent.sessionOpened(one))
          ..add(TerminalSessionsEvent.sessionOpened(two))
          ..add(TerminalSessionsEvent.sessionOpened(three))
          ..add(TerminalSessionsEvent.sessionSelected(two.id))
          ..add(TerminalSessionsEvent.sessionClosed(two.id));
        await bloc.stream.firstWhere(
          (state) =>
              state.sessions.length == 2 && state.activeSessionId == three.id,
        );

        bloc.add(TerminalSessionsEvent.sessionClosed(three.id));
        await bloc.stream.firstWhere(
          (state) => state.activeSessionId == one.id,
        );
        bloc.add(TerminalSessionsEvent.sessionClosed(one.id));
        await bloc.stream.firstWhere((state) => state.sessions.isEmpty);
        expect(bloc.state.activeSessionId, isNull);
      },
    );

    test('closing an inactive session preserves the active session', () async {
      var next = 0;
      final bloc = TerminalSessionsBloc(
        idFactory: (prefix) => '$prefix-${next++}',
      );
      addTearDown(bloc.close);
      final one = bloc.createSession('One');
      final two = bloc.createSession('Two');
      bloc
        ..add(TerminalSessionsEvent.sessionOpened(one))
        ..add(TerminalSessionsEvent.sessionOpened(two))
        ..add(TerminalSessionsEvent.sessionClosed(one.id));

      await bloc.stream.firstWhere(
        (state) =>
            state.sessions.length == 1 && state.sessions.single.id == two.id,
      );
      expect(bloc.state.activeSessionId, two.id);
    });
  });
}
