import 'package:sqflite/sqflite.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/connect_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/credential_coordinator.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';

final class AppDependencies {
  AppDependencies({
    required this.profilesRepository,
    required this.snippetsRepository,
    required this.settingsRepository,
    SecureCredentialStore? credentialStore,
    KnownHostsRepository? knownHostsRepository,
    SshSessionFactory? sshSessionFactory,
    SshDatabase? database,
    Future<void> Function()? retryCredentialCleanup,
    Future<void> Function(CredentialReference)? scheduleCredentialCleanup,
  }) : // Public dependency name intentionally differs from the private field.
       // ignore: prefer_initializing_formals
       _database = database {
    _retryCredentialCleanup = retryCredentialCleanup ?? _noCleanup;
    final store = credentialStore ?? _MemoryCredentials();
    final hosts = knownHostsRepository ?? _MemoryKnownHosts();
    final factory = sshSessionFactory ?? _UnavailableSshFactory();
    this.credentialStore = store;
    this.knownHostsRepository = hosts;
    this.sshSessionFactory = factory;
    credentials = CredentialCoordinator(
      profiles: profilesRepository,
      credentials: store,
      references: CredentialReferenceGenerator(),
      scheduleCleanup: scheduleCredentialCleanup,
    );
    terminalRuntimes = TerminalRuntimeRegistry(
      factory: factory,
      knownHosts: hosts,
      credentials: store,
      cleanupTransient: credentials.cleanupTransient,
    );
    connect = ConnectCoordinator(
      credentials: credentials,
      runtimes: terminalRuntimes,
    );
  }

  factory AppDependencies.preview() {
    final credentials = _MemoryCredentials();
    final knownHosts = _MemoryKnownHosts();
    final factory = _UnavailableSshFactory();
    return AppDependencies(
      profilesRepository: InMemoryProfilesRepository(),
      snippetsRepository: InMemorySnippetsRepository(),
      settingsRepository: InMemorySettingsRepository(),
      credentialStore: credentials,
      knownHostsRepository: knownHosts,
      sshSessionFactory: factory,
    );
  }

  static Future<AppDependencies> production() async {
    final directory = await getDatabasesPath();
    final database = SshDatabase(
      factory: databaseFactory,
      path: '$directory/surf_terminal.db',
    );
    await database.open();
    final credentialStore = FlutterSecureCredentialStore.platform();
    final profiles = SqliteProfilesRepository(
      database: database,
      credentialStore: credentialStore,
    );
    final knownHosts = SqliteKnownHostsRepository(database: database);
    await profiles.retryPendingCredentialCleanup().catchError((_) {});
    final sshFactory = DartSshSessionFactory(credentialStore: credentialStore);
    return AppDependencies(
      profilesRepository: profiles,
      snippetsRepository: InMemorySnippetsRepository(),
      settingsRepository: InMemorySettingsRepository(),
      credentialStore: credentialStore,
      knownHostsRepository: knownHosts,
      sshSessionFactory: sshFactory,
      database: database,
      retryCredentialCleanup: profiles.retryPendingCredentialCleanup,
      scheduleCredentialCleanup: profiles.scheduleCredentialCleanup,
    );
  }

  final ProfilesRepository profilesRepository;
  final SnippetsRepository snippetsRepository;
  final SettingsRepository settingsRepository;
  late final SecureCredentialStore credentialStore;
  late final KnownHostsRepository knownHostsRepository;
  late final SshSessionFactory sshSessionFactory;
  late final CredentialCoordinator credentials;
  late final TerminalRuntimeRegistry terminalRuntimes;
  late final ConnectCoordinator connect;
  final SshDatabase? _database;
  late final Future<void> Function() _retryCredentialCleanup;
  Future<void>? _disposeFuture;

  Future<void> retryCredentialCleanup() => _retryCredentialCleanup();

  Future<void> dispose() => _disposeFuture ??= _dispose();

  Future<void> _dispose() async {
    await terminalRuntimes.dispose();
    await _database?.close();
  }
}

Future<void> _noCleanup() async {}

final class _MemoryCredentials implements SecureCredentialStore {
  final _values = <CredentialReference, String>{};
  @override
  Future<bool> contains(CredentialReference reference) async =>
      _values.containsKey(reference);
  @override
  Future<void> delete(CredentialReference reference) async {
    _values.remove(reference);
  }

  @override
  Future<String?> read(CredentialReference reference) async =>
      _values[reference];
  @override
  Future<void> write(CredentialReference reference, String secret) async {
    _values[reference] = secret;
  }
}

final class _MemoryKnownHosts implements KnownHostsRepository {
  final _values = <String, KnownHostRecord>{};
  String _key(HostEndpoint endpoint, String algorithm) =>
      '${endpoint.normalizedHost}:${endpoint.port}:$algorithm';
  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {
    _values.remove(_key(endpoint, algorithm));
  }

  @override
  Future<KnownHostRecord?> find(
    HostEndpoint endpoint,
    String algorithm,
  ) async => _values[_key(endpoint, algorithm)];
  @override
  Future<void> save(KnownHostRecord record) async {
    _values[_key(record.endpoint, record.algorithm)] = record;
  }
}

final class _UnavailableSshFactory implements SshSessionFactory {
  @override
  SshConnectionAttempt start(
    SshProfile profile,
    TerminalDimensions initialDimensions,
  ) => _UnavailableAttempt();
}

final class _UnavailableAttempt implements SshConnectionAttempt {
  static const failure = SshFailure.transport(
    message: 'SSH is unavailable in preview dependencies.',
  );
  @override
  Future<PresentedHostKey> get presentedHostKey => Future.error(failure);
  @override
  Future<SshSession> get session => Future.error(failure);
  @override
  Future<void> acceptHostKey() async {}
  @override
  Future<void> cancel() async {}
  @override
  Future<void> rejectHostKey() async {}
}
