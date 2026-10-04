import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_controllers.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/form/connection_editor_form.dart';
import 'package:surf_terminal/ui_layout/pages/connections/profile_connector.dart';

class ConnectionEditorPage extends StatefulWidget {
  const ConnectionEditorPage({this.profileId, super.key});
  final String? profileId;
  @override
  State<ConnectionEditorPage> createState() => _ConnectionEditorPageState();
}

class _ConnectionEditorPageState extends State<ConnectionEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final ConnectionEditorControllers _controllers;
  bool _obscurePassword = true, _rememberPassword = true;
  bool _removeSavedPassword = false, _sendUtf8 = true;
  bool _jumpHost = false, _proxy = false;
  bool _saving = false;
  SshProfile? _existing;

  @override
  void initState() {
    super.initState();
    final profiles = context.read<ProfilesBloc>().state.profiles;
    _existing = widget.profileId == null
        ? null
        : profiles.where((item) => item.id == widget.profileId).firstOrNull;
    _controllers = ConnectionEditorControllers.fromProfile(_existing);
    _sendUtf8 = _existing?.sendUtf8Locale ?? true;
    _jumpHost = _existing?.jumpHostEnabled ?? false;
    _proxy = _existing?.proxyEnabled ?? false;
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final bloc = context.read<ProfilesBloc>();
    final name = _controllers.name.text.trim().isEmpty
        ? _controllers.host.text.trim()
        : _controllers.name.text.trim();
    final profile =
        _existing?.copyWith(
          name: name,
          host: _controllers.host.text.trim(),
          port: int.parse(_controllers.port.text),
          username: _controllers.username.text.trim(),
          label: _label,
          sendUtf8Locale: _sendUtf8,
          jumpHostEnabled: _jumpHost,
          proxyEnabled: _proxy,
        ) ??
        bloc.createProfile(
          name: name,
          host: _controllers.host.text.trim(),
          port: int.parse(_controllers.port.text),
          username: _controllers.username.text.trim(),
          label: _label,
          sendUtf8Locale: _sendUtf8,
          jumpHostEnabled: _jumpHost,
          proxyEnabled: _proxy,
        );
    final secret = _controllers.password.text;
    final intent = _credentialIntent(profile, secret);
    try {
      final dependencies = context.read<AppDependencies>();
      if (_existing != null) {
        await dependencies.credentials.save(
          profile: profile,
          intent: intent,
          secret: secret.isEmpty ? null : secret,
        );
        bloc.add(const ProfilesEvent.loadRequested());
        if (mounted) context.pop();
        return;
      }
      if (secret.isEmpty) {
        if (!mounted) return;
        await ProfileConnector.connect(
          context,
          profile,
          replaceCurrent: true,
        );
        if (mounted) setState(() => _saving = false);
        return;
      }
      final launch = await dependencies.connect.connectWithSecret(
        profile: profile,
        secret: secret,
        remember: _rememberPassword,
      );
      _controllers.password.clear();
      if (!mounted) {
        await dependencies.terminalRuntimes.close(launch.runtime.id);
        return;
      }
      ProfileConnector.openLaunch(
        context,
        launch,
        title: profile.name,
        replaceCurrent: true,
      );
    } on Object catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is RepositoryFailure
                  ? error.message
                  : 'The profile could not be saved.',
            ),
          ),
        );
      }
    }
  }

  String get _label => _controllers.label.text.trim().isEmpty
      ? 'Personal'
      : _controllers.label.text.trim();

  CredentialIntent _credentialIntent(SshProfile profile, String secret) {
    if (_removeSavedPassword ||
        (profile.credentialReference != null && !_rememberPassword)) {
      return const CredentialIntent.remove();
    }
    if (secret.isNotEmpty && _rememberPassword) {
      return const CredentialIntent.store();
    }
    return const CredentialIntent.preserve();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_existing == null ? 'New host' : 'Edit host'),
      actions: [
        TextButton(
          onPressed: _saving ? null : _save,
          child: Text(_existing == null ? 'Connect' : 'Save'),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ConnectionEditorForm(
        formKey: _formKey,
        controllers: _controllers,
        obscurePassword: _obscurePassword,
        sendUtf8: _sendUtf8,
        jumpHost: _jumpHost,
        proxy: _proxy,
        isEditing: _existing != null,
        rememberPassword: _rememberPassword,
        hasSavedPassword: _existing?.credentialReference != null,
        removeSavedPassword: _removeSavedPassword,
        onTogglePasswordVisibility: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onRememberChanged: (value) => setState(() => _rememberPassword = value),
        onRemoveChanged: (value) =>
            setState(() => _removeSavedPassword = value),
        onSendUtf8Changed: (value) => setState(() => _sendUtf8 = value),
        onJumpHostChanged: (value) => setState(() => _jumpHost = value),
        onProxyChanged: (value) => setState(() => _proxy = value),
        onSave: _save,
      ),
    ),
  );
}
