import 'package:sqflite/sqflite.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../database/ssh_database.dart';

final class SqliteKnownHostsRepository implements KnownHostsRepository {
  SqliteKnownHostsRepository({required SshDatabase database})
    : // Public dependency name intentionally differs from the private field.
      // ignore: prefer_initializing_formals
      _database = database;

  final SshDatabase _database;

  @override
  Future<KnownHostRecord?> find(HostEndpoint endpoint, String algorithm) async {
    try {
      final rows = await (await _database.open()).query(
        'known_hosts',
        where: 'host = ? AND port = ? AND algorithm = ?',
        whereArgs: <Object?>[endpoint.normalizedHost, endpoint.port, algorithm],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      final row = rows.single;
      return KnownHostRecord(
        endpoint: HostEndpoint(
          host: row['host']! as String,
          port: row['port']! as int,
        ),
        algorithm: row['algorithm']! as String,
        fingerprint: row['fingerprint']! as String,
        firstSeenAt: DateTime.parse(row['first_seen_at']! as String),
        lastConfirmedAt: DateTime.parse(row['last_confirmed_at']! as String),
      );
    } on Object {
      throw const RepositoryFailure(
        'known_host_read',
        'Trusted host information could not be read.',
      );
    }
  }

  @override
  Future<void> save(KnownHostRecord record) async {
    try {
      await (await _database.open()).insert('known_hosts', <String, Object?>{
        'host': record.endpoint.normalizedHost,
        'port': record.endpoint.port,
        'algorithm': record.algorithm,
        'fingerprint': record.fingerprint,
        'first_seen_at': record.firstSeenAt.toUtc().toIso8601String(),
        'last_confirmed_at': record.lastConfirmedAt.toUtc().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } on Object {
      throw const RepositoryFailure(
        'known_host_save',
        'Trusted host information could not be saved.',
      );
    }
  }

  @override
  Future<void> delete(HostEndpoint endpoint, String algorithm) async {
    try {
      await (await _database.open()).delete(
        'known_hosts',
        where: 'host = ? AND port = ? AND algorithm = ?',
        whereArgs: <Object?>[endpoint.normalizedHost, endpoint.port, algorithm],
      );
    } on Object {
      throw const RepositoryFailure(
        'known_host_delete',
        'Trusted host information could not be deleted.',
      );
    }
  }
}
