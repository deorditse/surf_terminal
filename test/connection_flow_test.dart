import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

AppDependencies emptyDependencies() => AppDependencies(
  profilesRepository: InMemoryProfilesRepository(initialProfiles: const []),
  snippetsRepository: InMemorySnippetsRepository(),
  settingsRepository: InMemorySettingsRepository(),
  sftpRepository: InMemorySftpRepository(),
);

void main() {
  testWidgets('empty host state creates a validated profile', (tester) async {
    await tester.pumpWidget(
      SurfTerminalApp(dependencies: emptyDependencies()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your terminal starts here'), findsOneWidget);
    await tester.tap(find.byTooltip('Add SSH host'));
    await tester.pumpAndSettle();

    final saveProfile = find.text('Save');

    await tester.tap(saveProfile);
    await tester.pump();
    expect(find.text('Required'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const Key('profile-host')),
      'demo.example.com',
    );
    await tester.enterText(find.byKey(const Key('profile-username')), 'demo');
    await tester.enterText(find.byKey(const Key('profile-port')), '70000');
    await tester.tap(saveProfile);
    await tester.pump();
    expect(find.text('Enter a port from 1 to 65535'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('profile-port')), '22');
    await tester.tap(saveProfile);
    await tester.pumpAndSettle();
    expect(find.text('demo@demo.example.com:22'), findsOneWidget);
  });

  testWidgets('password is obscured by default and can be revealed', (
    tester,
  ) async {
    await tester.pumpWidget(
      SurfTerminalApp(dependencies: emptyDependencies()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add SSH host'));
    await tester.pumpAndSettle();

    final passwordFinder = find.byKey(const Key('profile-password'));
    EditableText editablePassword() => tester.widget<EditableText>(
      find.descendant(of: passwordFinder, matching: find.byType(EditableText)),
    );
    expect(editablePassword().obscureText, isTrue);
    await tester.tap(find.byTooltip('Reveal password'));
    await tester.pump();
    expect(editablePassword().obscureText, isFalse);
  });
}
