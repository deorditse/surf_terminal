import 'package:sqflite/sqflite.dart';

final class SshDatabase {
  SshDatabase({required DatabaseFactory factory, required String path})
    : // Public dependency names intentionally differ from private fields.
      // ignore: prefer_initializing_formals
      _factory = factory,
      // ignore: prefer_initializing_formals
      _path = path;

  static const schemaVersion = 1;
  final DatabaseFactory _factory;
  final String _path;
  Database? _database;

  Future<Database> open() async {
    final existing = _database;
    if (existing != null && existing.isOpen) return existing;
    final database = await _factory.openDatabase(
      _path,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        singleInstance: false,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _createSchema,
        onUpgrade: _upgradeSchema,
      ),
    );
    _database = database;
    return database;
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    if (database != null && database.isOpen) await database.close();
  }

  static Future<void> _createSchema(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE ssh_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        host TEXT NOT NULL,
        port INTEGER NOT NULL CHECK(port BETWEEN 1 AND 65535),
        username TEXT NOT NULL,
        label TEXT NOT NULL DEFAULT 'Personal',
        startup_snippet TEXT,
        send_utf8_locale INTEGER NOT NULL DEFAULT 1 CHECK(send_utf8_locale IN (0, 1)),
        jump_host_enabled INTEGER NOT NULL DEFAULT 0 CHECK(jump_host_enabled IN (0, 1)),
        proxy_enabled INTEGER NOT NULL DEFAULT 0 CHECK(proxy_enabled IN (0, 1)),
        credential_ref TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE known_hosts (
        host TEXT NOT NULL,
        port INTEGER NOT NULL CHECK(port BETWEEN 1 AND 65535),
        algorithm TEXT NOT NULL,
        fingerprint TEXT NOT NULL,
        first_seen_at TEXT NOT NULL,
        last_confirmed_at TEXT NOT NULL,
        PRIMARY KEY (host, port, algorithm)
      )
    ''');
    batch.execute('''
      CREATE TABLE credential_cleanup (
        credential_ref TEXT PRIMARY KEY,
        requested_at TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await batch.commit(noResult: true);
  }

  static Future<void> _upgradeSchema(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion != newVersion) {
      throw StateError('Unsupported SSH database migration.');
    }
  }
}
