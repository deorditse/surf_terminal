import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('InMemoryProfilesRepository', () {
    test('starts with fictional preview profiles', () {
      final repository = InMemoryProfilesRepository();

      final profiles = repository.getAll();

      expect(profiles.map((profile) => profile.name), <String>[
        'Atlas Lab',
        'Edge Sandbox',
      ]);
      expect(profiles[0].endpoint, 'developer@atlas.example.com:22');
      expect(profiles[1].endpoint, 'operator@192.0.2.24:2222');
    });

    test('returns a collection copy', () {
      final repository = InMemoryProfilesRepository();

      repository.getAll().clear();

      expect(repository.getAll(), hasLength(2));
    });

    test('saves a profile and updates the matching id in place', () {
      final repository = InMemoryProfilesRepository(initialProfiles: const []);
      const profile = SshProfile(
        id: 'profile-local',
        name: 'Local fixture',
        host: 'host.example',
        port: 22,
        username: 'demo',
      );

      repository.save(profile);
      repository.save(profile.copyWith(name: 'Updated fixture'));

      expect(repository.getAll(), hasLength(1));
      expect(repository.getAll().single.name, 'Updated fixture');
    });

    test('deletes profiles through the final empty state', () {
      final repository = InMemoryProfilesRepository();

      for (final profile in repository.getAll()) {
        repository.delete(profile.id);
      }

      expect(repository.getAll(), isEmpty);
    });
  });
}
