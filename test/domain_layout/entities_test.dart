import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('SshProfile', () {
    const profile = SshProfile(
      id: 'profile-1',
      name: 'Lab',
      host: 'lab.example.com',
      port: 2222,
      username: 'developer',
      startupSnippet: 'status',
      sendUtf8Locale: false,
      jumpHostEnabled: true,
      proxyEnabled: true,
    );

    test('exposes the current UI endpoint format', () {
      expect(profile.endpoint, 'developer@lab.example.com:2222');
    });

    test('copyWith preserves identity and unchanged fields', () {
      final changed = profile.copyWith(name: 'Updated');

      expect(changed.id, profile.id);
      expect(changed.name, 'Updated');
      expect(changed.host, profile.host);
      expect(changed.startupSnippet, profile.startupSnippet);
      expect(changed.sendUtf8Locale, isFalse);
      expect(changed.jumpHostEnabled, isTrue);
      expect(changed.proxyEnabled, isTrue);
    });
  });

  group('CommandSnippet', () {
    test('defensively copies labels', () {
      final labels = <String>['safe'];
      final snippet = CommandSnippet(
        id: 'snippet-1',
        title: 'Status',
        command: 'status',
        labels: labels,
      );
      labels.add('changed');

      expect(snippet.labels, <String>['safe']);
      expect(() => snippet.labels.add('forbidden'), throwsUnsupportedError);
    });

    test('copyWith preserves identity and defensively copies new labels', () {
      final labels = <String>['ops'];
      final changed = CommandSnippet(
        id: 'snippet-1',
        title: 'Status',
        command: 'status',
      ).copyWith(description: 'Safe status', labels: labels);
      labels.add('changed');

      expect(changed.id, 'snippet-1');
      expect(changed.description, 'Safe status');
      expect(changed.labels, <String>['ops']);
    });
  });

  test('PreviewSession exposes immutable identity and title', () {
    const session = PreviewSession(id: 'session-1', title: 'Lab');

    expect(session.id, 'session-1');
    expect(session.title, 'Lab');
  });

  test('TerminalPreferences preserves defaults and copies every value', () {
    const defaults = TerminalPreferences();
    final changed = defaults.copyWith(
      autoTheme: false,
      palette: TerminalPalette.tide,
      fontSize: 16,
      cursorStyle: TerminalCursorStyle.block,
      cursorBlink: false,
      emulation: 'vt100',
      keepaliveSeconds: 30,
      keepaliveCount: 5,
      keepAwake: true,
    );

    expect(defaults.palette, TerminalPalette.midnight);
    expect(defaults.cursorStyle, TerminalCursorStyle.bar);
    expect(changed.autoTheme, isFalse);
    expect(changed.palette, TerminalPalette.tide);
    expect(changed.fontSize, 16);
    expect(changed.cursorStyle, TerminalCursorStyle.block);
    expect(changed.cursorBlink, isFalse);
    expect(changed.emulation, 'vt100');
    expect(changed.keepaliveSeconds, 30);
    expect(changed.keepaliveCount, 5);
    expect(changed.keepAwake, isTrue);
  });
}
