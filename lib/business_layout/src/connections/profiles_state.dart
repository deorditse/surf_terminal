import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'profiles_state.freezed.dart';

enum ProfilesStatus { loading, success, failure }

@freezed
sealed class ProfilesState with _$ProfilesState {
  const ProfilesState._();

  const factory ProfilesState.loading({
    @Default(<SshProfile>[]) List<SshProfile> profiles,
    String? errorMessage,
  }) = ProfilesLoading;

  const factory ProfilesState.success({
    required List<SshProfile> profiles,
    String? errorMessage,
  }) = ProfilesSuccess;

  const factory ProfilesState.failure({
    required List<SshProfile> profiles,
    required String errorMessage,
  }) = ProfilesFailure;

  ProfilesStatus get status => switch (this) {
    ProfilesLoading() => ProfilesStatus.loading,
    ProfilesSuccess() => ProfilesStatus.success,
    ProfilesFailure() => ProfilesStatus.failure,
  };
}
