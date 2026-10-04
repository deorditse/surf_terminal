import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_controllers.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionAuthenticationSection extends StatelessWidget {
  const ConnectionAuthenticationSection({
    required this.controllers,
    required this.obscurePassword,
    required this.rememberPassword,
    required this.hasSavedPassword,
    required this.removeSavedPassword,
    required this.onTogglePasswordVisibility,
    required this.onRememberChanged,
    required this.onRemoveChanged,
    super.key,
  });

  final ConnectionEditorControllers controllers;
  final bool obscurePassword;
  final bool rememberPassword;
  final bool hasSavedPassword;
  final bool removeSavedPassword;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool> onRememberChanged;
  final ValueChanged<bool> onRemoveChanged;

  @override
  Widget build(BuildContext context) => SurfSection(
    title: 'Authentication',
    child: Column(
      children: [
        if (hasSavedPassword)
          ListTile(
            key: const Key('saved-password-indicator'),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Password saved securely'),
            subtitle: const Text('The saved value is never displayed.'),
            trailing: TextButton(
              onPressed: () => onRemoveChanged(!removeSavedPassword),
              child: Text(removeSavedPassword ? 'Keep' : 'Remove'),
            ),
          ),
        TextFormField(
          key: const Key('profile-password'),
          controller: controllers.password,
          obscureText: obscurePassword,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: hasSavedPassword ? 'Replace password' : 'Password',
            hintText: hasSavedPassword
                ? 'Leave empty to preserve saved password'
                : 'Ask at connection when empty',
            suffixIcon: IconButton(
              tooltip: obscurePassword ? 'Reveal password' : 'Hide password',
              onPressed: onTogglePasswordVisibility,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        SwitchListTile.adaptive(
          key: const Key('remember-password'),
          contentPadding: EdgeInsets.zero,
          value: rememberPassword && !removeSavedPassword,
          onChanged: removeSavedPassword ? null : onRememberChanged,
          title: const Text('Save password securely'),
          subtitle: const Text('Uses Keychain or Android Keystore storage.'),
        ),
      ],
    ),
  );
}
