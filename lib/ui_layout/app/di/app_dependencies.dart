import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class AppDependencies {
  const AppDependencies({
    required this.profilesRepository,
    required this.snippetsRepository,
    required this.settingsRepository,
    required this.sftpRepository,
  });

  factory AppDependencies.preview() => AppDependencies(
    profilesRepository: InMemoryProfilesRepository(),
    snippetsRepository: InMemorySnippetsRepository(),
    settingsRepository: InMemorySettingsRepository(),
    sftpRepository: InMemorySftpRepository(),
  );

  final ProfilesRepository profilesRepository;
  final SnippetsRepository snippetsRepository;
  final SettingsRepository settingsRepository;
  final SftpRepository sftpRepository;
}
