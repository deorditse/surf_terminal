import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';
import 'package:surf_terminal/ui_layout/pages/settings/widgets/terminal_mini_preview.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class TerminalSettingsSection extends StatelessWidget {
  const TerminalSettingsSection({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final TerminalPreferences preferences;
  final ValueChanged<TerminalPreferences> onChanged;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Terminal',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Auto app theme'),
            subtitle: const Text('Follow the system light or dark appearance'),
            value: preferences.autoTheme,
            onChanged: (value) =>
                onChanged(preferences.copyWith(autoTheme: value)),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.palette_outlined),
            title: Text('Terminal palette'),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TerminalPalette.values.map((palette) {
              final selected = preferences.palette == palette;
              return ChoiceChip(
                key: Key('palette-${palette.name}'),
                selected: selected,
                avatar: CircleAvatar(
                  backgroundColor: TerminalPreferences(palette: palette)
                      .terminalForeground,
                ),
                label: Text(palette.name),
                onSelected: (_) =>
                    onChanged(preferences.copyWith(palette: palette)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.text_fields),
              const SizedBox(width: 12),
              const Expanded(child: Text('Font size')),
              Text('${preferences.fontSize.round()} pt'),
            ],
          ),
          Slider(
            key: const Key('font-size-slider'),
            min: 11,
            max: 22,
            divisions: 11,
            value: preferences.fontSize,
            label: '${preferences.fontSize.round()}',
            onChanged: (value) =>
                onChanged(preferences.copyWith(fontSize: value)),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.text_fields_rounded),
            title: Text('Cursor style'),
          ),
          SegmentedButton<TerminalCursorStyle>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: TerminalCursorStyle.block,
                label: Text('Block'),
              ),
              ButtonSegment(
                value: TerminalCursorStyle.underline,
                label: Text('Line'),
              ),
              ButtonSegment(value: TerminalCursorStyle.bar, label: Text('Bar')),
            ],
            selected: {preferences.cursorStyle},
            onSelectionChanged: (value) =>
                onChanged(preferences.copyWith(cursorStyle: value.first)),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Cursor blink'),
            value: preferences.cursorBlink,
            onChanged: (value) =>
                onChanged(preferences.copyWith(cursorBlink: value)),
          ),
          TerminalMiniPreview(preferences: preferences),
        ],
      ),
    );
  }
}
