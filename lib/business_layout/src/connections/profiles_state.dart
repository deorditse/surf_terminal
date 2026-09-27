import 'package:surf_terminal/domain_layout/domain_layout.dart';

enum ProfilesStatus { loading, success, failure }

final class ProfilesState {
  ProfilesState({
    this.status = ProfilesStatus.loading,
    List<SshProfile> profiles = const <SshProfile>[],
    this.errorMessage,
  }) : profiles = List<SshProfile>.unmodifiable(profiles);

  final ProfilesStatus status;
  final List<SshProfile> profiles;
  final String? errorMessage;

  ProfilesState copyWith({
    ProfilesStatus? status,
    List<SshProfile>? profiles,
    String? errorMessage,
    bool clearError = false,
  }) => ProfilesState(
    status: status ?? this.status,
    profiles: profiles ?? this.profiles,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
