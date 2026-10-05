import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/app/theme/terminal_preferences_ui.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_status_bar.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_tabs.dart';
import 'package:xterm/xterm.dart' as xterm;

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
    attempt ?? FakeAttempt(fakeKey(), session),
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

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
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
    expect(
      find.byKey(const Key('terminal-glass-top-controls')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('terminal-glass-special-key-controls')),
      findsOneWidget,
    );
    expect(find.byType(TerminalSessionTabs), findsNothing);
    expect(find.byType(SessionStatusBar), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    expect(find.textContaining('Offline preview'), findsNothing);

    final runtime = dependencies.terminalRuntimes.sessions.single;
    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isTrue);

    await tester.tap(find.byKey(const Key('terminal-key-control')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('terminal-key-c')));
    await tester.pump();
    expect(ssh.sent.last, <int>[3]);

    await tester.scrollUntilVisible(
      find.byKey(const Key('terminal-key-hide-keyboard')),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('special-key-toolbar')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const Key('terminal-key-hide-keyboard')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isFalse);

    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isTrue);
  });

  testWidgets('terminal content extends beneath the icon-only top control', (
    tester,
  ) async {
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetPadding);
    final dependencies = workspaceDependencies(FakeSession());
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();

    final controls = tester.getRect(
      find.byKey(const Key('terminal-glass-top-controls')),
    );
    final content = tester.getRect(
      find.byKey(const Key('terminal-input-viewport')),
    );
    expect(content.top, lessThan(controls.bottom));
    expect(
      find.descendant(
        of: find.byKey(const Key('terminal-glass-top-controls')),
        matching: find.byType(Text),
      ),
      findsNothing,
    );
  });

  testWidgets('terminal controls use compact visual chrome', (tester) async {
    final dependencies = workspaceDependencies(FakeSession());
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();

    expect(
      tester
          .getSize(find.byKey(const Key('terminal-glass-top-controls')))
          .height,
      lessThanOrEqualTo(32),
    );
    expect(
      tester
          .getSize(find.byKey(const Key('terminal-glass-special-key-controls')))
          .height,
      lessThanOrEqualTo(34),
    );
    expect(
      tester.getSize(find.byKey(const Key('special-key-toolbar'))).height,
      44,
    );
    for (final label in <String>[
      'Esc',
      'Ctrl',
      'Alt',
      'Tab',
      'Paste',
      'Hide keyboard',
    ]) {
      expect(find.text(label), findsNothing);
    }
  });

  testWidgets('terminal uses one flat dark background without colored panels', (
    tester,
  ) async {
    for (final palette in TerminalPalette.values) {
      expect(
        TerminalPreferences(palette: palette).terminalBackground,
        SurfColors.ink,
      );
    }

    final dependencies = workspaceDependencies(FakeSession());
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();

    final page = tester.widget<ColoredBox>(
      find.byKey(const Key('terminal-page')),
    );
    final viewport = tester.widget<ColoredBox>(
      find.byKey(const Key('terminal-viewport')),
    );
    final terminal = tester.widget<xterm.TerminalView>(
      find.byKey(const Key('terminal-input-viewport')),
    );

    expect(page.color, SurfColors.ink);
    expect(viewport.color, SurfColors.ink);
    expect(terminal.theme.background, SurfColors.ink);
  });

  testWidgets('terminal scrollback follows a comfortable vertical drag', (
    tester,
  ) async {
    final dependencies = workspaceDependencies(FakeSession());
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();

    final runtime = dependencies.terminalRuntimes.sessions.single;
    final terminalView = tester.widget<xterm.TerminalView>(
      find.byKey(const Key('terminal-input-viewport')),
    );
    expect(terminalView.simulateScroll, isTrue);
    runtime.terminal.write(
      List<String>.generate(160, (index) => 'history line $index').join('\r\n'),
    );
    await tester.pumpAndSettle();

    final scrollable = find.descendant(
      of: find.byKey(const Key('terminal-input-viewport')),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.maxScrollExtent, greaterThan(0));
    final bottom = position.pixels;

    await tester.drag(
      find.byKey(const Key('terminal-input-viewport')),
      const Offset(0, 240),
    );
    await tester.pumpAndSettle();

    expect(position.pixels, lessThan(bottom));
  });

  testWidgets('software keyboard Return always sends terminal Enter', (
    tester,
  ) async {
    final ssh = FakeSession();
    final dependencies = workspaceDependencies(ssh);
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('terminal-input-viewport')));
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.newline);
    await tester.pump(const Duration(milliseconds: 300));

    expect(ssh.sent, hasLength(1));
    expect(ssh.sent.single, <int>[13]);
  });

  testWidgets('floating Enter key sends carriage return and keeps focus', (
    tester,
  ) async {
    final ssh = FakeSession();
    final dependencies = workspaceDependencies(ssh);
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workspace test'));
    await tester.pumpAndSettle();
    final runtime = dependencies.terminalRuntimes.sessions.single;
    await tester.tap(find.byKey(const Key('terminal-input-viewport')));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key('terminal-key-enter')));
    await tester.pump();

    expect(ssh.sent.single, <int>[13]);
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
