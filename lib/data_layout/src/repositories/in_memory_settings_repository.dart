import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../datasources/preview_fixture_source.dart';

final class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository({TerminalPreferences? initialPreferences})
    : _preferences =
          initialPreferences ?? const PreviewFixtureSource().preferences();

  TerminalPreferences _preferences;

  @override
  TerminalPreferences load() => _preferences;

  @override
  void save(TerminalPreferences preferences) {
    _preferences = preferences;
  }
}
