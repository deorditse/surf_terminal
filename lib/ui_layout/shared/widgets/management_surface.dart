import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

class ManagementSurface extends StatelessWidget {
  const ManagementSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: DecoratedBox(
            key: const Key('management-ocean-motif'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  SurfColors.surf.withValues(alpha: 0.07),
                  SurfColors.deep.withValues(alpha: 0.02),
                  SurfColors.ink,
                ],
                stops: const [0, 0.38, 0.78],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
