import 'package:bloc/bloc.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'sftp_state.dart';

final class SftpCubit extends Cubit<SftpState> {
  SftpCubit(this._repository) : super(SftpState()) {
    refresh();
  }

  final SftpRepository _repository;

  Future<void> refresh() async {
    try {
      emit(
        SftpState(
          previewState: _repository.previewState,
          path: _repository.path,
          entries: _repository.list(),
        ),
      );
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> setPreviewState(SftpPreviewState value) async {
    try {
      _repository.setPreviewState(value);
      await refresh();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> openFolder(String name) async {
    try {
      _repository.openFolder(name);
      await refresh();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> openFixtureFolder(String name) => openFolder(name);

  Future<void> goToParent() async {
    try {
      _repository.goToParent();
      await refresh();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> goToParentFixtureFolder() => goToParent();

  void _emitFailure(Object error) => emit(
    SftpState(
      previewState: SftpPreviewState.error,
      path: state.path,
      entries: state.entries,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
