import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

import 'business_layout/support/ssh_session_fakes.dart';
import 'support/ui_fakes.dart';

Future<void> configureSurface(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

AppDependencies terminalGoldenDependencies() {
  final session = FakeSession();
  return AppDependencies(
    profilesRepository: InMemoryProfilesRepository(
      initialProfiles: const [
        SshProfile(
          id: 'golden-terminal',
          name: 'Terminal preview',
          host: 'golden.invalid',
          port: 22,
          username: 'tester',
          credentialReference: CredentialReference('opaque-golden-ref'),
        ),
      ],
    ),
    snippetsRepository: InMemorySnippetsRepository(),
    settingsRepository: InMemorySettingsRepository(),
    credentialStore: AvailableCredentialStore(),
    knownHostsRepository: FakeKnownHosts(record: fakeRecord('SHA256:current')),
    sshSessionFactory: GoldenSessionFactory(FakeAttempt(fakeKey(), session)),
  );
}

final class GoldenSessionFactory implements SshSessionFactory {
  GoldenSessionFactory(this.attempt);

  final SshConnectionAttempt attempt;

  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions dimensions,
  ) => attempt;
}

void main() {
  testWidgets('compact SSH shell golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CupertinoApp),
      matchesGoldenFile('goldens/ssh_compact.png'),
    );
  });

  testWidgets('compact host editor golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add host'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CupertinoApp),
      matchesGoldenFile('goldens/host_editor_compact.png'),
    );
  });

  testWidgets('compact terminal golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetPadding);
    final dependencies = terminalGoldenDependencies();
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terminal preview'));
    for (var index = 0; index < 20; index++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find
          .byKey(const Key('terminal-input-viewport'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }
    expect(find.byKey(const Key('terminal-input-viewport')), findsOneWidget);
    dependencies.terminalRuntimes.sessions.single.terminal.write(
      '\x1b[?25lLast login: Sun Oct 4 22:41:03 on ttys001\r\n'
      'tester@golden ~ % echo Surf Terminal\r\n'
      'Surf Terminal\r\n'
      'tester@golden ~ % ',
    );
    await tester.pump();
    await expectLater(
      find.byType(CupertinoApp),
      matchesGoldenFile('goldens/terminal_compact.png'),
    );
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('expanded snippets golden', (tester) async {
    await configureSurface(tester, const Size(900, 700));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CupertinoApp),
      matchesGoldenFile('goldens/snippets_expanded.png'),
    );
  });

  testWidgets('compact settings golden', (tester) async {
    await configureSurface(tester, const Size(430, 932));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CupertinoApp),
      matchesGoldenFile('goldens/settings_compact.png'),
    );
  });
}
