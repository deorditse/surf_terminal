import 'package:bloc/bloc.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'settings_state.dart';

final class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState()) {
    load();
  }

  static const double minFontSize = 8;
  static const double maxFontSize = 32;
  static const int minKeepaliveSeconds = 0;
  static const int maxKeepaliveSeconds = 300;
  static const int minKeepaliveCount = 0;
  static const int maxKeepaliveCount = 10;

  final SettingsRepository _repository;

  void load() {
    try {
      emit(
        SettingsState(
          status: SettingsStatus.success,
          preferences: _bounded(_repository.load()),
        ),
      );
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> updatePreferences(TerminalPreferences preferences) async {
    final next = _bounded(preferences);
    try {
      _repository.save(next);
      emit(SettingsState(status: SettingsStatus.success, preferences: next));
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> updateAutoTheme(bool value) =>
      updatePreferences(state.preferences.copyWith(autoTheme: value));

  Future<void> updatePalette(TerminalPalette value) =>
      updatePreferences(state.preferences.copyWith(palette: value));

  Future<void> updateFontSize(double value) =>
      updatePreferences(state.preferences.copyWith(fontSize: value));

  Future<void> updateCursorStyle(TerminalCursorStyle value) =>
      updatePreferences(state.preferences.copyWith(cursorStyle: value));

  Future<void> updateCursorBlink(bool value) =>
      updatePreferences(state.preferences.copyWith(cursorBlink: value));

  Future<void> updateEmulation(String value) =>
      updatePreferences(state.preferences.copyWith(emulation: value));

  Future<void> updateKeepaliveSeconds(int value) =>
      updatePreferences(state.preferences.copyWith(keepaliveSeconds: value));

  Future<void> updateKeepaliveCount(int value) =>
      updatePreferences(state.preferences.copyWith(keepaliveCount: value));

  Future<void> updateKeepAwake(bool value) =>
      updatePreferences(state.preferences.copyWith(keepAwake: value));

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

  void _emitFailure(Object error) => emit(
    SettingsState(
      status: SettingsStatus.failure,
      preferences: state.preferences,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
