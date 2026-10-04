final class TerminalDimensions {
  const TerminalDimensions({required this.columns, required this.rows})
    : assert(columns > 0),
      assert(rows > 0);

  factory TerminalDimensions.validated({
    required int columns,
    required int rows,
  }) {
    if (columns <= 0 || rows <= 0) {
      throw ArgumentError('Terminal dimensions must be positive.');
    }
    return TerminalDimensions(columns: columns, rows: rows);
  }

  final int columns;
  final int rows;

  @override
  bool operator ==(Object other) =>
      other is TerminalDimensions &&
      other.columns == columns &&
      other.rows == rows;

  @override
  int get hashCode => Object.hash(columns, rows);
}

enum SshSessionLifecycle {
  disconnected,
  connecting,
  verifying,
  authenticating,
  connected,
  reconnecting,
  failed,
}
