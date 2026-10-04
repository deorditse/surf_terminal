// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_sessions_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TerminalSessionsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TerminalSessionsEvent()';
}


}

/// @nodoc
class $TerminalSessionsEventCopyWith<$Res>  {
$TerminalSessionsEventCopyWith(TerminalSessionsEvent _, $Res Function(TerminalSessionsEvent) __);
}


/// Adds pattern-matching-related methods to [TerminalSessionsEvent].
extension TerminalSessionsEventPatterns on TerminalSessionsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TerminalSessionOpened value)?  sessionOpened,TResult Function( TerminalSessionSelected value)?  sessionSelected,TResult Function( TerminalSessionClosed value)?  sessionClosed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TerminalSessionOpened() when sessionOpened != null:
return sessionOpened(_that);case TerminalSessionSelected() when sessionSelected != null:
return sessionSelected(_that);case TerminalSessionClosed() when sessionClosed != null:
return sessionClosed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TerminalSessionOpened value)  sessionOpened,required TResult Function( TerminalSessionSelected value)  sessionSelected,required TResult Function( TerminalSessionClosed value)  sessionClosed,}){
final _that = this;
switch (_that) {
case TerminalSessionOpened():
return sessionOpened(_that);case TerminalSessionSelected():
return sessionSelected(_that);case TerminalSessionClosed():
return sessionClosed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TerminalSessionOpened value)?  sessionOpened,TResult? Function( TerminalSessionSelected value)?  sessionSelected,TResult? Function( TerminalSessionClosed value)?  sessionClosed,}){
final _that = this;
switch (_that) {
case TerminalSessionOpened() when sessionOpened != null:
return sessionOpened(_that);case TerminalSessionSelected() when sessionSelected != null:
return sessionSelected(_that);case TerminalSessionClosed() when sessionClosed != null:
return sessionClosed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PreviewSession session)?  sessionOpened,TResult Function( String id)?  sessionSelected,TResult Function( String id)?  sessionClosed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TerminalSessionOpened() when sessionOpened != null:
return sessionOpened(_that.session);case TerminalSessionSelected() when sessionSelected != null:
return sessionSelected(_that.id);case TerminalSessionClosed() when sessionClosed != null:
return sessionClosed(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PreviewSession session)  sessionOpened,required TResult Function( String id)  sessionSelected,required TResult Function( String id)  sessionClosed,}) {final _that = this;
switch (_that) {
case TerminalSessionOpened():
return sessionOpened(_that.session);case TerminalSessionSelected():
return sessionSelected(_that.id);case TerminalSessionClosed():
return sessionClosed(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PreviewSession session)?  sessionOpened,TResult? Function( String id)?  sessionSelected,TResult? Function( String id)?  sessionClosed,}) {final _that = this;
switch (_that) {
case TerminalSessionOpened() when sessionOpened != null:
return sessionOpened(_that.session);case TerminalSessionSelected() when sessionSelected != null:
return sessionSelected(_that.id);case TerminalSessionClosed() when sessionClosed != null:
return sessionClosed(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class TerminalSessionOpened implements TerminalSessionsEvent {
  const TerminalSessionOpened(this.session);
  

 final  PreviewSession session;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionOpenedCopyWith<TerminalSessionOpened> get copyWith => _$TerminalSessionOpenedCopyWithImpl<TerminalSessionOpened>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionOpened&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session);
}

@override
String toString() {
    return 'TerminalSessionsEvent.sessionOpened(session: $session)';
}


}

/// @nodoc
abstract mixin class $TerminalSessionOpenedCopyWith<$Res> implements $TerminalSessionsEventCopyWith<$Res> {
  factory $TerminalSessionOpenedCopyWith(TerminalSessionOpened value, $Res Function(TerminalSessionOpened) _then) = _$TerminalSessionOpenedCopyWithImpl;
@useResult
$Res call({
 PreviewSession session
});




}
/// @nodoc
class _$TerminalSessionOpenedCopyWithImpl<$Res>
    implements $TerminalSessionOpenedCopyWith<$Res> {
  _$TerminalSessionOpenedCopyWithImpl(this._self, this._then);

  final TerminalSessionOpened _self;
  final $Res Function(TerminalSessionOpened) _then;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(TerminalSessionOpened(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PreviewSession,
  ));
}


}

/// @nodoc


class TerminalSessionSelected implements TerminalSessionsEvent {
  const TerminalSessionSelected(this.id);
  

 final  String id;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionSelectedCopyWith<TerminalSessionSelected> get copyWith => _$TerminalSessionSelectedCopyWithImpl<TerminalSessionSelected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionSelected&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TerminalSessionsEvent.sessionSelected(id: $id)';
}


}

/// @nodoc
abstract mixin class $TerminalSessionSelectedCopyWith<$Res> implements $TerminalSessionsEventCopyWith<$Res> {
  factory $TerminalSessionSelectedCopyWith(TerminalSessionSelected value, $Res Function(TerminalSessionSelected) _then) = _$TerminalSessionSelectedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$TerminalSessionSelectedCopyWithImpl<$Res>
    implements $TerminalSessionSelectedCopyWith<$Res> {
  _$TerminalSessionSelectedCopyWithImpl(this._self, this._then);

  final TerminalSessionSelected _self;
  final $Res Function(TerminalSessionSelected) _then;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(TerminalSessionSelected(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TerminalSessionClosed implements TerminalSessionsEvent {
  const TerminalSessionClosed(this.id);
  

 final  String id;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalSessionClosedCopyWith<TerminalSessionClosed> get copyWith => _$TerminalSessionClosedCopyWithImpl<TerminalSessionClosed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalSessionClosed&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TerminalSessionsEvent.sessionClosed(id: $id)';
}


}

/// @nodoc
abstract mixin class $TerminalSessionClosedCopyWith<$Res> implements $TerminalSessionsEventCopyWith<$Res> {
  factory $TerminalSessionClosedCopyWith(TerminalSessionClosed value, $Res Function(TerminalSessionClosed) _then) = _$TerminalSessionClosedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$TerminalSessionClosedCopyWithImpl<$Res>
    implements $TerminalSessionClosedCopyWith<$Res> {
  _$TerminalSessionClosedCopyWithImpl(this._self, this._then);

  final TerminalSessionClosed _self;
  final $Res Function(TerminalSessionClosed) _then;

/// Create a copy of TerminalSessionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(TerminalSessionClosed(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
