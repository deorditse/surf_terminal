import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

import '../common/business_helpers.dart';
import 'profiles_event.dart';
import 'profiles_state.dart';

final class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc(this._repository, {this._idFactory = dateTimeIdFactory})
    : super(const ProfilesState.loading()) {
    on<ProfilesLoadRequested>(_onLoadRequested, transformer: sequential());
    on<ProfileSaved>(_onProfileSaved, transformer: sequential());
    on<ProfileDeleted>(_onProfileDeleted, transformer: sequential());
    add(const ProfilesEvent.loadRequested());
  }

  final ProfilesRepository _repository;
  final IdFactory _idFactory;

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

  Future<void> _onLoadRequested(
    ProfilesLoadRequested event,
    Emitter<ProfilesState> emit,
  ) async {
    emit(ProfilesState.loading(profiles: state.profiles));
    await _readCurrent(emit);
  }

  Future<void> _onProfileSaved(
    ProfileSaved event,
    Emitter<ProfilesState> emit,
  ) => _mutate(emit, () => _repository.save(event.profile));

  Future<void> _onProfileDeleted(
    ProfileDeleted event,
    Emitter<ProfilesState> emit,
  ) => _mutate(emit, () => _repository.delete(event.id));

  Future<void> _mutate(
    Emitter<ProfilesState> emit,
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
      emit(ProfilesState.success(profiles: await _repository.getAll()));
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  Future<void> _readCurrent(Emitter<ProfilesState> emit) async {
    try {
      emit(ProfilesState.success(profiles: await _repository.getAll()));
    } on Object catch (error) {
      _emitFailure(emit, error);
    }
  }

  void _emitFailure(Emitter<ProfilesState> emit, Object error) => emit(
    ProfilesState.failure(
      profiles: state.profiles,
      errorMessage: repositoryErrorMessage(error),
    ),
  );
}
