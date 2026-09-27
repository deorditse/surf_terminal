import '../entities/command_snippet.dart';

abstract interface class SnippetsRepository {
  List<CommandSnippet> getAll();
  void save(CommandSnippet snippet);
  void delete(String id);
}
