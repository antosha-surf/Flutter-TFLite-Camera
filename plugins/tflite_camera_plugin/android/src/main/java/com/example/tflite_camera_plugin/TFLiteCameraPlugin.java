// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.example.tflite_camera_plugin;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import com.example.tflite_camera_plugin.CameraPermissions.PermissionsRegistry;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;

import io.flutter.view.TextureRegistry;

/**
 * Platform implementation of the camera_plugin.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 * See {@code com.example.tflite_camera_plugin.MainActivity} for an example.
 *
 * <p>Call {@link #registerWith(io.flutter.plugin.common.PluginRegistry.Registrar)} to register an
 * implementation of this that uses the stable {@code io.flutter.plugin.common} package.
 */
public final class TFLiteCameraPlugin implements FlutterPlugin, ActivityAware {

  private static final String TAG = "TFLiteCameraPlugin";
  private @Nullable FlutterPluginBinding flutterPluginBinding;
  private @Nullable MethodCallHandlerImpl methodCallHandler;

  /**
   * Initialize this within the {@code #configureFlutterEngine} of a Flutter activity or fragment.
   *
   * <p>See {@code com.example.tflite_camera_plugin.MainActivity} for an example.
   */
  public TFLiteCameraPlugin() {}

  /**
   * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
   * package.
   *
   * <p>Calling this automatically initializes the plugin. However plugins initialized this way
   * won't react to changes in activity or context, unlike {@link TFLiteCameraPlugin}.
   */
  @SuppressWarnings("deprecation")
  public static void registerWith(
          @NonNull io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    TFLiteCameraPlugin plugin = new TFLiteCameraPlugin();
    plugin.maybeStartListening(
            registrar.activity(),
            registrar.messenger(),
            registrar::addRequestPermissionsResultListener,
            registrar.view());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    this.flutterPluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    this.flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    maybeStartListening(
            binding.getActivity(),
            flutterPluginBinding.getBinaryMessenger(),
            binding::addRequestPermissionsResultListener,
            flutterPluginBinding.getTextureRegistry());
  }

  @Override
  public void onDetachedFromActivity() {
    // Could be on too low of an SDK to have started listening originally.
    if (methodCallHandler != null) {
      methodCallHandler.stopListening();
      methodCallHandler = null;
    }
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  private void maybeStartListening(
          Activity activity,
          BinaryMessenger messenger,
          PermissionsRegistry permissionsRegistry,
          TextureRegistry textureRegistry) {
    methodCallHandler =
        new MethodCallHandlerImpl(
            activity,
            messenger,
            new CameraPermissions(),
            permissionsRegistry,
            textureRegistry,
            (assetName) -> flutterPluginBinding
                    .getFlutterAssets()
                    .getAssetFilePathBySubpath(assetName)
        );
  }
}
