import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class _ProfilesRepository implements ProfilesRepository {
  @override
  List<SshProfile> getAll() => const <SshProfile>[];

  @override
  void save(SshProfile profile) {}

  @override
  void delete(String id) {}
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

final class _SftpRepository implements SftpRepository {
  @override
  SftpPreviewState previewState = SftpPreviewState.empty;

  @override
  String path = '/';

  @override
  List<SftpEntry> list() => const <SftpEntry>[];

  @override
  void setPreviewState(SftpPreviewState state) => previewState = state;

  @override
  void openFolder(String name) => path = '/$name';

  @override
  void goToParent() => path = '/';
}

void main() {
  test('repository contracts expose domain-only profile operations', () {
    final repository = _ProfilesRepository();

    expect(repository.getAll(), isEmpty);
    repository
      ..save(
        const SshProfile(
          id: 'profile-1',
          name: 'Lab',
          host: 'lab.example.com',
          port: 22,
          username: 'developer',
        ),
      )
      ..delete('profile-1');
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

  test('SFTP contract supports preview state and navigation', () {
    final repository = _SftpRepository();

    repository
      ..setPreviewState(SftpPreviewState.loading)
      ..openFolder('logs');
    expect(repository.previewState, SftpPreviewState.loading);
    expect(repository.path, '/logs');
    expect(repository.list(), isEmpty);

    repository.goToParent();
    expect(repository.path, '/');
  });
}
