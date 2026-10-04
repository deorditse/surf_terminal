import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'snippets_event.dart';
import 'snippets_state.dart';

final class SnippetsBloc extends Bloc<SnippetsEvent, SnippetsState> {
  SnippetsBloc(this._repository, {this._idFactory = dateTimeIdFactory})
    : super(const SnippetsState.loading()) {
    on<SnippetsLoadRequested>(_onLoadRequested, transformer: sequential());
    on<SnippetsFilterChanged>(_onFilterChanged, transformer: sequential());
    on<SnippetSaved>(_onSnippetSaved, transformer: sequential());
    on<SnippetDeleted>(_onSnippetDeleted, transformer: sequential());
    add(const SnippetsEvent.loadRequested());
  }

  final SnippetsRepository _repository;
  final IdFactory _idFactory;

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

  Future<void> _onLoadRequested(
    SnippetsLoadRequested event,
    Emitter<SnippetsState> emit,
  ) async {
    emit(SnippetsState.loading(snippets: state.snippets, filter: state.filter));
    await _readCurrent(emit);
  }

  void _onFilterChanged(
    SnippetsFilterChanged event,
    Emitter<SnippetsState> emit,
  ) => emit(
    SnippetsState.success(snippets: state.snippets, filter: event.value),
  );

  Future<void> _onSnippetSaved(
    SnippetSaved event,
    Emitter<SnippetsState> emit,
  ) => _mutate(emit, () => _repository.save(event.snippet));

  Future<void> _onSnippetDeleted(
    SnippetDeleted event,
    Emitter<SnippetsState> emit,
  ) => _mutate(emit, () => _repository.delete(event.id));

  Future<void> _mutate(
    Emitter<SnippetsState> emit,
    void Function() operation,
  ) async {
    try {
      operation();
      await _readCurrent(emit);
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  Future<void> _readCurrent(Emitter<SnippetsState> emit) async {
    try {
      emit(
        SnippetsState.success(
          snippets: _repository.getAll(),
          filter: state.filter,
        ),
      );
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  void _emitFailure(Emitter<SnippetsState> emit, Object error) => emit(
    SnippetsState.failure(
      snippets: state.snippets,
      filter: state.filter,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
