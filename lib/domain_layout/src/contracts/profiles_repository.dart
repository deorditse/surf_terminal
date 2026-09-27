import '../entities/ssh_profile.dart';

abstract interface class ProfilesRepository {
  List<SshProfile> getAll();
  void save(SshProfile profile);
  void delete(String id);
}
