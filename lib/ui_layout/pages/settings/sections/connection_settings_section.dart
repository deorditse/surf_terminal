import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/pages/settings/widgets/choice_row.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionSettingsSection extends StatelessWidget {
  const ConnectionSettingsSection({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final TerminalPreferences preferences;
  final ValueChanged<TerminalPreferences> onChanged;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Connection',
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.monitor_outlined),
            title: const Text('Emulation type'),
            subtitle: const Text(
              'Terminal capability advertised to future sessions',
            ),
            trailing: DropdownButton<String>(
              value: preferences.emulation,
              items: const [
                DropdownMenuItem(
                  value: 'xterm-256color',
                  child: Text('xterm-256color'),
                ),
                DropdownMenuItem(
                  value: 'xterm-color',
                  child: Text('xterm-color'),
                ),
                DropdownMenuItem(value: 'vt100', child: Text('vt100')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onChanged(preferences.copyWith(emulation: value));
                }
              },
            ),
          ),
          const Divider(),
          ChoiceRow(
            title: 'Keepalive interval',
            subtitle: 'Presentation value; no packets are sent',
            value: '${preferences.keepaliveSeconds}s',
            values: const [15, 30, 60, 120],
            onSelected: (value) =>
                onChanged(preferences.copyWith(keepaliveSeconds: value)),
          ),
          const Divider(),
          ChoiceRow(
            title: 'Keepalive count',
            subtitle: 'Bounded retry count for a future transport',
            value: '${preferences.keepaliveCount}',
            values: const [1, 3, 5, 8],
            onSelected: (value) =>
                onChanged(preferences.copyWith(keepaliveCount: value)),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Keep awake'),
            subtitle: const Text('Preview only; device policy is unchanged'),
            value: preferences.keepAwake,
            onChanged: (value) =>
                onChanged(preferences.copyWith(keepAwake: value)),
          ),
        ],
      ),
    );
  }
}
