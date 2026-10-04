// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profiles_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfilesEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProfilesEvent()';
}


}

/// @nodoc
class $ProfilesEventCopyWith<$Res>  {
$ProfilesEventCopyWith(ProfilesEvent _, $Res Function(ProfilesEvent) __);
}


/// Adds pattern-matching-related methods to [ProfilesEvent].
extension ProfilesEventPatterns on ProfilesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfilesLoadRequested value)?  loadRequested,TResult Function( ProfileSaved value)?  profileSaved,TResult Function( ProfileDeleted value)?  profileDeleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfilesLoadRequested() when loadRequested != null:
return loadRequested(_that);case ProfileSaved() when profileSaved != null:
return profileSaved(_that);case ProfileDeleted() when profileDeleted != null:
return profileDeleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfilesLoadRequested value)  loadRequested,required TResult Function( ProfileSaved value)  profileSaved,required TResult Function( ProfileDeleted value)  profileDeleted,}){
final _that = this;
switch (_that) {
case ProfilesLoadRequested():
return loadRequested(_that);case ProfileSaved():
return profileSaved(_that);case ProfileDeleted():
return profileDeleted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfilesLoadRequested value)?  loadRequested,TResult? Function( ProfileSaved value)?  profileSaved,TResult? Function( ProfileDeleted value)?  profileDeleted,}){
final _that = this;
switch (_that) {
case ProfilesLoadRequested() when loadRequested != null:
return loadRequested(_that);case ProfileSaved() when profileSaved != null:
return profileSaved(_that);case ProfileDeleted() when profileDeleted != null:
return profileDeleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( SshProfile profile)?  profileSaved,TResult Function( String id)?  profileDeleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfilesLoadRequested() when loadRequested != null:
return loadRequested();case ProfileSaved() when profileSaved != null:
return profileSaved(_that.profile);case ProfileDeleted() when profileDeleted != null:
return profileDeleted(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( SshProfile profile)  profileSaved,required TResult Function( String id)  profileDeleted,}) {final _that = this;
switch (_that) {
case ProfilesLoadRequested():
return loadRequested();case ProfileSaved():
return profileSaved(_that.profile);case ProfileDeleted():
return profileDeleted(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( SshProfile profile)?  profileSaved,TResult? Function( String id)?  profileDeleted,}) {final _that = this;
switch (_that) {
case ProfilesLoadRequested() when loadRequested != null:
return loadRequested();case ProfileSaved() when profileSaved != null:
return profileSaved(_that.profile);case ProfileDeleted() when profileDeleted != null:
return profileDeleted(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class ProfilesLoadRequested implements ProfilesEvent {
  const ProfilesLoadRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilesLoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProfilesEvent.loadRequested()';
}


}




/// @nodoc


class ProfileSaved implements ProfilesEvent {
  const ProfileSaved(this.profile);
  

 final  SshProfile profile;

/// Create a copy of ProfilesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSavedCopyWith<ProfileSaved> get copyWith => _$ProfileSavedCopyWithImpl<ProfileSaved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSaved&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile);
}

@override
String toString() {
    return 'ProfilesEvent.profileSaved(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ProfileSavedCopyWith<$Res> implements $ProfilesEventCopyWith<$Res> {
  factory $ProfileSavedCopyWith(ProfileSaved value, $Res Function(ProfileSaved) _then) = _$ProfileSavedCopyWithImpl;
@useResult
$Res call({
 SshProfile profile
});




}
/// @nodoc
class _$ProfileSavedCopyWithImpl<$Res>
    implements $ProfileSavedCopyWith<$Res> {
  _$ProfileSavedCopyWithImpl(this._self, this._then);

  final ProfileSaved _self;
  final $Res Function(ProfileSaved) _then;

/// Create a copy of ProfilesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(ProfileSaved(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SshProfile,
  ));
}


}

/// @nodoc


class ProfileDeleted implements ProfilesEvent {
  const ProfileDeleted(this.id);
  

 final  String id;

/// Create a copy of ProfilesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDeletedCopyWith<ProfileDeleted> get copyWith => _$ProfileDeletedCopyWithImpl<ProfileDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDeleted&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'ProfilesEvent.profileDeleted(id: $id)';
}


}

/// @nodoc
abstract mixin class $ProfileDeletedCopyWith<$Res> implements $ProfilesEventCopyWith<$Res> {
  factory $ProfileDeletedCopyWith(ProfileDeleted value, $Res Function(ProfileDeleted) _then) = _$ProfileDeletedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ProfileDeletedCopyWithImpl<$Res>
    implements $ProfileDeletedCopyWith<$Res> {
  _$ProfileDeletedCopyWithImpl(this._self, this._then);

  final ProfileDeleted _self;
  final $Res Function(ProfileDeleted) _then;

/// Create a copy of ProfilesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(ProfileDeleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
