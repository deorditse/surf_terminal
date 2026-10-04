import 'package:flutter/material.dart';

Future<bool> showPasswordPrompt(
  BuildContext context, {
  required String endpoint,
  required void Function(String password, bool remember) onSubmit,
}) async {
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) =>
        _PasswordPromptDialog(endpoint: endpoint, onSubmit: onSubmit),
  );
  return accepted ?? false;
}

class _PasswordPromptDialog extends StatefulWidget {
  const _PasswordPromptDialog({required this.endpoint, required this.onSubmit});

  final String endpoint;
  final void Function(String password, bool remember) onSubmit;

  @override
  State<_PasswordPromptDialog> createState() => _PasswordPromptDialogState();
}

class _PasswordPromptDialogState extends State<_PasswordPromptDialog> {
  final _controller = TextEditingController();
  var _remember = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Password required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.endpoint),
          const SizedBox(height: 16),
          TextField(
            key: const Key('transient-password'),
            controller: _controller,
            obscureText: true,
            autofocus: true,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          CheckboxListTile(
            key: const Key('retain-transient-password'),
            contentPadding: EdgeInsets.zero,
            value: _remember,
            onChanged: (value) => setState(() => _remember = value ?? false),
            title: const Text('Save password securely'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _controller.text.isEmpty
              ? null
              : () {
                  widget.onSubmit(_controller.text, _remember);
                  Navigator.pop(context, true);
                },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
