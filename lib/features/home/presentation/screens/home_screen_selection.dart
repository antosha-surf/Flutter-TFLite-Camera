import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tflite/common/common.dart';
import 'package:tflite_camera_plugin/tflite_camera_plugin.dart';

part 'home_screen_selection.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class HomeScreenSelection with _$HomeScreenSelection {
  const factory HomeScreenSelection({
    required ResolutionPreset? resolutionPreset,
  }) = _HomeScreenSelection;
}
