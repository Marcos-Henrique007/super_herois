// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hero {

 int get id; String get name; String get image; int get intelligence; int get strength; int get speed; int get durability; int get power; int get combat; String get gender; String get race; List<String> get height; List<String> get weight;
/// Create a copy of Hero
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeroCopyWith<Hero> get copyWith => _$HeroCopyWithImpl<Hero>(this as Hero, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hero&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.intelligence, intelligence) || other.intelligence == intelligence)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.durability, durability) || other.durability == durability)&&(identical(other.power, power) || other.power == power)&&(identical(other.combat, combat) || other.combat == combat)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.race, race) || other.race == race)&&const DeepCollectionEquality().equals(other.height, height)&&const DeepCollectionEquality().equals(other.weight, weight));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,image,intelligence,strength,speed,durability,power,combat,gender,race,const DeepCollectionEquality().hash(height),const DeepCollectionEquality().hash(weight));

@override
String toString() {
  return 'Hero(id: $id, name: $name, image: $image, intelligence: $intelligence, strength: $strength, speed: $speed, durability: $durability, power: $power, combat: $combat, gender: $gender, race: $race, height: $height, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $HeroCopyWith<$Res>  {
  factory $HeroCopyWith(Hero value, $Res Function(Hero) _then) = _$HeroCopyWithImpl;
@useResult
$Res call({
 int id, String name, String image, int intelligence, int strength, int speed, int durability, int power, int combat, String gender, String race, List<String> height, List<String> weight
});




}
/// @nodoc
class _$HeroCopyWithImpl<$Res>
    implements $HeroCopyWith<$Res> {
  _$HeroCopyWithImpl(this._self, this._then);

  final Hero _self;
  final $Res Function(Hero) _then;

/// Create a copy of Hero
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,Object? intelligence = null,Object? strength = null,Object? speed = null,Object? durability = null,Object? power = null,Object? combat = null,Object? gender = null,Object? race = null,Object? height = null,Object? weight = null,}) {
  return _then(Hero(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,intelligence: null == intelligence ? _self.intelligence : intelligence // ignore: cast_nullable_to_non_nullable
as int,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,durability: null == durability ? _self.durability : durability // ignore: cast_nullable_to_non_nullable
as int,power: null == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as int,combat: null == combat ? _self.combat : combat // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,race: null == race ? _self.race : race // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as List<String>,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Hero].
extension HeroPatterns on Hero {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hero value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hero() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hero value)  $default,){
final _that = this;
switch (_that) {
case _Hero():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hero value)?  $default,){
final _that = this;
switch (_that) {
case _Hero() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String image,  int intelligence,  int strength,  int speed,  int durability,  int power,  int combat,  String gender,  String race,  List<String> height,  List<String> weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hero() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.intelligence,_that.strength,_that.speed,_that.durability,_that.power,_that.combat,_that.gender,_that.race,_that.height,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String image,  int intelligence,  int strength,  int speed,  int durability,  int power,  int combat,  String gender,  String race,  List<String> height,  List<String> weight)  $default,) {final _that = this;
switch (_that) {
case _Hero():
return $default(_that.id,_that.name,_that.image,_that.intelligence,_that.strength,_that.speed,_that.durability,_that.power,_that.combat,_that.gender,_that.race,_that.height,_that.weight);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String image,  int intelligence,  int strength,  int speed,  int durability,  int power,  int combat,  String gender,  String race,  List<String> height,  List<String> weight)?  $default,) {final _that = this;
switch (_that) {
case _Hero() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.intelligence,_that.strength,_that.speed,_that.durability,_that.power,_that.combat,_that.gender,_that.race,_that.height,_that.weight);case _:
  return null;

}
}

}

/// @nodoc


class _Hero implements Hero {
  const _Hero({required this.id, required this.name, required this.image, required this.intelligence, required this.strength, required this.speed, required this.durability, required this.power, required this.combat, required this.gender, required this.race, required  List<String> height, required  List<String> weight}): _height = height,_weight = weight;
  

@override final  int id;
@override final  String name;
@override final  String image;
@override final  int intelligence;
@override final  int strength;
@override final  int speed;
@override final  int durability;
@override final  int power;
@override final  int combat;
@override final  String gender;
@override final  String race;
 final  List<String> _height;
@override List<String> get height {
  if (_height is EqualUnmodifiableListView) return _height;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_height);
}

 final  List<String> _weight;
@override List<String> get weight {
  if (_weight is EqualUnmodifiableListView) return _weight;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weight);
}


/// Create a copy of Hero
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeroCopyWith<_Hero> get copyWith => __$HeroCopyWithImpl<_Hero>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hero&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.intelligence, intelligence) || other.intelligence == intelligence)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.durability, durability) || other.durability == durability)&&(identical(other.power, power) || other.power == power)&&(identical(other.combat, combat) || other.combat == combat)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.race, race) || other.race == race)&&const DeepCollectionEquality().equals(other._height, _height)&&const DeepCollectionEquality().equals(other._weight, _weight));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,image,intelligence,strength,speed,durability,power,combat,gender,race,const DeepCollectionEquality().hash(_height),const DeepCollectionEquality().hash(_weight));

@override
String toString() {
  return 'Hero(id: $id, name: $name, image: $image, intelligence: $intelligence, strength: $strength, speed: $speed, durability: $durability, power: $power, combat: $combat, gender: $gender, race: $race, height: $height, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$HeroCopyWith<$Res> implements $HeroCopyWith<$Res> {
  factory _$HeroCopyWith(_Hero value, $Res Function(_Hero) _then) = __$HeroCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String image, int intelligence, int strength, int speed, int durability, int power, int combat, String gender, String race, List<String> height, List<String> weight
});




}
/// @nodoc
class __$HeroCopyWithImpl<$Res>
    implements _$HeroCopyWith<$Res> {
  __$HeroCopyWithImpl(this._self, this._then);

  final _Hero _self;
  final $Res Function(_Hero) _then;

/// Create a copy of Hero
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,Object? intelligence = null,Object? strength = null,Object? speed = null,Object? durability = null,Object? power = null,Object? combat = null,Object? gender = null,Object? race = null,Object? height = null,Object? weight = null,}) {
  return _then(_Hero(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,intelligence: null == intelligence ? _self.intelligence : intelligence // ignore: cast_nullable_to_non_nullable
as int,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,durability: null == durability ? _self.durability : durability // ignore: cast_nullable_to_non_nullable
as int,power: null == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as int,combat: null == combat ? _self.combat : combat // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,race: null == race ? _self.race : race // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self._height : height // ignore: cast_nullable_to_non_nullable
as List<String>,weight: null == weight ? _self._weight : weight // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
