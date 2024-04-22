package com.example.tflite_camera_plugin.tflite;

import android.util.Log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class TFLitePredictionCaptureController {
  public interface OnComplete {
    void onComplete(PredictionCapture predictionCapture, CompletionReason reason);
  }
  public enum CompletionReason {
    OK,
    TIMEOUT,
    UNEXPECTED_NULL,
    DISPOSED
  }

  private final byte[] imageBytes;
  private final OnComplete onComplete;
  private Timer timer;
  private boolean isComplete = false;

  public TFLitePredictionCaptureController(byte[] imageBytes, OnComplete onComplete) {
    this.imageBytes = imageBytes;
    this.onComplete = onComplete;

    // Add a 2s timeout to this request in case something goes horribly wrong.
    this.timer = new Timer();
    timer.schedule(new TimerTask() {
      @Override
      public void run() {
        complete(null, CompletionReason.TIMEOUT);
      }
    }, 2000);
  }

  public void onDetectionsReceived(List<Map<String, Object>> detections) {
    complete(
      detections,
      detections == null
          ? CompletionReason.UNEXPECTED_NULL
          : CompletionReason.OK
    );
  }

  public void dispose() {
    complete(null, CompletionReason.DISPOSED);
  }

  private void complete(List<Map<String, Object>> detections, CompletionReason reason) {
    if (isComplete) return;
    isComplete = true;
    cancelTimeoutTimer();
    onComplete.onComplete(new PredictionCapture(imageBytes, detections), reason);
  }

  private void cancelTimeoutTimer() {
    if (timer != null) {
      timer.cancel();
      timer.purge();
      timer = null;
    }
  }
}

class PredictionCapture {
  final byte[] imageBytes;
  final List<Map<String, Object>> detections;
  public PredictionCapture(
          byte[] imageBytes,
          List<Map<String, Object>> detections
  ) {
    this.imageBytes = imageBytes;
    this.detections = detections;
  }

  public Map<String, Object> toJson() {
    Map<String, Object> map = new HashMap<>();
    map.put("imageBytes", imageBytes);
    map.put("detections", detections);
    return map;
  }
}