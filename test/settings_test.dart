import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

void main() {
  test('theme contrast-critical pairs exceed 4.5:1', () {
    final dark = SurfTheme.dark().colorScheme;

    double contrast(Color a, Color b) {
      final lighter = a.computeLuminance() > b.computeLuminance() ? a : b;
      final darker = identical(lighter, a) ? b : a;
      return (lighter.computeLuminance() + 0.05) /
          (darker.computeLuminance() + 0.05);
    }

    expect(contrast(dark.onSurface, dark.surface), greaterThanOrEqualTo(4.5));
  });

  testWidgets('settings controls update visible terminal preview', (
    tester,
  ) async {
    await tester.pumpWidget(const SurfTerminalApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    expect(find.text('Make it yours'), findsOneWidget);
    final kelpPalette = find.byKey(const Key('palette-kelp'));
    await tester.ensureVisible(kelpPalette);
    await tester.pumpAndSettle();
    await tester.tap(kelpPalette);
    await tester.pump();
    final chip = tester.widget<ChoiceChip>(kelpPalette);
    expect(chip.selected, isTrue);
    final cloudBackup = find.text('Cloud backup');
    await tester.scrollUntilVisible(cloudBackup, 300);
    expect(cloudBackup, findsOneWidget);
    expect(
      tester
          .widget<ListTile>(find.widgetWithText(ListTile, 'Cloud backup'))
          .enabled,
      isFalse,
    );
  });
}
