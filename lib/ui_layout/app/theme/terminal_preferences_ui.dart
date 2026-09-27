import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

extension TerminalPreferencesUi on TerminalPreferences {
  Color get terminalBackground => switch (palette) {
    TerminalPalette.midnight => const Color(0xFF070B12),
    TerminalPalette.tide => const Color(0xFF07151C),
    TerminalPalette.kelp => const Color(0xFF07130C),
    TerminalPalette.sand => const Color(0xFF1C1912),
  };

  Color get terminalForeground => switch (palette) {
    TerminalPalette.midnight => const Color(0xFFBCE7FF),
    TerminalPalette.tide => const Color(0xFF8DE4E8),
    TerminalPalette.kelp => const Color(0xFFB6F2A1),
    TerminalPalette.sand => const Color(0xFFF4DB9B),
  };
}
