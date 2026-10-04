import '../entities/known_host.dart';

abstract interface class KnownHostsRepository {
  Future<KnownHostRecord?> find(HostEndpoint endpoint, String algorithm);

  Future<void> save(KnownHostRecord record);

  Future<void> delete(HostEndpoint endpoint, String algorithm);
}
