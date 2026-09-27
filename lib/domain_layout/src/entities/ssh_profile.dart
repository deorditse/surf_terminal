final class SshProfile {
  const SshProfile({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.label = 'Personal',
    this.startupSnippet,
    this.sendUtf8Locale = true,
    this.jumpHostEnabled = false,
    this.proxyEnabled = false,
  });

  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String label;
  final String? startupSnippet;
  final bool sendUtf8Locale;
  final bool jumpHostEnabled;
  final bool proxyEnabled;

  String get endpoint => '$username@$host:$port';

  SshProfile copyWith({
    String? name,
    String? host,
    int? port,
    String? username,
    String? label,
    String? startupSnippet,
    bool? sendUtf8Locale,
    bool? jumpHostEnabled,
    bool? proxyEnabled,
  }) => SshProfile(
    id: id,
    name: name ?? this.name,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    label: label ?? this.label,
    startupSnippet: startupSnippet ?? this.startupSnippet,
    sendUtf8Locale: sendUtf8Locale ?? this.sendUtf8Locale,
    jumpHostEnabled: jumpHostEnabled ?? this.jumpHostEnabled,
    proxyEnabled: proxyEnabled ?? this.proxyEnabled,
  );
}
