// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detected_object.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetectedObject {
  int get categoryIndex => throw _privateConstructorUsedError;
  double get categoryScore => throw _privateConstructorUsedError;
  BoundingBox get boundingBox => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DetectedObjectCopyWith<DetectedObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetectedObjectCopyWith<$Res> {
  factory $DetectedObjectCopyWith(
          DetectedObject value, $Res Function(DetectedObject) then) =
      _$DetectedObjectCopyWithImpl<$Res, DetectedObject>;
  @useResult
  $Res call({int categoryIndex, double categoryScore, BoundingBox boundingBox});

  $BoundingBoxCopyWith<$Res> get boundingBox;
}

/// @nodoc
class _$DetectedObjectCopyWithImpl<$Res, $Val extends DetectedObject>
    implements $DetectedObjectCopyWith<$Res> {
  _$DetectedObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIndex = null,
    Object? categoryScore = null,
    Object? boundingBox = null,
  }) {
    return _then(_value.copyWith(
      categoryIndex: null == categoryIndex
          ? _value.categoryIndex
          : categoryIndex // ignore: cast_nullable_to_non_nullable
              as int,
      categoryScore: null == categoryScore
          ? _value.categoryScore
          : categoryScore // ignore: cast_nullable_to_non_nullable
              as double,
      boundingBox: null == boundingBox
          ? _value.boundingBox
          : boundingBox // ignore: cast_nullable_to_non_nullable
              as BoundingBox,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoundingBoxCopyWith<$Res> get boundingBox {
    return $BoundingBoxCopyWith<$Res>(_value.boundingBox, (value) {
      return _then(_value.copyWith(boundingBox: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetectedObjectImplCopyWith<$Res>
    implements $DetectedObjectCopyWith<$Res> {
  factory _$$DetectedObjectImplCopyWith(_$DetectedObjectImpl value,
          $Res Function(_$DetectedObjectImpl) then) =
      __$$DetectedObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int categoryIndex, double categoryScore, BoundingBox boundingBox});

  @override
  $BoundingBoxCopyWith<$Res> get boundingBox;
}

/// @nodoc
class __$$DetectedObjectImplCopyWithImpl<$Res>
    extends _$DetectedObjectCopyWithImpl<$Res, _$DetectedObjectImpl>
    implements _$$DetectedObjectImplCopyWith<$Res> {
  __$$DetectedObjectImplCopyWithImpl(
      _$DetectedObjectImpl _value, $Res Function(_$DetectedObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIndex = null,
    Object? categoryScore = null,
    Object? boundingBox = null,
  }) {
    return _then(_$DetectedObjectImpl(
      categoryIndex: null == categoryIndex
          ? _value.categoryIndex
          : categoryIndex // ignore: cast_nullable_to_non_nullable
              as int,
      categoryScore: null == categoryScore
          ? _value.categoryScore
          : categoryScore // ignore: cast_nullable_to_non_nullable
              as double,
      boundingBox: null == boundingBox
          ? _value.boundingBox
          : boundingBox // ignore: cast_nullable_to_non_nullable
              as BoundingBox,
    ));
  }
}

/// @nodoc

class _$DetectedObjectImpl implements _DetectedObject {
  const _$DetectedObjectImpl(
      {required this.categoryIndex,
      required this.categoryScore,
      required this.boundingBox});

  @override
  final int categoryIndex;
  @override
  final double categoryScore;
  @override
  final BoundingBox boundingBox;

  @override
  String toString() {
    return 'DetectedObject(categoryIndex: $categoryIndex, categoryScore: $categoryScore, boundingBox: $boundingBox)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetectedObjectImpl &&
            (identical(other.categoryIndex, categoryIndex) ||
                other.categoryIndex == categoryIndex) &&
            (identical(other.categoryScore, categoryScore) ||
                other.categoryScore == categoryScore) &&
            (identical(other.boundingBox, boundingBox) ||
                other.boundingBox == boundingBox));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryIndex, categoryScore, boundingBox);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetectedObjectImplCopyWith<_$DetectedObjectImpl> get copyWith =>
      __$$DetectedObjectImplCopyWithImpl<_$DetectedObjectImpl>(
          this, _$identity);
}

abstract class _DetectedObject implements DetectedObject {
  const factory _DetectedObject(
      {required final int categoryIndex,
      required final double categoryScore,
      required final BoundingBox boundingBox}) = _$DetectedObjectImpl;

  @override
  int get categoryIndex;
  @override
  double get categoryScore;
  @override
  BoundingBox get boundingBox;
  @override
  @JsonKey(ignore: true)
  _$$DetectedObjectImplCopyWith<_$DetectedObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
