part of 'image_inference_bloc.dart';

sealed class ImageInferenceEvent {
  const ImageInferenceEvent();
}

final class GetLatestCameraSnapshot extends ImageInferenceEvent {
  final Future<PredictionCapture> Function() onTakePicture;

  const GetLatestCameraSnapshot(this.onTakePicture);
}
