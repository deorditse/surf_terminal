import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/di/connect_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';
import 'package:surf_terminal/ui_layout/pages/connections/dialogs/password_prompt.dart';

final class ProfileConnector {
  static Future<void> connect(
    BuildContext context,
    SshProfile profile, {
    bool replaceCurrent = false,
  }) async {
    try {
      await _connect(context, profile, replaceCurrent: replaceCurrent);
    } on Object catch (error) {
      if (!context.mounted) return;
      final message = error is RepositoryFailure
          ? error.message
          : 'The SSH session could not be prepared.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () =>
                connect(context, profile, replaceCurrent: replaceCurrent),
          ),
        ),
      );
    }
  }

  static Future<void> _connect(
    BuildContext context,
    SshProfile profile, {
    required bool replaceCurrent,
  }) async {
    final dependencies = context.read<AppDependencies>();
    final reference = profile.credentialReference;
    final available =
        reference != null &&
        await dependencies.credentialStore.contains(reference);
    if (!context.mounted) return;
    if (!available) {
      String? submittedSecret;
      var remember = true;
      final accepted = await showPasswordPrompt(
        context,
        endpoint: profile.endpoint,
        onSubmit: (value, retain) {
          submittedSecret = value;
          remember = retain;
        },
      );
      if (!accepted || submittedSecret == null || !context.mounted) return;
      final launch = await dependencies.connect.connectWithSecret(
        profile: profile,
        secret: submittedSecret!,
        remember: remember,
      );
      submittedSecret = null;
      if (!context.mounted) {
        await dependencies.terminalRuntimes.close(launch.runtime.id);
        return;
      }
      openLaunch(
        context,
        launch,
        title: profile.name,
        replaceCurrent: replaceCurrent,
      );
      return;
    }
    if (!context.mounted) return;
    final runtime = await dependencies.connect.connectStored(profile);
    if (!context.mounted) {
      await dependencies.terminalRuntimes.close(runtime.id);
      return;
    }
    _openRuntime(
      context,
      runtime,
      profile.name,
      replaceCurrent: replaceCurrent,
    );
  }

  static void openLaunch(
    BuildContext context,
    ConnectLaunch launch, {
    required String title,
    bool replaceCurrent = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final profiles = context.read<ProfilesBloc>();
    _openRuntime(
      context,
      launch.runtime,
      title,
      replaceCurrent: replaceCurrent,
    );
    unawaited(_observePersistence(launch, profiles, messenger));
  }

  static void _openRuntime(
    BuildContext context,
    TerminalSessionRuntime runtime,
    String title, {
    bool replaceCurrent = false,
  }) {
    context.read<TerminalSessionsBloc>().add(
      TerminalSessionsEvent.sessionOpened(
        PreviewSession(id: runtime.id, title: title),
      ),
    );
    final location = '/terminal/${runtime.id}';
    if (replaceCurrent) {
      context.replace(location);
    } else {
      context.push(location);
    }
  }

  static Future<void> _observePersistence(
    ConnectLaunch launch,
    ProfilesBloc profiles,
    ScaffoldMessengerState messenger,
  ) async {
    try {
      await launch.persistence;
      profiles.add(const ProfilesEvent.loadRequested());
    } on Object catch (error) {
      messenger.showSnackBar(
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
