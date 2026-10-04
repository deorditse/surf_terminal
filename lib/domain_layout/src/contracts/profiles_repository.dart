import '../entities/ssh_profile.dart';

abstract interface class ProfilesRepository {
  Future<List<SshProfile>> getAll();
  Future<void> save(SshProfile profile);
  Future<void> delete(String id);
}
