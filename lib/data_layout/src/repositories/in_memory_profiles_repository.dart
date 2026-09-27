import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../datasources/preview_fixture_source.dart';

final class InMemoryProfilesRepository implements ProfilesRepository {
  InMemoryProfilesRepository({List<SshProfile>? initialProfiles})
    : _profiles = List<SshProfile>.of(
        initialProfiles ?? const PreviewFixtureSource().profiles(),
      );

  final List<SshProfile> _profiles;

  @override
  List<SshProfile> getAll() => List<SshProfile>.of(_profiles);

  @override
  void save(SshProfile profile) {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      _profiles.add(profile);
    } else {
      _profiles[index] = profile;
    }
  }

  @override
  void delete(String id) {
    _profiles.removeWhere((profile) => profile.id == id);
  }
}
