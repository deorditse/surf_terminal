import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_controllers.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/sections/connection_advanced_routing_section.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/sections/connection_authentication_section.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/sections/connection_endpoint_section.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/sections/connection_session_section.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionEditorForm extends StatelessWidget {
  const ConnectionEditorForm({
    required this.formKey,
    required this.controllers,
    required this.obscurePassword,
    required this.sendUtf8,
    required this.jumpHost,
    required this.proxy,
    required this.isEditing,
    required this.rememberPassword,
    required this.hasSavedPassword,
    required this.removeSavedPassword,
    required this.onTogglePasswordVisibility,
    required this.onRememberChanged,
    required this.onRemoveChanged,
    required this.onSendUtf8Changed,
    required this.onJumpHostChanged,
    required this.onProxyChanged,
    required this.onSave,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final ConnectionEditorControllers controllers;
  final bool obscurePassword;
  final bool sendUtf8;
  final bool jumpHost;
  final bool proxy;
  final bool isEditing;
  final bool rememberPassword;
  final bool hasSavedPassword;
  final bool removeSavedPassword;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool> onRememberChanged;
  final ValueChanged<bool> onRemoveChanged;
  final ValueChanged<bool> onSendUtf8Changed;
  final ValueChanged<bool> onJumpHostChanged;
  final ValueChanged<bool> onProxyChanged;
  final VoidCallback onSave;

  static String? requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  static String? portValidator(String? value) {
    final port = int.tryParse(value ?? '');
    if (port == null || port < 1 || port > 65535) {
      return 'Enter a port from 1 to 65535';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        key: const PageStorageKey('connection-editor-scroll'),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            const PageIntro(
              eyebrow: 'Connection profile',
              title: 'Host details',
              description: 'Profiles persist locally. Passwords are never prefilled and can be stored securely.',
            ),
            const SizedBox(height: 24),
            ConnectionEndpointSection(
              controllers: controllers,
              requiredValidator: requiredValidator,
              portValidator: portValidator,
            ),
            const SizedBox(height: 20),
            ConnectionAuthenticationSection(
              controllers: controllers,
              obscurePassword: obscurePassword,
              rememberPassword: rememberPassword,
              hasSavedPassword: hasSavedPassword,
              removeSavedPassword: removeSavedPassword,
              onTogglePasswordVisibility: onTogglePasswordVisibility,
              onRememberChanged: onRememberChanged,
              onRemoveChanged: onRemoveChanged,
            ),
            const SizedBox(height: 20),
            ConnectionSessionSection(
              controllers: controllers,
              sendUtf8: sendUtf8,
              onSendUtf8Changed: onSendUtf8Changed,
            ),
            const SizedBox(height: 20),
            ConnectionAdvancedRoutingSection(
              jumpHost: jumpHost,
              proxy: proxy,
              onJumpHostChanged: onJumpHostChanged,
              onProxyChanged: onProxyChanged,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('save-profile'),
              onPressed: onSave,
              icon: const Icon(Icons.check),
              label: Text(isEditing ? 'Save changes' : 'Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
