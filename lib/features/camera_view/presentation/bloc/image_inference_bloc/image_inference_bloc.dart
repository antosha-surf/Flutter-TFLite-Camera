import 'package:tflite/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/features/inference_image_view/domain/domain.dart';
import 'package:tflite_camera_plugin/tflite_camera_plugin.dart';

part 'image_inference_event.dart';
part 'image_inference_state.dart';

class ImageInferenceBloc
    extends Bloc<ImageInferenceEvent, ImageInferenceState> {
  ImageInferenceBloc() : super(const Initial()) {
    on<GetLatestCameraSnapshot>(_getLatestCameraSnapshot);
  }

  void _getLatestCameraSnapshot(
    GetLatestCameraSnapshot event,
    Emitter<ImageInferenceState> emit,
  ) async {
    emit(const Loading());

    try {
      final res = await event.onTakePicture();

      emit(Done(InferenceImageViewImageData(
        image: res.imageBytes,
        detections: res.rawDetections.map((e) {
          return DetectedObject.fromPluginData(e);
        }).toList(),
      )));
    } on Object catch (error) {
      emit(Error(error));
    }
  }
}
