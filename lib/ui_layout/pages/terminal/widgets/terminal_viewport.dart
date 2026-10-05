import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';
import 'package:xterm/xterm.dart' as xterm;

class TerminalViewport extends StatelessWidget {
  const TerminalViewport({
    required this.runtime,
    required this.preferences,
    this.controlBottomInset = 0,
    super.key,
  });

  final TerminalSessionRuntime runtime;
  final TerminalPreferences preferences;
  final double controlBottomInset;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = controlBottomInset > media.padding.bottom
        ? controlBottomInset
        : media.padding.bottom;
    return ColoredBox(
      key: const Key('terminal-viewport'),
      color: preferences.terminalBackground,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, media.padding.top, 8, bottomInset),
        child: xterm.TerminalView(
          runtime.terminal,
          key: const Key('terminal-input-viewport'),
          theme: preferences.terminalTheme,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          focusNode: runtime.focusNode,
          deleteDetection: true,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.dark,
          textStyle: xterm.TerminalStyle(fontSize: preferences.fontSize),
          cursorType: switch (preferences.cursorStyle) {
            TerminalCursorStyle.block => xterm.TerminalCursorType.block,
            TerminalCursorStyle.underline => xterm.TerminalCursorType.underline,
            TerminalCursorStyle.bar => xterm.TerminalCursorType.verticalBar,
          },
          onTapUp: (_, _) => runtime.focusNode.requestFocus(),
        ),
      ),
    );
  }
}
