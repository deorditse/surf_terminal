import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';

void main() {
  testWidgets('opens terminal preview and manages session tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Atlas Lab'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('terminal-page')), findsOneWidget);
    expect(find.textContaining('Offline preview'), findsWidgets);

    await tester.tap(find.byKey(const Key('add-session')));
    await tester.pumpAndSettle();
    expect(find.text('Preview 2'), findsOneWidget);

    await tester.tap(find.text('Ctrl'));
    await tester.pump();
    final ctrlSemantics = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == 'Ctrl terminal key',
    );
    final ctrl = tester.widget<Semantics>(ctrlSemantics);
    expect(ctrl.properties.selected, isTrue);
  });

  testWidgets('SFTP fixture changes state and opens a local folder', (
    tester,
  ) async {
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('SFTP').last);
    await tester.pumpAndSettle();

    expect(find.text('/home/demo'), findsOneWidget);
    await tester.tap(find.text('projects'));
    await tester.pumpAndSettle();
    expect(find.text('/home/demo/projects'), findsOneWidget);

    await tester.tap(find.text('Error'));
    await tester.pumpAndSettle();
    expect(find.text('Fixture unavailable'), findsOneWidget);
  });
}
