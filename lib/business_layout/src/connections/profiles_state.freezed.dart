// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profiles_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfilesState {

 List<SshProfile> get profiles; String? get errorMessage;
/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilesStateCopyWith<ProfilesState> get copyWith => _$ProfilesStateCopyWithImpl<ProfilesState>(this as ProfilesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfilesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesState&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as ProfilesState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.profiles),_this.errorMessage);
}

@override
String toString() {
  final _this = this as ProfilesState;
  return 'ProfilesState(profiles: ${_this.profiles}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $ProfilesStateCopyWith<$Res>  {
  factory $ProfilesStateCopyWith(ProfilesState value, $Res Function(ProfilesState) _then) = _$ProfilesStateCopyWithImpl;
@useResult
$Res call({
 List<SshProfile> profiles, String errorMessage
});




}
/// @nodoc
class _$ProfilesStateCopyWithImpl<$Res>
    implements $ProfilesStateCopyWith<$Res> {
  _$ProfilesStateCopyWithImpl(this._self, this._then);

  final ProfilesState _self;
  final $Res Function(ProfilesState) _then;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profiles = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<SshProfile>,errorMessage: null == errorMessage ? _self.errorMessage! : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilesState].
extension ProfilesStatePatterns on ProfilesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfilesLoading value)?  loading,TResult Function( ProfilesSuccess value)?  success,TResult Function( ProfilesFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfilesLoading() when loading != null:
return loading(_that);case ProfilesSuccess() when success != null:
return success(_that);case ProfilesFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfilesLoading value)  loading,required TResult Function( ProfilesSuccess value)  success,required TResult Function( ProfilesFailure value)  failure,}){
final _that = this;
switch (_that) {
case ProfilesLoading():
return loading(_that);case ProfilesSuccess():
return success(_that);case ProfilesFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfilesLoading value)?  loading,TResult? Function( ProfilesSuccess value)?  success,TResult? Function( ProfilesFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ProfilesLoading() when loading != null:
return loading(_that);case ProfilesSuccess() when success != null:
return success(_that);case ProfilesFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<SshProfile> profiles,  String? errorMessage)?  loading,TResult Function( List<SshProfile> profiles,  String? errorMessage)?  success,TResult Function( List<SshProfile> profiles,  String errorMessage)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfilesLoading() when loading != null:
return loading(_that.profiles,_that.errorMessage);case ProfilesSuccess() when success != null:
return success(_that.profiles,_that.errorMessage);case ProfilesFailure() when failure != null:
return failure(_that.profiles,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<SshProfile> profiles,  String? errorMessage)  loading,required TResult Function( List<SshProfile> profiles,  String? errorMessage)  success,required TResult Function( List<SshProfile> profiles,  String errorMessage)  failure,}) {final _that = this;
switch (_that) {
case ProfilesLoading():
return loading(_that.profiles,_that.errorMessage);case ProfilesSuccess():
return success(_that.profiles,_that.errorMessage);case ProfilesFailure():
return failure(_that.profiles,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<SshProfile> profiles,  String? errorMessage)?  loading,TResult? Function( List<SshProfile> profiles,  String? errorMessage)?  success,TResult? Function( List<SshProfile> profiles,  String errorMessage)?  failure,}) {final _that = this;
switch (_that) {
case ProfilesLoading() when loading != null:
return loading(_that.profiles,_that.errorMessage);case ProfilesSuccess() when success != null:
return success(_that.profiles,_that.errorMessage);case ProfilesFailure() when failure != null:
return failure(_that.profiles,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class ProfilesLoading extends ProfilesState {
  const ProfilesLoading({ List<SshProfile> profiles = const <SshProfile>[], this.errorMessage}): _profiles = profiles,super._();
  

 final  List<SshProfile> _profiles;
@override@JsonKey() List<SshProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override final  String? errorMessage;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilesLoadingCopyWith<ProfilesLoading> get copyWith => _$ProfilesLoadingCopyWithImpl<ProfilesLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesLoading&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),errorMessage);
}

@override
String toString() {
    return 'ProfilesState.loading(profiles: $profiles, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfilesLoadingCopyWith<$Res> implements $ProfilesStateCopyWith<$Res> {
  factory $ProfilesLoadingCopyWith(ProfilesLoading value, $Res Function(ProfilesLoading) _then) = _$ProfilesLoadingCopyWithImpl;
@override @useResult
$Res call({
 List<SshProfile> profiles, String? errorMessage
});




}
/// @nodoc
class _$ProfilesLoadingCopyWithImpl<$Res>
    implements $ProfilesLoadingCopyWith<$Res> {
  _$ProfilesLoadingCopyWithImpl(this._self, this._then);

  final ProfilesLoading _self;
  final $Res Function(ProfilesLoading) _then;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? errorMessage = freezed,}) {
  return _then(ProfilesLoading(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<SshProfile>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ProfilesSuccess extends ProfilesState {
  const ProfilesSuccess({required  List<SshProfile> profiles, this.errorMessage}): _profiles = profiles,super._();
  

 final  List<SshProfile> _profiles;
@override List<SshProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override final  String? errorMessage;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilesSuccessCopyWith<ProfilesSuccess> get copyWith => _$ProfilesSuccessCopyWithImpl<ProfilesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesSuccess&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),errorMessage);
}

@override
String toString() {
    return 'ProfilesState.success(profiles: $profiles, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfilesSuccessCopyWith<$Res> implements $ProfilesStateCopyWith<$Res> {
  factory $ProfilesSuccessCopyWith(ProfilesSuccess value, $Res Function(ProfilesSuccess) _then) = _$ProfilesSuccessCopyWithImpl;
@override @useResult
$Res call({
 List<SshProfile> profiles, String? errorMessage
});




}
/// @nodoc
class _$ProfilesSuccessCopyWithImpl<$Res>
    implements $ProfilesSuccessCopyWith<$Res> {
  _$ProfilesSuccessCopyWithImpl(this._self, this._then);

  final ProfilesSuccess _self;
  final $Res Function(ProfilesSuccess) _then;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? errorMessage = freezed,}) {
  return _then(ProfilesSuccess(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<SshProfile>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ProfilesFailure extends ProfilesState {
  const ProfilesFailure({required  List<SshProfile> profiles, required this.errorMessage}): _profiles = profiles,super._();
  

 final  List<SshProfile> _profiles;
@override List<SshProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override final  String errorMessage;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilesFailureCopyWith<ProfilesFailure> get copyWith => _$ProfilesFailureCopyWithImpl<ProfilesFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesFailure&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),errorMessage);
}

@override
String toString() {
    return 'ProfilesState.failure(profiles: $profiles, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfilesFailureCopyWith<$Res> implements $ProfilesStateCopyWith<$Res> {
  factory $ProfilesFailureCopyWith(ProfilesFailure value, $Res Function(ProfilesFailure) _then) = _$ProfilesFailureCopyWithImpl;
@override @useResult
$Res call({
 List<SshProfile> profiles, String errorMessage
});




}
/// @nodoc
class _$ProfilesFailureCopyWithImpl<$Res>
    implements $ProfilesFailureCopyWith<$Res> {
  _$ProfilesFailureCopyWithImpl(this._self, this._then);

  final ProfilesFailure _self;
  final $Res Function(ProfilesFailure) _then;

/// Create a copy of ProfilesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? errorMessage = null,}) {
  return _then(ProfilesFailure(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<SshProfile>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
