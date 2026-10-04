import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_controllers.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionEndpointSection extends StatelessWidget {
  const ConnectionEndpointSection({
    required this.controllers,
    required this.requiredValidator,
    required this.portValidator,
    super.key,
  });

  final ConnectionEditorControllers controllers;
  final FormFieldValidator<String> requiredValidator;
  final FormFieldValidator<String> portValidator;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Endpoint',
      child: Column(
        children: [
          TextFormField(
            key: const Key('profile-name'),
            controller: controllers.name,
            decoration: const InputDecoration(
              labelText: 'Display name',
              hintText: 'Optional',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('profile-host'),
            controller: controllers.host,
            validator: requiredValidator,
            decoration: const InputDecoration(
              labelText: 'Host',
              hintText: 'server.example.com',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  key: const Key('profile-username'),
                  controller: controllers.username,
                  validator: requiredValidator,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: const Key('profile-port'),
                  controller: controllers.port,
                  validator: portValidator,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Port'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
