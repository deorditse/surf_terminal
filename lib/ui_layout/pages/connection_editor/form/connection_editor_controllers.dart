import 'package:flutter/widgets.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

class ConnectionEditorControllers {
  ConnectionEditorControllers.fromProfile(SshProfile? profile)
    : name = TextEditingController(text: profile?.name ?? ''),
      host = TextEditingController(text: profile?.host ?? ''),
      port = TextEditingController(text: '${profile?.port ?? 22}'),
      username = TextEditingController(text: profile?.username ?? ''),
      password = TextEditingController(),
      label = TextEditingController(text: profile?.label ?? 'Personal');

  final TextEditingController name;
  final TextEditingController host;
  final TextEditingController port;
  final TextEditingController username;
  final TextEditingController password;
  final TextEditingController label;

  void dispose() {
    name.dispose();
    host.dispose();
    port.dispose();
    username.dispose();
    password.dispose();
    label.dispose();
  }
}
