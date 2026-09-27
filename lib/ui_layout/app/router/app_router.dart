import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/ui_layout/pages/connection_editor/connection_editor_page.dart';
import 'package:surf_terminal/ui_layout/pages/connections/connections_page.dart';
import 'package:surf_terminal/ui_layout/pages/settings/settings_page.dart';
import 'package:surf_terminal/ui_layout/pages/sftp/sftp_page.dart';
import 'package:surf_terminal/ui_layout/pages/shell/app_shell_page.dart';
import 'package:surf_terminal/ui_layout/pages/snippet_editor/snippet_editor_page.dart';
import 'package:surf_terminal/ui_layout/pages/snippets/snippets_page.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/terminal_page.dart';

GoRouter createAppRouter() {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/connections',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/connections',
                builder: (context, state) => const ConnectionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sftp',
                builder: (context, state) => const SftpPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/snippets',
                builder: (context, state) => const SnippetsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/connections/new',
        builder: (context, state) => const ConnectionEditorPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/connections/:profileId/edit',
        builder: (context, state) =>
            ConnectionEditorPage(profileId: state.pathParameters['profileId']),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/terminal/:sessionId',
        builder: (context, state) =>
            TerminalPage(sessionId: state.pathParameters['sessionId']!),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/snippets/new',
        builder: (context, state) => const SnippetEditorPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/snippets/:snippetId/edit',
        builder: (context, state) =>
            SnippetEditorPage(snippetId: state.pathParameters['snippetId']),
      ),
    ],
  );
}
