import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class CredentialCoordinator {
  CredentialCoordinator({
    required ProfilesRepository profiles,
    required SecureCredentialStore credentials,
    required CredentialReferenceGenerator references,
    Future<void> Function(CredentialReference)? scheduleCleanup,
  }) : // Public dependency names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _profiles = profiles,
       // ignore: prefer_initializing_formals
       _credentials = credentials,
       // ignore: prefer_initializing_formals
       _references = references,
       _scheduleCleanup = scheduleCleanup ?? _noCleanup;

  final ProfilesRepository _profiles;
  final SecureCredentialStore _credentials;
  final CredentialReferenceGenerator _references;
  final Future<void> Function(CredentialReference) _scheduleCleanup;

  Future<PreparedCredential> prepareTransient(
    SshProfile profile,
    String secret,
  ) async {
    final reference = _references.create();
    await _credentials.write(reference, secret);
    return PreparedCredential(_withReference(profile, reference), reference);
  }

  Future<SshProfile> save({
    required SshProfile profile,
    required CredentialIntent intent,
    String? secret,
  }) async {
    switch (intent) {
      case PreserveCredential():
      case TransientCredential():
        await _profiles.save(profile);
        return profile;
      case StoreCredential():
        if (secret == null || secret.isEmpty) {
          throw const RepositoryFailure(
            'credential_empty',
            'Enter a password before enabling secure retention.',
          );
        }
        final oldReference = profile.credentialReference;
        final newReference = _references.create();
        await _credentials.write(newReference, secret);
        final updated = _withReference(profile, newReference);
        try {
          await _profiles.save(updated);
        } on Object {
          await _bestEffortDelete(newReference);
          rethrow;
        }
        if (oldReference != null) await _bestEffortDelete(oldReference);
        return updated;
      case RemoveCredential():
        final oldReference = profile.credentialReference;
        final updated = _withReference(profile, null);
        await _profiles.save(updated);
        if (oldReference != null) await _bestEffortDelete(oldReference);
        return updated;
    }
  }

  Future<void> cleanupTransient(CredentialReference reference) =>
      _bestEffortDelete(reference);

  Future<void> _bestEffortDelete(CredentialReference reference) async {
    try {
      await _credentials.delete(reference);
    } on Object {
      await _scheduleCleanup(reference);
    }
  }
}

Future<void> _noCleanup(CredentialReference reference) async {}

final class PreparedCredential {
  const PreparedCredential(this.profile, this.reference);
  final SshProfile profile;
  final CredentialReference reference;
}

SshProfile _withReference(SshProfile profile, CredentialReference? reference) =>
    SshProfile(
      id: profile.id,
      name: profile.name,
      host: profile.host,
      port: profile.port,
      username: profile.username,
      label: profile.label,
      startupSnippet: profile.startupSnippet,
      sendUtf8Locale: profile.sendUtf8Locale,
      jumpHostEnabled: profile.jumpHostEnabled,
      proxyEnabled: profile.proxyEnabled,
      credentialReference: reference,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
