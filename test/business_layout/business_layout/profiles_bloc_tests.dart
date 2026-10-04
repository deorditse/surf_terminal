part of '../business_layout_test.dart';

void _registerProfilesTests() {
  const profile = SshProfile(
    id: 'profile-1',
    name: 'Server',
    host: 'server.example',
    port: 22,
    username: 'user',
  );

  group('ProfilesBloc', () {
    test('loads, saves, updates, and deletes profiles', () async {
      final repository = _ProfilesRepository(<SshProfile>[profile]);
      final bloc = ProfilesBloc(
        repository,
        idFactory: (prefix) => '$prefix-fixed',
      );
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == ProfilesStatus.success,
      );

      expect(bloc.state.profiles, <SshProfile>[profile]);
      final created = bloc.createProfile(
        name: 'New',
        host: 'new.example',
        port: 2222,
        username: 'new-user',
        label: 'Lab',
        sendUtf8Locale: true,
        jumpHostEnabled: false,
        proxyEnabled: false,
      );
      expect(created.id, 'profile-fixed');

      final saved = bloc.stream.firstWhere(
        (state) => state.profiles.singleOrNull?.name == 'Updated',
      );
      bloc.add(ProfilesEvent.profileSaved(profile.copyWith(name: 'Updated')));
      await saved;
      final deleted = bloc.stream.firstWhere((state) => state.profiles.isEmpty);
      bloc.add(ProfilesEvent.profileDeleted(profile.id));
      await deleted;
      expect(bloc.state.profiles, isEmpty);
    });

    test(
      'preserves loaded profiles when a repository operation fails',
      () async {
        final repository = _ProfilesRepository(<SshProfile>[profile]);
        final bloc = ProfilesBloc(repository);
        addTearDown(bloc.close);
        await bloc.stream.firstWhere(
          (state) => state.status == ProfilesStatus.success,
        );
        repository.failure = const RepositoryFailure('save', 'cannot save');

        final failed = bloc.stream.firstWhere(
          (state) => state.status == ProfilesStatus.failure,
        );
        bloc.add(ProfilesEvent.profileSaved(profile.copyWith(name: 'Changed')));
        await failed;

        expect(bloc.state.errorMessage, 'cannot save');
        expect(bloc.state.profiles, <SshProfile>[profile]);
      },
    );
  });
}
