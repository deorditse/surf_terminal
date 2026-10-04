// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ssh_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SshSessionState {

 SshProfile? get profile;
/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionStateCopyWith<SshSessionState> get copyWith => _$SshSessionStateCopyWithImpl<SshSessionState>(this as SshSessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SshSessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionState&&(identical(other.profile, _this.profile) || other.profile == _this.profile));
}


@override
int get hashCode {
  final _this = this as SshSessionState;
  return Object.hash(runtimeType,_this.profile);
}

@override
String toString() {
  final _this = this as SshSessionState;
  return 'SshSessionState(profile: ${_this.profile})';
}


}

/// @nodoc
abstract mixin class $SshSessionStateCopyWith<$Res>  {
  factory $SshSessionStateCopyWith(SshSessionState value, $Res Function(SshSessionState) _then) = _$SshSessionStateCopyWithImpl;
@useResult
$Res call({
 SshProfile profile
});




}
/// @nodoc
class _$SshSessionStateCopyWithImpl<$Res>
    implements $SshSessionStateCopyWith<$Res> {
  _$SshSessionStateCopyWithImpl(this._self, this._then);

  final SshSessionState _self;
  final $Res Function(SshSessionState) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,}) {
  return _then(_self.copyWith(
profile: null == profile ? _self.profile! : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,
  ));
}

}


/// Adds pattern-matching-related methods to [SshSessionState].
extension SshSessionStatePatterns on SshSessionState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SshSessionDisconnected value)?  disconnected,TResult Function( SshSessionConnecting value)?  connecting,TResult Function( SshSessionVerifying value)?  verifying,TResult Function( SshSessionAuthenticating value)?  authenticating,TResult Function( SshSessionConnected value)?  connected,TResult Function( SshSessionReconnecting value)?  reconnecting,TResult Function( SshSessionFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SshSessionDisconnected() when disconnected != null:
return disconnected(_that);case SshSessionConnecting() when connecting != null:
return connecting(_that);case SshSessionVerifying() when verifying != null:
return verifying(_that);case SshSessionAuthenticating() when authenticating != null:
return authenticating(_that);case SshSessionConnected() when connected != null:
return connected(_that);case SshSessionReconnecting() when reconnecting != null:
return reconnecting(_that);case SshSessionFailed() when failed != null:
return failed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SshSessionDisconnected value)  disconnected,required TResult Function( SshSessionConnecting value)  connecting,required TResult Function( SshSessionVerifying value)  verifying,required TResult Function( SshSessionAuthenticating value)  authenticating,required TResult Function( SshSessionConnected value)  connected,required TResult Function( SshSessionReconnecting value)  reconnecting,required TResult Function( SshSessionFailed value)  failed,}){
final _that = this;
switch (_that) {
case SshSessionDisconnected():
return disconnected(_that);case SshSessionConnecting():
return connecting(_that);case SshSessionVerifying():
return verifying(_that);case SshSessionAuthenticating():
return authenticating(_that);case SshSessionConnected():
return connected(_that);case SshSessionReconnecting():
return reconnecting(_that);case SshSessionFailed():
return failed(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SshSessionDisconnected value)?  disconnected,TResult? Function( SshSessionConnecting value)?  connecting,TResult? Function( SshSessionVerifying value)?  verifying,TResult? Function( SshSessionAuthenticating value)?  authenticating,TResult? Function( SshSessionConnected value)?  connected,TResult? Function( SshSessionReconnecting value)?  reconnecting,TResult? Function( SshSessionFailed value)?  failed,}){
final _that = this;
switch (_that) {
case SshSessionDisconnected() when disconnected != null:
return disconnected(_that);case SshSessionConnecting() when connecting != null:
return connecting(_that);case SshSessionVerifying() when verifying != null:
return verifying(_that);case SshSessionAuthenticating() when authenticating != null:
return authenticating(_that);case SshSessionConnected() when connected != null:
return connected(_that);case SshSessionReconnecting() when reconnecting != null:
return reconnecting(_that);case SshSessionFailed() when failed != null:
return failed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SshProfile? profile)?  disconnected,TResult Function( String connectionId,  SshProfile profile)?  connecting,TResult Function( String connectionId,  SshProfile profile,  HostKeyChallenge challenge)?  verifying,TResult Function( String connectionId,  SshProfile profile)?  authenticating,TResult Function( String connectionId,  SshProfile profile)?  connected,TResult Function( String connectionId,  SshProfile profile,  int attempt,  Duration delay)?  reconnecting,TResult Function( String connectionId,  SshProfile profile,  SshFailure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SshSessionDisconnected() when disconnected != null:
return disconnected(_that.profile);case SshSessionConnecting() when connecting != null:
return connecting(_that.connectionId,_that.profile);case SshSessionVerifying() when verifying != null:
return verifying(_that.connectionId,_that.profile,_that.challenge);case SshSessionAuthenticating() when authenticating != null:
return authenticating(_that.connectionId,_that.profile);case SshSessionConnected() when connected != null:
return connected(_that.connectionId,_that.profile);case SshSessionReconnecting() when reconnecting != null:
return reconnecting(_that.connectionId,_that.profile,_that.attempt,_that.delay);case SshSessionFailed() when failed != null:
return failed(_that.connectionId,_that.profile,_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SshProfile? profile)  disconnected,required TResult Function( String connectionId,  SshProfile profile)  connecting,required TResult Function( String connectionId,  SshProfile profile,  HostKeyChallenge challenge)  verifying,required TResult Function( String connectionId,  SshProfile profile)  authenticating,required TResult Function( String connectionId,  SshProfile profile)  connected,required TResult Function( String connectionId,  SshProfile profile,  int attempt,  Duration delay)  reconnecting,required TResult Function( String connectionId,  SshProfile profile,  SshFailure failure)  failed,}) {final _that = this;
switch (_that) {
case SshSessionDisconnected():
return disconnected(_that.profile);case SshSessionConnecting():
return connecting(_that.connectionId,_that.profile);case SshSessionVerifying():
return verifying(_that.connectionId,_that.profile,_that.challenge);case SshSessionAuthenticating():
return authenticating(_that.connectionId,_that.profile);case SshSessionConnected():
return connected(_that.connectionId,_that.profile);case SshSessionReconnecting():
return reconnecting(_that.connectionId,_that.profile,_that.attempt,_that.delay);case SshSessionFailed():
return failed(_that.connectionId,_that.profile,_that.failure);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SshProfile? profile)?  disconnected,TResult? Function( String connectionId,  SshProfile profile)?  connecting,TResult? Function( String connectionId,  SshProfile profile,  HostKeyChallenge challenge)?  verifying,TResult? Function( String connectionId,  SshProfile profile)?  authenticating,TResult? Function( String connectionId,  SshProfile profile)?  connected,TResult? Function( String connectionId,  SshProfile profile,  int attempt,  Duration delay)?  reconnecting,TResult? Function( String connectionId,  SshProfile profile,  SshFailure failure)?  failed,}) {final _that = this;
switch (_that) {
case SshSessionDisconnected() when disconnected != null:
return disconnected(_that.profile);case SshSessionConnecting() when connecting != null:
return connecting(_that.connectionId,_that.profile);case SshSessionVerifying() when verifying != null:
return verifying(_that.connectionId,_that.profile,_that.challenge);case SshSessionAuthenticating() when authenticating != null:
return authenticating(_that.connectionId,_that.profile);case SshSessionConnected() when connected != null:
return connected(_that.connectionId,_that.profile);case SshSessionReconnecting() when reconnecting != null:
return reconnecting(_that.connectionId,_that.profile,_that.attempt,_that.delay);case SshSessionFailed() when failed != null:
return failed(_that.connectionId,_that.profile,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SshSessionDisconnected implements SshSessionState {
  const SshSessionDisconnected({this.profile});
  

@override final  SshProfile? profile;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionDisconnectedCopyWith<SshSessionDisconnected> get copyWith => _$SshSessionDisconnectedCopyWithImpl<SshSessionDisconnected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionDisconnected&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile);
}

@override
String toString() {
    return 'SshSessionState.disconnected(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SshSessionDisconnectedCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionDisconnectedCopyWith(SshSessionDisconnected value, $Res Function(SshSessionDisconnected) _then) = _$SshSessionDisconnectedCopyWithImpl;
@override @useResult
$Res call({
 SshProfile? profile
});




}
/// @nodoc
class _$SshSessionDisconnectedCopyWithImpl<$Res>
    implements $SshSessionDisconnectedCopyWith<$Res> {
  _$SshSessionDisconnectedCopyWithImpl(this._self, this._then);

  final SshSessionDisconnected _self;
  final $Res Function(SshSessionDisconnected) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,}) {
  return _then(SshSessionDisconnected(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile?,
  ));
}


}

/// @nodoc


class SshSessionConnecting implements SshSessionState {
  const SshSessionConnecting({required this.connectionId, required this.profile});
  

 final  String connectionId;
@override final  SshProfile profile;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionConnectingCopyWith<SshSessionConnecting> get copyWith => _$SshSessionConnectingCopyWithImpl<SshSessionConnecting>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionConnecting&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile);
}

@override
String toString() {
    return 'SshSessionState.connecting(connectionId: $connectionId, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SshSessionConnectingCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionConnectingCopyWith(SshSessionConnecting value, $Res Function(SshSessionConnecting) _then) = _$SshSessionConnectingCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile
});




}
/// @nodoc
class _$SshSessionConnectingCopyWithImpl<$Res>
    implements $SshSessionConnectingCopyWith<$Res> {
  _$SshSessionConnectingCopyWithImpl(this._self, this._then);

  final SshSessionConnecting _self;
  final $Res Function(SshSessionConnecting) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,}) {
  return _then(SshSessionConnecting(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,
  ));
}


}

/// @nodoc


class SshSessionVerifying implements SshSessionState {
  const SshSessionVerifying({required this.connectionId, required this.profile, required this.challenge});
  

 final  String connectionId;
@override final  SshProfile profile;
 final  HostKeyChallenge challenge;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionVerifyingCopyWith<SshSessionVerifying> get copyWith => _$SshSessionVerifyingCopyWithImpl<SshSessionVerifying>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionVerifying&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile,challenge);
}

@override
String toString() {
    return 'SshSessionState.verifying(connectionId: $connectionId, profile: $profile, challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class $SshSessionVerifyingCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionVerifyingCopyWith(SshSessionVerifying value, $Res Function(SshSessionVerifying) _then) = _$SshSessionVerifyingCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile, HostKeyChallenge challenge
});




}
/// @nodoc
class _$SshSessionVerifyingCopyWithImpl<$Res>
    implements $SshSessionVerifyingCopyWith<$Res> {
  _$SshSessionVerifyingCopyWithImpl(this._self, this._then);

  final SshSessionVerifying _self;
  final $Res Function(SshSessionVerifying) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,Object? challenge = null,}) {
  return _then(SshSessionVerifying(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as HostKeyChallenge,
  ));
}


}

/// @nodoc


class SshSessionAuthenticating implements SshSessionState {
  const SshSessionAuthenticating({required this.connectionId, required this.profile});
  

 final  String connectionId;
@override final  SshProfile profile;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionAuthenticatingCopyWith<SshSessionAuthenticating> get copyWith => _$SshSessionAuthenticatingCopyWithImpl<SshSessionAuthenticating>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionAuthenticating&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile);
}

@override
String toString() {
    return 'SshSessionState.authenticating(connectionId: $connectionId, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SshSessionAuthenticatingCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionAuthenticatingCopyWith(SshSessionAuthenticating value, $Res Function(SshSessionAuthenticating) _then) = _$SshSessionAuthenticatingCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile
});




}
/// @nodoc
class _$SshSessionAuthenticatingCopyWithImpl<$Res>
    implements $SshSessionAuthenticatingCopyWith<$Res> {
  _$SshSessionAuthenticatingCopyWithImpl(this._self, this._then);

  final SshSessionAuthenticating _self;
  final $Res Function(SshSessionAuthenticating) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,}) {
  return _then(SshSessionAuthenticating(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,
  ));
}


}

/// @nodoc


class SshSessionConnected implements SshSessionState {
  const SshSessionConnected({required this.connectionId, required this.profile});
  

 final  String connectionId;
@override final  SshProfile profile;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionConnectedCopyWith<SshSessionConnected> get copyWith => _$SshSessionConnectedCopyWithImpl<SshSessionConnected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionConnected&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile);
}

@override
String toString() {
    return 'SshSessionState.connected(connectionId: $connectionId, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SshSessionConnectedCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionConnectedCopyWith(SshSessionConnected value, $Res Function(SshSessionConnected) _then) = _$SshSessionConnectedCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile
});




}
/// @nodoc
class _$SshSessionConnectedCopyWithImpl<$Res>
    implements $SshSessionConnectedCopyWith<$Res> {
  _$SshSessionConnectedCopyWithImpl(this._self, this._then);

  final SshSessionConnected _self;
  final $Res Function(SshSessionConnected) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,}) {
  return _then(SshSessionConnected(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,
  ));
}


}

/// @nodoc


class SshSessionReconnecting implements SshSessionState {
  const SshSessionReconnecting({required this.connectionId, required this.profile, required this.attempt, required this.delay});
  

 final  String connectionId;
@override final  SshProfile profile;
 final  int attempt;
 final  Duration delay;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionReconnectingCopyWith<SshSessionReconnecting> get copyWith => _$SshSessionReconnectingCopyWithImpl<SshSessionReconnecting>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionReconnecting&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.delay, delay) || other.delay == delay));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile,attempt,delay);
}

@override
String toString() {
    return 'SshSessionState.reconnecting(connectionId: $connectionId, profile: $profile, attempt: $attempt, delay: $delay)';
}


}

/// @nodoc
abstract mixin class $SshSessionReconnectingCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionReconnectingCopyWith(SshSessionReconnecting value, $Res Function(SshSessionReconnecting) _then) = _$SshSessionReconnectingCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile, int attempt, Duration delay
});




}
/// @nodoc
class _$SshSessionReconnectingCopyWithImpl<$Res>
    implements $SshSessionReconnectingCopyWith<$Res> {
  _$SshSessionReconnectingCopyWithImpl(this._self, this._then);

  final SshSessionReconnecting _self;
  final $Res Function(SshSessionReconnecting) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,Object? attempt = null,Object? delay = null,}) {
  return _then(SshSessionReconnecting(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,delay: null == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class SshSessionFailed implements SshSessionState {
  const SshSessionFailed({required this.connectionId, required this.profile, required this.failure});
  

 final  String connectionId;
@override final  SshProfile profile;
 final  SshFailure failure;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshSessionFailedCopyWith<SshSessionFailed> get copyWith => _$SshSessionFailedCopyWithImpl<SshSessionFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionFailed&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,profile,failure);
}

@override
String toString() {
    return 'SshSessionState.failed(connectionId: $connectionId, profile: $profile, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SshSessionFailedCopyWith<$Res> implements $SshSessionStateCopyWith<$Res> {
  factory $SshSessionFailedCopyWith(SshSessionFailed value, $Res Function(SshSessionFailed) _then) = _$SshSessionFailedCopyWithImpl;
@override @useResult
$Res call({
 String connectionId, SshProfile profile, SshFailure failure
});




}
/// @nodoc
class _$SshSessionFailedCopyWithImpl<$Res>
    implements $SshSessionFailedCopyWith<$Res> {
  _$SshSessionFailedCopyWithImpl(this._self, this._then);

  final SshSessionFailed _self;
  final $Res Function(SshSessionFailed) _then;

/// Create a copy of SshSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? profile = null,Object? failure = null,}) {
  return _then(SshSessionFailed(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as SshFailure,
  ));
}


}

// dart format on
