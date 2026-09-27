enum SftpPreviewState { empty, loading, data, error }

final class SftpEntry {
  const SftpEntry({
    required this.name,
    required this.metadata,
    required this.isDirectory,
  });

  final String name;
  final String metadata;
  final bool isDirectory;
}
