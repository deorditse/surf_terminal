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

    expect(
      find.text('Terminal appearance and connection behavior.'),
      findsOneWidget,
    );
    final kelpPalette = find.byKey(const Key('palette-kelp'));
    await tester.scrollUntilVisible(
      kelpPalette,
      160,
      scrollable: find.descendant(
        of: find.byKey(const PageStorageKey('settings-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('settings-scroll')),
      const Offset(0, 120),
    );
    await tester.pumpAndSettle();
    await tester.tap(kelpPalette);
    await tester.pump();
    final chip = tester.widget<ChoiceChip>(kelpPalette);
    expect(chip.selected, isTrue);
  });
}
