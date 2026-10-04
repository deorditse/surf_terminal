// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_sessions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TerminalSessionsState {

 List<PreviewSession> get sessions; String? get activeSessionId;
/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionsStateCopyWith<TerminalSessionsState> get copyWith => _$TerminalSessionsStateCopyWithImpl<TerminalSessionsState>(this as TerminalSessionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TerminalSessionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionsState&&const DeepCollectionEquality().equals(other.sessions, _this.sessions)&&(identical(other.activeSessionId, _this.activeSessionId) || other.activeSessionId == _this.activeSessionId));
}


@override
int get hashCode {
  final _this = this as TerminalSessionsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sessions),_this.activeSessionId);
}

@override
String toString() {
  final _this = this as TerminalSessionsState;
  return 'TerminalSessionsState(sessions: ${_this.sessions}, activeSessionId: ${_this.activeSessionId})';
}


}

/// @nodoc
abstract mixin class $TerminalSessionsStateCopyWith<$Res>  {
  factory $TerminalSessionsStateCopyWith(TerminalSessionsState value, $Res Function(TerminalSessionsState) _then) = _$TerminalSessionsStateCopyWithImpl;
@useResult
$Res call({
 List<PreviewSession> sessions, String? activeSessionId
});




}
/// @nodoc
class _$TerminalSessionsStateCopyWithImpl<$Res>
    implements $TerminalSessionsStateCopyWith<$Res> {
  _$TerminalSessionsStateCopyWithImpl(this._self, this._then);

  final TerminalSessionsState _self;
  final $Res Function(TerminalSessionsState) _then;

/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? activeSessionId = freezed,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PreviewSession>,activeSessionId: freezed == activeSessionId ? _self.activeSessionId : activeSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TerminalSessionsState].
extension TerminalSessionsStatePatterns on TerminalSessionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TerminalSessionsInitial value)?  initial,TResult Function( TerminalSessionsReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TerminalSessionsInitial() when initial != null:
return initial(_that);case TerminalSessionsReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TerminalSessionsInitial value)  initial,required TResult Function( TerminalSessionsReady value)  ready,}){
final _that = this;
switch (_that) {
case TerminalSessionsInitial():
return initial(_that);case TerminalSessionsReady():
return ready(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TerminalSessionsInitial value)?  initial,TResult? Function( TerminalSessionsReady value)?  ready,}){
final _that = this;
switch (_that) {
case TerminalSessionsInitial() when initial != null:
return initial(_that);case TerminalSessionsReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<PreviewSession> sessions,  String? activeSessionId)?  initial,TResult Function( List<PreviewSession> sessions,  String? activeSessionId)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TerminalSessionsInitial() when initial != null:
return initial(_that.sessions,_that.activeSessionId);case TerminalSessionsReady() when ready != null:
return ready(_that.sessions,_that.activeSessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<PreviewSession> sessions,  String? activeSessionId)  initial,required TResult Function( List<PreviewSession> sessions,  String? activeSessionId)  ready,}) {final _that = this;
switch (_that) {
case TerminalSessionsInitial():
return initial(_that.sessions,_that.activeSessionId);case TerminalSessionsReady():
return ready(_that.sessions,_that.activeSessionId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<PreviewSession> sessions,  String? activeSessionId)?  initial,TResult? Function( List<PreviewSession> sessions,  String? activeSessionId)?  ready,}) {final _that = this;
switch (_that) {
case TerminalSessionsInitial() when initial != null:
return initial(_that.sessions,_that.activeSessionId);case TerminalSessionsReady() when ready != null:
return ready(_that.sessions,_that.activeSessionId);case _:
  return null;

}
}

}

/// @nodoc


class TerminalSessionsInitial extends TerminalSessionsState {
  const TerminalSessionsInitial({ List<PreviewSession> sessions = const <PreviewSession>[], this.activeSessionId}): _sessions = sessions,super._();
  

 final  List<PreviewSession> _sessions;
@override@JsonKey() List<PreviewSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override final  String? activeSessionId;

/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionsInitialCopyWith<TerminalSessionsInitial> get copyWith => _$TerminalSessionsInitialCopyWithImpl<TerminalSessionsInitial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionsInitial&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.activeSessionId, activeSessionId) || other.activeSessionId == activeSessionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),activeSessionId);
}

@override
String toString() {
    return 'TerminalSessionsState.initial(sessions: $sessions, activeSessionId: $activeSessionId)';
}


}

/// @nodoc
abstract mixin class $TerminalSessionsInitialCopyWith<$Res> implements $TerminalSessionsStateCopyWith<$Res> {
  factory $TerminalSessionsInitialCopyWith(TerminalSessionsInitial value, $Res Function(TerminalSessionsInitial) _then) = _$TerminalSessionsInitialCopyWithImpl;
@override @useResult
$Res call({
 List<PreviewSession> sessions, String? activeSessionId
});




}
/// @nodoc
class _$TerminalSessionsInitialCopyWithImpl<$Res>
    implements $TerminalSessionsInitialCopyWith<$Res> {
  _$TerminalSessionsInitialCopyWithImpl(this._self, this._then);

  final TerminalSessionsInitial _self;
  final $Res Function(TerminalSessionsInitial) _then;

/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? activeSessionId = freezed,}) {
  return _then(TerminalSessionsInitial(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PreviewSession>,activeSessionId: freezed == activeSessionId ? _self.activeSessionId : activeSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TerminalSessionsReady extends TerminalSessionsState {
  const TerminalSessionsReady({required  List<PreviewSession> sessions, this.activeSessionId}): _sessions = sessions,super._();
  

 final  List<PreviewSession> _sessions;
@override List<PreviewSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override final  String? activeSessionId;

/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionsReadyCopyWith<TerminalSessionsReady> get copyWith => _$TerminalSessionsReadyCopyWithImpl<TerminalSessionsReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionsReady&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.activeSessionId, activeSessionId) || other.activeSessionId == activeSessionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),activeSessionId);
}

@override
String toString() {
    return 'TerminalSessionsState.ready(sessions: $sessions, activeSessionId: $activeSessionId)';
}


}

/// @nodoc
abstract mixin class $TerminalSessionsReadyCopyWith<$Res> implements $TerminalSessionsStateCopyWith<$Res> {
  factory $TerminalSessionsReadyCopyWith(TerminalSessionsReady value, $Res Function(TerminalSessionsReady) _then) = _$TerminalSessionsReadyCopyWithImpl;
@override @useResult
$Res call({
 List<PreviewSession> sessions, String? activeSessionId
});




}
/// @nodoc
class _$TerminalSessionsReadyCopyWithImpl<$Res>
    implements $TerminalSessionsReadyCopyWith<$Res> {
  _$TerminalSessionsReadyCopyWithImpl(this._self, this._then);

  final TerminalSessionsReady _self;
  final $Res Function(TerminalSessionsReady) _then;

/// Create a copy of TerminalSessionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? activeSessionId = freezed,}) {
  return _then(TerminalSessionsReady(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PreviewSession>,activeSessionId: freezed == activeSessionId ? _self.activeSessionId : activeSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
