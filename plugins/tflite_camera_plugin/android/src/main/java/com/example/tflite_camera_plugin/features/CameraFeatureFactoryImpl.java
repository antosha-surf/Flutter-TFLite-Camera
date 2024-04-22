// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.example.tflite_camera_plugin.features;

import android.app.Activity;
import androidx.annotation.NonNull;
import com.example.tflite_camera_plugin.CameraProperties;
import com.example.tflite_camera_plugin.DartMessenger;
import com.example.tflite_camera_plugin.features.autofocus.AutoFocusFeature;
import com.example.tflite_camera_plugin.features.exposurelock.ExposureLockFeature;
import com.example.tflite_camera_plugin.features.exposureoffset.ExposureOffsetFeature;
import com.example.tflite_camera_plugin.features.exposurepoint.ExposurePointFeature;
import com.example.tflite_camera_plugin.features.flash.FlashFeature;
import com.example.tflite_camera_plugin.features.focuspoint.FocusPointFeature;
import com.example.tflite_camera_plugin.features.fpsrange.FpsRangeFeature;
import com.example.tflite_camera_plugin.features.noisereduction.NoiseReductionFeature;
import com.example.tflite_camera_plugin.features.resolution.ResolutionFeature;
import com.example.tflite_camera_plugin.features.resolution.ResolutionPreset;
import com.example.tflite_camera_plugin.features.sensororientation.SensorOrientationFeature;
import com.example.tflite_camera_plugin.features.zoomlevel.ZoomLevelFeature;

/**
 * Implementation of the {@link CameraFeatureFactory} interface creating the supported feature
 * implementation controlling different aspects of the {@link
 * android.hardware.camera2.CaptureRequest}.
 */
public class CameraFeatureFactoryImpl implements CameraFeatureFactory {
  @NonNull
  @Override
  public AutoFocusFeature createAutoFocusFeature(
      @NonNull CameraProperties cameraProperties, boolean recordingVideo) {
    return new AutoFocusFeature(cameraProperties, recordingVideo);
  }

  @NonNull
  @Override
  public ExposureLockFeature createExposureLockFeature(@NonNull CameraProperties cameraProperties) {
    return new ExposureLockFeature(cameraProperties);
  }

  @NonNull
  @Override
  public ExposureOffsetFeature createExposureOffsetFeature(
      @NonNull CameraProperties cameraProperties) {
    return new ExposureOffsetFeature(cameraProperties);
  }

  @NonNull
  @Override
  public FlashFeature createFlashFeature(@NonNull CameraProperties cameraProperties) {
    return new FlashFeature(cameraProperties);
  }

  @NonNull
  @Override
  public ResolutionFeature createResolutionFeature(
      @NonNull CameraProperties cameraProperties,
      @NonNull ResolutionPreset initialSetting,
      @NonNull String cameraName) {
    return new ResolutionFeature(cameraProperties, initialSetting, cameraName);
  }

  @NonNull
  @Override
  public FocusPointFeature createFocusPointFeature(
      @NonNull CameraProperties cameraProperties,
      @NonNull SensorOrientationFeature sensorOrientationFeature) {
    return new FocusPointFeature(cameraProperties, sensorOrientationFeature);
  }

  @NonNull
  @Override
  public FpsRangeFeature createFpsRangeFeature(@NonNull CameraProperties cameraProperties) {
    return new FpsRangeFeature(cameraProperties);
  }

  @NonNull
  @Override
  public SensorOrientationFeature createSensorOrientationFeature(
      @NonNull CameraProperties cameraProperties,
      @NonNull Activity activity,
      @NonNull DartMessenger dartMessenger) {
    return new SensorOrientationFeature(cameraProperties, activity, dartMessenger);
  }

  @NonNull
  @Override
  public ZoomLevelFeature createZoomLevelFeature(@NonNull CameraProperties cameraProperties) {
    return new ZoomLevelFeature(cameraProperties);
  }

  @NonNull
  @Override
  public ExposurePointFeature createExposurePointFeature(
      @NonNull CameraProperties cameraProperties,
      @NonNull SensorOrientationFeature sensorOrientationFeature) {
    return new ExposurePointFeature(cameraProperties, sensorOrientationFeature);
  }

  @NonNull
  @Override
  public NoiseReductionFeature createNoiseReductionFeature(
      @NonNull CameraProperties cameraProperties) {
    return new NoiseReductionFeature(cameraProperties);
  }
}
