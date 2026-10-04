part of '../business_layout_test.dart';

final class _ProfilesRepository implements ProfilesRepository {
  _ProfilesRepository([List<SshProfile> items = const <SshProfile>[]])
    : items = List<SshProfile>.of(items);

  final List<SshProfile> items;
  RepositoryFailure? failure;

  void _throwIfNeeded() {
    if (failure case final failure?) throw failure;
  }

  @override
  Future<void> delete(String id) async {
    _throwIfNeeded();
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<SshProfile>> getAll() async {
    _throwIfNeeded();
    return List<SshProfile>.of(items);
  }

  @override
  Future<void> save(SshProfile profile) async {
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
