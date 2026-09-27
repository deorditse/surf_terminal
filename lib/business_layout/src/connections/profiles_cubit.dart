import 'package:bloc/bloc.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'profiles_state.dart';

final class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit(this._repository, {this._idFactory = dateTimeIdFactory})
    : super(ProfilesState()) {
    load();
  }

  final ProfilesRepository _repository;
  final IdFactory _idFactory;

  void load() {
    emit(ProfilesState(profiles: state.profiles));
    try {
      emit(
        ProfilesState(
          status: ProfilesStatus.success,
          profiles: _repository.getAll(),
        ),
      );
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  SshProfile createProfile({
    required String name,
    required String host,
    required int port,
    required String username,
    required String label,
    required bool sendUtf8Locale,
    required bool jumpHostEnabled,
    required bool proxyEnabled,
  }) => SshProfile(
    id: _idFactory('profile'),
    name: name,
    host: host,
    port: port,
    username: username,
    label: label,
    sendUtf8Locale: sendUtf8Locale,
    jumpHostEnabled: jumpHostEnabled,
    proxyEnabled: proxyEnabled,
  );

  Future<void> saveProfile(SshProfile profile) async {
    try {
      _repository.save(profile);
      _emitCurrent();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      _repository.delete(id);
      _emitCurrent();
    } on Object catch (error) {
      _emitFailure(error);
    }
  }

  void _emitCurrent() => emit(
    ProfilesState(
      status: ProfilesStatus.success,
      profiles: _repository.getAll(),
    ),
  );

  void _emitFailure(Object error) => emit(
    ProfilesState(
      status: ProfilesStatus.failure,
      profiles: state.profiles,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
