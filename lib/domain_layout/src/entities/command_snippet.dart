final class CommandSnippet {
  CommandSnippet({
    required this.id,
    required this.title,
    required this.command,
    this.description = '',
    List<String> labels = const <String>[],
  }) : labels = List<String>.unmodifiable(labels);

  final String id;
  final String title;
  final String command;
  final String description;
  final List<String> labels;

  CommandSnippet copyWith({
    String? title,
    String? command,
    String? description,
    List<String>? labels,
  }) => CommandSnippet(
    id: id,
    title: title ?? this.title,
    command: command ?? this.command,
    description: description ?? this.description,
    labels: labels ?? this.labels,
  );
}
