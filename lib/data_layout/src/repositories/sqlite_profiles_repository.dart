import 'package:sqflite/sqflite.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../database/profile_row_mapper.dart';
import '../database/ssh_database.dart';

final class SqliteProfilesRepository implements ProfilesRepository {
  SqliteProfilesRepository({
    required SshDatabase database,
    SecureCredentialStore? credentialStore,
    DateTime Function()? now,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _database = database,
       // ignore: prefer_initializing_formals
       _credentialStore = credentialStore,
       _now = now ?? DateTime.now;

  final SshDatabase _database;
  final SecureCredentialStore? _credentialStore;
  final DateTime Function() _now;

  @override
  Future<List<SshProfile>> getAll() async {
    try {
      final rows = await (await _database.open()).query(
        'ssh_profiles',
        orderBy: 'name COLLATE NOCASE ASC, id ASC',
      );
      return rows.map(profileFromRow).toList(growable: false);
    } on RepositoryFailure {
      rethrow;
    } on Object {
      throw const RepositoryFailure(
        'profile_read',
        'Saved SSH profiles could not be read.',
      );
    }
  }

  @override
  Future<void> save(SshProfile profile) async {
    try {
      final db = await _database.open();
      await db.transaction((transaction) async {
        final existing = await transaction.query(
          'ssh_profiles',
          columns: <String>['created_at'],
          where: 'id = ?',
          whereArgs: <Object?>[profile.id],
          limit: 1,
        );
        final now = _now().toUtc();
        final row = profileToRow(profile, now);
        if (existing.isNotEmpty && profile.createdAt == null) {
          row['created_at'] = existing.single['created_at'];
        }
        if (profile.updatedAt == null) {
          row['updated_at'] = now.toIso8601String();
        }
        await transaction.insert(
          'ssh_profiles',
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } on Object {
      throw const RepositoryFailure(
        'profile_save',
        'The SSH profile could not be saved.',
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    String? credentialReference;
    try {
      final db = await _database.open();
      await db.transaction((transaction) async {
        final rows = await transaction.query(
          'ssh_profiles',
          columns: <String>['credential_ref'],
          where: 'id = ?',
          whereArgs: <Object?>[id],
          limit: 1,
        );
        credentialReference = rows.isEmpty
            ? null
            : rows.single['credential_ref'] as String?;
        if (credentialReference != null) {
          await transaction.insert('credential_cleanup', <String, Object?>{
            'credential_ref': credentialReference,
            'requested_at': _now().toUtc().toIso8601String(),
            'attempt_count': 0,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        await transaction.delete(
          'ssh_profiles',
          where: 'id = ?',
          whereArgs: <Object?>[id],
        );
      });
    } on Object {
      throw const RepositoryFailure(
        'profile_delete',
        'The SSH profile could not be deleted.',
      );
    }
    if (credentialReference != null) {
      await _clean(CredentialReference(credentialReference!));
    }
  }

  Future<List<String>> pendingCredentialCleanup() async {
    final rows = await (await _database.open()).query(
      'credential_cleanup',
      columns: <String>['credential_ref'],
      orderBy: 'requested_at ASC',
    );
    return rows.map((row) => row['credential_ref']! as String).toList();
  }

  Future<void> retryPendingCredentialCleanup() async {
    for (final reference in await pendingCredentialCleanup()) {
      await _clean(CredentialReference(reference));
    }
  }

  Future<void> scheduleCredentialCleanup(CredentialReference reference) async {
    final db = await _database.open();
    await db.insert('credential_cleanup', <String, Object?>{
      'credential_ref': reference.value,
      'requested_at': _now().toUtc().toIso8601String(),
      'attempt_count': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> _clean(CredentialReference reference) async {
    final store = _credentialStore;
    if (store == null) {
      throw const RepositoryFailure(
        'credential_cleanup',
        'Secure credential cleanup must be retried.',
      );
    }
    try {
      await store.delete(reference);
      final db = await _database.open();
      await db.delete(
        'credential_cleanup',
        where: 'credential_ref = ?',
        whereArgs: <Object?>[reference.value],
      );
    } on Object {
      final db = await _database.open();
      await db.rawUpdate(
        'UPDATE credential_cleanup SET attempt_count = attempt_count + 1 '
        'WHERE credential_ref = ?',
        <Object?>[reference.value],
      );
      throw const RepositoryFailure(
        'credential_cleanup',
        'The profile was deleted, but secure credential cleanup must be retried.',
      );
    }
  }
}
