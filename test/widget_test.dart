import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

AppDependencies _dependencies({List<SshProfile> profiles = const []}) =>
    AppDependencies(
      profilesRepository: InMemoryProfilesRepository(initialProfiles: profiles),
      snippetsRepository: InMemorySnippetsRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

void _expectSingleAppBarAddHostAction() {
  expect(find.byTooltip('Add host'), findsOneWidget);
  expect(find.byKey(const Key('add-host-fab')), findsNothing);
  expect(find.byType(FloatingActionButton), findsNothing);
  expect(find.text('Create host'), findsNothing);
  expect(
    find.textContaining(RegExp('preview|offline', caseSensitive: false)),
    findsNothing,
  );
}

void main() {
  testWidgets('empty Connections exposes only the AppBar Add host action', (
    tester,
  ) async {
    await tester.pumpWidget(SurfTerminalApp(dependencies: _dependencies()));
    await tester.pumpAndSettle();

    _expectSingleAppBarAddHostAction();
    await tester.tap(find.byTooltip('Add host'));
    await tester.pumpAndSettle();
    expect(find.text('New host'), findsOneWidget);
  });

  testWidgets('populated Connections exposes only the AppBar Add host action', (
    tester,
  ) async {
    await tester.pumpWidget(
      SurfTerminalApp(
        dependencies: _dependencies(
          profiles: const [
            SshProfile(
              id: 'widget-host',
              name: 'Widget host',
              host: 'host.invalid',
              port: 22,
              username: 'tester',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Widget host'), findsOneWidget);
    _expectSingleAppBarAddHostAction();

    await tester.tap(find.byTooltip('Host actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(RegExp('preview|offline', caseSensitive: false)),
      findsNothing,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add host'));
    await tester.pumpAndSettle();
    expect(find.text('New host'), findsOneWidget);
  });

  testWidgets('shell route transitions do not collide on FAB Hero tags', (
    tester,
  ) async {
    await tester.pumpWidget(
      SurfTerminalApp(
        dependencies: _dependencies(
          profiles: const [
            SshProfile(
              id: 'hero-host',
              name: 'Hero host',
              host: 'hero.invalid',
              port: 22,
              username: 'tester',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();

    final snippetsFab = find.byKey(const Key('add-snippet-fab'));
    expect(
      tester.widget<FloatingActionButton>(snippetsFab).heroTag,
      'snippets-add-fab',
    );
    await tester.tap(snippetsFab);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('starts on SSH and switches all primary destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('connections-page')), findsOneWidget);
    expect(find.byTooltip('Add host'), findsOneWidget);
    expect(find.text('SFTP'), findsNothing);

    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('snippets-page')), findsOneWidget);

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('settings-page')), findsOneWidget);
  });
}
