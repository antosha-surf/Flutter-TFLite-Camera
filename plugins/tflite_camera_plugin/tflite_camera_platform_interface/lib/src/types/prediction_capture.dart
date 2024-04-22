import 'dart:typed_data';

/// A result of calling `CameraController.takePictureAndInfer`.
class PredictionCapture {
  /// An absolute path to taken image.
  final Uint8List imageBytes;

  /// Raw detections on that image.
  final List<Map<String, dynamic>> rawDetections;

  const PredictionCapture({
    required this.imageBytes,
    required this.rawDetections,
  });

  factory PredictionCapture.fromPlatformJson(Map<String, dynamic> json) {
    return PredictionCapture(
      imageBytes: json['imageBytes'],
      rawDetections: (json['detections'] as List)
          .map((e) => (e as Map<Object?, Object?>).cast<String, dynamic>())
          .toList(),
    );
  }
}
