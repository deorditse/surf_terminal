import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class _ProfilesRepository implements ProfilesRepository {
  @override
  Future<List<SshProfile>> getAll() async => const <SshProfile>[];

  @override
  Future<void> save(SshProfile profile) async {}

  @override
  Future<void> delete(String id) async {}
}

final class _SnippetsRepository implements SnippetsRepository {
  @override
  List<CommandSnippet> getAll() => <CommandSnippet>[];

  @override
  void save(CommandSnippet snippet) {}

  @override
  void delete(String id) {}
}

final class _SettingsRepository implements SettingsRepository {
  @override
  TerminalPreferences load() => const TerminalPreferences();

  @override
  void save(TerminalPreferences preferences) {}
}

void main() {
  test('repository contracts expose domain-only profile operations', () async {
    final repository = _ProfilesRepository();

    expect(await repository.getAll(), isEmpty);
    await repository.save(
      const SshProfile(
        id: 'profile-1',
        name: 'Lab',
        host: 'lab.example.com',
        port: 22,
        username: 'developer',
      ),
    );
    await repository.delete('profile-1');
  });

  test('repository contracts expose domain-only snippet operations', () {
    final repository = _SnippetsRepository();

    expect(repository.getAll(), isEmpty);
    repository
      ..save(
        CommandSnippet(id: 'snippet-1', title: 'Status', command: 'status'),
      )
      ..delete('snippet-1');
  });

  test('settings contract loads and saves terminal preferences', () {
    final repository = _SettingsRepository();

    expect(repository.load().palette, TerminalPalette.midnight);
    repository.save(
      repository.load().copyWith(cursorStyle: TerminalCursorStyle.underline),
    );
  });
}
