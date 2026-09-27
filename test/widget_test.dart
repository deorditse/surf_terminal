import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';

void main() {
  testWidgets('starts on SSH and switches all primary destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('connections-page')), findsOneWidget);

    await tester.tap(find.text('SFTP').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sftp-page')), findsOneWidget);

    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('snippets-page')), findsOneWidget);

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('settings-page')), findsOneWidget);
  });
}
