import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bounding_box.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class BoundingBox with _$BoundingBox {
  @Assert('tl.dx <= br.dx && tl.dy <= br.dy')
  factory BoundingBox(Offset tl, Offset br) = _BoundingBox;
}

extension BoundingBoxX on BoundingBox {
  Rect get rect {
    return Rect.fromPoints(tl, br);
  }

  /// Turns a relative bounding box to an absolute bounding box for the
  /// given size.
  ///
  /// Relative bounding box is when:
  /// 0 is the left and top edge of the image;
  /// 1 is the right and bottom edge of the image.
  ///
  /// Absolute bounding box is given by its absolute pixel offsets.
  BoundingBox toAbsoluteFromSize(Size size) {
    return BoundingBox(
      Offset(tl.dx * size.width, tl.dy * size.height),
      Offset(br.dx * size.width, br.dy * size.height),
    );
  }

  /// If [offset] is within the bounds of this [BoundingBox].
  /// Edge cases are non-strict just because.
  bool contains(Offset offset) {
    return offset.dx >= tl.dx &&
        offset.dx <= br.dx &&
        offset.dy >= tl.dy &&
        offset.dy <= br.dy;
  }
}
