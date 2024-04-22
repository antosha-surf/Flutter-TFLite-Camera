package com.example.tflite_camera_plugin.tflite;

import android.app.Activity;
import android.media.Image;
import android.os.Handler;
import android.view.Surface;

import java.io.IOException;
import java.nio.MappedByteBuffer;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class TFLite {
    private TFLiteSession currentSession = null;

    public boolean hasLiveSession() {
        return currentSession != null && !currentSession.isDisposed();
    }

    public boolean isStreamingPredictions() {
        return hasLiveSession() && currentSession.isStreamingPredictions();
    }

    public void initSession(
        Activity activity,
        String modelPath,
        int resolutionWidth,
        int resolutionHeight,
        int imageFormat
    ) {
        currentSession = new TFLiteSession(
            activity,
            modelPath,
            resolutionWidth,
            resolutionHeight,
            imageFormat
        );
    }

    public void startSessionPredictionsStream(EventChannel eventChannel, Handler backgroundHandler) {
        currentSession.startPredictionsStream(eventChannel, backgroundHandler);
    }

    public void onImageForInferenceTaken(Image image, MethodChannel.Result result) {
        currentSession.onImageForInferenceCaptured(image, result);
    }

    public Surface getCurrentSessionSurface() {
        return currentSession.getImageReaderSurface();
    }

    public void disposeSession() {
        if (currentSession != null) {
            currentSession.dispose();
            currentSession = null;
        }
    }
}
