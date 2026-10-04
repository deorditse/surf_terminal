import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SurfSection(
      title: 'About',
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.waves_rounded),
            title: Text('Surf Terminal'),
            subtitle: Text('Mobile SSH client'),
          ),
        ],
      ),
    );
  }
}
