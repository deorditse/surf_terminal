import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'profile persists, connects through production runtime, and remains editable',
    (tester) async {
      final nonce = DateTime.now().microsecondsSinceEpoch;
      final host = 'profile-$nonce.invalid';
      final firstName = 'Lifecycle $nonce';
      final editedName = 'Edited $nonce';
      final secret = 'runtime-${nonce.hashCode}-${identityHashCode(tester)}';
      AppDependencies? active;
      SshProfile? created;

      try {
        active = await AppDependencies.production();
        await tester.pumpWidget(SurfTerminalApp(dependencies: active));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Add host'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('profile-name')),
          firstName,
        );
        await tester.enterText(find.byKey(const Key('profile-host')), host);
        await tester.enterText(
          find.byKey(const Key('profile-username')),
          'operator',
        );
        await tester.enterText(
          find.byKey(const Key('profile-password')),
          secret,
        );
        await tester.tap(find.widgetWithText(TextButton, 'Connect'));
        await _pumpUntil(
          tester,
          () => find.byKey(const Key('terminal-page')).evaluate().isNotEmpty,
        );

        created = await _waitForProfile(
          tester,
          active.profilesRepository,
          host,
        );
        expect(created.credentialReference, isNotNull);
        expect(
          await active.credentialStore.contains(created.credentialReference!),
          isTrue,
        );
        expect(active.terminalRuntimes.sessions, hasLength(1));

        await _stopApp(tester, active);
        active = await AppDependencies.production();
        await tester.pumpWidget(SurfTerminalApp(dependencies: active));
        await tester.pumpAndSettle();
        final reloaded = await _waitForProfile(
          tester,
          active.profilesRepository,
          host,
        );
        expect(reloaded.id, created.id);

        final card = find.ancestor(
          of: find.text(firstName),
          matching: find.byType(Card),
        );
        await tester.tap(
          find.descendant(of: card, matching: find.byTooltip('Host actions')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();
        expect(find.text('Edit host'), findsOneWidget);
        expect(
          find.byKey(const Key('saved-password-indicator')),
          findsOneWidget,
        );
        final password = tester.widget<TextFormField>(
          find.byKey(const Key('profile-password')),
        );
        expect(password.controller?.text, isEmpty);
        await tester.enterText(
          find.byKey(const Key('profile-name')),
          editedName,
        );
        await tester.tap(find.widgetWithText(TextButton, 'Save'));
        await tester.pumpAndSettle();

        final edited = await _waitForProfile(
          tester,
          active.profilesRepository,
          host,
        );
        expect(edited.id, created.id);
        expect(edited.name, editedName);
        expect(edited.credentialReference, created.credentialReference);

        await _stopApp(tester, active);
        active = await AppDependencies.production();
        await tester.pumpWidget(SurfTerminalApp(dependencies: active));
        await tester.pumpAndSettle();
        final finalReload = await _waitForProfile(
          tester,
          active.profilesRepository,
          host,
        );
        expect(finalReload.id, created.id);
        expect(finalReload.name, editedName);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        await active?.dispose();
        final cleanup = await AppDependencies.production();
        final matches = (await cleanup.profilesRepository.getAll()).where(
          (profile) => profile.host == host,
        );
        for (final profile in matches) {
          await cleanup.profilesRepository.delete(profile.id);
        }
        await cleanup.dispose();
      }
    },
    skip: !Platform.isAndroid,
  );
}

Future<SshProfile> _waitForProfile(
  WidgetTester tester,
  ProfilesRepository repository,
  String host,
) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    final profiles = await repository.getAll();
    for (final profile in profiles) {
      if (profile.host == host) return profile;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  throw StateError('The profile was not persisted before the timeout.');
}

Future<void> _pumpUntil(WidgetTester tester, bool Function() condition) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (condition()) return;
  }
  throw StateError('The expected UI state was not reached.');
}

Future<void> _stopApp(WidgetTester tester, AppDependencies dependencies) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await dependencies.dispose();
}
