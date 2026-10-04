import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('InMemorySettingsRepository', () {
    test('loads the preview defaults', () {
      final preferences = InMemorySettingsRepository().load();

      expect(preferences.palette, TerminalPalette.midnight);
      expect(preferences.fontSize, 14);
      expect(preferences.cursorStyle, TerminalCursorStyle.bar);
      expect(preferences.cursorBlink, isTrue);
      expect(preferences.emulation, 'xterm-256color');
      expect(preferences.keepaliveSeconds, 60);
      expect(preferences.keepaliveCount, 3);
      expect(preferences.keepAwake, isFalse);
    });

    test('saves and loads every setting', () {
      final repository = InMemorySettingsRepository();
      const preferences = TerminalPreferences(
        palette: TerminalPalette.tide,
        fontSize: 18,
        cursorStyle: TerminalCursorStyle.underline,
        cursorBlink: false,
        emulation: 'screen-256color',
        keepaliveSeconds: 30,
        keepaliveCount: 5,
        keepAwake: true,
      );

      repository.save(preferences);

      final loaded = repository.load();
      expect(loaded.palette, preferences.palette);
      expect(loaded.fontSize, preferences.fontSize);
      expect(loaded.cursorStyle, preferences.cursorStyle);
      expect(loaded.cursorBlink, preferences.cursorBlink);
      expect(loaded.emulation, preferences.emulation);
      expect(loaded.keepaliveSeconds, preferences.keepaliveSeconds);
      expect(loaded.keepaliveCount, preferences.keepaliveCount);
      expect(loaded.keepAwake, preferences.keepAwake);
    });
  });
}
