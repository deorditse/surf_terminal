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

class _SurfTerminalAppState extends State<SurfTerminalApp> {
  late final AppDependencies _dependencies =
      widget.dependencies ?? AppDependencies.preview();
  late final ProfilesCubit _profilesCubit = ProfilesCubit(
    _dependencies.profilesRepository,
  );
  late final SnippetsCubit _snippetsCubit = SnippetsCubit(
    _dependencies.snippetsRepository,
  );
  late final TerminalSessionsCubit _terminalSessionsCubit =
      TerminalSessionsCubit();
  late final SftpCubit _sftpCubit = SftpCubit(_dependencies.sftpRepository);
  late final SettingsCubit _settingsCubit = SettingsCubit(
    _dependencies.settingsRepository,
  );
  late final GoRouter _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    _profilesCubit.close();
    _snippetsCubit.close();
    _terminalSessionsCubit.close();
    _sftpCubit.close();
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _profilesCubit),
        BlocProvider.value(value: _snippetsCubit),
        BlocProvider.value(value: _terminalSessionsCubit),
        BlocProvider.value(value: _sftpCubit),
        BlocProvider.value(value: _settingsCubit),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.preferences.autoTheme != current.preferences.autoTheme,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Surf Terminal',
            debugShowCheckedModeBanner: false,
            theme: SurfTheme.light(),
            darkTheme: SurfTheme.dark(),
            themeMode: state.preferences.autoTheme
                ? ThemeMode.system
                : ThemeMode.dark,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
