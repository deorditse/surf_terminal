import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';
import 'package:surf_terminal/ui_layout/app/router/app_router.dart';
import 'package:surf_terminal/ui_layout/app/theme/app_theme.dart';

class SurfTerminalApp extends StatefulWidget {
  const SurfTerminalApp({this.dependencies, super.key});

  final AppDependencies? dependencies;

  @override
  State<SurfTerminalApp> createState() => _SurfTerminalAppState();
}

class _SurfTerminalAppState extends State<SurfTerminalApp>
    with WidgetsBindingObserver {
  late final AppDependencies _dependencies =
      widget.dependencies ?? AppDependencies.preview();
  late final ProfilesBloc _profilesBloc = ProfilesBloc(
    _dependencies.profilesRepository,
  );
  late final SnippetsBloc _snippetsBloc = SnippetsBloc(
    _dependencies.snippetsRepository,
  );
  late final TerminalSessionsBloc _terminalSessionsBloc =
      TerminalSessionsBloc();
  late final SettingsBloc _settingsBloc = SettingsBloc(
    _dependencies.settingsRepository,
  );
  late final GoRouter _router = createAppRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_dependencies.terminalRuntimes.disconnectAll());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    _profilesBloc.close();
    _snippetsBloc.close();
    _terminalSessionsBloc.close();
    _settingsBloc.close();
    unawaited(_dependencies.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _dependencies,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _profilesBloc),
          BlocProvider.value(value: _snippetsBloc),
          BlocProvider.value(value: _terminalSessionsBloc),
          BlocProvider.value(value: _settingsBloc),
        ],
        child: MaterialApp.router(
          title: 'Surf Terminal',
          debugShowCheckedModeBanner: false,
          theme: SurfTheme.dark(),
          themeMode: ThemeMode.dark,
          routerConfig: _router,
        ),
      ),
    );
  }
}
