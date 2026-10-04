import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'settings_event.dart';
import 'settings_state.dart';

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repository) : super(const SettingsState.loading()) {
    on<SettingsLoadRequested>(_onLoadRequested, transformer: sequential());
    on<SettingsPreferencesChanged>(
      _onPreferencesChanged,
      transformer: sequential(),
    );
    on<SettingsPaletteChanged>(_onPaletteChanged, transformer: sequential());
    on<SettingsFontSizeChanged>(_onFontSizeChanged, transformer: sequential());
    on<SettingsCursorStyleChanged>(
      _onCursorStyleChanged,
      transformer: sequential(),
    );
    on<SettingsCursorBlinkChanged>(
      _onCursorBlinkChanged,
      transformer: sequential(),
    );
    on<SettingsEmulationChanged>(
      _onEmulationChanged,
      transformer: sequential(),
    );
    on<SettingsKeepaliveSecondsChanged>(
      _onKeepaliveSecondsChanged,
      transformer: sequential(),
    );
    on<SettingsKeepaliveCountChanged>(
      _onKeepaliveCountChanged,
      transformer: sequential(),
    );
    on<SettingsKeepAwakeChanged>(
      _onKeepAwakeChanged,
      transformer: sequential(),
    );
    add(const SettingsEvent.loadRequested());
  }

  static const double minFontSize = 8;
  static const double maxFontSize = 32;
  static const int minKeepaliveSeconds = 0;
  static const int maxKeepaliveSeconds = 300;
  static const int minKeepaliveCount = 0;
  static const int maxKeepaliveCount = 10;

  final SettingsRepository _repository;

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsState.success(preferences: _bounded(_repository.load())));
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  Future<void> _onPreferencesChanged(
    SettingsPreferencesChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, event.value);

  Future<void> _onPaletteChanged(
    SettingsPaletteChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(palette: event.value));

  Future<void> _onFontSizeChanged(
    SettingsFontSizeChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(fontSize: event.value));

  Future<void> _onCursorStyleChanged(
    SettingsCursorStyleChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(cursorStyle: event.value));

  Future<void> _onCursorBlinkChanged(
    SettingsCursorBlinkChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(cursorBlink: event.value));

  Future<void> _onEmulationChanged(
    SettingsEmulationChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(emulation: event.value));

  Future<void> _onKeepaliveSecondsChanged(
    SettingsKeepaliveSecondsChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(keepaliveSeconds: event.value));

  Future<void> _onKeepaliveCountChanged(
    SettingsKeepaliveCountChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(keepaliveCount: event.value));

  Future<void> _onKeepAwakeChanged(
    SettingsKeepAwakeChanged event,
    Emitter<SettingsState> emit,
  ) => _save(emit, state.preferences.copyWith(keepAwake: event.value));

  Future<void> _save(
    Emitter<SettingsState> emit,
    TerminalPreferences preferences,
  ) async {
    final next = _bounded(preferences);
    try {
      _repository.save(next);
      emit(SettingsState.success(preferences: next));
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  TerminalPreferences _bounded(TerminalPreferences value) => value.copyWith(
    fontSize: value.fontSize.clamp(minFontSize, maxFontSize).toDouble(),
    keepaliveSeconds: value.keepaliveSeconds.clamp(
      minKeepaliveSeconds,
      maxKeepaliveSeconds,
    ),
    keepaliveCount: value.keepaliveCount.clamp(
      minKeepaliveCount,
      maxKeepaliveCount,
    ),
  );

  void _emitFailure(Emitter<SettingsState> emit, Object error) => emit(
    SettingsState.failure(
      preferences: state.preferences,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
