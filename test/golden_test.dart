import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';

Future<void> configureSurface(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

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
    await tester.tap(find.byTooltip('Add SSH host'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/host_editor_compact.png'),
    );
  });

  testWidgets('compact terminal golden', (tester) async {
    await configureSurface(tester, const Size(390, 844));
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atlas Lab'));
    await tester.pumpAndSettle();
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
