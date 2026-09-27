import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

class SurfSection extends StatelessWidget {
  const SurfSection({required this.child, this.title, this.padding, super.key});

  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title!.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: SurfColors.muted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
        Card(
          child: Padding(
            padding: padding ?? const EdgeInsets.all(SurfSpacing.md),
            child: child,
          ),
        ),
      ],
    );
  }
}
