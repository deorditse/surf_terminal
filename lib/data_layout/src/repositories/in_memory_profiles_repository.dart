import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class InMemoryProfilesRepository implements ProfilesRepository {
  InMemoryProfilesRepository({List<SshProfile>? initialProfiles})
    : _profiles = List<SshProfile>.of(initialProfiles ?? const <SshProfile>[]);

  final List<SshProfile> _profiles;

  @override
  Future<List<SshProfile>> getAll() async => List<SshProfile>.of(_profiles);

  @override
  Future<void> save(SshProfile profile) async {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      _profiles.add(profile);
    } else {
      _profiles[index] = profile;
    }
  }

  @override
  Future<void> delete(String id) async {
    _profiles.removeWhere((profile) => profile.id == id);
  }
}
