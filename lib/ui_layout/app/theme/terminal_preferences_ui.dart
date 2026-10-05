import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:xterm/xterm.dart' as xterm;

extension TerminalPreferencesUi on TerminalPreferences {
  Color get terminalBackground => SurfColors.ink;

  Color get terminalForeground => const Color(0xFFCCCCCC);

  xterm.TerminalTheme get terminalTheme => xterm.TerminalTheme(
    cursor: const Color(0xFFAEAFAD),
    selection: const Color(0x665B9BD5),
    foreground: terminalForeground,
    background: terminalBackground,
    black: const Color(0xFF000000),
    red: const Color(0xFFCD3131),
    green: const Color(0xFF0DBC79),
    yellow: const Color(0xFFE5E510),
    blue: const Color(0xFF2472C8),
    magenta: const Color(0xFFBC3FBC),
    cyan: const Color(0xFF11A8CD),
    white: const Color(0xFFE5E5E5),
    brightBlack: const Color(0xFF666666),
    brightRed: const Color(0xFFF14C4C),
    brightGreen: const Color(0xFF23D18B),
    brightYellow: const Color(0xFFF5F543),
    brightBlue: const Color(0xFF3B8EEA),
    brightMagenta: const Color(0xFFD670D6),
    brightCyan: const Color(0xFF29B8DB),
    brightWhite: const Color(0xFFFFFFFF),
    searchHitBackground: const Color(0xFFFFFF2B),
    searchHitBackgroundCurrent: const Color(0xFF31FF26),
    searchHitForeground: const Color(0xFF000000),
  );
}
