import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'settings_event.freezed.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadRequested() = SettingsLoadRequested;
  const factory SettingsEvent.preferencesChanged(TerminalPreferences value) =
      SettingsPreferencesChanged;
  const factory SettingsEvent.paletteChanged(TerminalPalette value) =
      SettingsPaletteChanged;
  const factory SettingsEvent.fontSizeChanged(double value) =
      SettingsFontSizeChanged;
  const factory SettingsEvent.cursorStyleChanged(TerminalCursorStyle value) =
      SettingsCursorStyleChanged;
  const factory SettingsEvent.cursorBlinkChanged(bool value) =
      SettingsCursorBlinkChanged;
  const factory SettingsEvent.emulationChanged(String value) =
      SettingsEmulationChanged;
  const factory SettingsEvent.keepaliveSecondsChanged(int value) =
      SettingsKeepaliveSecondsChanged;
  const factory SettingsEvent.keepaliveCountChanged(int value) =
      SettingsKeepaliveCountChanged;
  const factory SettingsEvent.keepAwakeChanged(bool value) =
      SettingsKeepAwakeChanged;
}
