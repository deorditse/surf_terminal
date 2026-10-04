import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

void main() {
  testWidgets('management surfaces use restrained Surf presentation', (
    tester,
  ) async {
    await tester.pumpWidget(
      SurfTerminalApp(
        dependencies: AppDependencies(
          profilesRepository: InMemoryProfilesRepository(
            initialProfiles: const [
              SshProfile(
                id: 'management-host',
                name: 'Management host',
                host: 'host.invalid',
                port: 22,
                username: 'surfer',
              ),
            ],
          ),
          snippetsRepository: InMemorySnippetsRepository(),
          settingsRepository: InMemorySettingsRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(app.theme?.scaffoldBackgroundColor, SurfColors.ink);
    expect(app.theme?.colorScheme.primary, SurfColors.surf);
    expect(app.theme?.colorScheme.secondary, SurfColors.tide);

    void expectRestrainedSurface() {
      expect(find.byKey(const Key('management-ocean-motif')), findsOneWidget);
      expect(find.byType(PreviewBadge), findsNothing);
      expect(
        find.textContaining(
          RegExp(r'\b(preview|offline|mock)\b', caseSensitive: false),
        ),
        findsNothing,
      );
      expect(find.text('Move faster'), findsNothing);
      expect(find.text('Make it yours'), findsNothing);

      final intro = find.byType(PageIntro);
      expect(intro, findsOneWidget);
      final title = tester.widgetList<Text>(
        find.descendant(of: intro, matching: find.byType(Text)),
      ).elementAt(1);
      expect(title.style?.fontSize, lessThanOrEqualTo(24));
    }

    expectRestrainedSurface();
    expect(find.text('SSH'), findsWidgets);
    expect(find.text('Snippets'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    expectRestrainedSurface();

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expectRestrainedSurface();
  });
}
