import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'settings_state.freezed.dart';

enum SettingsStatus { loading, success, failure }

@freezed
sealed class SettingsState with _$SettingsState {
  const SettingsState._();

  const factory SettingsState.loading({
    @Default(TerminalPreferences()) TerminalPreferences preferences,
    String? errorMessage,
  }) = SettingsLoading;

  const factory SettingsState.success({
    required TerminalPreferences preferences,
    String? errorMessage,
  }) = SettingsSuccess;

  const factory SettingsState.failure({
    required TerminalPreferences preferences,
    required String errorMessage,
  }) = SettingsFailure;

  SettingsStatus get status => switch (this) {
    SettingsLoading() => SettingsStatus.loading,
    SettingsSuccess() => SettingsStatus.success,
    SettingsFailure() => SettingsStatus.failure,
  };
}
