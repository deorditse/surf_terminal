part of '../business_layout_test.dart';

void _registerSettingsTests() {
  group('SettingsBloc', () {
    test('updates all preferences and convenience values', () async {
      final repository = _SettingsRepository();
      final bloc = SettingsBloc(repository);
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == SettingsStatus.success,
      );

      bloc
        ..add(
          const SettingsEvent.preferencesChanged(
            TerminalPreferences(palette: TerminalPalette.tide),
          ),
        )
        ..add(
          const SettingsEvent.cursorStyleChanged(TerminalCursorStyle.underline),
        )
        ..add(const SettingsEvent.emulationChanged('screen-256color'))
        ..add(const SettingsEvent.keepAwakeChanged(true));
      await bloc.stream.firstWhere((state) => state.preferences.keepAwake);

      expect(bloc.state.preferences.palette, TerminalPalette.tide);
      expect(bloc.state.preferences.cursorStyle, TerminalCursorStyle.underline);
      expect(bloc.state.preferences.emulation, 'screen-256color');
    });

    test('bounds numeric settings before saving', () async {
      final bloc = SettingsBloc(_SettingsRepository());
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == SettingsStatus.success,
      );

      bloc
        ..add(const SettingsEvent.fontSizeChanged(1000))
        ..add(const SettingsEvent.keepaliveSecondsChanged(-10))
        ..add(const SettingsEvent.keepaliveCountChanged(1000));
      await bloc.stream.firstWhere(
        (state) =>
            state.preferences.keepaliveCount == SettingsBloc.maxKeepaliveCount,
      );

      expect(bloc.state.preferences.fontSize, SettingsBloc.maxFontSize);
      expect(
        bloc.state.preferences.keepaliveSeconds,
        SettingsBloc.minKeepaliveSeconds,
      );
    });

    test('reports save failures while preserving preferences', () async {
      final repository = _SettingsRepository();
      final bloc = SettingsBloc(repository);
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == SettingsStatus.success,
      );
      repository.failure = const RepositoryFailure('save', 'cannot save');

      final failed = bloc.stream.firstWhere(
        (state) => state.status == SettingsStatus.failure,
      );
      bloc.add(const SettingsEvent.keepAwakeChanged(true));
      await failed;

      expect(bloc.state.errorMessage, 'cannot save');
      expect(bloc.state.preferences.keepAwake, isFalse);
    });
  });
}
