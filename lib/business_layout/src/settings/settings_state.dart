import 'package:surf_terminal/domain_layout/domain_layout.dart';

enum SettingsStatus { loading, success, failure }

final class SettingsState {
  const SettingsState({
    this.status = SettingsStatus.loading,
    this.preferences = const TerminalPreferences(),
    this.errorMessage,
  });

  final SettingsStatus status;
  final TerminalPreferences preferences;
  final String? errorMessage;
}
