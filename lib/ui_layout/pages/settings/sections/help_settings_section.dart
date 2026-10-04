import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class HelpSettingsSection extends StatelessWidget {
  const HelpSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Help',
      child: Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.help_outline),
            title: Text('Quick start'),
            subtitle: Text('Create a host and open its terminal'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.keyboard_alt_outlined),
            title: const Text('Keyboard mode'),
            subtitle: const Text('Standard toolbar layout'),
            trailing: Text(
              'Standard',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
