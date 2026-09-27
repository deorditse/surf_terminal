enum TerminalPalette { midnight, tide, kelp, sand }

enum TerminalCursorStyle { block, underline, bar }

final class TerminalPreferences {
  const TerminalPreferences({
    this.autoTheme = true,
    this.palette = TerminalPalette.midnight,
    this.fontSize = 14,
    this.cursorStyle = TerminalCursorStyle.bar,
    this.cursorBlink = true,
    this.emulation = 'xterm-256color',
    this.keepaliveSeconds = 60,
    this.keepaliveCount = 3,
    this.keepAwake = false,
  });

  final bool autoTheme;
  final TerminalPalette palette;
  final double fontSize;
  final TerminalCursorStyle cursorStyle;
  final bool cursorBlink;
  final String emulation;
  final int keepaliveSeconds;
  final int keepaliveCount;
  final bool keepAwake;

  TerminalPreferences copyWith({
    bool? autoTheme,
    TerminalPalette? palette,
    double? fontSize,
    TerminalCursorStyle? cursorStyle,
    bool? cursorBlink,
    String? emulation,
    int? keepaliveSeconds,
    int? keepaliveCount,
    bool? keepAwake,
  }) => TerminalPreferences(
    autoTheme: autoTheme ?? this.autoTheme,
    palette: palette ?? this.palette,
    fontSize: fontSize ?? this.fontSize,
    cursorStyle: cursorStyle ?? this.cursorStyle,
    cursorBlink: cursorBlink ?? this.cursorBlink,
    emulation: emulation ?? this.emulation,
    keepaliveSeconds: keepaliveSeconds ?? this.keepaliveSeconds,
    keepaliveCount: keepaliveCount ?? this.keepaliveCount,
    keepAwake: keepAwake ?? this.keepAwake,
  );
}
