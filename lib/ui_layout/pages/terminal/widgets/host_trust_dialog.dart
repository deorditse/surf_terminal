import 'package:flutter/material.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

enum HostTrustDecision { accept, replace, reject }

Future<HostTrustDecision> showHostTrustDialog(
  BuildContext context,
  HostKeyChallenge challenge,
) async {
  final presented = challenge.presented;
  final changed = challenge.kind == HostKeyChallengeKind.changed;
  final first = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(changed ? 'Host key changed' : 'Trust unknown host?'),
      content: SelectableText(
        '${presented.endpoint.host}:${presented.endpoint.port}\n'
        'Algorithm: ${presented.algorithm}\n'
        'Fingerprint: ${presented.fingerprint}'
        '${changed ? '\n\nThe saved fingerprint differs. This can indicate an attack or a server rebuild.' : ''}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Reject'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(changed ? 'Review replacement' : 'Trust'),
        ),
      ],
    ),
  );
  if (first != true) return HostTrustDecision.reject;
  if (!changed) return HostTrustDecision.accept;
  if (!context.mounted) return HostTrustDecision.reject;
  final replace = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Replace trusted fingerprint?'),
      content: const Text(
        'Only continue after confirming the new fingerprint through a trusted source.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel connection'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Replace and connect'),
        ),
      ],
    ),
  );
  return replace == true ? HostTrustDecision.replace : HostTrustDecision.reject;
}
