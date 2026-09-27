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
            subtitle: Text('Original mobile SSH client interface preview'),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: false,
            leading: Icon(Icons.cloud_outlined),
            title: Text('Cloud backup'),
            subtitle: Text('Coming later — unavailable in this preview'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: false,
            leading: Icon(Icons.radar_outlined),
            title: Text('Network scan'),
            subtitle: Text('Coming later — unavailable in this preview'),
          ),
        ],
      ),
    );
  }
}
