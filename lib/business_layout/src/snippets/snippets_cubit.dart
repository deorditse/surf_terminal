import 'package:bloc/bloc.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'snippets_state.dart';

final class SnippetsCubit extends Cubit<SnippetsState> {
  SnippetsCubit(this._repository, {this._idFactory = dateTimeIdFactory})
    : super(SnippetsState()) {
    load();
  }

  final SnippetsRepository _repository;
  final IdFactory _idFactory;

  void load() {
    emit(SnippetsState(filter: state.filter, snippets: state.snippets));
    try {
      _emitCurrent();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  void setFilter(String value) => emit(
    state.copyWith(
      filter: value,
      status: SnippetsStatus.success,
      clearError: true,
    ),
  );

  CommandSnippet createSnippet({
    required String title,
    required String command,
    required String description,
    required List<String> labels,
  }) => CommandSnippet(
    id: _idFactory('snippet'),
    title: title,
    command: command,
    description: description,
    labels: labels,
  );

  Future<void> saveSnippet(CommandSnippet snippet) async {
    try {
      _repository.save(snippet);
      _emitCurrent();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> deleteSnippet(String id) async {
    try {
      _repository.delete(id);
      _emitCurrent();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  void _emitCurrent() => emit(
    SnippetsState(
      status: SnippetsStatus.success,
      snippets: _repository.getAll(),
      filter: state.filter,
    ),
  );

  void _emitFailure(Object error) => emit(
    SnippetsState(
      status: SnippetsStatus.failure,
      snippets: state.snippets,
      filter: state.filter,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
