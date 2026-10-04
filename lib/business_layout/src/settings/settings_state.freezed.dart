// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 TerminalPreferences get preferences; String? get errorMessage;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.preferences, _this.preferences) || other.preferences == _this.preferences)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.preferences,_this.errorMessage);
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(preferences: ${_this.preferences}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 TerminalPreferences preferences, String errorMessage
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preferences = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as TerminalPreferences,errorMessage: null == errorMessage ? _self.errorMessage! : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsLoading value)?  loading,TResult Function( SettingsSuccess value)?  success,TResult Function( SettingsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsLoading() when loading != null:
return loading(_that);case SettingsSuccess() when success != null:
return success(_that);case SettingsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsLoading value)  loading,required TResult Function( SettingsSuccess value)  success,required TResult Function( SettingsFailure value)  failure,}){
final _that = this;
switch (_that) {
case SettingsLoading():
return loading(_that);case SettingsSuccess():
return success(_that);case SettingsFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsLoading value)?  loading,TResult? Function( SettingsSuccess value)?  success,TResult? Function( SettingsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SettingsLoading() when loading != null:
return loading(_that);case SettingsSuccess() when success != null:
return success(_that);case SettingsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TerminalPreferences preferences,  String? errorMessage)?  loading,TResult Function( TerminalPreferences preferences,  String? errorMessage)?  success,TResult Function( TerminalPreferences preferences,  String errorMessage)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsLoading() when loading != null:
return loading(_that.preferences,_that.errorMessage);case SettingsSuccess() when success != null:
return success(_that.preferences,_that.errorMessage);case SettingsFailure() when failure != null:
return failure(_that.preferences,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TerminalPreferences preferences,  String? errorMessage)  loading,required TResult Function( TerminalPreferences preferences,  String? errorMessage)  success,required TResult Function( TerminalPreferences preferences,  String errorMessage)  failure,}) {final _that = this;
switch (_that) {
case SettingsLoading():
return loading(_that.preferences,_that.errorMessage);case SettingsSuccess():
return success(_that.preferences,_that.errorMessage);case SettingsFailure():
return failure(_that.preferences,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TerminalPreferences preferences,  String? errorMessage)?  loading,TResult? Function( TerminalPreferences preferences,  String? errorMessage)?  success,TResult? Function( TerminalPreferences preferences,  String errorMessage)?  failure,}) {final _that = this;
switch (_that) {
case SettingsLoading() when loading != null:
return loading(_that.preferences,_that.errorMessage);case SettingsSuccess() when success != null:
return success(_that.preferences,_that.errorMessage);case SettingsFailure() when failure != null:
return failure(_that.preferences,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class SettingsLoading extends SettingsState {
  const SettingsLoading({this.preferences = const TerminalPreferences(), this.errorMessage}): super._();
  

@override@JsonKey() final  TerminalPreferences preferences;
@override final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsLoadingCopyWith<SettingsLoading> get copyWith => _$SettingsLoadingCopyWithImpl<SettingsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsLoading&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,preferences,errorMessage);
}

@override
String toString() {
    return 'SettingsState.loading(preferences: $preferences, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsLoadingCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsLoadingCopyWith(SettingsLoading value, $Res Function(SettingsLoading) _then) = _$SettingsLoadingCopyWithImpl;
@override @useResult
$Res call({
 TerminalPreferences preferences, String? errorMessage
});




}
/// @nodoc
class _$SettingsLoadingCopyWithImpl<$Res>
    implements $SettingsLoadingCopyWith<$Res> {
  _$SettingsLoadingCopyWithImpl(this._self, this._then);

  final SettingsLoading _self;
  final $Res Function(SettingsLoading) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? errorMessage = freezed,}) {
  return _then(SettingsLoading(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as TerminalPreferences,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SettingsSuccess extends SettingsState {
  const SettingsSuccess({required this.preferences, this.errorMessage}): super._();
  

@override final  TerminalPreferences preferences;
@override final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSuccessCopyWith<SettingsSuccess> get copyWith => _$SettingsSuccessCopyWithImpl<SettingsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSuccess&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,preferences,errorMessage);
}

@override
String toString() {
    return 'SettingsState.success(preferences: $preferences, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsSuccessCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsSuccessCopyWith(SettingsSuccess value, $Res Function(SettingsSuccess) _then) = _$SettingsSuccessCopyWithImpl;
@override @useResult
$Res call({
 TerminalPreferences preferences, String? errorMessage
});




}
/// @nodoc
class _$SettingsSuccessCopyWithImpl<$Res>
    implements $SettingsSuccessCopyWith<$Res> {
  _$SettingsSuccessCopyWithImpl(this._self, this._then);

  final SettingsSuccess _self;
  final $Res Function(SettingsSuccess) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? errorMessage = freezed,}) {
  return _then(SettingsSuccess(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as TerminalPreferences,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SettingsFailure extends SettingsState {
  const SettingsFailure({required this.preferences, required this.errorMessage}): super._();
  

@override final  TerminalPreferences preferences;
@override final  String errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsFailureCopyWith<SettingsFailure> get copyWith => _$SettingsFailureCopyWithImpl<SettingsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsFailure&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,preferences,errorMessage);
}

@override
String toString() {
    return 'SettingsState.failure(preferences: $preferences, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsFailureCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsFailureCopyWith(SettingsFailure value, $Res Function(SettingsFailure) _then) = _$SettingsFailureCopyWithImpl;
@override @useResult
$Res call({
 TerminalPreferences preferences, String errorMessage
});




}
/// @nodoc
class _$SettingsFailureCopyWithImpl<$Res>
    implements $SettingsFailureCopyWith<$Res> {
  _$SettingsFailureCopyWithImpl(this._self, this._then);

  final SettingsFailure _self;
  final $Res Function(SettingsFailure) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? errorMessage = null,}) {
  return _then(SettingsFailure(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as TerminalPreferences,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
