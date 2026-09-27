import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class ConnectionEditorPage extends StatefulWidget {
  const ConnectionEditorPage({this.profileId, super.key});

  final String? profileId;

  @override
  State<ConnectionEditorPage> createState() => _ConnectionEditorPageState();
}

class _ConnectionEditorPageState extends State<ConnectionEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _host;
  late final TextEditingController _port;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _label;
  bool _obscurePassword = true;
  bool _sendUtf8 = true;
  bool _jumpHost = false;
  bool _proxy = false;
  SshProfile? _existing;

  @override
  void initState() {
    super.initState();
    final profiles = context.read<ProfilesCubit>().state.profiles;
    _existing = widget.profileId == null
        ? null
        : profiles.where((item) => item.id == widget.profileId).firstOrNull;
    _name = TextEditingController(text: _existing?.name ?? '');
    _host = TextEditingController(text: _existing?.host ?? '');
    _port = TextEditingController(text: '${_existing?.port ?? 22}');
    _username = TextEditingController(text: _existing?.username ?? '');
    _password = TextEditingController();
    _label = TextEditingController(text: _existing?.label ?? 'Personal');
    _sendUtf8 = _existing?.sendUtf8Locale ?? true;
    _jumpHost = _existing?.jumpHostEnabled ?? false;
    _proxy = _existing?.proxyEnabled ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _host.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    _label.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String? _validatePort(String? value) {
    final port = int.tryParse(value ?? '');
    if (port == null || port < 1 || port > 65535) {
      return 'Enter a port from 1 to 65535';
    }
    return null;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<ProfilesCubit>();
    final profile =
        _existing?.copyWith(
          name: _name.text.trim().isEmpty
              ? _host.text.trim()
              : _name.text.trim(),
          host: _host.text.trim(),
          port: int.parse(_port.text),
          username: _username.text.trim(),
          label: _label.text.trim().isEmpty ? 'Personal' : _label.text.trim(),
          sendUtf8Locale: _sendUtf8,
          jumpHostEnabled: _jumpHost,
          proxyEnabled: _proxy,
        ) ??
        cubit.createProfile(
          name: _name.text.trim().isEmpty
              ? _host.text.trim()
              : _name.text.trim(),
          host: _host.text.trim(),
          port: int.parse(_port.text),
          username: _username.text.trim(),
          label: _label.text.trim().isEmpty ? 'Personal' : _label.text.trim(),
          sendUtf8Locale: _sendUtf8,
          jumpHostEnabled: _jumpHost,
          proxyEnabled: _proxy,
        );
    cubit.saveProfile(profile);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('connection-editor-page'),
      appBar: AppBar(
        title: Text(_existing == null ? 'New host' : 'Edit host'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            key: const PageStorageKey('connection-editor-scroll'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              children: [
                const PageIntro(
                  eyebrow: 'Connection profile',
                  title: 'Reach your server',
                  description: 'This change stores values in memory only. Passwords are never prefilled or persisted.',
                  trailing: PreviewBadge(label: 'LOCAL ONLY'),
                ),
                const SizedBox(height: 24),
                SurfSection(
                  title: 'Endpoint',
                  child: Column(
                    children: [
                      TextFormField(
                        key: const Key('profile-name'),
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Display name',
                          hintText: 'Optional',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('profile-host'),
                        controller: _host,
                        validator: _required,
                        decoration: const InputDecoration(
                          labelText: 'Host',
                          hintText: 'server.example.com',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              key: const Key('profile-username'),
                              controller: _username,
                              validator: _required,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              key: const Key('profile-port'),
                              controller: _port,
                              validator: _validatePort,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Port',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SurfSection(
                  title: 'Authentication',
                  child: Column(
                    children: [
                      TextFormField(
                        key: const Key('profile-password'),
                        controller: _password,
                        obscureText: _obscurePassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Ask at connection when empty',
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Reveal password'
                                : 'Hide password',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.key_outlined),
                        title: Text('Private key'),
                        subtitle: Text('No key selected'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SurfSection(
                  title: 'Session',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _label,
                        decoration: const InputDecoration(labelText: 'Label'),
                      ),
                      const SizedBox(height: 12),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.code),
                        title: Text('Startup snippet'),
                        subtitle: Text('None'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Send UTF-8 locale'),
                        subtitle: const Text(
                          'Advertise a Unicode-capable locale',
                        ),
                        value: _sendUtf8,
                        onChanged: (value) => setState(() => _sendUtf8 = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SurfSection(
                  title: 'Advanced routing',
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('SSH jump host'),
                        subtitle: const Text('Presentation setting only'),
                        value: _jumpHost,
                        onChanged: (value) => setState(() => _jumpHost = value),
                      ),
                      const Divider(),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('SOCKS5 proxy'),
                        subtitle: const Text('Presentation setting only'),
                        value: _proxy,
                        onChanged: (value) => setState(() => _proxy = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const Key('save-profile'),
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: Text(
                    _existing == null ? 'Create host' : 'Save changes',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
