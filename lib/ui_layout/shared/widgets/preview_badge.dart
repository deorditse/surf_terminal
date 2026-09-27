import 'package:flutter/material.dart';

class PreviewBadge extends StatelessWidget {
  const PreviewBadge({this.label = 'LOCAL PREVIEW', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Non-networked local preview',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.offline_bolt_outlined,
                size: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
