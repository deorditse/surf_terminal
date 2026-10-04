import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'ssh_session_state.freezed.dart';

@freezed
sealed class SshSessionState with _$SshSessionState {
  const factory SshSessionState.disconnected({SshProfile? profile}) =
      SshSessionDisconnected;
  const factory SshSessionState.connecting({
    required String connectionId,
    required SshProfile profile,
  }) = SshSessionConnecting;
  const factory SshSessionState.verifying({
    required String connectionId,
    required SshProfile profile,
    required HostKeyChallenge challenge,
  }) = SshSessionVerifying;
  const factory SshSessionState.authenticating({
    required String connectionId,
    required SshProfile profile,
  }) = SshSessionAuthenticating;
  const factory SshSessionState.connected({
    required String connectionId,
    required SshProfile profile,
  }) = SshSessionConnected;
  const factory SshSessionState.reconnecting({
    required String connectionId,
    required SshProfile profile,
    required int attempt,
    required Duration delay,
  }) = SshSessionReconnecting;
  const factory SshSessionState.failed({
    required String connectionId,
    required SshProfile profile,
    required SshFailure failure,
  }) = SshSessionFailed;
}
