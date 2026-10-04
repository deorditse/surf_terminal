import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'profiles_event.freezed.dart';

@freezed
sealed class ProfilesEvent with _$ProfilesEvent {
  const factory ProfilesEvent.loadRequested() = ProfilesLoadRequested;
  const factory ProfilesEvent.profileSaved(SshProfile profile) = ProfileSaved;
  const factory ProfilesEvent.profileDeleted(String id) = ProfileDeleted;
}
