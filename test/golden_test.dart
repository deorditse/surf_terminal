import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

import 'support/ui_fakes.dart';

Future<void> configureSurface(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

AppDependencies terminalGoldenDependencies() => AppDependencies(
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
  sshSessionFactory: FailedSshFactory(),
);

void main() {
  testWidgets('compact SSH shell golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
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
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/host_editor_compact.png'),
    );
  });

  testWidgets('compact terminal golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    final dependencies = terminalGoldenDependencies();
    await tester.pumpWidget(SurfTerminalApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terminal preview'));
    await tester.pumpAndSettle();
    dependencies.terminalRuntimes.sessions.single.terminal.write('\x1b[?25l');
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/terminal_compact.png'),
    );
  });

  testWidgets('expanded snippets golden', (tester) async {
    await configureSurface(tester, const Size(900, 700));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
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
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_compact.png'),
    );
  });
}
