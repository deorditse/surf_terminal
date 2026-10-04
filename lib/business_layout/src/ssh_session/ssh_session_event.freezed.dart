// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ssh_session_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SshSessionEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshSessionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SshSessionEvent()';
}


}

/// @nodoc
class $SshSessionEventCopyWith<$Res>  {
$SshSessionEventCopyWith(SshSessionEvent _, $Res Function(SshSessionEvent) __);
}


/// Adds pattern-matching-related methods to [SshSessionEvent].
extension SshSessionEventPatterns on SshSessionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SshConnectRequested value)?  connectRequested,TResult Function( SshHostKeyAccepted value)?  hostKeyAccepted,TResult Function( SshHostKeyReplaced value)?  hostKeyReplaced,TResult Function( SshHostKeyRejected value)?  hostKeyRejected,TResult Function( SshInputSent value)?  inputSent,TResult Function( SshResizeRequested value)?  resizeRequested,TResult Function( SshDisconnectRequested value)?  disconnectRequested,TResult Function( SshTransportLost value)?  transportLost,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SshConnectRequested() when connectRequested != null:
return connectRequested(_that);case SshHostKeyAccepted() when hostKeyAccepted != null:
return hostKeyAccepted(_that);case SshHostKeyReplaced() when hostKeyReplaced != null:
return hostKeyReplaced(_that);case SshHostKeyRejected() when hostKeyRejected != null:
return hostKeyRejected(_that);case SshInputSent() when inputSent != null:
return inputSent(_that);case SshResizeRequested() when resizeRequested != null:
return resizeRequested(_that);case SshDisconnectRequested() when disconnectRequested != null:
return disconnectRequested(_that);case SshTransportLost() when transportLost != null:
return transportLost(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SshConnectRequested value)  connectRequested,required TResult Function( SshHostKeyAccepted value)  hostKeyAccepted,required TResult Function( SshHostKeyReplaced value)  hostKeyReplaced,required TResult Function( SshHostKeyRejected value)  hostKeyRejected,required TResult Function( SshInputSent value)  inputSent,required TResult Function( SshResizeRequested value)  resizeRequested,required TResult Function( SshDisconnectRequested value)  disconnectRequested,required TResult Function( SshTransportLost value)  transportLost,}){
final _that = this;
switch (_that) {
case SshConnectRequested():
return connectRequested(_that);case SshHostKeyAccepted():
return hostKeyAccepted(_that);case SshHostKeyReplaced():
return hostKeyReplaced(_that);case SshHostKeyRejected():
return hostKeyRejected(_that);case SshInputSent():
return inputSent(_that);case SshResizeRequested():
return resizeRequested(_that);case SshDisconnectRequested():
return disconnectRequested(_that);case SshTransportLost():
return transportLost(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SshConnectRequested value)?  connectRequested,TResult? Function( SshHostKeyAccepted value)?  hostKeyAccepted,TResult? Function( SshHostKeyReplaced value)?  hostKeyReplaced,TResult? Function( SshHostKeyRejected value)?  hostKeyRejected,TResult? Function( SshInputSent value)?  inputSent,TResult? Function( SshResizeRequested value)?  resizeRequested,TResult? Function( SshDisconnectRequested value)?  disconnectRequested,TResult? Function( SshTransportLost value)?  transportLost,}){
final _that = this;
switch (_that) {
case SshConnectRequested() when connectRequested != null:
return connectRequested(_that);case SshHostKeyAccepted() when hostKeyAccepted != null:
return hostKeyAccepted(_that);case SshHostKeyReplaced() when hostKeyReplaced != null:
return hostKeyReplaced(_that);case SshHostKeyRejected() when hostKeyRejected != null:
return hostKeyRejected(_that);case SshInputSent() when inputSent != null:
return inputSent(_that);case SshResizeRequested() when resizeRequested != null:
return resizeRequested(_that);case SshDisconnectRequested() when disconnectRequested != null:
return disconnectRequested(_that);case SshTransportLost() when transportLost != null:
return transportLost(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SshProfile profile,  TerminalDimensions dimensions)?  connectRequested,TResult Function( String connectionId)?  hostKeyAccepted,TResult Function( String connectionId)?  hostKeyReplaced,TResult Function( String connectionId)?  hostKeyRejected,TResult Function( List<int> bytes)?  inputSent,TResult Function( TerminalDimensions dimensions)?  resizeRequested,TResult Function()?  disconnectRequested,TResult Function( String connectionId,  SshFailure failure)?  transportLost,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SshConnectRequested() when connectRequested != null:
return connectRequested(_that.profile,_that.dimensions);case SshHostKeyAccepted() when hostKeyAccepted != null:
return hostKeyAccepted(_that.connectionId);case SshHostKeyReplaced() when hostKeyReplaced != null:
return hostKeyReplaced(_that.connectionId);case SshHostKeyRejected() when hostKeyRejected != null:
return hostKeyRejected(_that.connectionId);case SshInputSent() when inputSent != null:
return inputSent(_that.bytes);case SshResizeRequested() when resizeRequested != null:
return resizeRequested(_that.dimensions);case SshDisconnectRequested() when disconnectRequested != null:
return disconnectRequested();case SshTransportLost() when transportLost != null:
return transportLost(_that.connectionId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SshProfile profile,  TerminalDimensions dimensions)  connectRequested,required TResult Function( String connectionId)  hostKeyAccepted,required TResult Function( String connectionId)  hostKeyReplaced,required TResult Function( String connectionId)  hostKeyRejected,required TResult Function( List<int> bytes)  inputSent,required TResult Function( TerminalDimensions dimensions)  resizeRequested,required TResult Function()  disconnectRequested,required TResult Function( String connectionId,  SshFailure failure)  transportLost,}) {final _that = this;
switch (_that) {
case SshConnectRequested():
return connectRequested(_that.profile,_that.dimensions);case SshHostKeyAccepted():
return hostKeyAccepted(_that.connectionId);case SshHostKeyReplaced():
return hostKeyReplaced(_that.connectionId);case SshHostKeyRejected():
return hostKeyRejected(_that.connectionId);case SshInputSent():
return inputSent(_that.bytes);case SshResizeRequested():
return resizeRequested(_that.dimensions);case SshDisconnectRequested():
return disconnectRequested();case SshTransportLost():
return transportLost(_that.connectionId,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SshProfile profile,  TerminalDimensions dimensions)?  connectRequested,TResult? Function( String connectionId)?  hostKeyAccepted,TResult? Function( String connectionId)?  hostKeyReplaced,TResult? Function( String connectionId)?  hostKeyRejected,TResult? Function( List<int> bytes)?  inputSent,TResult? Function( TerminalDimensions dimensions)?  resizeRequested,TResult? Function()?  disconnectRequested,TResult? Function( String connectionId,  SshFailure failure)?  transportLost,}) {final _that = this;
switch (_that) {
case SshConnectRequested() when connectRequested != null:
return connectRequested(_that.profile,_that.dimensions);case SshHostKeyAccepted() when hostKeyAccepted != null:
return hostKeyAccepted(_that.connectionId);case SshHostKeyReplaced() when hostKeyReplaced != null:
return hostKeyReplaced(_that.connectionId);case SshHostKeyRejected() when hostKeyRejected != null:
return hostKeyRejected(_that.connectionId);case SshInputSent() when inputSent != null:
return inputSent(_that.bytes);case SshResizeRequested() when resizeRequested != null:
return resizeRequested(_that.dimensions);case SshDisconnectRequested() when disconnectRequested != null:
return disconnectRequested();case SshTransportLost() when transportLost != null:
return transportLost(_that.connectionId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SshConnectRequested implements SshSessionEvent {
  const SshConnectRequested(this.profile, this.dimensions);
  

 final  SshProfile profile;
 final  TerminalDimensions dimensions;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshConnectRequestedCopyWith<SshConnectRequested> get copyWith => _$SshConnectRequestedCopyWithImpl<SshConnectRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshConnectRequested&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile,dimensions);
}

@override
String toString() {
    return 'SshSessionEvent.connectRequested(profile: $profile, dimensions: $dimensions)';
}


}

/// @nodoc
abstract mixin class $SshConnectRequestedCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshConnectRequestedCopyWith(SshConnectRequested value, $Res Function(SshConnectRequested) _then) = _$SshConnectRequestedCopyWithImpl;
@useResult
$Res call({
 SshProfile profile, TerminalDimensions dimensions
});




}
/// @nodoc
class _$SshConnectRequestedCopyWithImpl<$Res>
    implements $SshConnectRequestedCopyWith<$Res> {
  _$SshConnectRequestedCopyWithImpl(this._self, this._then);

  final SshConnectRequested _self;
  final $Res Function(SshConnectRequested) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? dimensions = null,}) {
  return _then(SshConnectRequested(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as TerminalDimensions,
  ));
}


}

/// @nodoc


class SshHostKeyAccepted implements SshSessionEvent {
  const SshHostKeyAccepted(this.connectionId);
  

 final  String connectionId;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshHostKeyAcceptedCopyWith<SshHostKeyAccepted> get copyWith => _$SshHostKeyAcceptedCopyWithImpl<SshHostKeyAccepted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshHostKeyAccepted&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId);
}

@override
String toString() {
    return 'SshSessionEvent.hostKeyAccepted(connectionId: $connectionId)';
}


}

/// @nodoc
abstract mixin class $SshHostKeyAcceptedCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshHostKeyAcceptedCopyWith(SshHostKeyAccepted value, $Res Function(SshHostKeyAccepted) _then) = _$SshHostKeyAcceptedCopyWithImpl;
@useResult
$Res call({
 String connectionId
});




}
/// @nodoc
class _$SshHostKeyAcceptedCopyWithImpl<$Res>
    implements $SshHostKeyAcceptedCopyWith<$Res> {
  _$SshHostKeyAcceptedCopyWithImpl(this._self, this._then);

  final SshHostKeyAccepted _self;
  final $Res Function(SshHostKeyAccepted) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connectionId = null,}) {
  return _then(SshHostKeyAccepted(
null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SshHostKeyReplaced implements SshSessionEvent {
  const SshHostKeyReplaced(this.connectionId);
  

 final  String connectionId;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshHostKeyReplacedCopyWith<SshHostKeyReplaced> get copyWith => _$SshHostKeyReplacedCopyWithImpl<SshHostKeyReplaced>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshHostKeyReplaced&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId);
}

@override
String toString() {
    return 'SshSessionEvent.hostKeyReplaced(connectionId: $connectionId)';
}


}

/// @nodoc
abstract mixin class $SshHostKeyReplacedCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshHostKeyReplacedCopyWith(SshHostKeyReplaced value, $Res Function(SshHostKeyReplaced) _then) = _$SshHostKeyReplacedCopyWithImpl;
@useResult
$Res call({
 String connectionId
});




}
/// @nodoc
class _$SshHostKeyReplacedCopyWithImpl<$Res>
    implements $SshHostKeyReplacedCopyWith<$Res> {
  _$SshHostKeyReplacedCopyWithImpl(this._self, this._then);

  final SshHostKeyReplaced _self;
  final $Res Function(SshHostKeyReplaced) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connectionId = null,}) {
  return _then(SshHostKeyReplaced(
null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SshHostKeyRejected implements SshSessionEvent {
  const SshHostKeyRejected(this.connectionId);
  

 final  String connectionId;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshHostKeyRejectedCopyWith<SshHostKeyRejected> get copyWith => _$SshHostKeyRejectedCopyWithImpl<SshHostKeyRejected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshHostKeyRejected&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId);
}

@override
String toString() {
    return 'SshSessionEvent.hostKeyRejected(connectionId: $connectionId)';
}


}

/// @nodoc
abstract mixin class $SshHostKeyRejectedCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshHostKeyRejectedCopyWith(SshHostKeyRejected value, $Res Function(SshHostKeyRejected) _then) = _$SshHostKeyRejectedCopyWithImpl;
@useResult
$Res call({
 String connectionId
});




}
/// @nodoc
class _$SshHostKeyRejectedCopyWithImpl<$Res>
    implements $SshHostKeyRejectedCopyWith<$Res> {
  _$SshHostKeyRejectedCopyWithImpl(this._self, this._then);

  final SshHostKeyRejected _self;
  final $Res Function(SshHostKeyRejected) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connectionId = null,}) {
  return _then(SshHostKeyRejected(
null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SshInputSent implements SshSessionEvent {
  const SshInputSent( List<int> bytes): _bytes = bytes;
  

 final  List<int> _bytes;
 List<int> get bytes {
  if (_bytes is EqualUnmodifiableListView) return _bytes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bytes);
}


/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshInputSentCopyWith<SshInputSent> get copyWith => _$SshInputSentCopyWithImpl<SshInputSent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshInputSent&&const DeepCollectionEquality().equals(other.bytes, _bytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_bytes));
}

@override
String toString() {
    return 'SshSessionEvent.inputSent(bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $SshInputSentCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshInputSentCopyWith(SshInputSent value, $Res Function(SshInputSent) _then) = _$SshInputSentCopyWithImpl;
@useResult
$Res call({
 List<int> bytes
});




}
/// @nodoc
class _$SshInputSentCopyWithImpl<$Res>
    implements $SshInputSentCopyWith<$Res> {
  _$SshInputSentCopyWithImpl(this._self, this._then);

  final SshInputSent _self;
  final $Res Function(SshInputSent) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bytes = null,}) {
  return _then(SshInputSent(
null == bytes ? _self._bytes : bytes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class SshResizeRequested implements SshSessionEvent {
  const SshResizeRequested(this.dimensions);
  

 final  TerminalDimensions dimensions;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshResizeRequestedCopyWith<SshResizeRequested> get copyWith => _$SshResizeRequestedCopyWithImpl<SshResizeRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshResizeRequested&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,dimensions);
}

@override
String toString() {
    return 'SshSessionEvent.resizeRequested(dimensions: $dimensions)';
}


}

/// @nodoc
abstract mixin class $SshResizeRequestedCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshResizeRequestedCopyWith(SshResizeRequested value, $Res Function(SshResizeRequested) _then) = _$SshResizeRequestedCopyWithImpl;
@useResult
$Res call({
 TerminalDimensions dimensions
});




}
/// @nodoc
class _$SshResizeRequestedCopyWithImpl<$Res>
    implements $SshResizeRequestedCopyWith<$Res> {
  _$SshResizeRequestedCopyWithImpl(this._self, this._then);

  final SshResizeRequested _self;
  final $Res Function(SshResizeRequested) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dimensions = null,}) {
  return _then(SshResizeRequested(
null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as TerminalDimensions,
  ));
}


}

/// @nodoc


class SshDisconnectRequested implements SshSessionEvent {
  const SshDisconnectRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshDisconnectRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SshSessionEvent.disconnectRequested()';
}


}




/// @nodoc


class SshTransportLost implements SshSessionEvent {
  const SshTransportLost(this.connectionId, this.failure);
  

 final  String connectionId;
 final  SshFailure failure;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshTransportLostCopyWith<SshTransportLost> get copyWith => _$SshTransportLostCopyWithImpl<SshTransportLost>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SshTransportLost&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,failure);
}

@override
String toString() {
    return 'SshSessionEvent.transportLost(connectionId: $connectionId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SshTransportLostCopyWith<$Res> implements $SshSessionEventCopyWith<$Res> {
  factory $SshTransportLostCopyWith(SshTransportLost value, $Res Function(SshTransportLost) _then) = _$SshTransportLostCopyWithImpl;
@useResult
$Res call({
 String connectionId, SshFailure failure
});




}
/// @nodoc
class _$SshTransportLostCopyWithImpl<$Res>
    implements $SshTransportLostCopyWith<$Res> {
  _$SshTransportLostCopyWithImpl(this._self, this._then);

  final SshTransportLost _self;
  final $Res Function(SshTransportLost) _then;

/// Create a copy of SshSessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? failure = null,}) {
  return _then(SshTransportLost(
null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as SshFailure,
  ));
}


}

// dart format on
