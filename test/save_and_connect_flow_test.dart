import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';
import 'package:surf_terminal/ui_layout/pages/connections/profile_connector.dart';

import 'support/save_connect_fakes.dart';

void main() {
  testWidgets('terminal is visible while profile save is pending', (
    tester,
  ) async {
    final gate = Completer<void>();
    final profiles = TrackingProfilesRepository(saveGate: gate);
    final dependencies = _dependencies(profiles: profiles);
    await _openEditor(tester, dependencies);

    await _submit(tester, remember: false);
    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(dependencies.terminalRuntimes.sessions, hasLength(1));
    expect(profiles.saveCount, 1);
    await profiles.saveStarted.future;
    await tester.pump();

    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(find.textContaining('Connecting'), findsOneWidget);
    expect(dependencies.terminalRuntimes.sessions, hasLength(1));
    gate.complete();
    await _disposeApp(tester, dependencies);
  });

  testWidgets('SSH failure does not suppress pending profile save', (
    tester,
  ) async {
    final gate = Completer<void>();
    final profiles = TrackingProfilesRepository(saveGate: gate);
    final dependencies = _dependencies(profiles: profiles);
    await _openEditor(tester, dependencies);

    await _submit(tester, remember: false);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('Controlled test failure.'), findsOneWidget);
    expect(profiles.profiles, isEmpty);

    gate.complete();
    await tester.pump();
    await tester.pump();
    expect(profiles.profiles, hasLength(1));
    await _disposeApp(tester, dependencies);
  });

  testWidgets('profile save failure leaves started runtime open', (
    tester,
  ) async {
    final profiles = TrackingProfilesRepository(failSave: true);
    final dependencies = _dependencies(profiles: profiles);
    await _openEditor(tester, dependencies);

    await _submit(tester, remember: false);
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(find.text('Profile storage failed.'), findsOneWidget);
    expect(dependencies.terminalRuntimes.sessions, hasLength(1));
    await _disposeApp(tester, dependencies);
  });

  testWidgets('permanent credential failure leaves started runtime open', (
    tester,
  ) async {
    final credentials = TrackingCredentialStore(failWriteNumber: 2);
    final dependencies = _dependencies(
      profiles: TrackingProfilesRepository(),
      credentials: credentials,
    );
    await _openEditor(tester, dependencies);

    await _submit(tester);
    await tester.pump();
    await tester.pump();

    expect(credentials.writeCount, 2);
    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(find.text('Credential storage failed.'), findsOneWidget);
    expect(dependencies.terminalRuntimes.sessions, hasLength(1));
    await _disposeApp(tester, dependencies);
  });

  testWidgets('remember uses distinct transient and permanent references', (
    tester,
  ) async {
    final profiles = TrackingProfilesRepository();
    final credentials = TrackingCredentialStore();
    final factory = PendingSessionFactory();
    final dependencies = _dependencies(
      profiles: profiles,
      credentials: credentials,
      factory: factory,
    );
    await _openEditor(tester, dependencies);

    await _submit(tester);
    await tester.pump();
    await tester.pump();

    final attempted = factory.startedProfiles.single.credentialReference;
    final persisted = profiles.profiles.single.credentialReference;
    expect(attempted, isNotNull);
    expect(persisted, isNotNull);
    expect(attempted, isNot(equals(persisted)));
    expect(
      credentials.written,
      containsAll(<CredentialReference>[attempted!, persisted!]),
    );
    await _disposeApp(tester, dependencies);
  });

  testWidgets('no remember persists null after transient first attempt', (
    tester,
  ) async {
    final profiles = TrackingProfilesRepository();
    final credentials = TrackingCredentialStore();
    final factory = PendingSessionFactory();
    final dependencies = _dependencies(
      profiles: profiles,
      credentials: credentials,
      factory: factory,
    );
    await _openEditor(tester, dependencies);

    await _submit(tester, remember: false);
    await tester.pump();
    await tester.pump();

    expect(factory.startedProfiles.single.credentialReference, isNotNull);
    expect(profiles.profiles.single.credentialReference, isNull);
    expect(credentials.writeCount, 1);
    await _disposeApp(tester, dependencies);
  });

  testWidgets('replacement leaves one runtime and one session record', (
    tester,
  ) async {
    final profiles = TrackingProfilesRepository();
    final dependencies = _dependencies(profiles: profiles);
    await _openEditor(tester, dependencies);
    await _submit(tester, remember: false);
    final firstRuntime = dependencies.terminalRuntimes.sessions.single;
    final terminalContext = tester.element(
      find.byKey(const Key('terminal-page')),
    );

    final launch = await dependencies.connect.connectWithSecret(
      profile: const SshProfile(
        id: 'replacement-profile',
        name: 'Replacement',
        host: 'replacement.invalid',
        port: 22,
        username: 'operator',
      ),
      secret: _secret(tester),
      remember: false,
    );
    ProfileConnector.openLaunch(
      terminalContext,
      launch,
      title: 'Replacement',
      replaceCurrent: true,
    );
    await tester.pump();
    await tester.pump();

    final sessions = terminalContext
        .read<TerminalSessionsBloc>()
        .state
        .sessions;
    expect(dependencies.terminalRuntimes.sessions, <TerminalSessionRuntime>[
      launch.runtime,
    ]);
    expect(dependencies.terminalRuntimes.find(firstRuntime.id), isNull);
    expect(sessions.map((session) => session.id), <String>[launch.runtime.id]);
    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    await _disposeApp(tester, dependencies);
  });

  testWidgets('edit remains save-only with the same profile identity', (
    tester,
  ) async {
    final profiles = TrackingProfilesRepository(
      initialProfiles: const [
        SshProfile(
          id: 'edit-profile',
          name: 'Saved host',
          host: 'saved.invalid',
          port: 22,
          username: 'operator',
        ),
      ],
    );
    final factory = PendingSessionFactory();
    final dependencies = _dependencies(profiles: profiles, factory: factory);
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Host actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('profile-host')),
      'edited.invalid',
    );
    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();

    expect(profiles.profiles.single.id, 'edit-profile');
    expect(profiles.profiles.single.host, 'edited.invalid');
    expect(factory.startedProfiles, isEmpty);
    await _disposeApp(tester, dependencies);
  });
}

AppDependencies _dependencies({
  required TrackingProfilesRepository profiles,
  TrackingCredentialStore? credentials,
  PendingSessionFactory? factory,
}) => AppDependencies(
  profilesRepository: profiles,
  snippetsRepository: InMemorySnippetsRepository(),
  settingsRepository: InMemorySettingsRepository(),
  credentialStore: credentials,
  knownHostsRepository: EmptyKnownHosts(),
  sshSessionFactory: factory ?? PendingSessionFactory(),
);

Future<void> _openEditor(
  WidgetTester tester,
  AppDependencies dependencies,
) async {
  await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Add host'));
  await tester.pumpAndSettle();
}

Future<void> _submit(WidgetTester tester, {bool remember = true}) async {
  await tester.enterText(find.byKey(const Key('profile-host')), 'new.invalid');
  await tester.enterText(find.byKey(const Key('profile-username')), 'operator');
  await tester.enterText(
    find.byKey(const Key('profile-password')),
    _secret(tester),
  );
  if (!remember) {
    await tester.ensureVisible(find.byKey(const Key('remember-password')));
    await tester.drag(
      find.byKey(const PageStorageKey('connection-editor-scroll')),
      const Offset(0, 120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remember-password')));
    await tester.pump();
  }
  await tester.tap(find.widgetWithText(TextButton, 'Connect'));
  await tester.pump();
  await tester.pump();
}

String _secret(WidgetTester tester) =>
    'runtime-${identityHashCode(tester)}-${DateTime.now().microsecondsSinceEpoch}';

Future<void> _disposeApp(
  WidgetTester tester,
  AppDependencies dependencies,
) async {
  await tester.pumpWidget(const SizedBox.shrink());
  final disposal = dependencies.dispose();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump();
  await disposal;
}
