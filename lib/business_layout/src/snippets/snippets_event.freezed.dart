// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippets_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SnippetsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SnippetsEvent()';
}


}

/// @nodoc
class $SnippetsEventCopyWith<$Res>  {
$SnippetsEventCopyWith(SnippetsEvent _, $Res Function(SnippetsEvent) __);
}


/// Adds pattern-matching-related methods to [SnippetsEvent].
extension SnippetsEventPatterns on SnippetsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SnippetsLoadRequested value)?  loadRequested,TResult Function( SnippetsFilterChanged value)?  filterChanged,TResult Function( SnippetSaved value)?  snippetSaved,TResult Function( SnippetDeleted value)?  snippetDeleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SnippetsLoadRequested() when loadRequested != null:
return loadRequested(_that);case SnippetsFilterChanged() when filterChanged != null:
return filterChanged(_that);case SnippetSaved() when snippetSaved != null:
return snippetSaved(_that);case SnippetDeleted() when snippetDeleted != null:
return snippetDeleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SnippetsLoadRequested value)  loadRequested,required TResult Function( SnippetsFilterChanged value)  filterChanged,required TResult Function( SnippetSaved value)  snippetSaved,required TResult Function( SnippetDeleted value)  snippetDeleted,}){
final _that = this;
switch (_that) {
case SnippetsLoadRequested():
return loadRequested(_that);case SnippetsFilterChanged():
return filterChanged(_that);case SnippetSaved():
return snippetSaved(_that);case SnippetDeleted():
return snippetDeleted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SnippetsLoadRequested value)?  loadRequested,TResult? Function( SnippetsFilterChanged value)?  filterChanged,TResult? Function( SnippetSaved value)?  snippetSaved,TResult? Function( SnippetDeleted value)?  snippetDeleted,}){
final _that = this;
switch (_that) {
case SnippetsLoadRequested() when loadRequested != null:
return loadRequested(_that);case SnippetsFilterChanged() when filterChanged != null:
return filterChanged(_that);case SnippetSaved() when snippetSaved != null:
return snippetSaved(_that);case SnippetDeleted() when snippetDeleted != null:
return snippetDeleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( String value)?  filterChanged,TResult Function( CommandSnippet snippet)?  snippetSaved,TResult Function( String id)?  snippetDeleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SnippetsLoadRequested() when loadRequested != null:
return loadRequested();case SnippetsFilterChanged() when filterChanged != null:
return filterChanged(_that.value);case SnippetSaved() when snippetSaved != null:
return snippetSaved(_that.snippet);case SnippetDeleted() when snippetDeleted != null:
return snippetDeleted(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( String value)  filterChanged,required TResult Function( CommandSnippet snippet)  snippetSaved,required TResult Function( String id)  snippetDeleted,}) {final _that = this;
switch (_that) {
case SnippetsLoadRequested():
return loadRequested();case SnippetsFilterChanged():
return filterChanged(_that.value);case SnippetSaved():
return snippetSaved(_that.snippet);case SnippetDeleted():
return snippetDeleted(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( String value)?  filterChanged,TResult? Function( CommandSnippet snippet)?  snippetSaved,TResult? Function( String id)?  snippetDeleted,}) {final _that = this;
switch (_that) {
case SnippetsLoadRequested() when loadRequested != null:
return loadRequested();case SnippetsFilterChanged() when filterChanged != null:
return filterChanged(_that.value);case SnippetSaved() when snippetSaved != null:
return snippetSaved(_that.snippet);case SnippetDeleted() when snippetDeleted != null:
return snippetDeleted(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class SnippetsLoadRequested implements SnippetsEvent {
  const SnippetsLoadRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsLoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SnippetsEvent.loadRequested()';
}


}




/// @nodoc


class SnippetsFilterChanged implements SnippetsEvent {
  const SnippetsFilterChanged(this.value);
  

 final  String value;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetsFilterChangedCopyWith<SnippetsFilterChanged> get copyWith => _$SnippetsFilterChangedCopyWithImpl<SnippetsFilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetsFilterChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'SnippetsEvent.filterChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $SnippetsFilterChangedCopyWith<$Res> implements $SnippetsEventCopyWith<$Res> {
  factory $SnippetsFilterChangedCopyWith(SnippetsFilterChanged value, $Res Function(SnippetsFilterChanged) _then) = _$SnippetsFilterChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$SnippetsFilterChangedCopyWithImpl<$Res>
    implements $SnippetsFilterChangedCopyWith<$Res> {
  _$SnippetsFilterChangedCopyWithImpl(this._self, this._then);

  final SnippetsFilterChanged _self;
  final $Res Function(SnippetsFilterChanged) _then;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(SnippetsFilterChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SnippetSaved implements SnippetsEvent {
  const SnippetSaved(this.snippet);
  

 final  CommandSnippet snippet;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetSavedCopyWith<SnippetSaved> get copyWith => _$SnippetSavedCopyWithImpl<SnippetSaved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetSaved&&(identical(other.snippet, snippet) || other.snippet == snippet));
}


@override
int get hashCode {
    return Object.hash(runtimeType,snippet);
}

@override
String toString() {
    return 'SnippetsEvent.snippetSaved(snippet: $snippet)';
}


}

/// @nodoc
abstract mixin class $SnippetSavedCopyWith<$Res> implements $SnippetsEventCopyWith<$Res> {
  factory $SnippetSavedCopyWith(SnippetSaved value, $Res Function(SnippetSaved) _then) = _$SnippetSavedCopyWithImpl;
@useResult
$Res call({
 CommandSnippet snippet
});




}
/// @nodoc
class _$SnippetSavedCopyWithImpl<$Res>
    implements $SnippetSavedCopyWith<$Res> {
  _$SnippetSavedCopyWithImpl(this._self, this._then);

  final SnippetSaved _self;
  final $Res Function(SnippetSaved) _then;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snippet = null,}) {
  return _then(SnippetSaved(
null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as CommandSnippet,
  ));
}


}

/// @nodoc


class SnippetDeleted implements SnippetsEvent {
  const SnippetDeleted(this.id);
  

 final  String id;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetDeletedCopyWith<SnippetDeleted> get copyWith => _$SnippetDeletedCopyWithImpl<SnippetDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetDeleted&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'SnippetsEvent.snippetDeleted(id: $id)';
}


}

/// @nodoc
abstract mixin class $SnippetDeletedCopyWith<$Res> implements $SnippetsEventCopyWith<$Res> {
  factory $SnippetDeletedCopyWith(SnippetDeleted value, $Res Function(SnippetDeleted) _then) = _$SnippetDeletedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SnippetDeletedCopyWithImpl<$Res>
    implements $SnippetDeletedCopyWith<$Res> {
  _$SnippetDeletedCopyWithImpl(this._self, this._then);

  final SnippetDeleted _self;
  final $Res Function(SnippetDeleted) _then;

/// Create a copy of SnippetsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SnippetDeleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
