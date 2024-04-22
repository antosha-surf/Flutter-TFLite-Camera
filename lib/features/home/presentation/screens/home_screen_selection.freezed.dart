// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_screen_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeScreenSelection {
  ResolutionPreset? get resolutionPreset => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeScreenSelectionCopyWith<HomeScreenSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeScreenSelectionCopyWith<$Res> {
  factory $HomeScreenSelectionCopyWith(
          HomeScreenSelection value, $Res Function(HomeScreenSelection) then) =
      _$HomeScreenSelectionCopyWithImpl<$Res, HomeScreenSelection>;
  @useResult
  $Res call({ResolutionPreset? resolutionPreset});
}

/// @nodoc
class _$HomeScreenSelectionCopyWithImpl<$Res, $Val extends HomeScreenSelection>
    implements $HomeScreenSelectionCopyWith<$Res> {
  _$HomeScreenSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resolutionPreset = freezed,
  }) {
    return _then(_value.copyWith(
      resolutionPreset: freezed == resolutionPreset
          ? _value.resolutionPreset
          : resolutionPreset // ignore: cast_nullable_to_non_nullable
              as ResolutionPreset?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeScreenSelectionImplCopyWith<$Res>
    implements $HomeScreenSelectionCopyWith<$Res> {
  factory _$$HomeScreenSelectionImplCopyWith(_$HomeScreenSelectionImpl value,
          $Res Function(_$HomeScreenSelectionImpl) then) =
      __$$HomeScreenSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ResolutionPreset? resolutionPreset});
}

/// @nodoc
class __$$HomeScreenSelectionImplCopyWithImpl<$Res>
    extends _$HomeScreenSelectionCopyWithImpl<$Res, _$HomeScreenSelectionImpl>
    implements _$$HomeScreenSelectionImplCopyWith<$Res> {
  __$$HomeScreenSelectionImplCopyWithImpl(_$HomeScreenSelectionImpl _value,
      $Res Function(_$HomeScreenSelectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resolutionPreset = freezed,
  }) {
    return _then(_$HomeScreenSelectionImpl(
      resolutionPreset: freezed == resolutionPreset
          ? _value.resolutionPreset
          : resolutionPreset // ignore: cast_nullable_to_non_nullable
              as ResolutionPreset?,
    ));
  }
}

/// @nodoc

class _$HomeScreenSelectionImpl implements _HomeScreenSelection {
  const _$HomeScreenSelectionImpl({required this.resolutionPreset});

  @override
  final ResolutionPreset? resolutionPreset;

  @override
  String toString() {
    return 'HomeScreenSelection(resolutionPreset: $resolutionPreset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeScreenSelectionImpl &&
            (identical(other.resolutionPreset, resolutionPreset) ||
                other.resolutionPreset == resolutionPreset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resolutionPreset);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeScreenSelectionImplCopyWith<_$HomeScreenSelectionImpl> get copyWith =>
      __$$HomeScreenSelectionImplCopyWithImpl<_$HomeScreenSelectionImpl>(
          this, _$identity);
}

abstract class _HomeScreenSelection implements HomeScreenSelection {
  const factory _HomeScreenSelection(
          {required final ResolutionPreset? resolutionPreset}) =
      _$HomeScreenSelectionImpl;

  @override
  ResolutionPreset? get resolutionPreset;
  @override
  @JsonKey(ignore: true)
  _$$HomeScreenSelectionImplCopyWith<_$HomeScreenSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
