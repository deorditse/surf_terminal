import '../value_objects/terminal_preferences.dart';

abstract interface class SettingsRepository {
  TerminalPreferences load();
  void save(TerminalPreferences preferences);
}
