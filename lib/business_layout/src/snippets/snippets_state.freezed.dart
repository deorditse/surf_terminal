// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippets_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SnippetsState {

 List<CommandSnippet> get snippets; String get filter; String? get errorMessage;
/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetsStateCopyWith<SnippetsState> get copyWith => _$SnippetsStateCopyWithImpl<SnippetsState>(this as SnippetsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SnippetsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsState&&const DeepCollectionEquality().equals(other.snippets, _this.snippets)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as SnippetsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.snippets),_this.filter,_this.errorMessage);
}

@override
String toString() {
  final _this = this as SnippetsState;
  return 'SnippetsState(snippets: ${_this.snippets}, filter: ${_this.filter}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $SnippetsStateCopyWith<$Res>  {
  factory $SnippetsStateCopyWith(SnippetsState value, $Res Function(SnippetsState) _then) = _$SnippetsStateCopyWithImpl;
@useResult
$Res call({
 List<CommandSnippet> snippets, String filter, String errorMessage
});




}
/// @nodoc
class _$SnippetsStateCopyWithImpl<$Res>
    implements $SnippetsStateCopyWith<$Res> {
  _$SnippetsStateCopyWithImpl(this._self, this._then);

  final SnippetsState _self;
  final $Res Function(SnippetsState) _then;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snippets = null,Object? filter = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
snippets: null == snippets ? _self.snippets : snippets // ignore: cast_nullable_to_non_nullable
as List<CommandSnippet>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,errorMessage: null == errorMessage ? _self.errorMessage! : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SnippetsState].
extension SnippetsStatePatterns on SnippetsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SnippetsLoading value)?  loading,TResult Function( SnippetsSuccess value)?  success,TResult Function( SnippetsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SnippetsLoading() when loading != null:
return loading(_that);case SnippetsSuccess() when success != null:
return success(_that);case SnippetsFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SnippetsLoading value)  loading,required TResult Function( SnippetsSuccess value)  success,required TResult Function( SnippetsFailure value)  failure,}){
final _that = this;
switch (_that) {
case SnippetsLoading():
return loading(_that);case SnippetsSuccess():
return success(_that);case SnippetsFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SnippetsLoading value)?  loading,TResult? Function( SnippetsSuccess value)?  success,TResult? Function( SnippetsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SnippetsLoading() when loading != null:
return loading(_that);case SnippetsSuccess() when success != null:
return success(_that);case SnippetsFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)?  loading,TResult Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)?  success,TResult Function( List<CommandSnippet> snippets,  String filter,  String errorMessage)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SnippetsLoading() when loading != null:
return loading(_that.snippets,_that.filter,_that.errorMessage);case SnippetsSuccess() when success != null:
return success(_that.snippets,_that.filter,_that.errorMessage);case SnippetsFailure() when failure != null:
return failure(_that.snippets,_that.filter,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)  loading,required TResult Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)  success,required TResult Function( List<CommandSnippet> snippets,  String filter,  String errorMessage)  failure,}) {final _that = this;
switch (_that) {
case SnippetsLoading():
return loading(_that.snippets,_that.filter,_that.errorMessage);case SnippetsSuccess():
return success(_that.snippets,_that.filter,_that.errorMessage);case SnippetsFailure():
return failure(_that.snippets,_that.filter,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)?  loading,TResult? Function( List<CommandSnippet> snippets,  String filter,  String? errorMessage)?  success,TResult? Function( List<CommandSnippet> snippets,  String filter,  String errorMessage)?  failure,}) {final _that = this;
switch (_that) {
case SnippetsLoading() when loading != null:
return loading(_that.snippets,_that.filter,_that.errorMessage);case SnippetsSuccess() when success != null:
return success(_that.snippets,_that.filter,_that.errorMessage);case SnippetsFailure() when failure != null:
return failure(_that.snippets,_that.filter,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class SnippetsLoading extends SnippetsState {
  const SnippetsLoading({ List<CommandSnippet> snippets = const <CommandSnippet>[], this.filter = '', this.errorMessage}): _snippets = snippets,super._();
  

 final  List<CommandSnippet> _snippets;
@override@JsonKey() List<CommandSnippet> get snippets {
  if (_snippets is EqualUnmodifiableListView) return _snippets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_snippets);
}

@override@JsonKey() final  String filter;
@override final  String? errorMessage;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetsLoadingCopyWith<SnippetsLoading> get copyWith => _$SnippetsLoadingCopyWithImpl<SnippetsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsLoading&&const DeepCollectionEquality().equals(other.snippets, _snippets)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_snippets),filter,errorMessage);
}

@override
String toString() {
    return 'SnippetsState.loading(snippets: $snippets, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SnippetsLoadingCopyWith<$Res> implements $SnippetsStateCopyWith<$Res> {
  factory $SnippetsLoadingCopyWith(SnippetsLoading value, $Res Function(SnippetsLoading) _then) = _$SnippetsLoadingCopyWithImpl;
@override @useResult
$Res call({
 List<CommandSnippet> snippets, String filter, String? errorMessage
});




}
/// @nodoc
class _$SnippetsLoadingCopyWithImpl<$Res>
    implements $SnippetsLoadingCopyWith<$Res> {
  _$SnippetsLoadingCopyWithImpl(this._self, this._then);

  final SnippetsLoading _self;
  final $Res Function(SnippetsLoading) _then;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snippets = null,Object? filter = null,Object? errorMessage = freezed,}) {
  return _then(SnippetsLoading(
snippets: null == snippets ? _self._snippets : snippets // ignore: cast_nullable_to_non_nullable
as List<CommandSnippet>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SnippetsSuccess extends SnippetsState {
  const SnippetsSuccess({required  List<CommandSnippet> snippets, this.filter = '', this.errorMessage}): _snippets = snippets,super._();
  

 final  List<CommandSnippet> _snippets;
@override List<CommandSnippet> get snippets {
  if (_snippets is EqualUnmodifiableListView) return _snippets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_snippets);
}

@override@JsonKey() final  String filter;
@override final  String? errorMessage;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetsSuccessCopyWith<SnippetsSuccess> get copyWith => _$SnippetsSuccessCopyWithImpl<SnippetsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsSuccess&&const DeepCollectionEquality().equals(other.snippets, _snippets)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_snippets),filter,errorMessage);
}

@override
String toString() {
    return 'SnippetsState.success(snippets: $snippets, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SnippetsSuccessCopyWith<$Res> implements $SnippetsStateCopyWith<$Res> {
  factory $SnippetsSuccessCopyWith(SnippetsSuccess value, $Res Function(SnippetsSuccess) _then) = _$SnippetsSuccessCopyWithImpl;
@override @useResult
$Res call({
 List<CommandSnippet> snippets, String filter, String? errorMessage
});




}
/// @nodoc
class _$SnippetsSuccessCopyWithImpl<$Res>
    implements $SnippetsSuccessCopyWith<$Res> {
  _$SnippetsSuccessCopyWithImpl(this._self, this._then);

  final SnippetsSuccess _self;
  final $Res Function(SnippetsSuccess) _then;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snippets = null,Object? filter = null,Object? errorMessage = freezed,}) {
  return _then(SnippetsSuccess(
snippets: null == snippets ? _self._snippets : snippets // ignore: cast_nullable_to_non_nullable
as List<CommandSnippet>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SnippetsFailure extends SnippetsState {
  const SnippetsFailure({required  List<CommandSnippet> snippets, this.filter = '', required this.errorMessage}): _snippets = snippets,super._();
  

 final  List<CommandSnippet> _snippets;
@override List<CommandSnippet> get snippets {
  if (_snippets is EqualUnmodifiableListView) return _snippets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_snippets);
}

@override@JsonKey() final  String filter;
@override final  String errorMessage;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetsFailureCopyWith<SnippetsFailure> get copyWith => _$SnippetsFailureCopyWithImpl<SnippetsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsFailure&&const DeepCollectionEquality().equals(other.snippets, _snippets)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_snippets),filter,errorMessage);
}

@override
String toString() {
    return 'SnippetsState.failure(snippets: $snippets, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SnippetsFailureCopyWith<$Res> implements $SnippetsStateCopyWith<$Res> {
  factory $SnippetsFailureCopyWith(SnippetsFailure value, $Res Function(SnippetsFailure) _then) = _$SnippetsFailureCopyWithImpl;
@override @useResult
$Res call({
 List<CommandSnippet> snippets, String filter, String errorMessage
});




}
/// @nodoc
class _$SnippetsFailureCopyWithImpl<$Res>
    implements $SnippetsFailureCopyWith<$Res> {
  _$SnippetsFailureCopyWithImpl(this._self, this._then);

  final SnippetsFailure _self;
  final $Res Function(SnippetsFailure) _then;

/// Create a copy of SnippetsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snippets = null,Object? filter = null,Object? errorMessage = null,}) {
  return _then(SnippetsFailure(
snippets: null == snippets ? _self._snippets : snippets // ignore: cast_nullable_to_non_nullable
as List<CommandSnippet>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
