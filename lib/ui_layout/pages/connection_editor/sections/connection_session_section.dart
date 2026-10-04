import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_controllers.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionSessionSection extends StatelessWidget {
  const ConnectionSessionSection({
    required this.controllers,
    required this.sendUtf8,
    required this.onSendUtf8Changed,
    super.key,
  });

  final ConnectionEditorControllers controllers;
  final bool sendUtf8;
  final ValueChanged<bool> onSendUtf8Changed;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Session',
      child: Column(
        children: [
          TextFormField(
            controller: controllers.label,
            decoration: const InputDecoration(labelText: 'Label'),
          ),
          const SizedBox(height: 12),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.code),
            title: Text('Startup snippet'),
            subtitle: Text('None'),
            trailing: Icon(Icons.chevron_right),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Send UTF-8 locale'),
            subtitle: const Text('Advertise a Unicode-capable locale'),
            value: sendUtf8,
            onChanged: onSendUtf8Changed,
          ),
        ],
      ),
    );
  }
}
