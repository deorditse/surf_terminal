import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'ssh_session_event.freezed.dart';

@freezed
sealed class SshSessionEvent with _$SshSessionEvent {
  const factory SshSessionEvent.connectRequested(
    SshProfile profile,
    TerminalDimensions dimensions,
  ) = SshConnectRequested;

  const factory SshSessionEvent.hostKeyAccepted(String connectionId) =
      SshHostKeyAccepted;
  const factory SshSessionEvent.hostKeyReplaced(String connectionId) =
      SshHostKeyReplaced;
  const factory SshSessionEvent.hostKeyRejected(String connectionId) =
      SshHostKeyRejected;
  const factory SshSessionEvent.inputSent(List<int> bytes) = SshInputSent;
  const factory SshSessionEvent.resizeRequested(TerminalDimensions dimensions) =
      SshResizeRequested;
  const factory SshSessionEvent.disconnectRequested() = SshDisconnectRequested;
  const factory SshSessionEvent.transportLost(
    String connectionId,
    SshFailure failure,
  ) = SshTransportLost;
}
