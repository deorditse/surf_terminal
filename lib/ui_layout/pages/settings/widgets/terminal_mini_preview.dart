import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';

class TerminalMiniPreview extends StatelessWidget {
  const TerminalMiniPreview({required this.preferences, super.key});

  final TerminalPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: preferences.terminalBackground,
        borderRadius: BorderRadius.circular(SurfRadii.sm),
      ),
      child: Text(
        'preview@surf:~\$ echo ready\nready',
        style: TextStyle(
          color: preferences.terminalForeground,
          fontFamily: 'monospace',
          fontSize: preferences.fontSize,
          height: 1.45,
        ),
      ),
    );
  }
}
