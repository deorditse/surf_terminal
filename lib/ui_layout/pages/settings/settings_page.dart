import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/ui_layout/pages/settings/sections/about_settings_section.dart';
import 'package:surf_terminal/ui_layout/pages/settings/sections/connection_settings_section.dart';
import 'package:surf_terminal/ui_layout/pages/settings/sections/help_settings_section.dart';
import 'package:surf_terminal/ui_layout/pages/settings/sections/terminal_settings_section.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final preferences = state.preferences;
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          key: const Key('settings-page'),
          appBar: AppBar(title: const Text('Settings')),
          body: SafeArea(
            top: false,
            child: ListView(
              key: const PageStorageKey('settings-scroll'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                const PageIntro(
                  eyebrow: 'Personalize',
                  title: 'Make it yours',
                  description: 'Tune the offline terminal preview and connection behavior controls.',
                ),
                const SizedBox(height: 24),
                const HelpSettingsSection(),
                const SizedBox(height: 20),
                TerminalSettingsSection(
                  preferences: preferences,
                  onChanged: cubit.updatePreferences,
                ),
                const SizedBox(height: 20),
                ConnectionSettingsSection(
                  preferences: preferences,
                  onChanged: cubit.updatePreferences,
                ),
                const SizedBox(height: 20),
                const AboutSettingsSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
