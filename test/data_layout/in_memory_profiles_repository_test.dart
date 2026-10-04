import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  group('InMemoryProfilesRepository', () {
    test(
      'starts empty until a profile is explicitly supplied or saved',
      () async {
        final repository = InMemoryProfilesRepository();

        expect(await repository.getAll(), isEmpty);
      },
    );

    test('returns a collection copy', () async {
      final repository = InMemoryProfilesRepository(
        initialProfiles: const [
          SshProfile(
            id: 'profile-copy-test',
            name: 'Copy test',
            host: 'copy.invalid',
            port: 22,
            username: 'tester',
          ),
        ],
      );

      (await repository.getAll()).clear();

      expect(await repository.getAll(), hasLength(1));
    });

    test('saves a profile and updates the matching id in place', () async {
      final repository = InMemoryProfilesRepository();
      const profile = SshProfile(
        id: 'profile-local',
        name: 'Local fixture',
        host: 'host.invalid',
        port: 22,
        username: 'tester',
      );

      await repository.save(profile);
      await repository.save(profile.copyWith(name: 'Updated fixture'));

      expect(await repository.getAll(), hasLength(1));
      expect((await repository.getAll()).single.name, 'Updated fixture');
    });

    test('deletes profiles through the final empty state', () async {
      final repository = InMemoryProfilesRepository(
        initialProfiles: const [
          SshProfile(
            id: 'profile-delete-test',
            name: 'Delete test',
            host: 'delete.invalid',
            port: 22,
            username: 'tester',
          ),
        ],
      );

      await repository.delete('profile-delete-test');

      expect(await repository.getAll(), isEmpty);
    });
  });
}
