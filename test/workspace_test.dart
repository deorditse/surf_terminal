import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_status_bar.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_tabs.dart';

import 'support/ui_fakes.dart';
import 'business_layout/support/ssh_session_fakes.dart';

AppDependencies workspaceDependencies(
  FakeSession session, {
  KnownHostsRepository? knownHosts,
  SshConnectionAttempt? attempt,
}) => AppDependencies(
  profilesRepository: InMemoryProfilesRepository(
    initialProfiles: const [
      SshProfile(
        id: 'workspace-test',
        name: 'Workspace test',
        host: 'host.invalid',
        port: 22,
        username: 'tester',
        credentialReference: CredentialReference('opaque-workspace-ref'),
      ),
    ],
  ),
  snippetsRepository: InMemorySnippetsRepository(),
  settingsRepository: InMemorySettingsRepository(),
  credentialStore: AvailableCredentialStore(),
  knownHostsRepository:
      knownHosts ?? FakeKnownHosts(record: fakeRecord('SHA256:current')),
  sshSessionFactory: WorkspaceSessionFactory(<SshConnectionAttempt>[
    attempt == null ? FakeAttempt(fakeKey(), session) : attempt,
  ]),
);

final class WorkspaceSessionFactory implements SshSessionFactory {
  WorkspaceSessionFactory(this.attempts);

  final List<SshConnectionAttempt> attempts;
  var _index = 0;

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions dimensions,
  ) => attempts[_index++];
}

final class DeferredSessionAttempt implements SshConnectionAttempt {
  DeferredSessionAttempt(this._session);

  final Completer<SshSession> _session;

  @override
  Future<PresentedHostKey> get presentedHostKey async => fakeKey();

  @override
  Future<SshSession> get session => _session.future;

  @override
  Future<void> acceptHostKey() async {}

  @override
  Future<void> rejectHostKey() async {}

  @override
  Future<void> cancel() async {}
}

void main() {
  testWidgets('setup is a centered lifecycle surface without terminal chrome', (
    tester,
  ) async {
    final ssh = FakeSession();
    final pendingSession = Completer<SshSession>();
    final dependencies = workspaceDependencies(
      ssh,
      attempt: DeferredSessionAttempt(pendingSession),
    );
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Authenticating'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Authenticating'),
        matching: find.byType(Center),
      ),
      findsOneWidget,
    );
    expect(find.byType(TerminalSessionTabs), findsNothing);
    expect(find.byType(SessionStatusBar), findsNothing);
    expect(find.byKey(const Key('terminal-viewport')), findsNothing);
    expect(find.byKey(const Key('special-key-toolbar')), findsNothing);

    pendingSession.complete(ssh);
    await tester.pumpAndSettle();
  });

  testWidgets('failure is centered with retry and SSH profiles actions', (
    tester,
  ) async {
    final ssh = FakeSession();
    final dependencies = workspaceDependencies(
      ssh,
      attempt: FakeAttempt.failed(
        fakeKey(),
        const SshFailure.authentication(message: 'Access denied'),
      ),
    );
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();

    expect(find.text('Access denied'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('SSH profiles'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Access denied'),
        matching: find.byType(Center),
      ),
      findsOneWidget,
    );
    expect(find.byType(TerminalSessionTabs), findsNothing);
    expect(find.byType(SessionStatusBar), findsNothing);
    expect(find.byKey(const Key('terminal-viewport')), findsNothing);
    expect(find.byKey(const Key('special-key-toolbar')), findsNothing);
  });

  testWidgets('opens a real terminal scope and supports focus dismissal', (
    tester,
  ) async {
    final ssh = FakeSession();
    final dependencies = workspaceDependencies(ssh);
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(find.byKey(const Key('terminal-viewport')), findsOneWidget);
    expect(find.byKey(const Key('special-key-toolbar')), findsOneWidget);
    expect(find.byType(TerminalSessionTabs), findsNothing);
    expect(find.byType(SessionStatusBar), findsNothing);
    expect(find.textContaining('Offline preview'), findsNothing);

    final runtime = dependencies.terminalRuntimes.sessions.single;
    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Ctrl'));
    await tester.pump();
    await tester.tap(find.text('C'));
    await tester.pump();
    expect(ssh.sent.last, <int>[3]);

    await tester.scrollUntilVisible(
      find.text('Hide keyboard'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('special-key-toolbar')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Hide keyboard'));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isFalse);

    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isTrue);
  });

  testWidgets('unknown host dialog dispatches trust to the waiting session', (
    tester,
  ) async {
    final dependencies = workspaceDependencies(
      FakeSession(),
      knownHosts: FakeKnownHosts(),
    );
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workspace test'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Trust unknown host?'), findsOneWidget);
    expect(find.textContaining('SHA256:current'), findsOneWidget);
    await tester.tap(find.text('Trust'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('terminal-viewport')), findsOneWidget);
    expect(find.byKey(const Key('special-key-toolbar')), findsOneWidget);
  });

  testWidgets('changed host requires a separate replacement confirmation', (
    tester,
  ) async {
    final dependencies = workspaceDependencies(
      FakeSession(),
      knownHosts: FakeKnownHosts(record: fakeRecord('SHA256:previous')),
    );
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workspace test'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Host key changed'), findsOneWidget);
    await tester.tap(find.text('Review replacement'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Replace trusted fingerprint?'), findsOneWidget);
    await tester.tap(find.text('Cancel connection'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Server identity was not trusted'),
      findsOneWidget,
    );
  });
}
