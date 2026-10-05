import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show AppBar, Colors, MaterialApp, Scaffold, Theme;
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

    expect(find.byType(MaterialApp), findsNothing);
    final app = tester.widget<CupertinoApp>(find.byType(CupertinoApp));
    expect(app.theme?.brightness, Brightness.dark);
    expect(app.theme?.primaryColor, SurfColors.surf);
    expect(app.theme?.scaffoldBackgroundColor, SurfColors.ink);

    final materialTheme = Theme.of(
      tester.element(find.byKey(const Key('connections-page'))),
    );
    expect(materialTheme.scaffoldBackgroundColor, SurfColors.ink);
    expect(materialTheme.colorScheme.primary, SurfColors.surf);
    expect(materialTheme.colorScheme.secondary, SurfColors.tide);

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
      final title = tester
          .widgetList<Text>(
            find.descendant(of: intro, matching: find.byType(Text)),
          )
          .elementAt(1);
      expect(title.style?.fontSize, lessThanOrEqualTo(24));
    }

    void expectContentScrollsUnderAppBar(Key pageKey, Key scrollKey) {
      final page = find.byKey(pageKey);
      final scaffold = tester.widget<Scaffold>(page);
      final appBarFinder = find.descendant(
        of: page,
        matching: find.byWidgetPredicate((widget) => widget is AppBar),
      );
      final appBar = tester.widget<AppBar>(appBarFinder);

      expect(scaffold.extendBodyBehindAppBar, isTrue);
      expect(appBar.backgroundColor, Colors.transparent);
      expect(appBar.scrolledUnderElevation, 0);
      expect(
        tester.getRect(find.byKey(scrollKey)).top,
        lessThan(tester.getRect(appBarFinder).bottom),
      );
    }

    expectRestrainedSurface();
    expectContentScrollsUnderAppBar(
      const Key('connections-page'),
      const PageStorageKey('connections-scroll'),
    );
    expect(find.text('SSH'), findsWidgets);
    expect(find.text('Snippets'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    expectRestrainedSurface();
    expectContentScrollsUnderAppBar(
      const Key('snippets-page'),
      const PageStorageKey('snippets-scroll'),
    );

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expectRestrainedSurface();
    expectContentScrollsUnderAppBar(
      const Key('settings-page'),
      const PageStorageKey('settings-scroll'),
    );

    await tester.tap(find.text('SSH').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add host'));
    await tester.pumpAndSettle();
    expectContentScrollsUnderAppBar(
      const Key('connection-editor-page'),
      const PageStorageKey('connection-editor-scroll'),
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snippets').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-snippet-fab')));
    await tester.pumpAndSettle();
    expectContentScrollsUnderAppBar(
      const Key('snippet-editor-page'),
      const PageStorageKey('snippet-editor-scroll'),
    );
  });
}
