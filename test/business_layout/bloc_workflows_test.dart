import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

void main() {
  test(
    'profiles workflow handles explicit load and save events in order',
    () async {
      final repository = _ProfilesRepository();
      final bloc = ProfilesBloc(
        repository,
        idFactory: (prefix) => '$prefix-fixed',
      );
      addTearDown(bloc.close);

      await bloc.stream.firstWhere(
        (state) => state.status == ProfilesStatus.success,
      );
      final profile = bloc.createProfile(
        name: 'Server',
        host: 'server.example',
        port: 22,
        username: 'user',
        label: 'Lab',
        sendUtf8Locale: true,
        jumpHostEnabled: false,
        proxyEnabled: false,
      );
      final saved = bloc.stream.firstWhere(
        (state) => state.profiles.isNotEmpty,
      );
      bloc.add(ProfilesEvent.profileSaved(profile));

      await saved;
      expect(bloc.state.profiles.single.id, 'profile-fixed');
    },
  );

  test('snippets workflow handles filter events', () async {
    final bloc = SnippetsBloc(_SnippetsRepository());
    addTearDown(bloc.close);

    await bloc.stream.firstWhere(
      (state) => state.status == SnippetsStatus.success,
    );
    final filtered = bloc.stream.firstWhere((state) => state.filter == 'ops');
    bloc.add(const SnippetsEvent.filterChanged('ops'));

    await filtered;
    expect(bloc.state.filter, 'ops');
  });

  test('terminal sessions workflow handles open and close events', () async {
    final bloc = TerminalSessionsBloc(idFactory: (prefix) => '$prefix-fixed');
    addTearDown(bloc.close);
    final session = bloc.createSession('Server');

    final opened = bloc.stream.firstWhere((state) => state.sessions.isNotEmpty);
    bloc.add(TerminalSessionsEvent.sessionOpened(session));
    await opened;
    final closed = bloc.stream.firstWhere((state) => state.sessions.isEmpty);
    bloc.add(TerminalSessionsEvent.sessionClosed(session.id));

    await closed;
    expect(bloc.state.activeSessionId, isNull);
  });

  test(
    'settings workflow bounds values from explicit preference events',
    () async {
      final bloc = SettingsBloc(_SettingsRepository());
      addTearDown(bloc.close);

      await bloc.stream.firstWhere(
        (state) => state.status == SettingsStatus.success,
      );
      final updated = bloc.stream.firstWhere(
        (state) => state.preferences.fontSize == SettingsBloc.maxFontSize,
      );
      bloc.add(const SettingsEvent.fontSizeChanged(1000));

      await updated;
      expect(bloc.state.preferences.fontSize, SettingsBloc.maxFontSize);
    },
  );
}

final class _ProfilesRepository implements ProfilesRepository {
  final List<SshProfile> _profiles = <SshProfile>[];

  @override
  Future<void> delete(String id) async =>
      _profiles.removeWhere((profile) => profile.id == id);

  @override
  Future<List<SshProfile>> getAll() async => List<SshProfile>.of(_profiles);

  @override
  Future<void> save(SshProfile profile) async => _profiles.add(profile);
}

final class _SnippetsRepository implements SnippetsRepository {
  @override
  void delete(String id) {}

  @override
  List<CommandSnippet> getAll() => const <CommandSnippet>[];

  @override
  void save(CommandSnippet snippet) {}
}

final class _SettingsRepository implements SettingsRepository {
  TerminalPreferences preferences = const TerminalPreferences();

  @override
  TerminalPreferences load() => preferences;

  @override
  void save(TerminalPreferences preferences) {
    this.preferences = preferences;
  }
}
