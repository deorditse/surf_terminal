import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  const profile = SshProfile(
    id: 'profile-1',
    name: 'Server',
    host: 'server.example',
    port: 22,
    username: 'user',
  );

  group('ProfilesCubit', () {
    test('loads, saves, updates, and deletes profiles', () async {
      final repository = _ProfilesRepository(<SshProfile>[profile]);
      final cubit = ProfilesCubit(
        repository,
        idFactory: (prefix) => '$prefix-fixed',
      );
      addTearDown(cubit.close);

      expect(cubit.state.status, ProfilesStatus.success);
      expect(cubit.state.profiles, <SshProfile>[profile]);
      final created = cubit.createProfile(
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

      await cubit.saveProfile(profile.copyWith(name: 'Updated'));
      expect(cubit.state.profiles.single.name, 'Updated');
      await cubit.deleteProfile(profile.id);
      expect(cubit.state.profiles, isEmpty);
    });

    test(
      'preserves loaded profiles when a repository operation fails',
      () async {
        final repository = _ProfilesRepository(<SshProfile>[profile]);
        final cubit = ProfilesCubit(repository);
        addTearDown(cubit.close);
        repository.failure = const RepositoryFailure('save', 'cannot save');

        await cubit.saveProfile(profile.copyWith(name: 'Changed'));

        expect(cubit.state.status, ProfilesStatus.failure);
        expect(cubit.state.errorMessage, 'cannot save');
        expect(cubit.state.profiles, <SshProfile>[profile]);
      },
    );
  });

  group('SnippetsCubit', () {
    test('filters, creates, updates, and deletes snippets', () async {
      final repository = _SnippetsRepository(<CommandSnippet>[
        CommandSnippet(
          id: 'one',
          title: 'Disk overview',
          command: 'df -h',
          labels: const <String>['diagnostics'],
        ),
        CommandSnippet(id: 'two', title: 'Status', command: 'systemctl'),
      ]);
      final cubit = SnippetsCubit(
        repository,
        idFactory: (prefix) => '$prefix-fixed',
      );
      addTearDown(cubit.close);

      cubit.setFilter('DIAG');
      expect(cubit.state.filteredSnippets.map((item) => item.id), <String>[
        'one',
      ]);
      expect(
        cubit
            .createSnippet(
              title: 'Logs',
              command: 'journalctl',
              description: 'Recent logs',
              labels: const <String>['ops'],
            )
            .id,
        'snippet-fixed',
      );

      await cubit.saveSnippet(
        repository.items.first.copyWith(title: 'Disk usage'),
      );
      expect(cubit.state.snippets.first.title, 'Disk usage');
      await cubit.deleteSnippet('one');
      expect(cubit.state.snippets.map((item) => item.id), <String>['two']);
    });

    test('reports repository failures without discarding snippets', () async {
      final snippet = CommandSnippet(id: 'one', title: 'One', command: 'true');
      final repository = _SnippetsRepository(<CommandSnippet>[snippet]);
      final cubit = SnippetsCubit(repository);
      addTearDown(cubit.close);
      repository.failure = const RepositoryFailure('delete', 'cannot delete');

      await cubit.deleteSnippet('one');

      expect(cubit.state.status, SnippetsStatus.failure);
      expect(cubit.state.errorMessage, 'cannot delete');
      expect(cubit.state.snippets, <CommandSnippet>[snippet]);
    });
  });

  group('TerminalSessionsCubit', () {
    test('opens, selects, and closes sessions using neighboring selection', () {
      var next = 0;
      final cubit = TerminalSessionsCubit(
        idFactory: (prefix) => '$prefix-${next++}',
      );
      addTearDown(cubit.close);

      final one = cubit.openSession('One');
      final two = cubit.openSession('Two');
      final three = cubit.openSession('Three');
      cubit.selectSession(two.id);
      cubit.closeSession(two.id);
      expect(cubit.state.activeSessionId, three.id);

      cubit.closeSession(three.id);
      expect(cubit.state.activeSessionId, one.id);
      cubit.closeSession(one.id);
      expect(cubit.state.sessions, isEmpty);
      expect(cubit.state.activeSessionId, isNull);
    });

    test('closing an inactive session preserves the active session', () {
      var next = 0;
      final cubit = TerminalSessionsCubit(
        idFactory: (prefix) => '$prefix-${next++}',
      );
      addTearDown(cubit.close);
      final one = cubit.openSession('One');
      final two = cubit.openSession('Two');

      cubit.closeSession(one.id);

      expect(cubit.state.activeSessionId, two.id);
    });
  });

  group('SftpCubit', () {
    test('loads entries and navigates folders and parents', () async {
      final repository = _SftpRepository();
      final cubit = SftpCubit(repository);
      addTearDown(cubit.close);
      expect(cubit.state.previewState, SftpPreviewState.data);
      expect(cubit.state.path, '/home/demo');

      await cubit.openFolder('logs');
      expect(cubit.state.path, '/home/demo/logs');
      await cubit.goToParent();
      expect(cubit.state.path, '/home/demo');
      await cubit.setPreviewState(SftpPreviewState.empty);
      expect(cubit.state.previewState, SftpPreviewState.empty);
    });

    test(
      'reports repository failures without discarding browser state',
      () async {
        final repository = _SftpRepository();
        final cubit = SftpCubit(repository);
        addTearDown(cubit.close);
        repository.failure = const RepositoryFailure('list', 'cannot list');

        await cubit.refresh();

        expect(cubit.state.previewState, SftpPreviewState.error);
        expect(cubit.state.errorMessage, 'cannot list');
        expect(cubit.state.path, '/home/demo');
      },
    );
  });

  group('SettingsCubit', () {
    test('updates all preferences and convenience values', () async {
      final repository = _SettingsRepository();
      final cubit = SettingsCubit(repository);
      addTearDown(cubit.close);

      await cubit.updatePreferences(
        const TerminalPreferences(palette: TerminalPalette.tide),
      );
      await cubit.updateCursorStyle(TerminalCursorStyle.underline);
      await cubit.updateEmulation('screen-256color');
      await cubit.updateKeepAwake(true);

      expect(cubit.state.preferences.palette, TerminalPalette.tide);
      expect(
        cubit.state.preferences.cursorStyle,
        TerminalCursorStyle.underline,
      );
      expect(cubit.state.preferences.emulation, 'screen-256color');
      expect(cubit.state.preferences.keepAwake, isTrue);
    });

    test('bounds numeric settings before saving', () async {
      final repository = _SettingsRepository();
      final cubit = SettingsCubit(repository);
      addTearDown(cubit.close);

      await cubit.updateFontSize(1000);
      await cubit.updateKeepaliveSeconds(-10);
      await cubit.updateKeepaliveCount(1000);

      expect(cubit.state.preferences.fontSize, SettingsCubit.maxFontSize);
      expect(
        cubit.state.preferences.keepaliveSeconds,
        SettingsCubit.minKeepaliveSeconds,
      );
      expect(
        cubit.state.preferences.keepaliveCount,
        SettingsCubit.maxKeepaliveCount,
      );
    });

    test('reports save failures while preserving preferences', () async {
      final repository = _SettingsRepository();
      final cubit = SettingsCubit(repository);
      addTearDown(cubit.close);
      repository.failure = const RepositoryFailure('save', 'cannot save');

      await cubit.updateKeepAwake(true);

      expect(cubit.state.status, SettingsStatus.failure);
      expect(cubit.state.errorMessage, 'cannot save');
      expect(cubit.state.preferences.keepAwake, isFalse);
    });
  });
}

final class _ProfilesRepository implements ProfilesRepository {
  _ProfilesRepository([List<SshProfile> items = const <SshProfile>[]])
    : items = List<SshProfile>.of(items);

  final List<SshProfile> items;
  RepositoryFailure? failure;

  void _throwIfNeeded() {
    if (failure case final failure?) throw failure;
  }

  @override
  void delete(String id) {
    _throwIfNeeded();
    items.removeWhere((item) => item.id == id);
  }

  @override
  List<SshProfile> getAll() {
    _throwIfNeeded();
    return List<SshProfile>.of(items);
  }

  @override
  void save(SshProfile profile) {
    _throwIfNeeded();
    final index = items.indexWhere((item) => item.id == profile.id);
    index == -1 ? items.add(profile) : items[index] = profile;
  }
}

final class _SnippetsRepository implements SnippetsRepository {
  _SnippetsRepository([List<CommandSnippet> items = const <CommandSnippet>[]])
    : items = List<CommandSnippet>.of(items);

  final List<CommandSnippet> items;
  RepositoryFailure? failure;

  void _throwIfNeeded() {
    if (failure case final failure?) throw failure;
  }

  @override
  void delete(String id) {
    _throwIfNeeded();
    items.removeWhere((item) => item.id == id);
  }

  @override
  List<CommandSnippet> getAll() {
    _throwIfNeeded();
    return List<CommandSnippet>.of(items);
  }

  @override
  void save(CommandSnippet snippet) {
    _throwIfNeeded();
    final index = items.indexWhere((item) => item.id == snippet.id);
    index == -1 ? items.add(snippet) : items[index] = snippet;
  }
}

final class _SftpRepository implements SftpRepository {
  RepositoryFailure? failure;
  SftpPreviewState _previewState = SftpPreviewState.data;
  String _path = '/home/demo';

  void _throwIfNeeded() {
    if (failure case final failure?) throw failure;
  }

  @override
  void goToParent() {
    _throwIfNeeded();
    final segments = _path.split('/')..removeWhere((item) => item.isEmpty);
    if (segments.isNotEmpty) segments.removeLast();
    _path = '/${segments.join('/')}';
  }

  @override
  List<SftpEntry> list() {
    _throwIfNeeded();
    return const <SftpEntry>[
      SftpEntry(name: 'logs', metadata: 'folder', isDirectory: true),
    ];
  }

  @override
  void openFolder(String name) {
    _throwIfNeeded();
    _path = '$_path/$name';
  }

  @override
  String get path => _path;

  @override
  SftpPreviewState get previewState => _previewState;

  @override
  void setPreviewState(SftpPreviewState state) {
    _throwIfNeeded();
    _previewState = state;
  }
}

final class _SettingsRepository implements SettingsRepository {
  TerminalPreferences preferences = const TerminalPreferences();
  RepositoryFailure? failure;

  void _throwIfNeeded() {
    if (failure case final failure?) throw failure;
  }

  @override
  TerminalPreferences load() {
    _throwIfNeeded();
    return preferences;
  }

  @override
  void save(TerminalPreferences preferences) {
    _throwIfNeeded();
    this.preferences = preferences;
  }
}
