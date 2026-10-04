import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionAdvancedRoutingSection extends StatelessWidget {
  const ConnectionAdvancedRoutingSection({
    required this.jumpHost,
    required this.proxy,
    required this.onJumpHostChanged,
    required this.onProxyChanged,
    super.key,
  });

  final bool jumpHost;
  final bool proxy;
  final ValueChanged<bool> onJumpHostChanged;
  final ValueChanged<bool> onProxyChanged;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      title: 'Advanced routing',
      child: Column(
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('SSH jump host'),
            subtitle: const Text('Presentation setting only'),
            value: jumpHost,
            onChanged: onJumpHostChanged,
          ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('SOCKS5 proxy'),
            subtitle: const Text('Presentation setting only'),
            value: proxy,
            onChanged: onProxyChanged,
          ),
        ],
      ),
    );
  }
}
