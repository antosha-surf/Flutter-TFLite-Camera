part of 'image_inference_bloc.dart';

sealed class ImageInferenceState {
  bool get isInitial => this is Initial;

  bool get isLoading => this is Loading;

  bool get isDone => this is Done;

  bool get isError => this is Error;

  Object get error {
    assert(isError);
    return (this as Error)._error;
  }

  const ImageInferenceState();
}

final class Initial extends ImageInferenceState {
  const Initial();
}

final class Loading extends ImageInferenceState {
  const Loading();
}

final class Done extends ImageInferenceState {
  final InferenceImageViewImageData result;

  const Done(this.result);
}

final class Error extends ImageInferenceState {
  final Object _error;

  const Error(this._error);
}
