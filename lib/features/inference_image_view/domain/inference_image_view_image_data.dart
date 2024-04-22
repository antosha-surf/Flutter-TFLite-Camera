import 'dart:typed_data';

import 'package:tflite/common/detections/detected_object.dart';

class InferenceImageViewImageData {
  final Uint8List image;
  final List<DetectedObject> detections;

  const InferenceImageViewImageData({
    required this.image,
    required this.detections,
  });
}
