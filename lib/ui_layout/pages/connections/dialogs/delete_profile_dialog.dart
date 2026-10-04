import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

Future<bool?> showDeleteProfileDialog(
  BuildContext context,
  SshProfile profile,
) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete host?'),
      content: Text('Remove “${profile.name}” from saved hosts?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
