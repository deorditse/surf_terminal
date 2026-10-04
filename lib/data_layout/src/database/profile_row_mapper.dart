import 'package:surf_terminal/domain_layout/domain_layout.dart';

Map<String, Object?> profileToRow(SshProfile profile, DateTime now) {
  final createdAt = profile.createdAt ?? now;
  final updatedAt = profile.updatedAt ?? now;
  return <String, Object?>{
    'id': profile.id,
    'name': profile.name,
    'host': profile.host,
    'port': profile.port,
    'username': profile.username,
    'label': profile.label,
    'startup_snippet': profile.startupSnippet,
    'send_utf8_locale': profile.sendUtf8Locale ? 1 : 0,
    'jump_host_enabled': profile.jumpHostEnabled ? 1 : 0,
    'proxy_enabled': profile.proxyEnabled ? 1 : 0,
    'credential_ref': profile.credentialReference?.value,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
}

SshProfile profileFromRow(Map<String, Object?> row) => SshProfile(
  id: row['id']! as String,
  name: row['name']! as String,
  host: row['host']! as String,
  port: row['port']! as int,
  username: row['username']! as String,
  label: row['label']! as String,
  startupSnippet: row['startup_snippet'] as String?,
  sendUtf8Locale: row['send_utf8_locale'] == 1,
  jumpHostEnabled: row['jump_host_enabled'] == 1,
  proxyEnabled: row['proxy_enabled'] == 1,
  credentialReference: switch (row['credential_ref']) {
    final String value => CredentialReference(value),
    _ => null,
  },
  createdAt: DateTime.parse(row['created_at']! as String),
  updatedAt: DateTime.parse(row['updated_at']! as String),
);
