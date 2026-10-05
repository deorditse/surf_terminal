import 'package:flutter/cupertino.dart';

class TerminalSetupSurface extends StatelessWidget {
  const TerminalSetupSurface({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CupertinoActivityIndicator(radius: 14),
        const SizedBox(height: 16),
        Text(label),
      ],
    ),
  );
}

class TerminalFailureSurface extends StatelessWidget {
  const TerminalFailureSurface({
    required this.message,
    required this.onRetry,
    required this.onProfiles,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onProfiles;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              CupertinoButton.filled(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
              CupertinoButton(
                onPressed: onProfiles,
                child: const Text('SSH profiles'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
