sealed class CredentialIntent {
  const CredentialIntent();

  const factory CredentialIntent.preserve() = PreserveCredential;
  const factory CredentialIntent.store() = StoreCredential;
  const factory CredentialIntent.remove() = RemoveCredential;
  const factory CredentialIntent.transient() = TransientCredential;
}

final class PreserveCredential extends CredentialIntent {
  const PreserveCredential();
}

final class StoreCredential extends CredentialIntent {
  const StoreCredential();
}

final class RemoveCredential extends CredentialIntent {
  const RemoveCredential();
}

final class TransientCredential extends CredentialIntent {
  const TransientCredential();
}

final class CredentialReference {
  const CredentialReference(this.value) : assert(value != '');

  final String value;

  @override
  bool operator ==(Object other) =>
      other is CredentialReference && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'CredentialReference(<opaque>)';
}
